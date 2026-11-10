import 'package:flutter/material.dart';
import 'package:students_async/countdown_screen.dart';

import 'students_screen.dart';
import 'students_future_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice 10')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentsScreen()),
              ),
              child: const Text('By hand'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentsFutureScreen()),
              ),
              child: const Text('FutureBuilder'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CountdownScreen()),
              ),
              child: const Text("Countdown"),
            ),
          ],
        ),
      ),
    );
  }
}
