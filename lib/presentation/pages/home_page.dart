import 'package:flutter/material.dart';

import '../widgets/fab_buttom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FABBottomAppBar(
        items: _items,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: _buildIcon(),
        onPressed: () {},
      ),
    );
  }

  int selectedTab = 0;

  _buildIcon() {
    return Icon(Icons.person_add);
  }

  final List<FABBottomAppBarItem> _items = [
    FABBottomAppBarItem(
      iconData: Icons.group,
      text: "People",
    ),
    FABBottomAppBarItem(
      iconData: Icons.event,
      text: "Events",
    ),
  ];
}
