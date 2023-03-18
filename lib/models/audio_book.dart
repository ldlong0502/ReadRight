// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ebook/models/media_data.dart';

class AudioBook {
  final int id;
  final String title;
  final String image;
  final String author;
  final String year;
  final int createdAt;
  final String publisher;
  final int listen;
  final List<String> genre;
  final List<Map<String, dynamic>> listMp3;
  final String description;
  int addedDate = DateTime.now().millisecondsSinceEpoch;
  String? locator;
  AudioBook({
    required this.id,
    required this.title,
    required this.image,
    required this.author,
    required this.year,
    required this.createdAt,
    required this.publisher,
    required this.listen,
    required this.genre,
    required this.listMp3,
    required this.description,

  });

  factory AudioBook.fromJson(Map<dynamic, dynamic> json) {
    return AudioBook(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String,
      author: json['author'] as String,
      year: json['year'] as String,
      createdAt: json['createdAt'] as int,
      publisher: json['publisher'] as String,
      listen: json['listen'] as int,
      genre: List<String>.from(json['genre'] as List),
      listMp3: List<Map<String, dynamic>>.from(json['mp3']),
      description: json['description'] as String,
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
      'listen': listen,
      'genre': genre,
      'description': description,
      'addedDate': addedDate,
    };
  }
}
