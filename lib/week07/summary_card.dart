import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.name,
    required this.email,
    required this.group,
    required this.birth,
  });

  final String name;
  final String email;
  final String? group;
  final DateTime? birth;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      ListTile(leading: const Icon(Icons.person), title: Text(name)),
      ListTile(leading: const Icon(Icons.mail), title: Text(email)),
      ListTile(leading: const Icon(Icons.group), title: Text(group ?? '—')),
      ListTile(
        leading: const Icon(Icons.cake),
        title: Text(
          birth == null
              ? '—'
              : '${birth!.day.toString().padLeft(2, '0')}.'
                    '${birth!.month.toString().padLeft(2, '0')}.'
                    '${birth!.year}',
        ),
      ),
    ];

    return Card(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 600;
          if (wide) {
            return GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 4,
              children: tiles,
            );
          }
          return Column(children: tiles);
        },
      ),
    );
  }
}
