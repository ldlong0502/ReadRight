// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:ebook/models/book.dart';

class BookDownLoad {
  final Book item;
  final String location;
  BookDownLoad({
    required this.item,
    required this.location,
  });

  BookDownLoad copyWith({
    Book? item,
    String? location,
  }) {
    return BookDownLoad(
      item: item ?? this.item,
      location: location ?? this.location,
    );
  }

  factory BookDownLoad.fromJson(Map<dynamic, dynamic> json){
    return BookDownLoad(
      item: Book.fromJson(json['item']),
      location: json['location'] as String
    );
  }

  
   Map<dynamic, dynamic> toJson() {
    return {
     'item': item.toJson(),
     'location': location
    };
  }

  
}
