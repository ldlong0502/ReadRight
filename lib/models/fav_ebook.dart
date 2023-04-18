// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ebook/models/book.dart';

class FavoriteEbook
 {
  final Book book;
  final int date;
  FavoriteEbook
({
    required this.book,
    required this.date,
  });

  FavoriteEbook
 copyWith({
    Book? book,
    int? date,
  }) {
    return FavoriteEbook
(
      book: book ?? this.book,
      date: date ?? this.date,
    );
  }

  factory FavoriteEbook
.fromJson(Map<dynamic, dynamic> json) {
    return FavoriteEbook
(
        book: Book.fromJson(json['book']),
        date: json['date'] as int);
  }

  Map<dynamic, dynamic> toJson() {
    return {'book': book.toJson(), 'date': date};
  }
}
