import 'package:flutter/material.dart';

import '../models/profile.dart';
import '../models/stay.dart';

// CHANGED: теперь StatefulWidget — у полей есть контроллеры
class ProfileTab extends StatefulWidget {
  const ProfileTab({
    super.key,
    required this.profile,
    required this.stays,
    required this.onProfileChanged,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  // NEW: R10 — профиль и список приходят из Shell
  final Profile profile;
  final List<Stay> stays;
  final ValueChanged<Profile> onProfileChanged;
  // R11: тема приходит из MyApp через Shell
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  // NEW: R38 — контроллеры заполняются из модели
  late final _name = TextEditingController(text: widget.profile.name);
  late final _group = TextEditingController(text: widget.profile.group);
  final _groupKey = GlobalKey<FormFieldState<String>>();

  // NEW: R38 — формат группы: 2–4 заглавные буквы, дефис, 4 цифры
  static final _groupPattern = RegExp(r'^[A-Z]{2,4}-\d{4}$');

  // NEW: после Reset data профиль в Shell очистился — обновляем поля
  @override
  void didUpdateWidget(ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.profile != oldWidget.profile) {
      _name.text = widget.profile.name;
      _group.text = widget.profile.group;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _group.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final name = widget.profile.name.trim();

    // NEW: R38 — считается из списка при каждом build (R7: any и fold)
    final hasBookings =
        name.isNotEmpty && widget.stays.any((s) => s.contains(name));
    final bookings = hasBookings
        ? widget.stays.fold(0, (n, s) => s.contains(name) ? n + 1 : n)
        : 0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // NEW: шапка профиля
        Row(
          children: [
            CircleAvatar(
              radius: 32,
              child: Text(name.isEmpty ? '?' : name[0]),
            ), // CircleAvatar
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name.isEmpty ? 'Guest' : name, style: text.titleLarge),
                  Text('You have $bookings bookings'), // R38
                ],
              ), // Column
            ), // Expanded
          ],
        ), // Row
        const SizedBox(height: 24),

        // NEW: R38 — имя сохраняется по Enter (onSubmitted)
        TextField(
          controller: _name,
          decoration: const InputDecoration(
            labelText: 'Name',
            helperText: 'Press Enter to save',
          ), // InputDecoration
          textInputAction: TextInputAction.done,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          onSubmitted: (value) => widget.onProfileChanged(
            widget.profile.copyWith(name: value.trim()),
          ),
        ), // TextField
        const SizedBox(height: 12),

        // NEW: R38 — группа с проверкой через RegExp
        TextFormField(
          key: _groupKey,
          controller: _group,
          decoration: const InputDecoration(
            labelText: 'Group',
            hintText: 'SE-2301',
            helperText: 'Press Enter to save',
          ), // InputDecoration
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.done,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          validator: (value) {
            final g = (value ?? '').trim();
            if (g.isEmpty) return null;
            return _groupPattern.hasMatch(g) ? null : 'Format: AA-0000';
          },
          onFieldSubmitted: (value) {
            final valid = _groupKey.currentState?.validate() ?? false;
            if (!valid) return;
            widget.onProfileChanged(
              widget.profile.copyWith(group: value.trim()),
            );
          },
        ), // TextFormField
        const SizedBox(height: 24),

        Text('Theme', style: text.titleSmall),
        const SizedBox(height: 8),
        // R22: режим темы из трёх ChoiceChip
        Wrap(
          spacing: 8,
          children: [
            for (final mode in ThemeMode.values)
              ChoiceChip(
                label: Text(switch (mode) {
                  ThemeMode.system => 'System',
                  ThemeMode.light => 'Light',
                  ThemeMode.dark => 'Dark',
                }),
                selected: widget.themeMode == mode,
                onSelected: (_) => widget.onThemeModeChanged(mode),
              ), // ChoiceChip
          ],
        ), // Wrap
      ],
    ); // ListView
  }
}