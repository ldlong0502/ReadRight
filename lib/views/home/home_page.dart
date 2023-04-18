import 'dart:async';

import 'package:ebook/components/audio_image.dart';
import 'package:ebook/models/book_download.dart';
import 'package:ebook/models/recent_audio_book.dart';
import 'package:ebook/util/const.dart';
import 'package:ebook/util/route.dart';
import 'package:ebook/view_models/book_history_provider.dart';
import 'package:ebook/view_models/history_provider.dart';
import 'package:ebook/views/ebook/ebook_home.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/view_models/appbar_provider.dart';
import 'package:ebook/views/home/recently_widget.dart';
import 'package:ebook/views/search_page/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../components/custom_search.dart';
import '../audio_books/audio_home.dart';
import 'home.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.isMenuClosed,
      required this.onRiveInit,
      required this.onPress});
  final bool isMenuClosed;
  final Function onRiveInit;
  final Function onPress;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late DateTime _dateTime = DateTime.now();
  var listSubject = [
    {
      'title': 'SÁCH NÓI',
      'asset': 'assets/images/audio_book.png',
      'widget': const AudioHome()
    },
    {
      'title': 'EBOOK',
      'asset': 'assets/images/ebook.png',
      'widget': const EbookHome()
    },
  ];
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<BookHistoryProvider>(context, listen: false).getInfo(),
    );
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<HistoryProvider>(context, listen: false).loadHistory(),
    );
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _dateTime = DateTime.now();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: size.height * 0.6,
            decoration: Constants.linearDecoration.copyWith(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(30)
              )
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                _buildSearch(context),
                _buildGreeting(),
                _buildStyle(),
                _buildText(),
                _buildHistory(),
                
              ],
            ),
          ),
          Container(
            color: ThemeConfig.lightAccent,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40)
                )
              ),
              child: const Home()),
          ),
        ],
      ),
    );
  }

  _buildSearch(BuildContext context) {
    return Consumer<AppBarProvider>(
      builder: (context, event, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => MyRouter.pushAnimationChooseType(
                  context, const SearchPage(), PageTransitionType.fade),
              child: Container(
                decoration: BoxDecoration(
                    color: ThemeConfig.lightSecond.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(5),
                height: 45,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child:
                          Icon(Icons.search, color: ThemeConfig.lightPrimary),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        'Tìm kiếm tác giả, tên sách...',
                        maxLines: 1,
                        style: TextStyle(
                            color: ThemeConfig.lightPrimary,
                            overflow: TextOverflow.ellipsis),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _searchBook(BuildContext context) {
    showSearch(context: context, delegate: CustomSearch());
  }

  _buildGreeting() {
    print(DateTime.now().hour);
    var map = {};
    if (_dateTime.hour >= 4 && _dateTime.hour <= 11) {
      map = {'asset': 'assets/images/sunny.png', 'greeting': 'Chào buổi sáng'};
    } else if (_dateTime.hour >= 12 && _dateTime.hour <= 13) {
      map = {'asset': 'assets/images/noon.png', 'greeting': 'Buổi trưa vui vẻ'};
    } else if (_dateTime.hour > 13 && _dateTime.hour <= 17) {
      map = {'asset': 'assets/images/noon.png', 'greeting': 'Chào buổi chiều'};
    } else if (_dateTime.hour > 17 && _dateTime.hour <= 23) {
      map = {'asset': 'assets/images/night.png', 'greeting': 'Buổi tối vui vẻ'};
    } else {
      map = {'asset': 'assets/images/owl.png', 'greeting': 'Chào cú đêm'};
    }
    return ListTile(
      leading: Image.asset(
        map['asset'] as String,
        height: 30,
      ),
      title: Text(
        map['greeting'] as String,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  _buildStyle() {
    return SizedBox(
      height: 120,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: listSubject
                .map((e) => InkWell(
                      onTap: () {
                        MyRouter.pushAnimation(context, e['widget'] as Widget);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: Image.asset(
                                e['asset'] as String,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              e['title'] as String,
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ))
                .toList()),
      ),
    );
  }

  _buildHistory() {
    return Consumer<HistoryProvider>(
      builder: (context, event, _) {
        return event.allBooks.isEmpty ? Container() : buildBooksHistory(event);
      },
    );
  }

  buildBooksHistory(HistoryProvider event) {
    final allBooks = event.allBooks;
    final listWidget = List.generate(
      allBooks.length,
      (index) => _buildTypeBook(event, allBooks[index], index),
    )..add(IconButton(
        onPressed: () {
          MyRouter.pushAnimation(context, const RecentlyWidget());
        },
        icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_forward_rounded))));
    return Container(
        height: 120,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: listWidget));
  }

  Widget _buildTypeBook(HistoryProvider event, book, int index) {
    if (book is RecentAudioBook) {
      var item = book;
      return Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white30, borderRadius: BorderRadius.circular(20)),
          width: 200,
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AudioImage(audioBook: item.audioBook, size: 20),
                  )),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'SÁCH NÓI',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          item.audioBook.title,
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ))
            ],
          ));
    } else {
      var item = book as BookDownLoad;
      return Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white30, borderRadius: BorderRadius.circular(20)),
          width: 200,
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.item.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'EBOOK',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          item.item.title,
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ))
            ],
          ));
    }
  }

  _buildText() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          'Đã đọc/nghe gần đây',
          maxLines: 2,
          style: TextStyle(
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }
}
