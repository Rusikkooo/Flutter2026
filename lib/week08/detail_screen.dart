import 'package:flutter/material.dart';

import 'models/book.dart';

enum BookAction { toggleRead, delete }

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.book});
  final Book book;
  Future<void> _delete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Delete '${book.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    if (ok != true) return; // Cancel (false) или тап мимо диалога (null)
    Navigator.of(context).pop(BookAction.delete);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Book')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.title, style: text.headlineSmall),
            const SizedBox(height: 8),
            Text(book.author, style: text.titleMedium),
            const SizedBox(height: 16),
            Text('${book.pages} pages'),
            Text(book.year == null ? 'Year unknown' : 'Year ${book.year}'),
            Text(book.read ? 'Read' : 'Not read yet'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(BookAction.toggleRead),
              child: Text(book.read ? 'Mark as unread' : 'Mark as read'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _delete(context),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
