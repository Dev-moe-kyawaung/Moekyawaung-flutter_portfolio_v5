import 'package:flutter/material.dart';

extension StringX on String {
  String get capitalize => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  String get initials => split(' ').take(2).map((w) => w.isEmpty ? '' : w[0]).join().toUpperCase();
  bool get isValidEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(this);
}

extension ColorX on Color {
  Color withLightness(double lightness) => HSLColor.fromColor(this).withLightness(lightness).toColor();
}

extension ContextX on BuildContext {
  double get width  => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  bool get isMobile  => width < 768;
  bool get isTablet  => width >= 768 && width < 1200;
  bool get isDesktop => width >= 1200;
}

extension DurationX on int {
  Duration get ms => Duration(milliseconds: this);
  Duration get s  => Duration(seconds: this);
}
