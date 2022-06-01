import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart' as material;
import 'package:social_irl/core/app_constants.dart';
import 'package:social_irl/presentation/pages/home_page.dart';
import 'package:social_irl/presentation/pages/person_add_edit_page.dart';
import 'package:social_irl/presentation/pages/social_events_add_edit_page.dart';

// import 'app_constants.dart';
import 'cn_helper.dart';

// ----- Router and navigation
CnRouter _cnRouter = CnRouter.instance;
FluroRouter get router => _cnRouter.router;
TransitionType get defaultTransition => _cnRouter.defaultTransition;
TransitionType get fadeInTransition => _cnRouter.fadeInTransition;
TransitionType get transitionFromBottom => _cnRouter.transitionFromBottom;

class CnRouter {
  static final CnRouter _cnRouter = CnRouter();
  static CnRouter get instance => _cnRouter;

  late FluroRouter router;
  TransitionType defaultTransition = TransitionType.cupertino;
  TransitionType fadeInTransition = TransitionType.fadeIn;
  TransitionType transitionFromBottom = TransitionType.inFromBottom;

  void routeMaker(String route, material.Widget targetPage) {
    router.define(
      route,
      transitionType: defaultTransition,
      handler: Handler(handlerFunc:
          (material.BuildContext? context, Map<String, List<String>> params) {
        return targetPage;
      }),
    );
  }

  void routerSetup() {
    router = FluroRouter();

    _myRoutes.forEach((route, page) => routeMaker(route, page));

    router.define(
      '$editPersonRoute/:id',
      transitionType: defaultTransition,
      handler: Handler(handlerFunc:
          (material.BuildContext? context, Map<String, dynamic> params) {
        if (selectedPerson == null) throw "Null Selected Person";

        if (selectedPerson!.id != _retrieveId(params)) {
          throw "Selected Person not set correctly";
        }

        return PersonAddEditPage(person: selectedPerson);
      }),
    );

    router.define(
      '$editSocialEventRoute/:id',
      transitionType: defaultTransition,
      handler: Handler(handlerFunc:
          (material.BuildContext? context, Map<String, dynamic> params) {
        if (selectedSocialEvent == null) throw "Null Selected Social Event";

        if (selectedSocialEvent!.id != _retrieveId(params)) {
          throw "Selected Social Event not set correctly";
        }

        return SocialEventAddEditPage(socialEvent: selectedSocialEvent);
      }),
    );
  }

  // --- Dynamic Routes
  static const String editPersonRoute = '/editPerson';
  static const String addPersonRoute = '/addPerson';
  static const String editSocialEventRoute = '/editEvent';
  static const String addSocialEventRoute = '/addEvent';

  // --- Static Routes
  static const String homePageRoute = '/home';
  static const String splashScreenRoute = '/splashScreen';
  static const String onBoardingRoute = '/onBoarding';
  static const String errorRoute = '/error';

  final Map<String, material.Widget> _myRoutes = {
    homePageRoute: const HomePage(),
    addPersonRoute: const PersonAddEditPage(),
    addSocialEventRoute: const SocialEventAddEditPage(),
    // addQuestionRoute: const QuestionAddEditPage(),
    // splashScreenRoute: const SplashScreenPage(),
    // onBoardingRoute: const OnBoardingPage(),
    // errorRoute: const QuestionListPage(), // TODO: Return error page
  };
}

int _retrieveId(Map<String, dynamic> params) => h.intOk(params['id'][0])!;
