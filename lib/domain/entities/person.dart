import 'package:equatable/equatable.dart';
import 'package:social_irl/domain/entities/social_event.dart';
import 'package:social_irl/domain/usecases/person_usecases.dart';

import 'tag.dart';

/// --- Later Additions
/// Image
/// Anniversaries
class Person extends Equatable {
  final int id;
  String name;

  SocialCircle? socialCircle;
  SocialCircle? potentialForCircle;

  String? notes;
  late List<PersonTag> tags;

  late List<SocialEvent> socialEvents;

  /// Default
  bool isDeleted = false;

  late DateTime createdAt;
  late DateTime modifiedAt;

  Person({
    required this.id,
    required this.name,
    this.socialCircle,
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

  void copyDataFromPerson(Person person) =>
      PersonGeneralUsecases.copyDataFromPerson(person, this);
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
