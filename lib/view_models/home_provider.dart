
import 'package:ebook/util/api.dart';
import 'package:flutter/foundation.dart';
import 'package:ebook/util/enum.dart';
import '../models/book.dart';
import '../models/category_book.dart';
import '../util/functions.dart';

class HomeProvider with ChangeNotifier {
  CategoryBook _top = CategoryBook(name: 'top', books: []);
  CategoryBook _recent = CategoryBook(name: 'recent', books: []);
  CategoryBook _autoSubject = CategoryBook(name: 'auto subject', books: []);
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  BooksApi api = BooksApi();
  
  void setRecent(value) {
    _recent = value;
    notifyListeners();
  }
  CategoryBook get recent {
    return _recent;
  }
  void setAutoSubject(value) {
    _autoSubject = value;
    notifyListeners();
  }

  CategoryBook get autoSubject {
    return _autoSubject;
  }

  Future<void> getBooks() async {
    try {
      setApiRequestStatus(APIRequestStatus.loading);

      //get auto subject
      var top5book = '${api.bookUrlKey}?_sort=view&_order=desc&_limit=5';
      setAutoSubject(_autoSubject.copyWith(books: (await api.getFilterBooks(top5book))));
      var top10recent = '${api.bookUrlKey}?_sort=createdAt&_order=desc&_limit=10';
      setRecent(_recent.copyWith(books: (await api.getFilterBooks(top10recent))));
      setApiRequestStatus(APIRequestStatus.loaded);
    }
    catch (e){
      checkError(e);
    }
   
  }
  void setApiRequestStatus(APIRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }
   void checkError(e) {
    if (Functions.checkConnectionError(e)) {
      setApiRequestStatus(APIRequestStatus.connectionError);
    } else {
      setApiRequestStatus(APIRequestStatus.error);
    }
  }
  
}
