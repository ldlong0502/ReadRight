// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'book.dart';

class CategoryBook {
  final String name;
  final List<Book> books;

  CategoryBook({
    required this.name,
    required this.books,
  });

  CategoryBook copyWith({
    String? name,
    List<Book>? books,
  }) {
    return CategoryBook(
      name: name ?? this.name,
      books: books ?? this.books,
    );
  }
}
