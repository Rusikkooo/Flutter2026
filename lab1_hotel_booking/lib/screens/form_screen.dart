import 'package:flutter/material.dart';

import '../routes.dart';

// временно — наполним на этапе 5
class FormScreen extends StatelessWidget {
  const FormScreen({super.key, required this.args});

  final FormArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(args.stay == null ? 'New stay' : 'Edit stay'),
      ), // AppBar
      body: const Center(
        child: Text('Form — stage 5'),
      ), // Center
    ); // Scaffold
  }
}