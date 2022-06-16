import 'package:equatable/equatable.dart';
import 'package:social_irl/core/cn_helper.dart';
import 'package:social_irl/data/models/social_event_model.dart';

import '../../domain/entities/person.dart';
import '../../domain/entities/social_event.dart';
import '../../domain/entities/tag.dart';

class PersonModel extends Equatable {
  final int id;
  String name;

  SocialCircle socialCircle;
  SocialCircle? potentialForCircle;

  String notes;
  late List<PersonTag> tags;

  late List<SocialEvent> socialEvents;

  // TODO Should we save it like this in the database? Or calculate this every time

  /// Start time for the last social event that included the user
  DateTime? lastSocialEvent;

  /// Start time for the next social event that includes the user
  DateTime? nextSocialEvent;

  /// Default
  bool isDeleted = false;

  late DateTime createdAt;
  late DateTime modifiedAt;

  PersonModel({
    required this.id,
    required this.name,
    required this.socialCircle,
    this.potentialForCircle,
    this.notes = "",
  }) {
    createdAt = modifiedAt = DateTime.now();
    socialEvents = [];
    tags = [];
  }

  @override
  List<Object?> get props => [
        id,
        name,
        socialCircle,
        potentialForCircle,
        notes,
        tags,
        socialEvents,
        lastSocialEvent,
        nextSocialEvent,
        createdAt,
        modifiedAt,
        isDeleted,
      ];

  /// Data Needed for [PersonListPage]
  ///
  /// Person ID
  /// Person Name
  /// Social Circle
  /// LastEventDate
  /// NextEventDate
  /// Person Tags
  ///
  /// Missing [socialEvents] field in incomplete mode
  Map<String, dynamic> toJson({bool complete = true}) {
    List _tags = [for (var tag in tags) tag.toJson()];

    Map<String, dynamic>? potentialForCircleString;
    if (potentialForCircle != null) {
      potentialForCircleString = potentialForCircle!.toJson();
    }

    List _socialEvents = [
      for (var event in socialEvents)
        SocialEventModel.fromSocialEvent(event).toJson(complete: !complete)
    ];

    return {
      'id': id,
      'name': name,
      'socialCircle': socialCircle.toJson(),
      'potentialForCircle': potentialForCircleString,
      'lastSocialEvent': h.dateTimeToString(lastSocialEvent),
      'nextSocialEvent': h.dateTimeToString(nextSocialEvent),
      'createdAt': h.dateTimeToString(createdAt),
      'modifiedAt': h.dateTimeToString(modifiedAt),
      'isDeleted': isDeleted,
      'tags': _tags,
      'notes': notes,
      'socialEvents': _socialEvents,
    };
  }

  factory PersonModel.fromJson(
    Map<String, dynamic> data, {
    bool complete = false,
  }) {
    SocialCircle socialCircle = SocialCircle.fromJson(data['socialCircle']);

    SocialCircle? potentialForCircle;
    if (data['potentialForCircle'] != null) {
      potentialForCircle = SocialCircle.fromJson(data['potentialForCircle']);
    }

    PersonModel temp = PersonModel(
      id: h.intOkForced(data['id']),
      name: h.strOkForced(data['name']),
      notes: h.strOk(data['notes']) ?? "",
      socialCircle: socialCircle,
      potentialForCircle: potentialForCircle,
    );

    // Can be null
    temp.lastSocialEvent = h.dateTimeOk(data['lastSocialEvent']);
    temp.nextSocialEvent = h.dateTimeOk(data['nextSocialEvent']);

    // Can't be null
    temp.createdAt = h.dateTimeOkForced(data['createdAt']);
    temp.modifiedAt = h.dateTimeOkForced(data['modifiedAt']);

    temp.isDeleted = h.boolOkForced(data['isDeleted']);

    temp.tags = [for (var tag in data['tags']) PersonTag.fromJson(tag)];

    if (complete) {
      temp.socialEvents = [
        for (var event in data['socialEvents'])
          SocialEventModel.fromJson(event).toSocialEvent()
      ];
    }

    return temp;
  }

  // ----------------------------------------
  // ----------------------------------------
  // ----------------------------------------
  // ----------------------------------------

  Person toPerson() {
    Person temp = Person(
      id: id,
      name: name,
      socialCircle: socialCircle,
      potentialForCircle: potentialForCircle,
      notes: notes,
    );

    temp.tags = [for (var tag in tags) tag];
    temp.socialEvents = [for (var event in socialEvents) event];

    temp.lastSocialEvent = lastSocialEvent;
    temp.nextSocialEvent = nextSocialEvent;

    temp.createdAt = createdAt;
    temp.modifiedAt = modifiedAt;
    temp.isDeleted = isDeleted;

    return temp;
  }

  static PersonModel fromPerson(Person person) {
    PersonModel temp = PersonModel(
      id: person.id,
      name: person.name,
      socialCircle: person.socialCircle,
      potentialForCircle: person.potentialForCircle,
      notes: person.notes,
    );

    temp.tags = [for (var tag in person.tags) tag];
    temp.socialEvents = [for (var event in person.socialEvents) event];

    temp.lastSocialEvent = person.lastSocialEvent;
    temp.nextSocialEvent = person.nextSocialEvent;

    temp.createdAt = person.createdAt;
    temp.modifiedAt = person.modifiedAt;
    temp.isDeleted = person.isDeleted;

    return temp;
  }
}
