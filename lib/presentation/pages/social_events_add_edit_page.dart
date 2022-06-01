import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_irl/core/app_constants.dart';
import 'package:social_irl/domain/entities/person.dart';
import 'package:social_irl/presentation/bloc/person_bloc.dart';
import 'package:social_irl/presentation/widgets/cn_widgets/cn_message.dart';
import 'package:social_irl/presentation/widgets/notes_suggester.dart';

import '../../core/extract_data_from_notes.dart';
import '../../domain/entities/social_event.dart';

import '../bloc/social_event_bloc.dart';
import '../widgets/cn_widgets/cn_button.dart';
import '../widgets/cn_widgets/cn_textformfield.dart';

class SocialEventAddEditPage extends StatefulWidget {
  const SocialEventAddEditPage({
    Key? key,
    this.socialEvent,
  }) : super(key: key);

  final SocialEvent? socialEvent;

  @override
  State<SocialEventAddEditPage> createState() => _SocialEventAddEditPageState();
}

class _SocialEventAddEditPageState extends State<SocialEventAddEditPage> {
  bool get editMode => widget.socialEvent != null;

  late final SocialEvent socialEvent;

  final _formKey = GlobalKey<FormState>();
  final FocusNode _notesFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildTitleTextField(),
                  _buildDatePicker(),
                  _buildNotesTextField(),
                  _buildNoteSuggestions(),
                ],
              ),
            ),
            _buildFAB(),
          ],
        ),
      ),

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildNoteSuggestions() {
    return NotesSuggestor(
      mode: NoteMode.socialEvent,
      focusNode: _notesFocusNode,
      controller: _notesController,
    );
  }

  CnTextFieldAndHeader _buildTitleTextField() {
    return CnTextFieldAndHeader(
      title: "Title",
      controller: _titleController,
    );
  }

  Container _buildDatePicker() {
    return Container(
      width: deviceWidth,
      height: 100,
      child: CupertinoDatePicker(
        onDateTimeChanged: _onDateTimeChanged,
        mode: CupertinoDatePickerMode.date,
      ),
    );
  }

  CnTextFieldAndHeader _buildNotesTextField() {
    return CnTextFieldAndHeader(
      title: "Notes",
      controller: _notesController,
      focusNode: _notesFocusNode,
      maxLines: 3,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: _submitForm,
      required: true,
    );
  }

  _onDateTimeChanged(DateTime value) {
    socialEvent.startDate = value;
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(editMode ? "Edit Social Event" : "Add Social Event"),
    );
  }

  Widget _buildFAB() {
    return SafeArea(
      child: CnButton(
        title: "Save",
        fullWidth: true,
        onPressed: _submitForm,
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      _notesFocusNode.requestFocus();
      return;
    }

    if (!_validateEventAttendees()) return;

    socialEvent.title = _titleController.text;
    socialEvent.notes = _notesController.text;

    if (editMode) {
      // Updating the data from temp
      widget.socialEvent!.copyDataFromSocialEvent(socialEvent);

      /// To fix Unknown bug.
      /// Sometimes, the opinion page doesn't get updated after edit question is called
      /// Even if it is related to async functions of edit event, it should happen at a later point, but it doesn't
      // context.read<SocialEventBloc>().add(UpdateSocialEventScoreEvent(widget.question!));

      context
          .read<SocialEventBloc>()
          .add(EditSocialEventEvent(widget.socialEvent!));

      Navigator.pop(context);

      return;
    }

    if (socialEvent.attendees.isEmpty) {
      throw "Empty Attendees is not acceptable!";
    }

    // Add SocialEvent Mode
    context.read<SocialEventBloc>().add(AddSocialEventEvent(socialEvent));

    // FIXME: delay driven development?! Should handle loading state and events
    await Future.delayed(const Duration(milliseconds: 300));

    // To get the newly created question with the correct ID (based on database)
    final state = context.read<SocialEventBloc>().state as SocialEventLoaded;

    SocialEvent socialEventFromDB = state.events.last;

    // context.read<SocialEventBloc>().add(UpdateSocialEventScoreEvent(socialEventFromDB));

    Navigator.pop(context);
  }

  bool _validateEventAttendees() {
    socialEvent.attendees = [];

    List<String> attendeesString =
        extractDataFromNotes(_notesController.text, atPattern);

    if (attendeesString.isEmpty) {
      showCnMessage(
        context,
        text: "So, it was a personal event? \nNot really social, is it? :D"
            "\n\nPlease add at least one attendee \n(type @name in the notes text box)",
      );
      return false;
    }

    final state = context.read<PersonBloc>().state as PersonLoaded;

    for (var item in attendeesString) {
      // is .any() and .firstWhere() faster than this?
      bool found = false;

      for (var person in state.persons) {
        if (person.name.toLowerCase() == item.toLowerCase()) {
          // FIXME: so ... what if two people have the same name? :D

          /// should be much more advanced and show possible options (if multiple)
          /// and user chooses between them
          /// but for now it can be enough

          socialEvent.attendees.add(person);
          found = true;
          break;
        }
      }

      if (!found) {
        showCnMessage(
          context,
          text: "One of the people was not found",
        );
        return false;
      }
    }

    return true;
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  void _setFieldValuesBasedOnInputSocialEvent() {
    socialEvent.copyDataFromSocialEvent(widget.socialEvent!);

    _titleController.text = socialEvent.title ?? "";
    _notesController.text = socialEvent.notes ?? "";

    _attendees = socialEvent.attendees;
  }

  List<Person> _attendees = [];

  @override
  void initState() {
    super.initState();

    socialEvent = SocialEvent(
      id: DateTime.now().millisecondsSinceEpoch,
      startDate: DateTime.now(),
      attendees: _attendees,
    );

    if (editMode) _setFieldValuesBasedOnInputSocialEvent();
  }
}
