import 'dart:async';

import 'package:flutter/material.dart';

import '../models/countdown.dart';
import '../models/stay.dart';
import '../routes.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.args});

  // R26: предложение и колбэки приходят через аргументы маршрута
  final DetailArgs args;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // своя копия: после брони покажем новое число гостей (шаг 5)
  late Stay _stay;
  // «сейчас» для отсчёта, обновляется таймером
  DateTime _now = DateTime.now();
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _stay = widget.args.stay;
    // R13: таймер раз в минуту, создаём в initState
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() => _now = DateTime.now()); // R12: только изменение
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // R13: остановить при уходе с экрана
    super.dispose();
  }

  // R9: текст отсчёта — исчерпывающий switch по sealed-классу
  String get _countdownText =>
      switch (Countdown.until(_stay.checkIn, now: _now)) {
        Upcoming(:final left) => 'in ${formatDuration(left)}',
        Started(:final since) => 'checked in ${formatDuration(since)} ago',
        Ended() => 'ended',
      };

  // вкладка About
  Widget _buildAbout() {
    // R5: достаём два числа из record
    final (:taken, :free) = _stay.places;
    // R6: копия в локальную переменную, чтобы проверить на null без !
    final description = _stay.description;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ListTile(
          leading: const Icon(Icons.event),
          title: Text(formatDateTime(_stay.checkIn)),
          subtitle: const Text('Check-in'),
        ), // ListTile
        ListTile(
          leading: Icon(_stay.partner ? Icons.link : Icons.place),
          title: Text(_stay.place),
          subtitle: Text(_stay.partner ? 'Partner link' : 'Address'),
        ), // ListTile
        ListTile(
          leading: const Icon(Icons.bed),
          title: Text('$taken booked · $free free'), // R5
          subtitle: Text('of ${_stay.rooms} rooms'),
        ), // ListTile
        // R6: описание показываем, только если оно есть (collection if)
        if (description != null)
          Card(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(description),
            ), // Padding
          ), // Card
      ],
    ); // ListView
  }

  // вкладка Guests
  Widget _buildGuests() {
    final guests = _stay.guests;
    final me = widget.args.profileName;
    final scheme = Theme.of(context).colorScheme;

    // R23: то же пустое состояние, без кнопки
    if (guests.isEmpty) {
      return const EmptyState(
        icon: Icons.group_outlined,
        message: 'Nobody has booked yet',
      ); // EmptyState
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // R7: collection for — по строке на гостя
        for (final name in guests)
          ListTile(
            leading: CircleAvatar(child: Text(name[0])),
            // R29: себя показываем как «You»
            title: Text(name == me ? 'You' : name),
            selected: name == me,
            selectedTileColor: scheme.primaryContainer,
          ), // ListTile
      ],
    ); // ListView
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    // R29: контроллер вкладок для TabBar и TabBarView
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stay details'),
        ), // AppBar
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // R24: шапка-Stack с картинкой из assets
            ConstrainedBox(
              // на широком экране шапка не выше 240
              constraints: const BoxConstraints(maxHeight: 240),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/${_stay.type.name}.png',
                      fit: BoxFit.cover,
                    ), // Image.asset
                    // R24: тип номера в левом нижнем углу
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Chip(
                        avatar: Icon(_stay.type.icon),
                        label: Text(_stay.type.label),
                        backgroundColor: _stay.type.color(scheme),
                      ), // Chip
                    ), // Positioned
                    // R24: отсчёт в правом нижнем углу
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Chip(
                        avatar: const Icon(Icons.schedule),
                        label: Text(_countdownText),
                        backgroundColor: scheme.surface,
                      ), // Chip
                    ), // Positioned
                  ],
                ), // Stack
              ), // AspectRatio
            ), // ConstrainedBox
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(_stay.title, style: text.headlineSmall),
            ), // Padding
            // R29: заголовки вкладок, число гостей живое
            TabBar(
              tabs: [
                const Tab(text: 'About'),
                Tab(text: 'Guests (${_stay.count})'),
              ],
            ), // TabBar
            // R29: содержимое вкладок занимает всё оставшееся место
            Expanded(
              child: TabBarView(
                children: [
                  _buildAbout(),
                  _buildGuests(),
                ],
              ), // TabBarView
            ), // Expanded
          ],
        ), // Column
      ), // Scaffold
    ); // DefaultTabController
  }
}