import 'package:flutter/material.dart';

import '../data/seed.dart';
import '../models/stay.dart';
import 'favourites_tab.dart';
import 'profile_tab.dart';
import 'stays_tab.dart';

class Shell extends StatefulWidget {
  const Shell(
    {
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    });
    // R11: приходит из MyApp
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

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
    // R32: About — закрыть меню и показать диалог
  void _showAbout() {
    Navigator.pop(context); // R32: пункт сам закрывает Drawer
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('About'),
        content: const Text(
          'Hotel Booking · Lab 1, Mobile Development.\n'
          'All data lives in memory.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ), 
    );
  }

  // R32: Reset data — сначала спросить, потом вернуть seed
  Future<void> _resetData() async {
    Navigator.pop(context); // R32: закрыть Drawer
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset data?'),
        content: const Text(
          'Bookings, favourites and new stays will be lost.',
        ), // Text
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ), // TextButton
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ), // FilledButton
        ],
      ), // AlertDialog
    );
    // R14: после await сначала mounted
    if (!mounted || ok != true) return;
    final fresh = seedStays();
    // R12: внутри setState только изменение
    setState(() => _stays = fresh);
  }



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
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.hotel,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ), 
                    const SizedBox(height: 12),
                    Text(
                      'Hotel Booking',
                      style: Theme.of(context).textTheme.titleLarge,
                    ), 
                    Text('${_stays.length} stays'),
                  ],
                ), 
              ), 
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                onTap: _showAbout,
              ), 
              ListTile(
                leading: const Icon(Icons.restart_alt),
                title: const Text('Reset data'),
                onTap: _resetData,
              ), 
            ],
          ), 
        ), 
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
          ProfileTab(
            themeMode: widget.themeMode,
            onThemeModeChanged: widget.onThemeModeChanged,
          ),
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