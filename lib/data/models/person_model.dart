import 'package:equatable/equatable.dart';

import '../../core/app_constants.dart';
import '../../core/cn_helper.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/tag.dart';

class PersonModel extends Equatable {
  final int id;
  String name;

  SocialCircle socialCircle;
  SocialCircle? potentialForCircle;

  String notes;
  late List<PersonTag> tags;

  late List<int> socialEventsIds;

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
    socialEventsIds = [];
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
        socialEventsIds,
        lastSocialEvent,
        nextSocialEvent,
        createdAt,
        modifiedAt,
        isDeleted,
      ];

  Map<String, dynamic> toJson() {
    List _tags = [for (var tag in tags) tag.toJson()];

    Map<String, dynamic>? potentialForCircleString;
    if (potentialForCircle != null) {
      potentialForCircleString = potentialForCircle!.toJson();
    }

    List _socialEventIds = [for (var eventId in socialEventsIds) eventId];

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
      'socialEventIds': _socialEventIds,
    };
  }

  factory PersonModel.fromJson(Map<String, dynamic> data) {
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

    temp.socialEventsIds = [
      for (var eventId in data['socialEventIds']) h.intOkForced(eventId)
      // SocialEventModel.fromJson(eventId).toSocialEvent()
    ];

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
    temp.socialEventIds = socialEventsIds;
    // temp.socialEvents = [
    //   for (var eventId in socialEventsIds)
    //     allSocialEvents.firstWhere((element) => element.id == eventId)
    // ];

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
    // temp.socialEventsIds = [for (var event in person.socialEvents) event.id];
    temp.socialEventsIds = person.socialEventIds;

    temp.lastSocialEvent = person.lastSocialEvent;
    temp.nextSocialEvent = person.nextSocialEvent;

    temp.createdAt = person.createdAt;
    temp.modifiedAt = person.modifiedAt;
    temp.isDeleted = person.isDeleted;

    return temp;
  }
}
