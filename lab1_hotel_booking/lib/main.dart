import 'package:flutter/material.dart';
import 'data/seed.dart';
import 'widgets/stay_card.dart';


void main() => runApp(const MyApp());
// R22: единственный цвет в lib/ — seed, из него строятся обе темы
const _seed = Colors.teal;

class MyApp extends StatefulWidget{
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState();

}
class _MyAppState extends State<MyApp>{
  ThemeMode _themeMode = ThemeMode.system;

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
      home: Scaffold(
        body: SafeArea(
          child:ListView(
            padding: const EdgeInsets.all(8),
            children: [
              for (final s in seedStays())
                StayCard(stay: s, onTap: () {}, onToggleFavourite: () {}),
            ],
          )),
      )
    );
  }
}