import 'package:flutter/material.dart';

import 'models/book.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  // NEW: «пульт» от формы
  final _formKey = GlobalKey<FormState>();

  // NEW: по контроллеру на каждое поле
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _pages = TextEditingController();
  final _year = TextEditingController();

  // NEW: освобождаем контроллеры, когда экран уходит
  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _pages.dispose();
    _year.dispose();
    super.dispose();
  }

  // NEW: проверить всё и ответить готовой книгой
  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final book = Book(
      title: _title.text.trim(),
      author: _author.text.trim(),
      pages: int.parse(_pages.text), // безопасно: валидатор уже проверил
      year: int.tryParse(_year.text), // '' → null, а это и есть «без года»
    );
    Navigator.of(context).pop(book);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add book')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                validator: (v) {
                  if ((v ?? '').trim().length < 2) {
                    return 'At least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _author,
                decoration: const InputDecoration(labelText: 'Author'),
                textInputAction: TextInputAction.next,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                validator: (v) {
                  if ((v ?? '').trim().isEmpty) return 'Author is required';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _pages,
                decoration: const InputDecoration(labelText: 'Pages'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'A whole number above 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _year,
                decoration: const InputDecoration(labelText: 'Year (optional)'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                validator: (v) {
                  if (v == null || v.isEmpty) return null; // пусто — ок
                  final y = int.tryParse(v);
                  final now = DateTime.now().year;
                  if (y == null || y < 1450 || y > now) {
                    return 'A year between 1450 and $now';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // шаг 3: кнопка Save
              FilledButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
