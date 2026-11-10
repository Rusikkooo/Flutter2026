import 'package:flutter/material.dart';

import 'api/fake_api.dart';
import 'widgets/empty_view.dart'; 
import 'widgets/error_view.dart'; 
import 'widgets/loading_view.dart'; 
import 'widgets/student_list.dart';

class StudentsFutureScreen extends StatefulWidget {
  const StudentsFutureScreen({super.key});
  @override
  State<StatefulWidget> createState() => _StudentsFutureScreenState();
}

class _StudentsFutureScreenState extends State<StatefulWidget> {
  final _api = FakeApi();
  late Future<List<Student>> _future;
  bool _compact = false;
  @override
  void initState() {
    super.initState();
    _future = _api.fetchStudents();
  }

  void _retry() {
    setState(() => _future = _api.fetchStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FutureBuilder"),
        actions: [
          Switch(
            value: _compact,
            onChanged: (v) =>
                setState(() => _compact = v), 
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: FutureBuilder<List<Student>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorView(onRetry: _retry);
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          final list = snapshot.data ?? const <Student>[];
          if (list.isEmpty) {
            return const EmptyView();
          }
          return StudentList(list, compact: _compact);
        },
      ),
    );
  }
}
