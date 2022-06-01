import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart' as material;

// import '../presentation/bloc/question_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../domain/entities/question.dart';
// import '../presentation/pages/question_add_edit_page.dart';

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

    //   _myRoutes.forEach((route, page) => routeMaker(route, page));

    //   router.define(
    //     '/category/:id',
    //     transitionType: defaultTransition,
    //     handler: Handler(handlerFunc:
    //         (material.BuildContext? context, Map<String, dynamic> params) {
    //       Question question = context.read<QuestionBloc>();

    //       return QuestionAddEditPage(question: question);
    //     }),
    //   );

    // router.define(
    //   '/vendor/:id',
    //   transitionType: defaultTransition,
    //   handler: Handler(handlerFunc:
    //       (material.BuildContext context, Map<String, dynamic> params) {
    //     Vendor vendor =
    //         allVendors.firstWhere((test) => test.id == params['id'][0]);

    //     return MainPage(vendor: vendor);
    //   }),
    // );
  }

  // final Map<String, material.Widget> _myRoutes = {
  // '/main': MainPage(),
  // '/chooseLanguage': ChooseLanguagePage(),
  // '/contactUs': ContactUsPage(),
  // };
}
