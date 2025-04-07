import 'package:flutter/material.dart';
import 'package:poke_tools/constants.dart';
import 'package:poke_tools/pages/nuzlocke_tracker_page.dart';
import 'package:poke_tools/theme.dart';

import 'components/navigation/navigation_container.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const PokeTools());
}

class PokeTools extends StatelessWidget {
  const PokeTools({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      themeMode: ThemeMode.dark,
      theme: PokeToolsTheme,
      routes: {
        '/$HOME_PAGE_ROUTE': (context) => const HomePage(),
        '/$NUZLOCKE_TRACKER_PAGE_ROUTE': (context) =>
            const NuzlockeTrackerPage(),
      },
      home: const NavigationContainer(), // Set NavigationContainer as the home
    );
  }
}
