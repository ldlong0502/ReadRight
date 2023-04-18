import 'dart:io';

import 'package:ebook/models/audio_book.dart';
import 'package:ebook/models/book_download.dart';
import 'package:ebook/models/fav_audioBook.dart';
import 'package:ebook/models/fav_ebook.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';

class LibraryProvider with ChangeNotifier {

  final hiveBookReading = Hive.box('book_reading_books');
  final hiveBookMark = Hive.box('bookmark_books');
  final hiveAudioBookMark = Hive.box('bookmark_audioBooks');

  int _currentIndex = 0;
  List<BookDownLoad> _listDownloads = <BookDownLoad>[];
  List<dynamic> _listFavorites = <dynamic>[];


   void setCurrentIndex(value) {
    _currentIndex = value;
    notifyListeners();
  }

  void setListDownloads(value) {
    _listDownloads = value;
    notifyListeners();
  }

  void setListFavorites(value) {
    _listFavorites = value;
    notifyListeners();
  }



  List<BookDownLoad> get listDownloads => _listDownloads;
  List<dynamic> get listFavorites => _listFavorites;
  int get currentIndex => _currentIndex;

  Future<void> getData() async {
    var listBookMark = <FavoriteEbook>[];
     for (var item in hiveBookMark.values.toList()) {
      var favBook = FavoriteEbook.fromJson(item);
      listBookMark.add(favBook);
    }
    var listAudioBookMark = <FavoriteAudioBook>[];
    for (var item in hiveAudioBookMark.values.toList()) {
      var favAudiobook = FavoriteAudioBook.fromJson(item);
      listAudioBookMark.add(favAudiobook);
    }
    var fav = <dynamic>[];
    fav.addAll(listBookMark);
    fav.addAll(listAudioBookMark);
    fav.sort((a, b) => b.date.compareTo(a.date));
    setListFavorites(fav);

    var down = <BookDownLoad>[];
    for (var item in hiveBookReading.values.toList()) {
      var downBook = BookDownLoad.fromJson(item);
      down.add(downBook);
    }
    down.sort((a, b) => b.dateDown.compareTo(a.dateDown));
    setListDownloads(down);
  }

   addBookReading(Book book) {
    var bookDown = BookDownLoad(
        item: book,
        location: '',
        dateDown: DateTime.now().millisecondsSinceEpoch,
        dateReadRecently: DateTime.now().millisecondsSinceEpoch);
    hiveBookReading.put(book.id, bookDown.toJson());
    getData();
  }
    removeBookDownload(Book book) async {
    await hiveBookReading.delete(book.id);

    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = '${appDocDir!.path}/${book.id}.epub';
    File file = File(path);
    if (File(path).existsSync()) {
      file.deleteSync();
    }
    getData(); 
  }
  removeBookFavorites(Book book) async {
    await hiveBookMark.delete(book.id);
    getData();
  }
  removeAudioBookFavorites(AudioBook book) async {
    await hiveAudioBookMark.delete(book.id);
    getData();
  }
  
}
