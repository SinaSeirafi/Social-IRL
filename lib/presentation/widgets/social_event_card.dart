import 'package:flutter/material.dart';
import 'package:social_irl/core/app_constants.dart';
import 'package:social_irl/core/cn_helper.dart';

import '../../core/app_router.dart';
import '../../domain/entities/social_event.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/social_event_bloc.dart';
import 'cn_widgets/cn_message.dart';
import 'common_widgets.dart';

class SocialEventCard extends StatelessWidget {
  const SocialEventCard({
    Key? key,
    required this.socialEvent,
  }) : super(key: key);

  final SocialEvent socialEvent;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(socialEvent.id.toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      child: InkWell(
        onTap: () => _navigateToEditPage(context),
        child: Card(
          margin: noTopPadding,
          child: ListTile(
            title: _buildTitle(),
            subtitle: _buildSubtitle(),
          ),
        ),
      ),
    );
  }

  _navigateToEditPage(BuildContext context) {
    selectedSocialEvent = socialEvent;

    router.navigateTo(
      context,
      CnRouter.editSocialEventRoute + '/${socialEvent.id}',
    );
  }

  Widget _buildTitle() {
    return Text(h.readableDateFromDateTime(socialEvent.startDate));
  }

  Widget _buildSubtitle() {
    String text = 'Attendees: ';

    for (var person in socialEvent.attendees) {
      text += person.name + " ";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        TagsInCardWrap(tags: socialEvent.tags),
      ],
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    _removeQuestion() {
      context
          .read<SocialEventBloc>()
          .add(RemoveSocialEventEvent(context, socialEvent));

      Navigator.pop(context);
    }

    bool result = await showCnConfirmationModalBottomSheet(
      context,
      child: Text(
        "Are you sure you want to delete this event?",
        style: TextStyle(color: accentColor, fontWeight: FontWeight.w500),
      ),
      confirmButtonAction: _removeQuestion,
    );

    return result;
  }
}
