import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_constants.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/social_event.dart';
import '../../domain/usecases/social_event_usecases.dart';
import '../bloc/person_bloc.dart';
import '../bloc/social_event_bloc.dart';
import '../widgets/cn_widgets/cn_button.dart';
import '../widgets/cn_widgets/cn_message.dart';
import '../widgets/cn_widgets/cn_text.dart';
import '../widgets/cn_widgets/cn_textformfield.dart';
import '../widgets/notes_suggester.dart';

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
                  _buildTitle("Attendees"),
                  _buildNoteAttendeesSuggestions(),
                  _buildTitle("Tags"),
                  _buildNoteTagsSuggestions(),
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

  _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: defaultPadding),
      child: CnTitle(title, hasPadding: false),
    );
  }

  Widget _buildNoteAttendeesSuggestions() {
    Set<String> suggestions = {};

    final state = context.read<PersonBloc>().state as PersonLoaded;

    for (var person in state.persons) {
      suggestions.add(person.name.trim().replaceAll(" ", "_"));
    }

    return NotesSuggestor(
      mode: SuggestionMode.attendee,
      suggestions: suggestions,
      focusNode: _notesFocusNode,
      controller: _notesController,
    );
  }

  Widget _buildNoteTagsSuggestions() {
    Set<String> socialDefaultTagSuggestions = {"Meet", "Call"};

    for (var element in allSocialEventTags) {
      socialDefaultTagSuggestions.add(element.title);
    }

    return NotesSuggestor(
      mode: SuggestionMode.tag,
      suggestions: socialDefaultTagSuggestions,
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

  Widget _buildDatePicker() {
    return SizedBox(
      width: deviceWidth,
      height: 100,
      child: CupertinoDatePicker(
        onDateTimeChanged: _onDateTimeChanged,
        mode: CupertinoDatePickerMode.date,
      ),
    );
  }

  _onDateTimeChanged(DateTime value) {
    socialEvent.startDate = value;
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(editMode ? "Edit Social Event" : "Add Social Event"),
    );
  }

  Widget _buildFAB() {
    double bottomPadding = 0;

    if (MediaQuery.of(context).padding.bottom == 0) {
      bottomPadding = defaultPadding * 3;
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: bottomPadding,
          top: bottomPadding / 2,
        ),
        child: CnButton(
          title: "Save",
          fullWidth: true,
          onPressed: _submitForm,
        ),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      _notesFocusNode.requestFocus();
      return;
    }

    if (!_validateEventAttendees()) return;

    // Should be handled in the validation above
    if (socialEvent.attendees.isEmpty) {
      throw "Empty Attendees is not acceptable!";
    }

    socialEvent.title = _titleController.text.trim();
    socialEvent.notes = _notesController.text.trim();

    SocialEventGeneralUsecases.setSocialEventTagsBasedOnNotes(socialEvent);

    if (editMode) {
      // Updating the data from temp
      widget.socialEvent!.copyDataFromSocialEvent(socialEvent);

      _handleRemovedPeopleList();

      context.read<SocialEventBloc>().add(EditSocialEventEvent(
            widget.socialEvent!,
            removedPeople: _removedPeople,
          ));

      Navigator.pop(context);

      return;
    }

    // Add SocialEvent Mode

    context.read<SocialEventBloc>().add(AddSocialEventEvent(socialEvent));

    // FIXME: delay driven development?! Should handle loading state and events
    await Future.delayed(const Duration(milliseconds: 300));

    Navigator.pop(context);
  }

  bool _validateEventAttendees() {
    final state = context.read<PersonBloc>().state as PersonLoaded;

    String? _validateAttendeesErrorMessage =
        SocialEventGeneralUsecases.validateEventAttendees(
      state.persons,
      socialEvent,
      _notesController,
    );

    if (_validateAttendeesErrorMessage != null) {
      showCnMessage(context, text: _validateAttendeesErrorMessage);
      return false;
    }

    return true;
  }

  /// Removing the attendees that have remained in the event from this list
  /// Every Person that remains in this list, is considered removed form the event attendees
  _handleRemovedPeopleList() {
    for (var person in socialEvent.attendees) {
      _removedPeople.remove(person);
    }
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  void _setFieldValuesBasedOnInputSocialEvent() {
    socialEvent.copyDataFromSocialEvent(widget.socialEvent!);

    _titleController.text = socialEvent.title;
    _notesController.text = socialEvent.notes;

    _attendees = socialEvent.attendees;

    // Setting the removed people as all of the current attendees
    // After edit, removing the remaining attendees from this list
    _removedPeople = socialEvent.attendees;
  }

  List<Person> _attendees = [];
  List<Person> _removedPeople = [];

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
