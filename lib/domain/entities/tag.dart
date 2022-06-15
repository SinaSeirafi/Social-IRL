import 'package:equatable/equatable.dart';

import '../../core/cn_helper.dart';

class Tag extends Equatable {
  final int id;
  final String title;

  const Tag({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}

class PersonTag extends Tag {
  const PersonTag({
    required id,
    required title,
  }) : super(id: id, title: title);

  @override
  List<Object?> get props => [id, title];

  factory PersonTag.fromJson(Map<String, dynamic> data) {
    return PersonTag(
      id: h.intOkForced(data['id']),
      title: h.strOkForced(data['title']),
    );
  }
}

class SocialEventTag extends Tag {
  const SocialEventTag({
    required id,
    required title,
  }) : super(id: id, title: title);

  @override
  List<Object?> get props => [id, title];

  factory SocialEventTag.fromJson(Map<String, dynamic> data) {
    return SocialEventTag(
      id: h.intOkForced(data['id']),
      title: h.strOkForced(data['title']),
    );
  }
}
