import 'package:flutter/material.dart';
import 'package:social_irl/core/app_constants.dart';
import 'package:social_irl/presentation/widgets/cn_widgets/cn_button.dart';

enum NoteMode {
  person,
  socialEvent,
}

const String tagPattern = "#";
const String atPattern = "@";

const List<String> personDefaultTagSuggestions = [];

List<String> personModeSuggestions = [
  tagPattern,
  for (var item in personDefaultTagSuggestions) tagPattern + item,
];

const List<String> socialDefaultTagSuggestions = [
  "Meet",
  "Call",
];

List<String> socialEventModeSuggestions = [
  atPattern,
  tagPattern,
  for (var item in socialDefaultTagSuggestions) tagPattern + item,

  // TODO: add People & hashtags dynamically
];

class NotesSuggestor extends StatelessWidget {
  const NotesSuggestor({
    Key? key,
    required this.mode,
    required this.controller,
    required this.focusNode,
  }) : super(key: key);

  final NoteMode mode;
  final FocusNode focusNode;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Wrap(
        spacing: defaultPadding,
        runSpacing: 10,
        children: [
          for (String item in suggestions) _buildSuggestion(item),
        ],
      ),
    );
  }

  List<String> get suggestions {
    if (mode == NoteMode.person) return personModeSuggestions;

    return socialEventModeSuggestions;
  }

  _buildSuggestion(String title) {
    return CnButton(
      title: title,
      // size: Size(100, 50),
      onPressed: () {
        controller.text += " " + title;
        focusNode.requestFocus();
        // Moving the curser to the last position
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      },
    );
  }
}
