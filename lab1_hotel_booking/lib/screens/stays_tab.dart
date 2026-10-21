import 'package:flutter/material.dart';

import '../models/room_type.dart';
import '../models/stay.dart';
import '../widgets/empty_state.dart';
import '../widgets/stay_card.dart';

class StaysTab extends StatefulWidget {
  const StaysTab({
    super.key,
    required this.stays,
    required this.onToggleFavourite,
  });

  // R10: данные приходят сверху
  final List<Stay> stays;
  // R10: изменения уходят наверх
  final ValueChanged<Stay> onToggleFavourite;

  @override
  State<StaysTab> createState() => _StaysTabState();
}

class _StaysTabState extends State<StaysTab> {
  // собственные настройки вкладки — не данные приложения
  final _search = TextEditingController();
  String _query = '';
  RoomType? _type; // null = All
  bool _showPast = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  // R7: фильтруем через where, сортируем КОПИЮ
  List<Stay> get _visible {
    final q = _query.trim().toLowerCase();
    final list = widget.stays
        .where((s) => _type == null || s.type == _type)
        .where((s) => _showPast || !s.isPast)
        .where((s) => s.title.toLowerCase().contains(q))
        .toList();
    // сначала будущие по дате заезда, прошедшие в конце
    list.sort((a, b) {
      if (a.isPast != b.isPast) return a.isPast ? 1 : -1;
      return a.checkIn.compareTo(b.checkIn);
    });
    return list;
  }

  void _clearSearch() {
    _search.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;

    // R21: всё в одном Column, список в Expanded
    return Column(
      children: [
        // R21: поле поиска
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            controller: _search,
            onChanged: (value) => setState(() => _query = value),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search stays',
              prefixIcon: const Icon(Icons.search),
              // R21: крестик только когда поле не пустое
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: _clearSearch,
                      tooltip: 'Clear',
                      icon: const Icon(Icons.close),
                    ), // IconButton
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ), // OutlineInputBorder
            ), // InputDecoration
          ), // TextField
        ), // Padding

        // R21: ряд чипов, прокрутка вбок
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _type == null,
                onSelected: (_) => setState(() => _type = null),
              ), // ChoiceChip
              // R7: collection for — по чипу на каждый тип
              for (final type in RoomType.values)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    avatar: Icon(type.icon),
                    label: Text(type.label),
                    selected: _type == type,
                    onSelected: (_) => setState(() => _type = type),
                  ), // ChoiceChip
                ), // Padding
            ],
          ), // Row
        ), // SingleChildScrollView

        // R21: фильтр прошедших
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FilterChip(
              avatar: const Icon(Icons.history),
              label: const Text('Show past'),
              selected: _showPast,
              onSelected: (value) => setState(() => _showPast = value),
            ), // FilterChip
          ), // Align
        ), // Padding

        // R21: список занимает всё оставшееся место
        Expanded(
          child: visible.isEmpty
              // R23: общее пустое состояние
              ? EmptyState(
                  icon: Icons.search_off,
                  message: 'No stays match your search',
                  actionLabel: 'Clear search',
                  onAction: _clearSearch,
                ) // EmptyState
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 88),
                  itemCount: visible.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final stay = visible[index];
                    return StayCard(
                      stay: stay,
                      onTap: () {}, // детали — на этапе 3
                      onToggleFavourite: () => widget.onToggleFavourite(stay),
                    ); // StayCard
                  },
                ), // ListView.separated
        ), // Expanded
      ],
    ); // Column
  }
}