import 'package:ebook/models/fav_ebook.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/book.dart';

class DetailsEbookProvider extends ChangeNotifier {
  Book? book;
  bool _isBookMark = false;
  bool loading = false;
  bool get isBookMark => _isBookMark;
  final hiveBookMark = Hive.box('bookmark_books');
  setLoading(value) {
    loading = value;
    notifyListeners();
  }

  getInfo(value) async {
    setLoading(true);
    checkBookMark();
    setLoading(false);
  }

  setBook(value) {
    book = value;
    notifyListeners();
  }

  getBook(value) {
    return book;
  }

  void checkBookMark() async {
    var c =  hiveBookMark.get(book!.id);
    if (c != null) {
      setBookMark(true);
    } else {
      setBookMark(false);
    }
  }

  addBookMark() {
    var item = FavoriteEbook(book: book!, date: DateTime.now().millisecondsSinceEpoch);
    hiveBookMark.put(book!.id , item.toJson());
    checkBookMark();
  }

  removeBookMark() async {
    hiveBookMark.delete(book!.id);
    checkBookMark();
  }

  void setBookMark(value) {
    _isBookMark = value;
    notifyListeners();
  }

   
}
