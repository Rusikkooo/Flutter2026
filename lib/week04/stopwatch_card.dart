import 'package:flutter/material.dart';

import 'dart:async';

class StopwatchCard extends StatefulWidget {
  const StopwatchCard({super.key});

  @override
  State<StopwatchCard> createState() => _StopwatchCardState();
}

class _StopwatchCardState extends State<StopwatchCard> {
  int _seconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _reset() {
    _stop();
    setState(() {
      _seconds = 0;
    });
  }

  String get _formatted {
    final minutes = _seconds ~/ 60;
    final secs = _seconds % 60;
    final mm = minutes.toString().padLeft(2, '0');
    final ss = secs.toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_formatted, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(onPressed: _start, child: const Text("Start")),

                const SizedBox(width: 8),

                FilledButton(onPressed: _stop, child: const Text("Stop")),

                const SizedBox(width: 8),

                FilledButton(onPressed: _reset, child: const Text("Reset")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
