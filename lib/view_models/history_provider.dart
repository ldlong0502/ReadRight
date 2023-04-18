import 'dart:convert';
import 'dart:io';

import 'package:ebook/models/audio_book.dart';
import 'package:ebook/models/book_download.dart';
import 'package:ebook/models/recent_audio_book.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';

class HistoryProvider extends ChangeNotifier {

  bool loading = false;
  List<dynamic> _allBooks = [];
  final hiveBookReading = Hive.box('book_reading_books');
  final hiveAudioBook = Hive.box('audio_books');

  setLoading(value) {
    loading = value;
    notifyListeners();
  }
  setAllBooks(value){
    _allBooks = value;
  }
  List<dynamic> get allBooks => _allBooks;
  loadHistory() {
    setLoading(true);
    var bookList = <BookDownLoad>[];
    var audioBookList = <RecentAudioBook>[];
    List<dynamic> temp = [];
    var dataBook = hiveBookReading.values.toList();
    var dataAudioBook = hiveAudioBook.values.toList();
    for (var item in dataBook) {
      var book = BookDownLoad.fromJson(item);
      bookList.add( book);
    }
    
    
    for (var item in dataAudioBook) {
      RecentAudioBook audioBook = RecentAudioBook.fromJson(item["recentAudio"]);
      audioBookList.add(audioBook);
    }
    temp.addAll(bookList);
    temp.addAll(audioBookList);
    temp.sort((a,b) => b.dateReadRecently.compareTo(a.dateReadRecently));
    setAllBooks(temp);
    setLoading(false);
    notifyListeners();

  }



  removeBook(Book book) async {
    hiveBookReading.delete(book.id);

    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = '${appDocDir!.path}/${book.id}.epub';
    File file = File(path);
    if (File(path).existsSync()) {
      file.deleteSync();
    }
  }
}
