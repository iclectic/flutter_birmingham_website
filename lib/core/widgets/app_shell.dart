import 'package:flutter/material.dart';

import 'app_footer.dart';
import 'app_nav_bar.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppNavBar(),
          Expanded(
            // Keyed by path so each route starts scrolled to the top.
            child: SingleChildScrollView(
              key: ValueKey(location),
              child: Column(children: [child, const AppFooter()]),
            ),
          ),
        ],
      ),
    );
  }
}
