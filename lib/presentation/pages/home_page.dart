import 'package:flutter/material.dart';
import 'package:social_irl/data/datasources/dummyData.dart';
import 'package:social_irl/presentation/bloc/person_bloc.dart';
import 'package:social_irl/presentation/bloc/social_event_bloc.dart';
import 'package:social_irl/presentation/pages/social_events_page.dart';
import 'package:social_irl/presentation/pages/people_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/fab_buttom_app_bar.dart';

Color primaryColor = Colors.white;
Color accentColor = Colors.black87;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        if (_selectedTab == 0) {
          context.read<PersonBloc>().add(AddPersonEvent(dummyPerson3));
        } else {
          context
              .read<SocialEventBloc>()
              .add(AddSocialEventEvent(dummySocialEvent2));
        }

        setState(() {});

        // Navigate to add page
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
