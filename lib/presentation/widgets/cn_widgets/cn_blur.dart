import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CnBlur extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;

  final double depth;
  final double? sigmaX;
  final double? sigmaY;

  final Color backgroundColor;
  final double backgroundColorOpacity;

  const CnBlur({
    required this.child,
    this.height,
    this.width,
    this.depth = 10.0,
    this.sigmaX,
    this.sigmaY,
    this.backgroundColor = Colors.white,
    this.backgroundColorOpacity = 0.75,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color finalBackgroundColor = backgroundColor;
    double finalBackgroundColorOpacity = backgroundColorOpacity;

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: sigmaX ?? depth,
          sigmaY: sigmaY ?? depth,
        ),
        child: Container(
          decoration: BoxDecoration(
            color:
                finalBackgroundColor.withOpacity(finalBackgroundColorOpacity),
          ),
          child: SizedBox(
            height: height,
            width: width,
            child: child,
          ),
        ),
      ),
    );
  }
}
