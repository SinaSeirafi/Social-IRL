import 'package:equatable/equatable.dart';
import 'package:social_irl/core/app_constants.dart';

import '../usecases/social_event_usecases.dart';
import 'person.dart';
import 'tag.dart';

class SocialEvent extends Equatable {
  final int id;
  String title;

  DateTime startDate;
  DateTime? endDate;

  List<Person> attendees;

  String notes;
  late List<SocialEventTag> tags;

  late DateTime createdAt;
  late DateTime modifiedAt;

  bool isDeleted = false;

  SocialEvent({
    required this.id,
    this.title = "",
    required this.startDate,
    this.endDate,
    required this.attendees,
    this.notes = "",
  }) {
    createdAt = modifiedAt = DateTime.now();
    tags = [];

    allSocialEvents.add(this);
  }

  @override
  List<Object?> get props => [
        id,
        title,
        startDate,
        endDate,
        attendees,
        notes,
        tags,
        isDeleted,
        createdAt,
        modifiedAt
      ];

  void copyDataFromSocialEvent(SocialEvent socialEvent) =>
      SocialEventGeneralUsecases.copyDataFromSocialEvent(socialEvent, this);
}
