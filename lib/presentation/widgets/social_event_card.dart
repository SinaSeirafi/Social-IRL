import 'package:flutter/material.dart';

import '../../domain/entities/social_event.dart';

class SocialEventCard extends StatelessWidget {
  const SocialEventCard({
    Key? key,
    required this.socialEvent,
  }) : super(key: key);

  final SocialEvent socialEvent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(socialEvent.startDate.toString()),
      subtitle: Text(_subTitleText),
    );
  }

  String get _subTitleText {
    String result = '';

    for (var person in socialEvent.attendees) {
      result += person.name + " ";
    }

    return result;
  }
}
