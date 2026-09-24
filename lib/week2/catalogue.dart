import 'models.dart';

class Library {
  final List<LibraryItem> items = [];

  List<Book> get books => items.whereType<Book>().toList();

  List<String> get titles => books.map((book) => book.title).toList();

  List<Book> get booksAfter2010 =>
      books.where((book) => book.year > 2010).toList();

  double get averagePageCount {
    return books.isEmpty
        ? 0
        : books.fold<int>(0, (total, book) => total + book.pages) / books.length;
  }

  Map<String, int> get booksByAuthor => books.fold<Map<String, int>>(
        {},
        (counts, book) {
          counts.update(book.author.name, (count) => count + 1,
              ifAbsent: () => 1);
          return counts;
        },
      );

  Set<String> get authorNames =>
      books.map((book) => book.author.name).toSet();

  Set<Genre> get genres => books.map((book) => book.genre).toSet();

  List<String> get display => [
        'CATALOGUE',
        for (final book in books) '${book.title} (${book.year})',
        ...authorNames,
        if (books.any((book) => book.pages == 0)) '(incomplete data)',
      ];

  void add(LibraryItem item) {
    items.add(item);
  }

  Book? findByTitle(String title) {
    for (var item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }
    return null;
  }
  
  String countryOf(String title) => findByTitle(title)?.author.country ?? 'unknown';
  // late final DateTime openedAt, assigned by void open() — not in the constructor
  late final DateTime openedAt;
  void open() {
    openedAt = DateTime.now();
  }
  // String? _cachedReport filled with ??= the first time a report is built
  String? _cachedReport;
  String buildReport() {
    _cachedReport ??= _generateReport();
    return _cachedReport ?? '';
  }
  String _generateReport() {
    return 'Library with ${items.length} items, opened at $openedAt';
  }
}
