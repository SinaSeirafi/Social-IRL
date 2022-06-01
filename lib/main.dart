import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app_router.dart';
import 'presentation/bloc/person_bloc.dart';
import 'presentation/bloc/social_event_bloc.dart';
import 'presentation/pages/splash_screen_page.dart';

void main() {
  runApp(const MyApp());

  CnRouter.instance.routerSetup();
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
        ),
        home: const SplashScreenPage(),
      ),
    );
  }
}
