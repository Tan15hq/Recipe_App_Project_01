import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
  useMaterial3: true,
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16),
  ),
);
