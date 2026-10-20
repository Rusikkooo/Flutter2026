import 'package:flutter/material.dart';
import '../models/stay.dart';
import '../utils/format.dart';

// R18: одна переиспользуемая карточка
class StayCard extends StatelessWidget {
  const StayCard({
    super.key,
    required this.stay,
    required this.onTap,
    required this.onToggleFavourite,
  });
  final Stay stay;
  final VoidCallback onTap;
  final VoidCallback onToggleFavourite;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    // R19: текст бейджа, или null — тогда бейджа нет
    final String? badge = stay.isFull
        ? 'FULL'
        : (stay.free <= 5 ? '${stay.free} left' : null);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
          child: Row(
            children: [
              // R18: слева аватар-Stack
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: stay.type.color(scheme),
                    foregroundColor: scheme.onSurface,
                    child: Icon(stay.type.icon),
                  ),
                  // R19: бейдж только если он есть (collection if)
                  if(badge!=null)
                    Positioned(
                      top: -6,
                      right: -10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: stay.isFull ? scheme.error : scheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: scheme.surface, width: 2),
                        ),
                        child: Text(
                          badge,
                          style: text.labelSmall?.copyWith(
                            color: stay.isFull
                                ? scheme.onError
                                : scheme.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      )
                    )
                ],
              ),
              const SizedBox(width: 16),
              // R18: по центру Expanded-колонка
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stay.title,
                      style: text.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(formatDateTime(stay.checkIn), style: text.bodySmall),
                    Text(
                      stay.place,
                      style: text.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              ),
              // R18: справа кнопка избранного
              IconButton(
                onPressed: onToggleFavourite,
                tooltip: 'Favourite',
                icon:Icon(
                  stay.favourite ? Icons.favorite : Icons.favorite_border,
                ),
                color: stay.favourite
                    ? scheme.primary
                    : scheme.onSurfaceVariant,
                )
            ],
          ),
          ),

      ),
    );
  }
}