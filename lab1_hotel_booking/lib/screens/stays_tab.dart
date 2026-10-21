import 'package:flutter/material.dart';

import '../models/stay.dart';
import '../widgets/stay_card.dart';

class StaysTab extends StatefulWidget{
  const StaysTab({
    super.key,
    required this.stays,
    required this.onToggleFavourite,
  });
   // R10: данные приходят сверху
  final List<Stay> stays;
  // R10: изменения уходят наверх
  final ValueChanged<Stay> onToggleFavourite;

  @override
  State<StaysTab> createState() => _StaysTabState();
}
class _StaysTabState extends State<StaysTab>{
  @override
  Widget build(BuildContext context) {
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
        itemBuilder:(context, index){
          final stay = widget.stays[index];
          return StayCard(
          stay: stay,
          onTap: () {}, // детали — на этапе 3
          onToggleFavourite: () => widget.onToggleFavourite(stay),
        ); 
        },
        separatorBuilder: (context, index) => const SizedBox(height: 4),
        itemCount: widget.stays.length,);
  }
}