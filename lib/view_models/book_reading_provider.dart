import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';

class BookReadingProvider extends ChangeNotifier {
  List<Book> bookReadingList = [];
  bool loading = false;
  final hiveBookReading = Hive.box('book_reading_books');


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
      Book book = Book.fromJson(item);
      list.add(book);
    }
    list.sort((a,b) => b.addedDate.compareTo(a.addedDate));
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
