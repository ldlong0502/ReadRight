import 'package:dio/dio.dart';
import 'package:ebook/models/audio_book.dart';
import 'dart:async';
import '../models/book.dart';

class BooksApi {
  final dio = Dio();
  
  String bookUrlKey = "https://readright.onrender.com/api/books";
  String audioBookUrlKey = "https://readright.onrender.com/api/audio_books";

  Future<List<Book>?> getBooks() async {
    Response result = await dio.get(bookUrlKey);
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

  Future<List<Book>?> getFilterBooks(String url) async {
    Response result = await dio.get(url);
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

  Future<List<AudioBook>?> getAudioBook() async {
    Response result = await dio.get(audioBookUrlKey);
    List<AudioBook> audioBooks = [];
    if (result.statusCode == 200) {
      for (var item in result.data) {
        var book = AudioBook.fromJson(item);

        audioBooks.add(book);
      }
      return audioBooks;
    } else {
      return null;
    }
  }

  Future<List<AudioBook>?> getFilterAudioBooks(String url) async {
    Response result = await dio.get(url);
    List<AudioBook> audioBooks = [];
    if (result.statusCode == 200) {
      for (var item in result.data) {
        var book = AudioBook.fromJson(item);

        audioBooks.add(book);
      }
      return audioBooks;
    } else {
      return null;
    }
  }
}
