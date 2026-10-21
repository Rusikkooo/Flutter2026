import 'dart:async';

import 'package:flutter/material.dart';

import '../models/countdown.dart';
import '../models/stay.dart';
import '../routes.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';

// пункты меню в AppBar
enum _MenuAction { edit, delete }

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.args});

  // R26: предложение и колбэки приходят через аргументы маршрута
  final DetailArgs args;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // своя копия: после брони показываем новое число гостей
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

  // R15: забронировать — сначала спросить
  Future<void> _book() async {
    // R15: без имени бронировать нельзя — SnackBar ведёт в профиль
    if (widget.args.profileName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Add your name in Profile to book'),
          action: SnackBarAction(
            label: 'Profile',
            onPressed: () {
              Navigator.pop(context); // закрыть детали
              widget.args.onOpenProfile(); // R28: вкладку переключит Shell
            },
          ), // SnackBarAction
        ), // SnackBar
      );
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Book a room?'),
        content: Text("Book '${_stay.title}' for ${widget.args.profileName}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ), // TextButton
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Book'),
          ), // FilledButton
        ],
      ), // AlertDialog
    );
    // R14: после await сначала mounted
    if (!mounted || ok != true) return;
    final updated = widget.args.onBook(_stay); // R26: меняет Shell
    setState(() => _stay = updated); // R12
  }

  // R16: противоположное действие
  void _cancelBooking() {
    final updated = widget.args.onCancel(_stay); // R26: меняет Shell
    setState(() => _stay = updated); // R12
  }

  // R31: Edit — открыть форму с этим предложением и дождаться ответа
  Future<void> _edit() async {
    final updated = await Navigator.pushNamed<Stay>(
      context,
      Routes.form,
      arguments: FormArgs(stay: _stay),
    );
    // R14, R27: проверить null и mounted
    if (updated == null || !mounted) return;
    widget.args.onUpdate(updated); // R26: меняет Shell
    setState(() => _stay = updated); // R12
  }

  // R31: Delete — сначала спросить
  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Delete '${_stay.title}'?"),
        content: const Text('This stay and its bookings will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ), // TextButton
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ), // FilledButton
        ],
      ), // AlertDialog
    );
    // R14: после await сначала mounted
    if (!mounted || ok != true) return;
    widget.args.onDelete(_stay); // R26: удаляет Shell
    Navigator.pop(context); // закрыть детали
  }

  // главная кнопка внизу
  Widget _buildAction() {
    final me = widget.args.profileName;
    final booked = me.isNotEmpty && _stay.contains(me);

    // R16: уже забронировал → кнопка становится противоположной
    if (booked) {
      return OutlinedButton.icon(
        onPressed: _cancelBooking,
        icon: const Icon(Icons.event_busy),
        label: const Text('Cancel booking'),
      ); // OutlinedButton.icon
    }

    // R16: мест нет или заезд прошёл → кнопка не может сработать
    final canBook = !_stay.isFull && !_stay.isPast;
    return FilledButton.icon(
      onPressed: canBook ? _book : null,
      icon: const Icon(Icons.event_available),
      label: Text(_stay.isFull ? 'Fully booked' : 'Book'),
    ); // FilledButton.icon
  }

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
        // R31: стрелку назад не пишем — AppBar рисует её сам
        appBar: AppBar(
          title: const Text('Stay details'),
          actions: [
            // R31: меню Edit / Delete
            PopupMenuButton<_MenuAction>(
              onSelected: (action) => switch (action) {
                _MenuAction.edit => _edit(),
                _MenuAction.delete => _delete(),
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: _MenuAction.edit,
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                  ), // ListTile
                ), // PopupMenuItem
                PopupMenuItem(
                  value: _MenuAction.delete,
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Delete'),
                  ), // ListTile
                ), // PopupMenuItem
              ],
            ), // PopupMenuButton
          ],
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
                children: [_buildAbout(), _buildGuests()],
              ), // TabBarView
            ), // Expanded
          ],
        ), // Column
        // R15, R16: главная кнопка внизу экрана
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: _buildAction(),
          ), // Padding
        ), // SafeArea
      ), // Scaffold
    ); // DefaultTabController
  }
}
