import 'package:flutter/material.dart';
import 'package:poke_tools/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text(HOME_PAGE, style: TextStyle(fontSize: 24)));
  }
}
