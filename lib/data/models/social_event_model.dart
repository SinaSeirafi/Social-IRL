import 'package:equatable/equatable.dart';
import 'package:social_irl/core/app_constants.dart';
import 'package:social_irl/core/cn_helper.dart';
import 'package:social_irl/data/models/person_model.dart';
import 'package:social_irl/domain/entities/social_event.dart';

import '../../domain/entities/person.dart';
import '../../domain/entities/tag.dart';

class SocialEventModel extends Equatable {
  final int id;
  String title;

  DateTime startDate;
  DateTime? endDate;

  List<int> attendeesIds;

  String notes;
  late List<SocialEventTag> tags;

  late DateTime createdAt;
  late DateTime modifiedAt;

  bool isDeleted = false;

  SocialEventModel({
    required this.id,
    this.title = "",
    required this.startDate,
    this.endDate,
    required this.attendeesIds,
    this.notes = "",
  }) {
    createdAt = modifiedAt = DateTime.now();
    tags = [];
  }

  @override
  List<Object?> get props => [
        id,
        title,
        startDate,
        endDate,
        attendeesIds,
        notes,
        tags,
        createdAt,
        modifiedAt,
        isDeleted,
      ];

  Map<String, dynamic> toJson({bool complete = true}) {
    List _tags = [for (var tag in tags) tag.toJson()];

    List _attendeesIds = [for (var personId in attendeesIds) personId];

    return {
      'id': id,
      'title': title,
      'startDate': h.dateTimeToString(startDate),
      'endDate': h.dateTimeToString(endDate),
      'createdAt': h.dateTimeToString(createdAt),
      'modifiedAt': h.dateTimeToString(modifiedAt),
      'attendeesIds': _attendeesIds,
      'notes': notes,
      'tags': _tags,
      'isDeleted': isDeleted,
    };
  }

  factory SocialEventModel.fromJson(Map<String, dynamic> data) {
    /// in case person.socialEvents was required,
    /// a mode should be developed that prevents loop
    /// (person getting socialEvent getting person ...)
    List<int> _attendeesIds = [
      for (var personId in data['attendeesIds']) h.intOkForced(personId)
    ];

    SocialEventModel temp = SocialEventModel(
      id: h.intOkForced(data['id']),
      title: h.strOk(data['title']) ?? "",
      notes: h.strOk(data['notes']) ?? "",
      startDate: h.dateTimeOkForced(data['startDate']),
      endDate: h.dateTimeOk(data['endDate']),
      attendeesIds: _attendeesIds,
    );

    temp.tags = [for (var tag in data['tags']) SocialEventTag.fromJson(tag)];

    temp.createdAt = h.dateTimeOkForced(data['createdAt']);
    temp.modifiedAt = h.dateTimeOkForced(data['modifiedAt']);

    temp.isDeleted = h.boolOkForced(data['isDeleted']);

    return temp;
  }

  // ----------------------------------------
  // ----------------------------------------
  // ----------------------------------------
  // ----------------------------------------

  SocialEvent toSocialEvent() {
    SocialEvent temp = SocialEvent(
      id: id,
      title: title,
      startDate: startDate,
      endDate: endDate,
      attendees: [
        for (var personId in attendeesIds)
          allPeople.firstWhere((element) => element.id == personId)
      ],
      notes: notes,
    );

    temp.tags = [for (var tag in tags) tag];

    temp.createdAt = createdAt;
    temp.modifiedAt = modifiedAt;
    temp.isDeleted = isDeleted;

    return temp;
  }

  static SocialEventModel fromSocialEvent(SocialEvent event) {
    SocialEventModel temp = SocialEventModel(
      id: event.id,
      title: event.title,
      startDate: event.startDate,
      endDate: event.endDate,
      attendeesIds: [for (var person in event.attendees) person.id],
      notes: event.notes,
    );

    temp.tags = [for (var tag in event.tags) tag];

    temp.createdAt = event.createdAt;
    temp.modifiedAt = event.modifiedAt;
    temp.isDeleted = event.isDeleted;

    return temp;
  }
}
