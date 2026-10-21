import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  // R11: тема приходит из MyApp через Shell
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // имя и группа — на этапе 6
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
                selected: themeMode == mode,
                onSelected: (_) => onThemeModeChanged(mode),
              ),
          ],
        ),
      ],
    );
  }
}