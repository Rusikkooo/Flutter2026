import 'package:flutter/material.dart';

import '../data/seed.dart';
import '../models/profile.dart';
import '../models/stay.dart';
import '../routes.dart';
import 'favourites_tab.dart';
import 'profile_tab.dart';
import 'stays_tab.dart';

class Shell extends StatefulWidget {
  const Shell({
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
  // R10: список и профиль живут в State оболочки
  List<Stay> _stays = seedStays();
  // Profile _profile = const Profile.empty();
  Profile _profile = const Profile(name: 'Ruslan', group: 'SE-2301');
  // какая вкладка открыта: 0 Stays, 1 Favourites, 2 Profile
  int _tab = 0;

  // заменить одно предложение в списке (по id)
  void _replace(Stay updated) {
    // R7: новый список через collection for
    final list = [
      for (final s in _stays) s.id == updated.id ? updated : s,
    ];
    // R12: внутри setState только изменение
    setState(() => _stays = list);
  }

  void _toggleFavourite(Stay stay) =>
      _replace(stay.copyWith(favourite: !stay.favourite));

  // R26: колбэки для экрана деталей
  Stay _book(Stay stay) {
    final updated = stay.book(_profile.name);
    _replace(updated);
    return updated;
  }

  Stay _cancel(Stay stay) {
    final updated = stay.cancel(_profile.name);
    _replace(updated);
    return updated;
  }

  void _delete(Stay stay) {
    // R7: оставляем все, кроме удалённого
    final list = _stays.where((s) => s.id != stay.id).toList();
    setState(() => _stays = list);
  }

  // R28: вкладки переключает только Shell
  void _goToTab(int index) => setState(() => _tab = index);

  // R26: Shell открывает детали и кладёт в аргументы свои колбэки
  void _openDetail(Stay stay) {
    Navigator.pushNamed(
      context,
      Routes.detail,
      arguments: DetailArgs(
        stay: stay,
        profileName: _profile.name,
        onBook: _book,
        onCancel: _cancel,
        onDelete: _delete,
        onUpdate: _replace,
        onOpenProfile: () => _goToTab(2), // R28
      ), // DeailArgs
    );
  }

    // CHANGED: R27 — ждём Stay из формы, проверяем null и mounted
  Future<void> _openForm() async {
    final stay = await Navigator.pushNamed<Stay>(
      context,
      Routes.form,
      arguments: const FormArgs(),
    );
    if (stay == null || !mounted) return; // R14, R27
    final list = [..._stays, stay];
    setState(() => _stays = list); // R12
  }

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
        ), // Text
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ), // TextButton
        ],
      ), // AlertDialog
    );
  }

  // R32: Reset data — спросить, вернуть seed и очистить профиль
  Future<void> _resetData() async {
    Navigator.pop(context); // R32: закрыть Drawer
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset data?'),
        content: const Text(
          'Bookings, favourites, new stays and your profile will be lost.',
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
    setState(() {
      _stays = fresh;
      _profile = const Profile.empty(); // R32: очистить профиль
      

    });
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
      ), // AppBar

      // R32: боковое меню
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
                    ), // Icon
                    const SizedBox(height: 12),
                    Text(
                      'Hotel Booking',
                      style: Theme.of(context).textTheme.titleLarge,
                    ), // Text
                    Text('${_stays.length} stays'),
                  ],
                ), // Column
              ), // Padding
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                onTap: _showAbout,
              ), // ListTile
              ListTile(
                leading: const Icon(Icons.restart_alt),
                title: const Text('Reset data'),
                onTap: _resetData,
              ), // ListTile
            ],
          ), // Column
        ), // SafeArea
      ), // Drawer

      // все три вкладки живут одновременно, видна одна
      body: IndexedStack(
        index: _tab,
        children: [
          StaysTab(
            stays: _stays,
            onToggleFavourite: _toggleFavourite,
            onOpen: _openDetail, // R26
          ), // StaysTab
          FavouritesTab(
            stays: _stays,
            onToggleFavourite: _toggleFavourite,
            onOpen: _openDetail, // R26
            onBrowse: () => _goToTab(0), // R28
          ), // FavouritesTab
          // R11: дальше вниз — в профиль
          ProfileTab(
            themeMode: widget.themeMode,
            onThemeModeChanged: widget.onThemeModeChanged,
          ), // ProfileTab
        ],
      ), // IndexedStack

      // R23: FAB только на вкладке Stays
      floatingActionButton: _tab == 0
          ? FloatingActionButton(
              onPressed: _openForm,
              tooltip: 'Add stay',
              child: const Icon(Icons.add),
            ) // FloatingActionButton
          : null,

      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: _goToTab, // R28
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.hotel_outlined),
            selectedIcon: Icon(Icons.hotel),
            label: 'Stays',
          ), // NavigationDestination
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favourites',
          ), // NavigationDestination
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ), // NavigationDestination
        ],
      ), // NavigationBar
    ); // Scaffold
  }
}