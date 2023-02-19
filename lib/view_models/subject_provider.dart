import 'package:ebook/util/enum.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/book.dart';
import '../util/api.dart';
import '../util/functions.dart';

class SubjectProvider extends ChangeNotifier {
  SubjectProvider() {
    checkDisplay();
    checkSort();
  }
  List<Book> listBook = <Book>[];
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  BooksApi api = BooksApi();
  var display = EnumDisplay.grid;
  var sort = EnumSort.latest;
  void setDisplay(value, c) async {
    display = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('display', c);
    notifyListeners();
  }

  void setSort(value, c) async {
    sort = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('sort', c);
    notifyListeners();
  }

  void setApiRequestStatus(APIRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }

  setListBook(value) {
    listBook = value;
    notifyListeners();
  }

  List<Book> getListBook() {
    return listBook;
  }

  Future<EnumDisplay> checkDisplay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    EnumDisplay temp;
    String r = prefs.getString('display') ?? 'grid';
    if (r == 'grid') {
      temp = EnumDisplay.grid;
      setDisplay(temp, 'grid');
    } else {
      temp = EnumDisplay.list;
      setDisplay(temp, 'list');
    }
    return temp;
  }

  Future<EnumSort> checkSort() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    EnumSort temp;
    String r = prefs.getString('sort') ?? 'latest';
    if (r == 'latest') {
      temp = EnumSort.latest;
      setSort(temp, 'latest');
    } else {
      temp = EnumSort.outstanding;
      setSort(temp, 'outstanding');
    }
    return temp;
  }

  Future<void> getBooks(subject) async {
    try {
      setApiRequestStatus(APIRequestStatus.loading);
      setListBook(await api.getBooks(api.subject(subject, 40)));
      setApiRequestStatus(APIRequestStatus.loaded);
    } catch (e) {
      checkError(e);
    }
  }

  void checkError(e) {
    if (Functions.checkConnectionError(e)) {
      setApiRequestStatus(APIRequestStatus.connectionError);
    } else {
      setApiRequestStatus(APIRequestStatus.error);
    }
  }
}
