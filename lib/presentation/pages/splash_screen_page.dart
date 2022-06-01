import 'package:flutter/material.dart';

import '../../core/app_constants.dart';
import '../../core/app_router.dart';
import '../../core/read_write_data.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return Material(
      child: InkWell(
        onTap: _navigateForward,
        child: StackWidgetsAboveLogoAndName(
          childStackedBelow: Container(
            color: accentColor,
          ),
          child: const AppVersionPositioned(),
        ),
      ),
    );
  }

  @override
  void initState() {
    // For dramatic effect :D
    Future.delayed(
      const Duration(seconds: 2),
      _navigateForward,
    );

    super.initState();
  }

  _navigateForward() async {
    _navigateHome() {
      router.navigateTo(
        context,
        CnRouter.homePageRoute,
        transition: fadeInTransition,
      );
    }

    // TODO: handle app version
    _navigateToOnBoarding(int version) {
      router.navigateTo(
        context,
        CnRouter.onBoardingRoute,
        transition: fadeInTransition,
      );
    }

    return _navigateHome();

    if (demoMode) {
      _navigateToOnBoarding(0);
      return;
    }

    bool isInitialStartup = true;

    String? lastShownOnBoardingVersion;

    try {
      lastShownOnBoardingVersion =
          await rw.read("lastShownOnBoardingVersion", "String");

      isInitialStartup = lastShownOnBoardingVersion == null;
      // Uncomment to enforce loading onboarding
      // isInitialStartup = true;
    } catch (e) {
      // For when the previous value is wrong somehow
      await rw.clearData();
    }

    if (isInitialStartup) {
      _navigateToOnBoarding(0);
    } else {
      /// Future versions:
      /// check onboarding update page version
      /// if same -> home
      /// else show updates since last version

      _navigateHome();
    }
  }
}

class StackWidgetsAboveLogoAndName extends StatelessWidget {
  const StackWidgetsAboveLogoAndName({
    Key? key,
    this.child,
    this.childStackedBelow,
    this.children = const [],
    this.logoElementsColor = Colors.white,
  }) : super(key: key);

  /// For when you have only one child
  final Widget? child;
  final Widget? childStackedBelow;
  final List<Widget> children;
  final Color logoElementsColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        childStackedBelow ?? Container(),
        AppLogoAndName(elementsColor: logoElementsColor),
        ...children,
        child ?? Container(),
      ],
    );
  }
}

class AppVersionPositioned extends StatelessWidget {
  const AppVersionPositioned({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      bottom: defaultPadding * 1.5,
      child: Text(
        appVersion,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }
}

class AppLogoAndName extends StatelessWidget {
  const AppLogoAndName({
    Key? key,
    this.elementsColor = Colors.white,
  }) : super(key: key);

  final Color elementsColor;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "App Logo Hero Tag",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_alt,
            size: 40,
            color: elementsColor,
          ),
          const SizedBox(height: 10),
          Material(
            color: Colors.transparent,
            child: Text(
              "Social IRL",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: elementsColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
