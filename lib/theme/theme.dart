import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.primaries.last),
  useMaterial3: true,
  scaffoldBackgroundColor: const Color.fromARGB(255, 36, 36, 36),
  dividerColor: Colors.white24,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: Color.fromARGB(255, 36, 36, 36),
    titleTextStyle: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
    shape: Border(bottom: BorderSide(color: Colors.orange, width: 2)),
    elevation: 0,
  ),
  listTileTheme: const ListTileThemeData(iconColor: Colors.white),
  textTheme: TextTheme(
    bodyMedium: const TextStyle(
        color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
    labelSmall: TextStyle(
        color: Colors.white.withOpacity(0.6),
        fontWeight: FontWeight.w700,
        fontSize: 14),
  ),
);
