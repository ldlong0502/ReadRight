import 'dart:convert';
import 'dart:io';

import 'package:ebook/models/audio_book.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';

class BookHistoryProvider extends ChangeNotifier {
  List<Book> bookReadingList = [];
  List<AudioBook> audioBookList = [];
  bool loading = false;
  final hiveBookReading = Hive.box('book_reading_books');
  final hiveAudioBook = Hive.box('audio_books');

  setLoading(value) {
    loading = value;
    notifyListeners();
  }

  getInfo() async {
    setLoading(true);
    setListBookReading();
    setLoading(false);
  }

  

  setListBookReading() {
    var list = <Book>[];
    var data = hiveBookReading.values.toList();
    for (var item in data) {
      Book book = Book.fromJson(item["item"]);
      list.insert(0,book);
    }
    
    bookReadingList = [...list];
    notifyListeners();
  }

  getListBookReading() {
    return bookReadingList;
  }

  removeBook(Book book) async {
    hiveBookReading.delete(book.id);

    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = '${appDocDir!.path}/${book.id}.epub';
    File file = File(path);
    if (File(path).existsSync()){
      file.deleteSync();
    }
    setListBookReading();
  }
}
