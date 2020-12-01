
import 'package:streamer_review/profile.dart';
import 'package:streamer_review/register.dart';
import 'package:streamer_review/temp_favorites.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    // StreamerPage(),
    // HomePage(),
    FavoritesPage(),
    // SettingsPage(),
    Profile(),
    Register(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        items: [

          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.grey,

            ),
            title: Text('HOME'),
            activeIcon: Icon(
              Icons.home,
              color: Colors.deepPurple[800],
            ),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.search,
          //     color: Colors.grey,
          //   ),
          //   title: Text('SEARCH'),
          //   activeIcon: Icon(
          //     Icons.search,
          //     color: Colors.deepPurple[800],
          //   ),
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Colors.grey,
            ),
            title: Text('FAVORITES'),
            activeIcon: Icon(
              Icons.favorite,
              color: Colors.deepPurple[800],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.grey,
            ),
            title: Text('SETTINGS'),
            activeIcon: Icon(
              Icons.settings,
              color: Colors.deepPurple[800],
            ),
          ),
        ],
        selectedItemColor:   Colors.deepPurple[800],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: Stack(
        children: [
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
          _buildOffstageNavigator(2),
          // _buildOffstageNavigator(3),
        ],
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          HomeScreen(),
          // StreamerPage(),
          // HomePage(),
          FavoritesPage(),
          Profile(),
          Register()
          // SettingsPage(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }
}

