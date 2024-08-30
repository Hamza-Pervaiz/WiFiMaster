import 'package:flutter/material.dart';
import 'package:masterwifi/browserScreen.dart';
import 'package:masterwifi/connectScreen.dart';
import 'package:masterwifi/moreScreen.dart';
import 'package:masterwifi/tool_Screen.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Connectscreen(),
    ToolScreen(),
    Browserscreen(),
    MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.wifi),
              label: 'Connect',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.badge_sharp),
              label: 'Tools',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.browser_updated_sharp),
              label: 'Browser',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more),
              label: 'More',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey),
    );
  }
}
