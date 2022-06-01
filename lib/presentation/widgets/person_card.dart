import 'package:flutter/material.dart';
import 'package:social_irl/domain/entities/person.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_irl/presentation/widgets/cn_widgets/cn_text.dart';

import '../../core/app_constants.dart';
import '../bloc/person_bloc.dart';
import 'cn_widgets/cn_message.dart';

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
      child: Card(
        child: ListTile(
          leading: _buildSocialCircle(),
          title: Text(person.name),
          subtitle: _buildSubtitle(),
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    String _subTitleText = "Never 😬";

    if (person.socialEvents.isNotEmpty) {
      DateTime lastEvent = person.socialEvents.last.startDate;

      _subTitleText = lastEvent.difference(DateTime.now()).inSeconds.toString();
      // _subTitleText = lastEvent.difference(DateTime.now()).inDays.toString();
    }

    return Text(_subTitleText);
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
