
import 'package:streamer_review/profile.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamer_review/view_reviews.dart';

import 'favorites.dart';
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
    ReviewsPage(),
    // SettingsPage(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[850],
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
              color: Colors.lightGreenAccent,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Colors.grey,
            ),
            title: Text('FAVORITES'),
            activeIcon: Icon(
              Icons.favorite,
              color: Colors.lightGreenAccent,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.rate_review,
              color: Colors.grey,
            ),
            title: Text('REVIEWS'),
            activeIcon: Icon(
              Icons.rate_review,
              color: Colors.lightGreenAccent,
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
              color: Colors.lightGreenAccent,
            ),
          ),
        ],
        selectedItemColor:   Colors.lightGreenAccent,
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
          _buildOffstageNavigator(3),
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
          ReviewsPage(),
          Profile(),
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
