import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static double maxWidth(BuildContext context) =>
      MediaQuery.of(context).size.width < 1400 ? MediaQuery.of(context).size.width : 1400;

  static double padding(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < 768) return 20;
    if (w < 1200) return 48;
    return 80;
  }

  static T value<T>(BuildContext context, {
    required T mobile, T? tablet, required T desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet ?? desktop;
    return desktop;
  }
}
