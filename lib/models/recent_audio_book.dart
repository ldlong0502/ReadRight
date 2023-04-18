// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ebook/models/audio_book.dart';

class RecentAudioBook {
  final AudioBook audioBook;
  final int dateReadRecently;
  RecentAudioBook({
    required this.audioBook,
    required this.dateReadRecently,
  });

  RecentAudioBook copyWith({
    AudioBook? audioBook,
    int? dateReadRecently,
  }) {
    return RecentAudioBook(
      audioBook: audioBook ?? this.audioBook,
      dateReadRecently: dateReadRecently ?? this.dateReadRecently,
    );
  }

  factory RecentAudioBook.fromJson(Map<dynamic, dynamic> json) {
    return RecentAudioBook(
        audioBook: AudioBook.fromJson(json['audioBook']),
        dateReadRecently: json['dateReadRecently'] as int);
  }

  Map<dynamic, dynamic> toJson() {
    return {'audioBook': audioBook.toJson(), 'dateReadRecently': dateReadRecently};
  }
}
