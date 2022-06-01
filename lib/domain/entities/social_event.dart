import 'package:equatable/equatable.dart';
import 'package:social_irl/domain/entities/person.dart';
import 'package:social_irl/domain/entities/tag.dart';

class SocialEvent extends Equatable {
  final int id;
  String? title;

  DateTime startDate;
  DateTime? endDate;

  List<Person> attendees;

  String? note;
  List<SocialEventTag>? tags;

  bool isDeleted = false;

  late DateTime createdAt;
  late DateTime modifiedAt;

  SocialEvent({
    required this.id,
    this.title,
    required this.startDate,
    this.endDate,
    required this.attendees,
    this.note,
    this.tags,
  }) {
    createdAt = modifiedAt = DateTime.now();
  }

  @override
  List<Object?> get props => [
        id,
        title,
        startDate,
        endDate,
        attendees,
        note,
        tags,
        isDeleted,
        createdAt,
        modifiedAt
      ];
}
