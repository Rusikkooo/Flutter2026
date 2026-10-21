import 'package:flutter/material.dart';

import '../routes.dart';

// временно — наполним на этапе 4
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.args});

  final DetailArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(args.stay.title),
      ), 
      body: const Center(
        child: Text('Details — stage 4'),
      ), 
    ); 
  }
}