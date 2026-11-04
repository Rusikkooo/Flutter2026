import 'package:flutter/material.dart';

// import 'models/book.dart';
import 'models/cart.dart';

import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Cart'),
      actions: [
        // NEW: кнопка очистки
        TextButton(
          onPressed: () => _confirmClear(context),
          child: const Text('Clear cart'),
        ),
      ],
    ),
    body: Column(
      children: [
        Expanded(
          child: Consumer<Cart>(
            builder: (context, cart, _) => ListView(
              children: [
                for (final b in cart.items)
                  ListTile(
                    title: Text(b.title),
                    subtitle: Text('${b.price} ₸'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('*${cart.qtyOf(b)}'),
                        IconButton(
                          icon: const Icon(Icons.add), // NEW: плюс
                          onPressed: () => cart.increment(b),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => cart.remove(b),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<Cart>(
            builder: (context, cart, label) => Row(
              children: [
                label!,
                const Spacer(),
                Text(
                  '${cart.total} ₸',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.receipt_long),
                SizedBox(width: 8),
                Text('Total'),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> _confirmClear(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Clear cart?'),
      content: const Text('All books will be removed.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Clear'),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  context.read<Cart>().clear();
}
