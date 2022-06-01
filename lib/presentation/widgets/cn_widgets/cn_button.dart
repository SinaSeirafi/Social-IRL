import 'package:flutter/material.dart';

import '../../../core/app_constants.dart';
import 'cn_animations.dart';
import 'cn_text.dart';

class CnButton extends StatelessWidget {
  const CnButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.largeTitle = true,
    this.color,
    this.active = true,
    this.loading = false,
    this.size,
    this.fullWidth = false,
    this.width,
    this.elevation = 2,
  }) : super(key: key);

  final Function onPressed;

  final String title;
  final bool largeTitle;

  final Color? color; // defaultButtonColor
  final bool active;
  final bool loading;

  final bool fullWidth;
  final Size? size;
  final double? width;
  final double? elevation;

  static double buttonHeight = 50;
  static double buttonWidth = deviceWidth / 1.2;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: _buildChild(),
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        fixedSize: _size,
        primary: color ?? defaultButtonColor,
        onSurface: defaultDisabledButtonColor,
      ),
    );
  }

  Widget _buildChild() {
    if (loading) return const CnDottedLoadingAnimation();

    if (largeTitle) return CnTitle(title, color: defaultTextColor);

    return CnText(title, color: defaultTextColor);
  }

  Size? get _size {
    if (size != null) return size!;

    if (fullWidth) return Size(buttonWidth, buttonHeight);

    if (width != null) return Size(width!, buttonHeight);

    return null;
  }
}
