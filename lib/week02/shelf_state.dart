import '../week2/models.dart';

sealed class ShelfState {
  const ShelfState();
}

class Empty extends ShelfState {
  const Empty();
}

class Ready extends ShelfState {
  final List<Book> books;

  const Ready(this.books);
}

class Broken extends ShelfState {
  final String message;

  const Broken(this.message);
}

String describe(ShelfState state) => switch (state) {
      Empty() => 'Shelf is empty',
      Ready(:final books) => 'Shelf is ready with ${books.length} books',
      Broken(:final message) => 'Shelf is broken: $message',
    };

({int count, double avgPages}) statsOf(List<Book> books) {
  final totalPages = books.fold<int>(
    0,
    (total, book) => total + book.pages,
  );

  return (
    count: books.length,
    avgPages: books.isEmpty ? 0.0 : totalPages / books.length,
  );
}
