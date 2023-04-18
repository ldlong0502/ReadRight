

import 'package:ebook/models/audio_book.dart';
import 'package:ebook/models/recent_audio_book.dart';
import 'package:ebook/view_models/speed_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../models/media_data.dart';
import '../models/position_data.dart';
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
  final MiniplayerController controller = MiniplayerController();

  AudioPlayer _audioPlayer  = AudioPlayer();
  var _playList = ConcatenatingAudioSource(children: []);
  Stream<PositionData> get positionDataSteam =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position: position,
              duration: duration ?? Duration.zero,
              bufferedPosition: bufferedPosition)).asBroadcastStream();
  setAudioPlayer(value){
    _audioPlayer = value;
    notifyListeners();
  }
  setPlayList(value) {
    _playList = value;
    notifyListeners();
  }
  ConcatenatingAudioSource get playList => _playList;
  AudioPlayer get audioPlayer => _audioPlayer;

  setAudioHistory(AudioPlayer audioPlayer){

    var x = RecentAudioBook(audioBook: audioBook!, dateReadRecently: DateTime.now().millisecondsSinceEpoch);
    audioHive.put(audioBook!.id, {
      'currentIndex': audioPlayer.currentIndex,
      'position': audioPlayer.position.inSeconds,
      'recentAudio': x.toJson()
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
  Future<void> createPlayer(AudioBook book, AudioPlayer player, BuildContext context) async{
   
    if(audioBook != null){
      setAudioHistory(audioPlayer);
    }
    audioPlayer.dispose();
    setAudioPlayer(player);
    setAudioBook(book);
    context.read<SpeedProvider>().checkSpeed().then((value) => audioPlayer.setSpeed(value));
    _playList = ConcatenatingAudioSource(
        children: audioBook!.listMp3
            .map((e) => AudioSource.uri(Uri.parse(e['url']),
                tag: MediaData(title: e['title'], url: e['url'])))
            .toList());
    await audioPlayer.setLoopMode(LoopMode.all);
    setPlayList(_playList);
    var s = audioHive.get(audioBook!.id);
    if (s == null) {
      await audioPlayer.setAudioSource(_playList);
    } else {
      await audioPlayer.setAudioSource(_playList,
          initialIndex: s['currentIndex'],
          initialPosition: Duration(seconds: s['position']));
    }
    audioPlayer.play();
  
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
