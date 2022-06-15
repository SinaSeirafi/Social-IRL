import 'package:equatable/equatable.dart';
import 'package:social_irl/core/cn_helper.dart';

import '../../domain/entities/person.dart';
import '../../domain/entities/social_event.dart';
import '../../domain/entities/tag.dart';

class PersonModel extends Equatable {
  final int id;
  String name;

  SocialCircle socialCircle;
  SocialCircle? potentialForCircle;

  String? notes;
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
    this.notes,
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
  /// Missing fields:
  /// [notes] and [socialEvents]
  Map<String, dynamic> toJsonIncomplete() {
    List tagsJson = [for (var tag in tags) tag.toJson()];

    Map<String, dynamic>? potentialForCircleString;
    if (potentialForCircle != null) {
      potentialForCircleString = potentialForCircle!.toJson();
    }

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
      'tags': tagsJson,
    };
  }

  static PersonModel fromJsonIncomplete(Map<String, dynamic> data) {
    SocialCircle socialCircle = SocialCircle.fromJson(data['socialCircle']);

    SocialCircle? potentialForCircle;
    if (data['potentialForCircle'] != null) {
      potentialForCircle = SocialCircle.fromJson(data['potentialForCircle']);
    }

    PersonModel temp = PersonModel(
      id: h.intOkForced(data['id']),
      name: h.strOkForced(data['name']),
      socialCircle: socialCircle,
      potentialForCircle: potentialForCircle,
    );

    // Can be null
    temp.lastSocialEvent = h.dateTimeOK(data['lastSocialEvent']);
    temp.nextSocialEvent = h.dateTimeOK(data['nextSocialEvent']);

    // Can't be null
    temp.createdAt = h.dateTimeOkForced(data['createdAt']);
    temp.modifiedAt = h.dateTimeOkForced(data['modifiedAt']);

    temp.isDeleted = h.boolOkForced(data['isDeleted']);

    for (var element in data['tags']) {
      temp.tags.add(PersonTag.fromJson(element));
    }

    return temp;
  }

  Person personFromPersonModel() {
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

  static PersonModel personModelFromPerson(Person person) {
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
