import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_irl/core/cn_helper.dart';

import '../../core/app_constants.dart';
import '../../core/app_router.dart';
import '../widgets/fab_buttom_app_bar.dart';
import 'person_list_page.dart';
import 'social_events_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    controller.addListener(() => streamController.add(controller.page ?? 0.0));

    return StreamBuilder<double>(
      stream: streamController.stream,
      initialData: 0,
      builder: (context, snapshot) {
        int _selectedTab = h.roundToInt(snapshot.data ?? 0.0)!;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            centerTitle: false,
            title: Text(_pages[_selectedTab].text),
          ),
          body: PageView(
            controller: controller,
            children: [
              for (var page in _pages) page.page,
            ],
          ),
          bottomNavigationBar: _buildButtomNavBar(_selectedTab),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _buildFAB(_selectedTab),
        );
      },
    );
  }

  final StreamController<double> streamController = StreamController<double>();

  _selectTab(int index) {
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  final PageController controller = PageController();

  _buildButtomNavBar(index) {
    return FABBottomAppBar(
      items: _items,
      onTabSelected: _selectTab,
      backgroundColor: primaryColor,
      color: accentColor.withOpacity(0.3),
      selectedColor: accentColor,
      startingIndex: index,
    );
  }

  _buildFAB(index) {
    return FloatingActionButton(
      backgroundColor: primaryColor,
      child: Icon(
        _pages[index].fabIconData,
        color: accentColor,
      ),
      onPressed: () {
        router.navigateTo(
          context,
          index == 0 ? CnRouter.addPersonRoute : CnRouter.addSocialEventRoute,
        );
      },
    );
  }

  List<FABBottomAppBarItem> get _items => [
        for (var item in _pages)
          FABBottomAppBarItem(
            iconData: item.navIconData,
            text: item.text,
          ),
      ];
}

List<AppPage> get _pages => [
      AppPage(
        navIconData: Icons.group,
        fabIconData: Icons.person_add,
        text: "People",
        fabRoute: "",
        page: const PeopleListPage(),
      ),
      AppPage(
        navIconData: Icons.event,
        fabIconData: Icons.edit_calendar,
        text: "Events",
        fabRoute: "",
        page: const SocialEventsListPage(),
      ),
    ];
