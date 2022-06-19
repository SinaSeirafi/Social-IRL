import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_irl/core/app_constants.dart';

import 'core/app_router.dart';
import 'presentation/bloc/person_bloc.dart';
import 'presentation/bloc/social_event_bloc.dart';
import 'presentation/pages/splash_screen_page.dart';

void main() {
  CnRouter.instance.routerSetup();

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
    ));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PersonBloc()..add(const LoadPersonData()),
        ),
        BlocProvider(
          create: (context) =>
              SocialEventBloc()..add(const LoadSocialEventData()),
        ),
      ],
      child: MaterialApp(
        title: 'Social IRL',
        theme: ThemeData(
          primarySwatch: Colors.grey,
          scaffoldBackgroundColor: primaryColor,
          backgroundColor: primaryColor,
          appBarTheme: AppBarTheme(
            backgroundColor: primaryColor,
          ),
        ),
        home: const SplashScreenPage(),
        onGenerateRoute: router.generator,
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (context) => const Center(child: Text("Unknown Route")),
          );
        },
      ),
    );
  }
}
