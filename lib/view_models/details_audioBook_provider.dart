import 'package:ebook/models/audio_book.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/fav_audioBook.dart';


class DetailsAudioBookProvider extends ChangeNotifier {
  AudioBook? audioBook;
  bool _isAudioBookMark = false;
  bool loading = false;
  bool get isAudioBookMark => _isAudioBookMark;
  final hiveBookMark = Hive.box('bookmark_audioBooks');
  setLoading(value) {
    loading = value;
    notifyListeners();
  }

  getInfo(value) async {
    setLoading(true);
    checkAudioBookMark();
    setLoading(false);
  }

  setAudioBook(value) {
    audioBook = value;
    notifyListeners();
  }

  getAudioBook(value) {
    return audioBook;
  }

  void checkAudioBookMark() async {
    var c = hiveBookMark.get(audioBook!.id);
    if (c != null) {
      setAudioBookMark(true);
    } else {
      setAudioBookMark(false);
    }
  }

  addAudioBookMark() {
    var item =
        FavoriteAudioBook(audioBook: audioBook!, date: DateTime.now().millisecondsSinceEpoch);
    hiveBookMark.put(audioBook!.id, item.toJson());
    checkAudioBookMark();
  }

  removeBookMark() async {
    hiveBookMark.delete(audioBook!.id);
    checkAudioBookMark();
  }

  void setAudioBookMark(value) {
    _isAudioBookMark = value;
    notifyListeners();
  }
}
