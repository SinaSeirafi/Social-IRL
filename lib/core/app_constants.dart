import 'app_router.dart';
import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

const String appVersion = "Beta 1.0";

// ----- global variables
bool demoMode = true; //FIXME:
int currentDatabaseLastId = 1;
// Question? selectedQuestion;
Color positiveResultColor = Colors.teal.shade300;
Color negativeResultColor = Colors.red.shade300;

// ----- UI elements
TextDirection appTextDirection = TextDirection.ltr;
bool get textDirectionLtr => appTextDirection == TextDirection.ltr;
const double defaultPadding = 10;
double deviceWidth = 0; // set in the splash screen page build method
double deviceHeight = 0; // set in the splash screen page build method

// ----- Router and navigation
CnRouter _cnRouter = CnRouter.instance;
fluro.FluroRouter get router => _cnRouter.router;
fluro.TransitionType get defaultTransition => _cnRouter.defaultTransition;
fluro.TransitionType get fadeInTransition => _cnRouter.fadeInTransition;
fluro.TransitionType get transitionFromBottom => _cnRouter.transitionFromBottom;

// ----- URL Launcher
launchURL(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      // forceWebView: false,
      // forceSafariVC: false,
    );
  } else {
    throw 'Could not launch $url';
  }
}
