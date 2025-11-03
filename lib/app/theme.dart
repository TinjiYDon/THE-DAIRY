import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C7BFF)),
    useMaterial3: true,
  );
}

ThemeData darkTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6C7BFF),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}

