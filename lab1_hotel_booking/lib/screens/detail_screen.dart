import 'dart:async';

import 'package:flutter/material.dart';

import '../models/countdown.dart';
import '../models/stay.dart';
import '../routes.dart';
import '../utils/format.dart';

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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
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
          // About и Guests — на шаге 4
          const Expanded(
            child: Center(child: Text('About / Guests — step 4')),
          ), // Expanded
        ],
      ), // Column
    ); // Scaffold
  }
}