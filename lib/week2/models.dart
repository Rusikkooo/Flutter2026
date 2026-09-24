class Author {
  final String name;
  final String? country;
  const Author({required this.name, this.country});
  @override
  String toString() {
    return 'Author {name : $name , country : $country}';
  }
}

enum Genre {
  craft('craft'),
  theory('theory'),
  unknown('unknown');

  final String label;
  const Genre(this.label);

  static Genre fromString(String? raw) {
    switch (raw) {
      case 'craft':
        return Genre.craft;
      case 'theory':
        return Genre.theory;
      default:
        return Genre.unknown;
    }
  }

  @override
  String toString() {
    return 'Genre {label : $label}';
  }
}

class Book extends LibraryItem with Borrowable {
  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  const Book({
    required String title,
    required int year,
    required this.pages,
    required this.author,
    required this.genre,
    this.description,
  }): super(title: title, year: year);


  @override
  String describe() {
    return 'Book {title : $title , year : $year , pages : $pages , author : $author , genre : $genre , description : $description}';
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] as String? ?? 'Untitled',
      year: json['year'] as int? ?? 0,
      pages: json['pages'] as int? ?? 0,
      author: Author(
        name: json['author'] as String? ?? 'Unknown',
        country: json['country'] as String?,
      ),
      genre: Genre.fromString(json['genre'] as String?),
      description: json['description'] as String?,
    );
  }

// A getter isLong — true when pages > 400
  bool get isLong => pages > 400;

// copyWith and an overridden toString()

  Book copyWith({
    String? title,
    int? year,
    int? pages,
    Author? author,
    Genre? genre,
    String? description,
  }) {
    return Book(
      title: title ?? this.title,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'Book {title : $title , year : $year , pages : $pages , author : $author , genre : $genre , description : $description}';
  }
  
}


abstract class LibraryItem{
  final String title;
  final int year;

  const LibraryItem({
    required this.title,
    required this.year,
  });
  String describe();
  bool get isOld => year < 2000;
}
// Magazine extends LibraryItem — final issue, implements describe()
class Magazine extends LibraryItem{
  final int issue;

  const Magazine({
    required String title,
    required int year,
    required this.issue,
  }):super(title: title, year: year);
  @override
  String describe() {
    return 'Magazine {title : $title , year : $year , issue : $issue}';
  }


}
mixin Borrowable on LibraryItem {
  String borrowLabel() => 'Borrowing: $title';
}

class Ghost implements LibraryItem {
  @override
  final String title;

  @override
  final int year;

  const Ghost(this.title, this.year);

  @override
  String describe() => 'A ghost story: "$title"';

  @override
  bool get isOld => true;
}