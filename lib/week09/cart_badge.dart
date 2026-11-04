import 'package:flutter/material.dart';

import 'models/cart.dart';

import 'package:provider/provider.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final n = context.select<Cart, int>((c) => c.count);
    return IconButton(
      icon: Badge(label: Text('$n'), child: const Icon(Icons.shopping_cart)),
      onPressed: () => Navigator.of(context).pushNamed('/cart'),
    );
  }
}
