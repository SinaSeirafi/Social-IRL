import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final int id;
  final String title;

  const Tag({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}

class PersonTag extends Tag {
  const PersonTag({
    required id,
    required title,
  }) : super(id: id, title: title);

  @override
  List<Object?> get props => [id, title];
}

class SocialEventTag extends Tag {
  const SocialEventTag({
    required id,
    required title,
  }) : super(id: id, title: title);

  @override
  List<Object?> get props => [id, title];
}
