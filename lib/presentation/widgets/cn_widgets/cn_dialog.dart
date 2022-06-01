import 'dart:async';

import 'package:flutter/material.dart';

import 'cn_animations.dart';
import 'cn_blur.dart';

Future showCnDialog({
  required BuildContext context,
  required Widget child,
}) async {
  await showFullScreenDialog(
    context: context,
    builder: (context) {
      return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Material(
          color: Colors.transparent,
          child: CnFade(
            child: CnBlur(
              // backgroundColor: Theme.of(context).primaryColor,
              backgroundColorOpacity: 0.05,
              depth: 5,
              child: child,
            ),
          ),
        ),
      );
    },
  );
}

Future<T?> showFullScreenDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  required WidgetBuilder builder,
  Duration transitionDuration = const Duration(milliseconds: 150),
  Color barrierColor = Colors.black54,
}) {
  assert(debugCheckHasMaterialLocalizations(context));
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final ThemeData theme = Theme.of(context);

      final Widget pageChild = Builder(builder: builder);
      return WillPopScope(
        onWillPop: () => Future.value(barrierDismissible),
        child: Builder(
          builder: (BuildContext context) {
            return Theme(data: theme, child: pageChild);
          },
        ),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor,
    transitionDuration: transitionDuration,
    transitionBuilder: _buildMaterialDialogTransitions,
  );
}

Widget _buildMaterialDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}
