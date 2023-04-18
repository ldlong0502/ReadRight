// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:ebook/models/book.dart';

class BookDownLoad {
  final Book item;
  final String location;
  final int dateDown;
  final int dateReadRecently;
  BookDownLoad({
    required this.item,
    required this.location,
    required this.dateDown,
    required this.dateReadRecently,
  });

  BookDownLoad copyWith({
    Book? item,
    String? location,
    int? dateDown,
    int? dateReadRecently,
  }) {
    return BookDownLoad(
      item: item ?? this.item,
      location: location ?? this.location,
      dateDown: dateDown ?? this.dateDown,
      dateReadRecently: dateReadRecently ?? this.dateReadRecently,
    );
  }

  factory BookDownLoad.fromJson(Map<dynamic, dynamic> json){
    return BookDownLoad(
      item: Book.fromJson(json['item']),
      location: json['location'] as String,
      dateDown: json['dateDown'] as int,
      dateReadRecently: json['dateReadRecently'] as int
    );
  }

  
   Map<dynamic, dynamic> toJson() {
    return {
     'item': item.toJson(),
     'location': location,
     'dateDown': dateDown,
     'dateReadRecently': dateReadRecently,
    };
  }

  
}
