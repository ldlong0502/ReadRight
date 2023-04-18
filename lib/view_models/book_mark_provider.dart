import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/book.dart';

class BookMarkProvider extends ChangeNotifier {

  List<Book> bookMarkList = [];
  bool loading = false;
  final hiveBookMark = Hive.box('bookmark_books');
  setLoading(value) {
    loading = value;
    notifyListeners();
  }

  getInfo() async {
    setLoading(true);
    setListBookMark();
    setLoading(false);
  }

  setListBookMark() {
    var list = <Book>[];
    var data = hiveBookMark.values.toList();
    for(var item in data){
      Book book = Book.fromJson(item);
      list.add(book);
    }

    bookMarkList = [...list];
    notifyListeners();
  }

  getListBookMark(value) {
    return bookMarkList;
  }

  removeBook(Book book) async {
    print(hiveBookMark.values.toList().length);
    await hiveBookMark.delete(book.id);

    print(hiveBookMark.values.toList().length);
    setListBookMark();
  }

}
