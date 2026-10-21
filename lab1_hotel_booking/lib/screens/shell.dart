import 'package:flutter/material.dart';

import '../data/seed.dart';
import '../models/stay.dart';
import 'stays_tab.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell>{
  // R10: список живёт в State оболочки
  List<Stay> _stays = seedStays();
  // R10: изменение приходит снизу через колбэк
  void _toggleFavourite(Stay stay){
    // R7: новый список через collection for, старый не трогаем
    final updated = [
      for (final s in _stays)
        s.id == stay.id ? s.copyWith(favourite: !s.favourite) : s,
    ];
    // R12: внутри setState только само изменение
    setState(() => _stays = updated);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Stays'),
      ),
      body: StaysTab(
        stays: _stays,
        onToggleFavourite: _toggleFavourite,
      ),
      // R23: FAB откроет форму (на этапе 4)
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add stay',
        child: const Icon(Icons.add),
      ),
    );
  }

}