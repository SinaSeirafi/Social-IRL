import 'package:flutter/material.dart';

import '../../../core/app_constants.dart';
import 'cn_text.dart';

class CnTextFieldAndHeader extends StatefulWidget {
  const CnTextFieldAndHeader({
    Key? key,
    required this.title,
    this.hasClearButton = false,
    this.titleRowHint,
    // For text form field
    required this.controller,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.hintText,
    this.padding = const EdgeInsets.only(
      left: defaultPadding,
      right: defaultPadding,
      bottom: defaultPadding,
    ),
    this.required = false,
    this.focusNode,
  }) : super(key: key);

  // For Header
  final String title;
  final bool hasClearButton;

  /// The hint that shows at the end of the title row
  final String? titleRowHint;

  // Show hide (address) // TODO: isn't it just better to disable the address text field?!
  // auto validate and call function? (address)

  // For text form field
  final TextEditingController controller;
  final Function? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final int maxLines;

  final String? hintText;
  final bool required;

  final EdgeInsets padding;
  final FocusNode? focusNode;

  @override
  State<CnTextFieldAndHeader> createState() => _CnTextFieldAndHeaderState();
}

class _CnTextFieldAndHeaderState extends State<CnTextFieldAndHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildTitle()),
              _buildTitleRowHint(),
            ],
          ),
          const SizedBox(height: 5),
          Stack(
            children: [
              _buildTextFormField(),
              if (widget.hasClearButton) _buildClearButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    String _title = widget.title;

    if (widget.required) _title += " * ";

    return CnTitle(_title);
  }

  Widget _buildTitleRowHint() {
    return CnText(
      widget.titleRowHint ?? "",
      // TODO: fix color
    );
  }

  Widget _buildTextFormField() {
    return _CnTextFormField(
      controller: widget.controller,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      hintText: widget.hintText,
      required: widget.required,
      focusNode: widget.focusNode,
    );
  }

  Widget _buildClearButton() {
    return IconButton(
      onPressed: () {
        // TODO: check if not needed -> stateless widget
        setState(() {
          widget.controller.clear();
        });
      },
      icon: const Icon(Icons.clear), // TODO:
    );
  }
}

class _CnTextFormField extends StatelessWidget {
  const _CnTextFormField({
    Key? key,
    required this.controller,
    this.onFieldSubmitted,
    this.textInputAction,
    this.maxLines = 1,
    this.hintText,
    this.required = false,
    this.focusNode,
  }) : super(key: key);

  final TextEditingController controller;
  final Function? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final int maxLines;

  final String? hintText;
  final bool required;

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: (_) {
        if (onFieldSubmitted != null) onFieldSubmitted!();
      },
      // onFieldSubmitted: (_) => _submitForm(),
      validator: (value) {
        if (required) {
          if (value == null || value.isEmpty) {
            return "";
          }
        }

        return null;
      },
    );
  }
}
