import 'package:flutter/material.dart';

import '../../../core/app_constants.dart';
import 'cn_animations.dart';
import 'cn_text.dart';

class CnButton extends StatelessWidget {
  const CnButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.color,
    this.active = true,
    this.loading = false,
    this.size,
  }) : super(key: key);

  final String title;
  final Function onPressed;

  final Color? color; // defaultButtonColor
  final bool active;
  final bool loading;

  final Size? size;

  static double buttonHeight = 50;
  static double buttonWidth = deviceWidth / 1.2;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: _buildChild(),
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        fixedSize: size ?? Size(buttonWidth, buttonHeight),
        primary: color ?? defaultButtonColor,
        onSurface: defaultDisabledButtonColor,
      ),
    );
  }

  Widget _buildChild() {
    if (loading) return const CnDottedLoadingAnimation();

    return CnText(title, color: defaultTextColor);
  }
}
