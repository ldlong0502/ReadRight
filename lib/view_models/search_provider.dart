import 'package:ebook/models/audio_book.dart';
import 'package:ebook/util/api.dart';
import 'package:flutter/foundation.dart';
import 'package:ebook/util/enum.dart';
import '../models/book.dart';
import '../util/functions.dart';

class SearchProvider with ChangeNotifier {
  String _query = '';
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  BooksApi api = BooksApi();
  List<Book> _listBooks = <Book>[];
  List<AudioBook> _listAudioBooks = <AudioBook>[];

  void setListBooks(value) {
    _listBooks = value;
    notifyListeners();
  }
  void setListAudioBooks(value) {
    _listAudioBooks = value;
    notifyListeners();
  }

  void setQuery(value) {
    _query = value;
    notifyListeners();
  }

  List<Book> get listBooks => _listBooks;
  List<AudioBook> get listAudioBooks => _listAudioBooks;
  String get query => _query;

  

  Future<void> searchBook(String querySearch) async {
    try {
      setApiRequestStatus(APIRequestStatus.loading);

      setQuery(querySearch);
      var urlBook = '';
      var urlAudioBook = '';
      if(query == ""){
         urlBook = '${api.bookUrlKey}?_sort=view&_order=desc&_limit=2';
         urlAudioBook = '${api.audioBookUrlKey}?_sort=listen&_order=desc&_limit=2';
      }
      else{
        urlBook = '${api.bookUrlKey}?q=$query';
        urlAudioBook = '${api.audioBookUrlKey}?q=$query';
      }
      setListBooks(await api.getFilterBooks(urlBook));
      setListAudioBooks(await api.getFilterAudioBooks(urlAudioBook));
      setApiRequestStatus(APIRequestStatus.loaded);
    } catch (e) {
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
