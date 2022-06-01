import 'package:flutter/material.dart';
import 'package:social_irl/domain/entities/person.dart';

class PersonCard extends StatelessWidget {
  const PersonCard({
    Key? key,
    required this.person,
  }) : super(key: key);

  final Person person;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(person.name),
      subtitle: Text(_subTitleText),
    );
  }

  String get _subTitleText {
    if (person.socialEvents.isNotEmpty) {
      return person.socialEvents.last.startDate.toString();
    }

    return "Never 😬";
  }
}
