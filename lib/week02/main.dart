import '../week2/catalogue.dart';
import '../week2/data.dart';
import '../week2/models.dart';
import 'shelf_state.dart';

void main() {
  final library = Library();
  rawBooks.map(Book.fromJson).forEach(library.add);

  print(library.titles);
  print(library.booksAfter2010.map((book) => book.title).toList());
  print(library.averagePageCount);
  print(library.booksByAuthor);
  print(library.authorNames);
  print(library.genres);
  print(library.display);

  final stats = statsOf(library.books);
  print('count: ${stats.count}, average pages: ${stats.avgPages}');

  const empty = Empty();
  final ready = Ready(library.books);
  const broken = Broken('missing shelf data');
  for (final state in [empty, ready, broken]) {
    print(describe(state));
  }
}
