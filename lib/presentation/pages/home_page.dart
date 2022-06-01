import 'package:flutter/material.dart';

import '../../core/app_constants.dart';
import '../../core/app_router.dart';
import '../widgets/fab_buttom_app_bar.dart';
import 'people_page.dart';
import 'social_events_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: Text(_pages[_selectedTab].text),
      ),
      body: _pages[_selectedTab].page,
      bottomNavigationBar: _buildButtomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFAB(),
    );
  }

  int _selectedTab = 0;

  _selectTab(int index) {
    setState(() => _selectedTab = index);
  }

  _buildButtomNavBar() {
    return FABBottomAppBar(
      items: _items,
      onTabSelected: _selectTab,
      backgroundColor: primaryColor,
      color: accentColor.withOpacity(0.5),
      selectedColor: accentColor,
    );
  }

  _buildFAB() {
    return FloatingActionButton(
      backgroundColor: primaryColor,
      child: Icon(
        _pages[_selectedTab].fabIconData,
        color: accentColor,
      ),
      onPressed: () {
        router.navigateTo(
          context,
          _selectedTab == 0
              ? CnRouter.addPersonRoute
              : CnRouter.addSocialEventRoute,
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
