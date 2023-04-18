// ignore_for_file: public_member_api_docs, sort_constructors_first


class Book {
  final int id;
  final String title;
  final String image;
  final String author;
  final String year;
  final int createdAt;
  final String publisher;
  final int view;
  final List<String> genre;
  final String pages;
  final String description;
  final String epub;
  String? locator;
  Book({
    required this.id,
    required this.title,
    required this.image,
    required this.author,
    required this.year,
    required this.createdAt,
    required this.publisher,
    required this.view,
    required this.genre,
    required this.pages,
    required this.description,
    required this.epub,
  });

  factory Book.fromJson(Map<dynamic, dynamic> json) {
    return Book(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String,
      author: json['author'] as String,
      year: json['year'] as String,
      createdAt: json['createdAt'] as int,
      publisher: json['publisher'] as String,
      view: json['view'] as int,
      genre: List<String>.from(json['genre'] as List),
      pages: json['pages'] as String,
      description: json['description'] as String,
      epub: json['epub'] as String,
    );
  }
  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'author': author,
      'year': year,
      'createdAt': createdAt,
      'publisher': publisher,
      'view': view,
      'genre': genre,
      'pages': pages,
      'description': description,
      'epub': epub,
    };
  }

  

  
}
