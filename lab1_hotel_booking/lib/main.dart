import 'package:flutter/material.dart';

import 'screens/shell.dart';

void main() => runApp(const MyApp());

// R22: единственный цвет в lib/ — seed, из него строятся обе темы
const _seed = Colors.teal;

// R11: ThemeMode живёт в State виджета MyApp, выше MaterialApp
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  // R11: тему меняет только MyApp
  void _setThemeMode(ThemeMode mode) => setState(() => _themeMode = mode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking',
      debugShowCheckedModeBanner: false,
      // R22: светлая тема
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seed),
      ), 
      // R22: тёмная тема из того же seed
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ), 
      ), 
      themeMode: _themeMode,
      // R11: режим темы и способ его поменять уходят вниз
      home: Shell(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
    ); 
  }
}