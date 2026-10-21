import 'package:flutter/material.dart';

import '../data/seed.dart';
import '../models/stay.dart';
import 'favourites_tab.dart';
import 'profile_tab.dart';
import 'stays_tab.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  // R10: список живёт в State оболочки
  List<Stay> _stays = seedStays();
  // какая вкладка открыта: 0 Stays, 1 Favourites, 2 Profile
  int _tab = 0;

  void _toggleFavourite(Stay stay) {
    final updated = [
      for (final s in _stays)
        s.id == stay.id ? s.copyWith(favourite: !s.favourite) : s,
    ];
    // R12: внутри setState только изменение
    setState(() => _stays = updated);
  }

  // R28: вкладки переключает только Shell
  void _goToTab(int index) => setState(() => _tab = index);

  @override
  Widget build(BuildContext context) {
    final title = switch (_tab) {
      0 => 'Hotel Stays',
      1 => 'Favourites',
      _ => 'Profile',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),

      // все три вкладки живут одновременно, видна одна
      body: IndexedStack(
        index: _tab,
        children: [
          StaysTab(
            stays: _stays,
            onToggleFavourite: _toggleFavourite,
          ), 
          FavouritesTab(
            stays: _stays,
            onToggleFavourite: _toggleFavourite,
            onBrowse: () => _goToTab(0), // R28
          ), 
          const ProfileTab(),
        ],
      ), // IndexedStack

      // R23: FAB только на вкладке Stays
      floatingActionButton: _tab == 0
          ? FloatingActionButton(
              onPressed: () {}, // форма — на этапе 5
              tooltip: 'Add stay',
              child: const Icon(Icons.add),
            ) 
          : null,

      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: _goToTab, // R28
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.hotel_outlined),
            selectedIcon: Icon(Icons.hotel),
            label: 'Stays',
          ), 
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favourites',
          ), 
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ), 
        ],
      ), 
    ); 
  }
}