import 'package:flutter/material.dart';
import 'package:social_irl/core/app_router.dart';
import 'package:social_irl/core/cn_helper.dart';
import 'package:social_irl/domain/entities/person.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_irl/presentation/widgets/cn_widgets/cn_button.dart';

import 'package:social_irl/presentation/widgets/cn_widgets/cn_text.dart';

import '../../core/app_constants.dart';
import '../../domain/entities/tag.dart';
import '../bloc/person_bloc.dart';
import 'cn_widgets/cn_message.dart';
import 'common_widgets.dart';

class PersonCard extends StatelessWidget {
  const PersonCard({
    Key? key,
    required this.person,
  }) : super(key: key);

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(person.id.toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      child: InkWell(
        onTap: () => _navigateToEditPage(context),
        child: Card(
          margin: noTopPadding,
          child: ListTile(
            leading: _buildSocialCircle(),
            title: CnTitle(person.name),
            subtitle: _buildSubtitle(context),
          ),
        ),
      ),
    );
  }

  _navigateToEditPage(BuildContext context) {
    selectedPerson = person;

    router.navigateTo(
      context,
      CnRouter.editPersonRoute + '/${person.id}',
    );
  }

  String _timePassed() {
    if (person.socialEvents.isEmpty) return "Never 😬";

    return h.timePassed(person.socialEvents.last.startDate) ??
        "Less than a second ago! That's a record! :))";
  }

  Widget _buildSubtitle(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Last Event: " + _timePassed()),
        TagsInCardWrap(tags: person.tags),
      ],
    );
  }

  _buildSocialCircle() {
    String text =
        person.socialCircle == null ? "🤷🏻‍♂️" : person.socialCircle!.title;

    const double size = 30;

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: CnText(text),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    _removeQuestion() {
      context.read<PersonBloc>().add(RemovePersonEvent(context, person));

      Navigator.pop(context);
    }

    bool result = await showCnConfirmationModalBottomSheet(
      context,
      child: Text(
        "Are you sure you want to delete this person?",
        style: TextStyle(color: accentColor, fontWeight: FontWeight.w500),
      ),
      confirmButtonAction: _removeQuestion,
    );

    return result;
  }
}
