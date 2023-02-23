import 'package:dio/dio.dart';
import 'dart:async';
import '../models/book.dart';

class BooksApi {
  final dio = Dio();
  
  String urlKey = "http://10.0.2.2:3000/api/books";

  Future<List<Book>?> getBooks() async {
    Response result = await dio.get(urlKey);
    List<Book> books = [];
    if (result.statusCode == 200) {
      for (var item in result.data) {
        var book = Book.fromJson(item);

        books.add(book);
      }
      return books;
    } else {
      return null;
    }
  }
}
