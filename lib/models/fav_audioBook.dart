// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ebook/models/audio_book.dart';

class FavoriteAudioBook {
  final AudioBook audioBook;
  final int date;
  FavoriteAudioBook({
    required this.audioBook,
    required this.date,
  });

  FavoriteAudioBook copyWith({
    AudioBook? audioBook,
    int? date,
  }) {
    return FavoriteAudioBook(
      audioBook: audioBook ?? this.audioBook,
      date: date ?? this.date,
    );
  }

  factory FavoriteAudioBook.fromJson(Map<dynamic, dynamic> json) {
    return FavoriteAudioBook(
        audioBook: AudioBook.fromJson(json['audioBook']), date: json['date'] as int);
  }

  Map<dynamic, dynamic> toJson() {
    return {'audioBook': audioBook.toJson(), 'date': date};
  }
}
