import 'package:budget_app/screens/welcome/welcome.dart';
import 'package:budget_app/shared/utils/toaster.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Budget App",
      theme: _buildTheme(Brightness.light),
      builder: Toaster.builder,

      home: WelcomePage(),
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  final baseTheme = ThemeData(brightness: brightness);

  return baseTheme.copyWith(
    textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
  );
}
