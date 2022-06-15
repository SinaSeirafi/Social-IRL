import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_irl/core/app_constants.dart';
import 'package:social_irl/core/cn_helper.dart';
import 'package:social_irl/data/datasources/dummyData.dart';
import 'package:social_irl/domain/usecases/person_usecases.dart';
import 'package:social_irl/presentation/widgets/cn_widgets/cn_text.dart';

import '../../domain/entities/person.dart';
import '../bloc/person_bloc.dart';
import '../widgets/cn_widgets/cn_button.dart';

import '../widgets/cn_widgets/cn_textformfield.dart';
import '../widgets/notes_suggester.dart';

class PersonAddEditPage extends StatefulWidget {
  const PersonAddEditPage({
    Key? key,
    this.person,
  }) : super(key: key);

  final Person? person;

  @override
  State<PersonAddEditPage> createState() => _PersonAddEditPageState();
}

class _PersonAddEditPageState extends State<PersonAddEditPage> {
  bool get editMode => widget.person != null;

  late final Person person;

  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _notesFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildNameTextField(),
                    _buildNotesTextField(),
                    _buildTitle("Circle"),
                    _buildSocialCircle(),
                    _buildTitle("Tags"),
                    _buildNoteSuggestions(),
                  ],
                ),
              ),
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteSuggestions() {
    Set<String> personDefaultTagSuggestions = {};

    for (var element in allPersonTags) {
      personDefaultTagSuggestions.add(element.title);
    }

    return NotesSuggestor(
      suggestions: personDefaultTagSuggestions,
      mode: SuggestionMode.tag,
      focusNode: _notesFocusNode,
      controller: _notesController,
    );
  }

  CnTextFieldAndHeader _buildNameTextField() {
    return CnTextFieldAndHeader(
      title: "Name",
      controller: _nameController,
      focusNode: _nameFocusNode,
      required: true,
    );
  }

  _buildSocialCircle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Wrap(
        spacing: defaultPadding,
        runSpacing: 5,
        children: [
          for (var circle in allSocialCircles)
            CnButton(
              color: person.socialCircle == circle
                  ? selectedItemColor
                  : primaryColor,
              onPressed: () {
                setState(() {
                  person.socialCircle = circle;
                });
              },
              title: circle.title,
            ),
        ],
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
    );
  }

  _buildTitle(String title) {
    return CnTitle(title);
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(editMode ? person.name : "Add Person"),
    );
  }

  Widget _buildButton() {
    double bottomPadding = 0;

    if (MediaQuery.of(context).padding.bottom == 0) {
      bottomPadding = defaultPadding * 3;
    }

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(
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
      _nameFocusNode.requestFocus();
      return;
    }

    person.name = _nameController.text.trim();
    person.notes = _notesController.text.trim();

    PersonGeneralUsecases.setPersonTagsBasedOnNotes(person);

    if (editMode) {
      // Updating the data from temp
      widget.person!.copyDataFromPerson(person);

      /// To fix Unknown bug.
      /// Sometimes, the opinion page doesn't get updated after edit question is called
      /// Even if it is related to async functions of edit event, it should happen at a later point, but it doesn't
      // context.read<PersonBloc>().add(UpdatePersonScoreEvent(widget.question!));

      context.read<PersonBloc>().add(EditPersonEvent(widget.person!));

      Navigator.pop(context);

      return;
    }

    // Add Person Mode
    context.read<PersonBloc>().add(AddPersonEvent(person));

    // FIXME: delay driven development?! Should handle loading state and events
    await Future.delayed(const Duration(milliseconds: 100));

    // To get the newly created question with the correct ID (based on database)
    final state = context.read<PersonBloc>().state as PersonLoaded;

    Person personFromDB = state.persons.last;

    // context.read<PersonBloc>().add(UpdatePersonScoreEvent(personFromDB));

    Navigator.pop(context);
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  void _setFieldValuesBasedOnInputPerson() {
    person.copyDataFromPerson(widget.person!);

    _nameController.text = person.name;
    _notesController.text = person.notes ?? "";
  }

  @override
  void initState() {
    super.initState();

    person = Person(
      id: DateTime.now().millisecondsSinceEpoch,
      name: "",
      socialCircle: allSocialCircles.first,
    );

    if (editMode) _setFieldValuesBasedOnInputPerson();
  }
}
