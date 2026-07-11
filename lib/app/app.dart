import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class FlutterBirminghamApp extends StatelessWidget {
  const FlutterBirminghamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Birmingham',
      theme: AppTheme.light,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
