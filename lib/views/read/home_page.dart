import 'dart:async';

import 'package:ebook/util/const.dart';
import 'package:ebook/util/functions.dart';
import 'package:ebook/util/route.dart';
import 'package:ebook/view_models/book_reading_provider.dart';
import 'package:ebook/views/ebook/ebook_home.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/view_models/appbar_provider.dart';
import 'package:ebook/views/search_page/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../components/custom_search.dart';
import '../../components/slide_button.dart';
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
      (_) => Provider.of<BookReadingProvider>(context, listen: false).getInfo(),
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
        body: Stack(
          children: [
            
           
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: size.height / 2,
                child: Container(
                  decoration: Constants.linearDecoration,
                  child: Column(
                    children: [
                      const SizedBox(height: 70,),
                      _buildSearch(context),
                      _buildGreeting(),
                      
                     
                      _buildStyle(),
                    ],
                  ),
                )),
                 AnimatedPositioned(
              top: 0,
              left: widget.isMenuClosed ? 15 : 200,
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              child: SlideButton(
                riveOnInt: (artboard) {
                  widget.onRiveInit(artboard);
                },
                press: () {
                  widget.onPress();
                },
              ),
            ),
            Positioned(
              top: size.height * 0.4,
              left: 0,
              right: 0,
              height: size.height - size.height / 3,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: const Home(),
              ),
            ),
          ],
        ),
        floatingActionButton: _buildLatestBookReading());
  }

  _buildSearch(BuildContext context) {
    return Consumer<AppBarProvider>(
      builder: (context, event, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => MyRouter.pushAnimationChooseType(context, const SearchPage(), PageTransitionType.fade),
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

  Widget _buildLatestBookReading() {
    return Consumer<BookReadingProvider>(builder: (context, event, _) {
      return event.bookReadingList.isEmpty
          ? Container()
          : InkWell(
              onTap: () async {
                var path = await Functions().getPath(event.bookReadingList[0]);
                if (!mounted) return;
                Functions().openEpub(path, context, event.bookReadingList[0]);
              },
              child: Container(
                  height: 71,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ThemeConfig.lightAccent)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(event.bookReadingList[0].image))),
            );
    });
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
}
