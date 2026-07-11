import 'package:flutter/widgets.dart';

abstract final class Breakpoints {
  static const double mobile = 600.0;
  static const double tablet = 960.0;
  static const double desktop = 1280.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobile && width < tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;

  static bool isWideDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktop;

  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (Breakpoints.isMobile(context)) return mobile;
    if (Breakpoints.isTablet(context)) return tablet ?? desktop;
    return desktop;
  }
}
