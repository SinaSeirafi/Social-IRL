import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_irl/presentation/widgets/cn_widgets/cn_button.dart';

import '../../../core/app_constants.dart';
import 'cn_animations.dart';
import 'cn_blur.dart';
import 'cn_dialog.dart';

Future<bool> showCnConfirmationModalBottomSheet(
  BuildContext context, {
  required Widget child,
  bool showButton = true,
  String buttonText = 'Got it',
  required Function confirmButtonAction,
  double height = 240,
  double? horizontalPadding,
  double? buttonTopPadding,
  bool enableDragToClose = true,
  // required Stream buttonLoadingStream,
}) async {
  late bool result;

  void _closeModal() {
    result = false;
    Navigator.pop(context);
  }

  Color _backgroundColor = primaryColor;

  Widget _buildButton() {
    if (!showButton) return Container();

    Size buttonSize = Size(100, CnButton.buttonHeight);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CnButton(
          title: "Yes",
          size: buttonSize,
          onPressed: () {
            result = true;
            confirmButtonAction();
          },
        ),
        CnButton(
          title: "No",
          size: buttonSize,
          onPressed: _closeModal,
        ),
      ],
    );

    // return CnButton(
    //   title: buttonText,
    //   loadingStream: buttonLoadingStream,
    //   onPressed: buttonOnPressed ?? _closeModal,
    // );
  }

  Widget _buildAnimations({required Widget child}) {
    return CnSlide(
      begin: const Offset(0, 0.015),
      child: Container(
        alignment: Alignment.bottomCenter,
        child: child,
      ),
    );
  }

  BorderRadius _borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  );

  await showFullScreenDialog(
    context: context,
    barrierColor: Colors.white.withOpacity(0),
    builder: (context) {
      return GestureDetector(
        onTap: _closeModal,
        child: Material(
          color: Colors.transparent,
          child: CnFade(
            child: CnBlur(
              backgroundColor: _backgroundColor,
              backgroundColorOpacity: 0.05,
              depth: 5,
              child: Container(
                alignment: FractionalOffset.bottomCenter,
                width: deviceWidth,
                // color: _backgroundColor.withOpacity(0.05),
                child: _buildAnimations(
                  child: ClipRRect(
                    borderRadius: _borderRadius,
                    child: Container(
                      color: _backgroundColor,
                      // width: adjustedWidth,
                      height: height,
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding ?? defaultPadding,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // Main Widget
                          child,
                          SizedBox(
                            height: buttonTopPadding ?? defaultPadding * 4,
                          ),
                          _buildButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  return result;
}

Future<bool> showCnMessage(
  BuildContext context, {
  String? text,
  Widget? child,
  String buttonText = 'Got it',
  double height = 240,
  double? horizontalPadding,
  double? buttonTopPadding,
  bool enableDragToClose = true,
  TextAlign textAlign = TextAlign.center,
  // required Stream buttonLoadingStream,
}) async {
  if (child == null && text == null) {
    throw "Both child and text shouldn't be empty in [showCnMessage]";
  }

  late bool result;

  void _closeModal() {
    result = false;
    Navigator.pop(context);
  }

  Color _backgroundColor = primaryColor;

  Widget _buildAnimations({required Widget child}) {
    return CnSlide(
      begin: const Offset(0, 0.015),
      child: Container(
        alignment: Alignment.bottomCenter,
        child: child,
      ),
    );
  }

  BorderRadius _borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  );

  await showFullScreenDialog(
    context: context,
    barrierColor: Colors.white.withOpacity(0),
    builder: (context) {
      return GestureDetector(
        onTap: _closeModal,
        child: Material(
          color: Colors.transparent,
          child: CnFade(
            child: CnBlur(
              backgroundColor: _backgroundColor,
              backgroundColorOpacity: 0.05,
              depth: 5,
              child: Container(
                alignment: FractionalOffset.bottomCenter,
                width: deviceWidth,
                // color: _backgroundColor.withOpacity(0.05),
                child: _buildAnimations(
                  child: ClipRRect(
                    borderRadius: _borderRadius,
                    child: Container(
                      color: _backgroundColor,
                      // width: adjustedWidth,
                      height: height,
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding ?? defaultPadding,
                      ),
                      alignment: Alignment.center,
                      // ------ Main Widget ------
                      child: child ?? Text(text!, textAlign: textAlign),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  return result;
}
