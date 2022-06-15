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
        isDeleted,
        createdAt,
        modifiedAt
      ];

  /// Data Needed for [PersonListPage]
  ///
  /// Person Name
  /// Social Circle
  /// LastEventDate
  /// NextEventDate
  /// Person Tags

  static PersonModel fromJsonIncomplete(Map<String, dynamic> data) {
    SocialCircle socialCircle = SocialCircle(
      id: h.intOkForced(data['socialCircle']['id']),
      title: h.strOkForced(data['socialCircle']['title']),
    );

    PersonModel temp = PersonModel(
      id: h.intOkForced(data['id']),
      name: h.strOkForced(data['name']),
      socialCircle: socialCircle,
    );

    // Can't be null
    temp.createdAt = h.dateTimeOkForced(data['createdAt']);
    temp.modifiedAt = h.dateTimeOkForced(data['modifiedAt']);

    // Can be null
    temp.lastSocialEvent = h.dateTimeOK(data['lastSocialEvent']);
    temp.nextSocialEvent = h.dateTimeOK(data['nextSocialEvent']);

    temp.isDeleted = h.boolOk(data['isDeleted'])!;

    return temp;
  }
}