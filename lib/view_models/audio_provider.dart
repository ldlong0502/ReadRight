import 'package:ebook/models/audio_book.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/api.dart';
import '../util/enum.dart';
import '../util/functions.dart';


class AudioProvider extends ChangeNotifier {
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  BooksApi api = BooksApi();

  List<AudioBook> top5 = <AudioBook>[];
  List<AudioBook> recent = <AudioBook>[];
  AudioBook? audioBook;
  final audioHive = Hive.box('audio_books');

  setAudioHistory(AudioPlayer audioPlayer){
    audioHive.put(audioBook!.id, {
      'currentIndex': audioPlayer.currentIndex,
      'position': audioPlayer.position.inSeconds
    });
  }
   void setTop5(value) {
    top5 = value;
    notifyListeners();
  }
  List<AudioBook> getTop5() {
    return [...top5];
  }

  void setRecent(value) {
    recent = value;
    notifyListeners();
  }
  List<AudioBook> getRecent() {
    return [...recent];
  }
 

  AudioBook? getAudioBook() {
    return audioBook;
  }

  void setAudioBook(value) {
    audioBook = value;
    notifyListeners();
  }

  Future<void> getBooks() async {
    try {
      setApiRequestStatus(APIRequestStatus.loading);

      //get auto subject
      var top5Url = '${api.audioBookUrlKey}?_sort=listen&_order=desc&_limit=5';
      setTop5((await api.getFilterAudioBooks(top5Url))!);
      var recentUrl =
          '${api.audioBookUrlKey}?_sort=createdAt&_order=desc&_limit=10';
      setRecent((await api.getFilterAudioBooks(recentUrl))!);
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
