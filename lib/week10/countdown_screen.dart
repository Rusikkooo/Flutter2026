import 'package:flutter/material.dart';
import 'api/countdown.dart';
import 'dart:async';
enum _Version { a, b }
class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});
  @override
  State<StatefulWidget> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  _Version _version = _Version.a;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Countdown")),
      body: Column(
        children: [
          const SizedBox(height: 16),
          SegmentedButton<_Version>(
            segments: const [
              ButtonSegment(value: _Version.a, label: Text('StreamBuilder')),
              ButtonSegment(value: _Version.b, label: Text('listen')),
            ],
            selected: {_version},
            onSelectionChanged: (s) => setState(() => _version = s.first),
          ),
          Expanded(
            child: _version == _Version.a
                ? _CountdownA()
                : _CountdownB(), // NEW
          ),
        ],
      ),
    );
  }
}

class _CountdownA extends StatefulWidget {
  const _CountdownA();
  @override
  State<StatefulWidget> createState() => _CountdownAState();
}

class _CountdownAState extends State<StatefulWidget> {
  late final Stream<int> _stream = countdown(10);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<int>(
        stream: _stream,
        builder: (context, snapshot) {
          return Text(
            '${snapshot.data ?? 10}',
            style: Theme.of(context).textTheme.displayLarge,
          );
        },
      ),
    );
  }
}

class _CountdownB extends StatefulWidget {
  const _CountdownB();
  @override
  State<StatefulWidget> createState() => _CountdownBState();
}

class _CountdownBState extends State<StatefulWidget> {
  int _left = 10;
  late StreamSubscription<int> _sub;
  @override
  void initState() {
    super.initState();
    _sub = countdown(10).listen((i) => setState(() => _left = i));
  }

  @override
  void dispose() {
    unawaited(_sub.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$_left', style: Theme.of(context).textTheme.displayLarge),
    );
  }
}
