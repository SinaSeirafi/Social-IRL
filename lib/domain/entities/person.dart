import 'package:equatable/equatable.dart';
import 'package:social_irl/domain/entities/social_event.dart';

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
  List<PersonTag>? tags;

  List<SocialEvent> socialEvents;

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
    this.tags,
    this.socialEvents = const [],
  }) {
    createdAt = modifiedAt = DateTime.now();
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
