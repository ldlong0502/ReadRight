class Book {
  String id;
  String title;
  List<String> authors;
  String publisher;
  String publishedDate;
  String description;
  int pageCount;
  List<String> categories;
  double averageRating;
  int ratingsCount;
  String thumbnailUrl;
  String previewLink;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.description,
    required this.pageCount,
    required this.categories,
    required this.averageRating,
    required this.ratingsCount,
    required this.thumbnailUrl,
    required this.previewLink,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['volumeInfo']['title'],
      authors: List<String>.from(json['volumeInfo']['authors'] ?? ['None']),
      publisher: json['volumeInfo']['publisher'] ?? '',
      publishedDate: json['volumeInfo']['publishedDate'] ?? '',
      description: json['volumeInfo']['description'] ?? '',
      pageCount: json['volumeInfo']['pageCount'] ?? 0,
      categories: List<String>.from(json['volumeInfo']['categories'] ?? ['None']),
      averageRating: (json['volumeInfo']['averageRating'] ?? 0).toDouble(),
      ratingsCount: json['volumeInfo']['ratingsCount'] ?? 0,
      thumbnailUrl: json['volumeInfo']['imageLinks'] != null ? json['volumeInfo']['imageLinks']['thumbnail'] ?? '' : '',
      previewLink: json['volumeInfo']['previewLink'] ?? '',
    );
  }
}
