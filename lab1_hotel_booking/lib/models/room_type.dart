import 'package:flutter/material.dart';

enum RoomType {
  single('Single', Icons.single_bed),
  standard('Standard', Icons.bed),
  suite('Suite', Icons.king_bed),
  family('Family', Icons.family_restroom),
  deluxe('Deluxe', Icons.star),
  dorm('Dorm', Icons.groups);

  const RoomType(this.label, this.icon);

  final String label;
  final IconData icon;
  // R2: исчерпывающий switch → роль из colorScheme (никаких Colors.*)
  Color color(ColorScheme scheme) => switch (this) {
        RoomType.single => scheme.secondaryContainer,
        RoomType.standard => scheme.primaryContainer,
        RoomType.suite => scheme.tertiaryContainer,
        RoomType.family => scheme.surfaceContainerHighest,
        RoomType.deluxe => scheme.errorContainer,
        RoomType.dorm => scheme.inversePrimary,
      };
}
