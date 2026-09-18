import 'package:flutter/material.dart';

abstract final class AppColors {
  // Main brand colors
  static const Color primary = Color(0xFF20CFA5);
  static const Color dark = Color(0xFF242424);

  // Backgrounds
  static const Color background = Color(0xfffef9e6);
  static const Color backgroundSecondary = Color(0xFFe67c63);
  static const Color card = Colors.white;
  static const Color lightGrey = Color(0xFFF1F1F1);

  // Text
  static const Color primaryText = Color(0xff060f28);
  static const Color secondaryText = Colors.black54;

  // Other
  static const Color divider = Color(0xFFE5E5E5);
  static const Color white = Colors.white;
  static const Color success = Color(0xFFa1dec6);

  // Semantic colors
  static const Color successIconBackground = Color(0xFFB9EBD8);
  static const Color errorIconBackground = Color(0xFFFFE9A8);
  static const Color successIcon = Color(0xFF148563);
  static const Color errorIcon = Color(0xFF1A1A2E);
  static const Color cardTitle = Color(0xFF1A1A2E);
  static const Color successText = Color(0xFF276B57);
  static const Color errorText = Color(0xFF5C4A1E);

  // Border
  static const Color border = Color(0xFFE5E0CE);
  static const Color error = Color.fromARGB(255, 248, 114, 114);
}
