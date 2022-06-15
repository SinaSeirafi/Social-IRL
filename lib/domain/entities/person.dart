import 'package:equatable/equatable.dart';

import '../usecases/person_usecases.dart';
import 'social_event.dart';
import 'tag.dart';

/// --- Later Additions
/// Image
/// Anniversaries
class Person extends Equatable {
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

  Person({
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

  String get nameAndCircleEmoji => name + " " + socialCircle.title;

  void copyDataFromPerson(Person person) =>
      PersonGeneralUsecases.copyDataFromPerson(person, this);

  String get timeSinceLastEvent =>
      PersonGeneralUsecases.timeSinceLastEvent(this);

  void updateNextAndLastSocialEventTimes() =>
      PersonGeneralUsecases.updateNextAndLastSocialEventTimes(this);
}

class SocialCircle extends Equatable {
  final int id;
  final String title;

  const SocialCircle({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}
