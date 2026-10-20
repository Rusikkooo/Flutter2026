import 'package:flutter/material.dart';

// R23: один виджет для всех пустых состояний
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });
  final IconData icon;
  final String message;
  final String? actionLabel; // текст кнопки — необязательный
  final VoidCallback? onAction; // действие кнопки — необязательное
  
  @override
  Widget build(BuildContext context) {

    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final label = actionLabel;
    final action = onAction;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: scheme.secondaryContainer,
              foregroundColor: scheme.onSecondaryContainer,
              child:Icon(icon,size: 40,)
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: text.titleMedium,
              textAlign: TextAlign.center,
            ),
            // R23: кнопка только если переданы и текст, и действие
            if (label != null && action != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: action,
                child: Text(label),
              ),
            ]
          ],
        ),
        ),

    );
  }
} 