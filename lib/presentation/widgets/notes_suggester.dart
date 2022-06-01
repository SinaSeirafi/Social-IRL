import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_irl/core/app_constants.dart';
import 'package:social_irl/core/extract_data_from_notes.dart';
import 'package:social_irl/presentation/widgets/cn_widgets/cn_button.dart';

enum SuggestionMode {
  tag,
  attendee,
}

const String tagPattern = "#";
const String attendeePattern = "@";

class NotesSuggestor extends StatelessWidget {
  NotesSuggestor({
    Key? key,
    required this.mode,
    required this.controller,
    required this.focusNode,
    required this.suggestions,
  }) : super(key: key) {
    controller.addListener(() => streamController.add(0));
  }

  final SuggestionMode mode;
  final FocusNode focusNode;
  final TextEditingController controller;
  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamController.stream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Wrap(
            spacing: defaultPadding,
            runSpacing: 10,
            children: [
              _buildSuggestion(pattern, handleRemove: false),
              for (String item in _suggestions) _buildSuggestion(item),
            ],
          ),
        );
      },
    );
  }

  String get pattern =>
      mode == SuggestionMode.attendee ? attendeePattern : tagPattern;

  List<String> get _suggestions {
    return [for (var item in suggestions) pattern + item];
  }

  final StreamController streamController = StreamController();

  _buildSuggestion(String title, {bool handleRemove = true}) {
    bool used = extractDataFromNotes(controller.text.toLowerCase(), pattern)
        .contains(title.substring(1).toLowerCase());

    if (!handleRemove) used = false;

    _addToText() {
      controller.text += " " + title;
      focusNode.requestFocus();
      // Moving the curser to the last position
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }

    _removeFromText() {
      controller.text = controller.text.replaceAll(" " + title, "");
      // in case it was the first word
      controller.text = controller.text.replaceAll(title, "");
    }

    return CnButton(
      title: title,
      largeTitle: false,
      color: used ? Colors.blueGrey.shade100 : primaryColor,
      // color: used ? accentColor.withOpacity(0.3) : primaryColor,
      onPressed: used ? _removeFromText : _addToText,
    );
  }
}
