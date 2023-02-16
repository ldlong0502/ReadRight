import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';

import '../models/book.dart';

class BooksApi {
  final String urlKey = '&key=AIzaSyDzZMA0_Z5Yu5_zs10Hgw5BSz00YK_h7oE';
  final String urlQuery = 'volumes?q=';
  final String urlBase = 'https://www.googleapis.com/books/v1/';
  
  final String urlRecent =
      'https://www.googleapis.com/books/v1/volumes?q=subject:fiction&orderBy=newest&maxResults=10';

  String subject(String subject, amount) =>
      'https://www.googleapis.com/books/v1/volumes?q=subject:$subject&orderBy=newest&maxResults=$amount';

  Future<List<Book>?> getBooks(String url) async {
    Response result = await http.get(Uri.parse(url ));
    List<Book> books = [];
    if (result.statusCode == 200) {
      final jsonResponse = json.decode(result.body);
      final booksMap = jsonResponse['items'];
      for (var item in booksMap) {
        var book = Book.fromJson(item);

        books.add(book);
      }
      return books;
    } else {
      return null;
    }
  }
}
