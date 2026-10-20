import 'package:flutter/material.dart';

import 'models/book.dart';
import 'widgets/book_tile.dart';
import 'detail_screen.dart';
import 'add_book_screen.dart';

enum Filter { all, unread, read }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Book> _books = [...seed];
  Filter _filter = Filter.all;

  List<Book> get _visible => switch (_filter) {
    Filter.all => _books,
    Filter.unread => unread(_books),
    Filter.read => _books.where((b) => b.read).toList(),
  };
  Widget _stat(String label, int value) {
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Text('$value', style: text.headlineSmall),
          Text(label, style: text.bodySmall),
        ],
      ),
    );
  }

  Future<void> _open(Book book) async {
    final action = await Navigator.of(context).push<BookAction>(
      MaterialPageRoute(builder: (_) => DetailScreen(book: book)),
    );
    if (!mounted) return;

    switch (action) {
      case null:
        return;
      case BookAction.toggleRead:
        setState(() => book.read = !book.read);
      case BookAction.delete:
        setState(() => _books.remove(book));
    }
  }

  // NEW: открыть форму и добавить книгу, если она вернулась
  Future<void> _add() async {
    final book = await Navigator.of(context)
        .push<Book>(MaterialPageRoute(builder: (_) => const AddBookScreen()));
    if (book == null) return; // нажали «назад» — ничего не добавляем
    if (!mounted) return;
    setState(() => _books.add(book));
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    return Scaffold(
      appBar: AppBar(title: Text('Reading list (${visible.length})')),

      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  _stat("Books", _books.length),
                  _stat("Pages", totalPages(_books)),
                  _stat("Unread", unread(_books).length),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                for (final f in Filter.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(switch (f) {
                        Filter.all => 'All',
                        Filter.unread => 'Unread',
                        Filter.read => 'Read',
                      }),
                      selected: _filter == f,
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: visible.length,
              itemBuilder: (context, i) {
                final book = visible[i];
                return BookTile(
                  book: book,
                  onTap: () => _open(book),
                  onToggle: () => setState(() => book.read = !book.read),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
