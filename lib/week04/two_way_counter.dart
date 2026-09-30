import 'package:flutter/material.dart';

// class 1
class TwoWayCounter extends StatefulWidget {
  const TwoWayCounter({super.key});
  @override
  State<TwoWayCounter> createState() => _TwoWayCounterState();
}

// class 2
class _TwoWayCounterState extends State<TwoWayCounter> {
  // function save
  Future<void> _save() async {
    setState(() {
      _saving = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _saving = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saved')));
  }

  int _count = 0;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: _count == 0
                  ? null
                  : () {
                      setState(() {
                        _count--;
                      });
                    },
              child: const Text("-"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('$_count'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _count++;
                });
              },
              child: const Text('+'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Save"),
        ),
      ],
    );
  }
}
