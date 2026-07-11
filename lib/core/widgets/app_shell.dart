import 'package:flutter/material.dart';

import 'app_nav_bar.dart';
import 'app_footer.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          const AppNavBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  child,
                  const AppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
