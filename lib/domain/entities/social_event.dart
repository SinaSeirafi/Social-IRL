import 'package:equatable/equatable.dart';
import 'package:social_irl/domain/entities/person.dart';
import 'package:social_irl/domain/entities/tag.dart';

import '../usecases/social_event_usecases.dart';

class SocialEvent extends Equatable {
  final int id;
  String? title;

  DateTime startDate;
  DateTime? endDate;

  List<Person> attendees;

  String? notes;
  late List<SocialEventTag> tags;

  bool isDeleted = false;

  late DateTime createdAt;
  late DateTime modifiedAt;

  SocialEvent({
    required this.id,
    this.title,
    required this.startDate,
    this.endDate,
    required this.attendees,
    this.notes,
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
