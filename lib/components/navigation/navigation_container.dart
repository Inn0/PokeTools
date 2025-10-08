import 'package:flutter/material.dart';
import 'package:poke_tools/constants.dart';
import 'package:poke_tools/pages/home_page.dart';
import 'package:poke_tools/pages/levelcaps_page.dart';
import 'package:poke_tools/pages/locations_page.dart';
import 'package:poke_tools/pages/nuzlocke_tracker_page.dart';
import 'package:poke_tools/theme.dart';

class NavigationContainer extends StatefulWidget {
  const NavigationContainer({super.key});

  @override
  NavigationContainerState createState() => NavigationContainerState();
}

class NavigationContainerState extends State<NavigationContainer> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  String _selectedRoute = HOME_PAGE_ROUTE;

  bool get isDesktop => MediaQuery.of(context).size.width > 600;

  void _navigateTo(String route, String title) {
    setState(() {
      _selectedRoute = route;
    });

    _navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(route, (route) => false);

    Navigator.of(context, rootNavigator: true).pop();
  }

  Widget _buildSidebar() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              APP_TITLE,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: pokemonYellow,
                shadows: [
                  Shadow(offset: Offset(-2, -2), color: pokemonBlue),
                  Shadow(offset: Offset(2, -2), color: pokemonBlue),
                  Shadow(offset: Offset(-2, 2), color: pokemonBlue),
                  Shadow(offset: Offset(2, 2), color: pokemonBlue),
                ],
              ),
            ),
          ),
          _buildMenuItem(HOME_PAGE, HOME_PAGE_ROUTE),
          _buildMenuItem(NUZLOCKE_TRACKER_PAGE, NUZLOCKE_TRACKER_PAGE_ROUTE),
          _buildMenuItem(LOCATIONS_PAGE, LOCATIONS_PAGE_ROUTE),
          _buildMenuItem(LEVELCAPS_PAGE, LEVELCAPS_PAGE_ROUTE),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, String route) {
    bool isSelected = _selectedRoute == route;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: isDesktop ? 20 : 16,
          color: Colors.white,
        ),
      ),
      tileColor: isSelected ? Theme.of(context).primaryColor : null,
      onTap: () => _navigateTo(route, title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedRoute == HOME_PAGE_ROUTE
            ? HOME_PAGE
            : NUZLOCKE_TRACKER_PAGE),
        backgroundColor: pokemonRed,
      ),
      body: Row(
        children: [
          Expanded(
            child: Navigator(
              key: _navigatorKey,
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case HOME_PAGE_ROUTE:
                    return _buildPageRoute(const HomePage());
                  case NUZLOCKE_TRACKER_PAGE_ROUTE:
                    return _buildPageRoute(const NuzlockeTrackerPage());
                  case LOCATIONS_PAGE_ROUTE:
                    return _buildPageRoute(const LocationsPage());
                  case LEVELCAPS_PAGE_ROUTE:
                    return _buildPageRoute(const LevelCapsPage());
                  default:
                    return _buildPageRoute(const HomePage());
                }
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(child: _buildSidebar()),
      extendBodyBehindAppBar: false,
    );
  }

  PageRouteBuilder _buildPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: Duration.zero,
      transitionsBuilder: (_, __, ___, child) => child,
    );
  }
}
