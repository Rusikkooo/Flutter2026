import 'package:flutter/material.dart';

import '../models/stay.dart';
import '../widgets/empty_state.dart';
import '../widgets/stay_card.dart';

class FavouritesTab  extends StatelessWidget{
  const FavouritesTab({
    super.key,
    required this.stays,
    required this.onToggleFavourite,
    required this.onBrowse,
  });
  // R10: весь список приходит сверху
  final List<Stay> stays;
  final ValueChanged<Stay> onToggleFavourite;
  // R28: попросить Shell переключить вкладку
  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    // R7: оставляем только избранное
    final favourites = stays.where((s) => s.favourite).toList();

    // R23: то же пустое состояние, что и в поиске
    if(favourites.isEmpty){
      return EmptyState(icon: Icons.favorite_border, message: 'No favourites yet', actionLabel: 'Browse stays',onAction: onBrowse,);
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
      separatorBuilder: (context, index) => const SizedBox(height: 4), 
      itemCount: favourites.length,
      itemBuilder:(context, index) {
        final stay = favourites[index];
        return StayCard(
          stay: stay,
          onTap: () {}, // детали — на этапе 4
          onToggleFavourite: () => onToggleFavourite(stay),
        );
      }
      );
  }
}