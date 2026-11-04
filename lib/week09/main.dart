import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // NEW

import 'books_screen.dart';
import 'cart_screen.dart';
import 'models/cart.dart';

void main() =>
    runApp(ChangeNotifierProvider(create: (_) => Cart(), child: const Shell()));

// CHANGED: был StatefulWidget с _cart, _add, _remove. Теперь без состояния
class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
    ),
    routes: {
      '/': (_) => const BooksScreen(), // CHANGED: без параметров
      '/cart': (_) => const CartScreen(), // CHANGED: без параметров
    },
  );
}
