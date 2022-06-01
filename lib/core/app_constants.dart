import 'package:flutter/material.dart';

import '../domain/entities/person.dart';
import '../domain/entities/social_event.dart';

const String appVersion = "Alpha 0.1";

/// FIXME: This value should be [FALSE] before build
/// Not [const] because it can be switched within the app
bool demoMode = false;
// This value should be [FALSE] before build

// ----- global variables
Person? selectedPerson;
SocialEvent? selectedSocialEvent;

// ----- UI elements: Colors
Color primaryColor = Colors.white;
Color accentColor = Colors.black87;
Color defaultButtonColor = Colors.white;
Color defaultDisabledButtonColor = Colors.grey.shade200;
const Color itemsColor = Colors.white;

// ----- UI elements: Text
TextDirection appTextDirection = TextDirection.ltr;
bool get textDirectionLtr => appTextDirection == TextDirection.ltr;
Color defaultTextColor = Colors.black87;
const String defaultFontFamily = 'CircularStd';

// ----- UI elements: Sizes
const double defaultPadding = 10;
double deviceWidth = 0; // set in the splash screen page build method
double deviceHeight = 0; // set in the splash screen page build method
const EdgeInsetsGeometry noTopPadding = EdgeInsets.only(
  left: defaultPadding,
  right: defaultPadding,
  bottom: defaultPadding,
);
