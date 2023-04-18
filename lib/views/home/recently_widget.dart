import 'package:ebook/models/book_download.dart';
import 'package:ebook/models/recent_audio_book.dart';
import 'package:ebook/view_models/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../../components/audio_image.dart';
import '../../theme/theme_config.dart';
import '../../util/dialogs.dart';
import '../../view_models/app_provider.dart';

class RecentlyWidget extends StatefulWidget {
  const RecentlyWidget({super.key});
  

  @override
  State<RecentlyWidget> createState() => _RecentlyWidgetState();
}

class _RecentlyWidgetState extends State<RecentlyWidget> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<HistoryProvider>(context, listen: false)
          .loadHistory()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(builder: (context, event, _) {
      return event.allBooks.isEmpty
          ? _buildEmpty()
          : _buildHistory(context, event);
    });
  }

  

  

  _buildEmpty() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                alignment: Alignment.center,
                child: const Text(
                  'Danh sách trống! Đợi chúng tôi thêm chủ đề này vào nhé.',
                  maxLines: 2,
                  style: TextStyle(fontSize: 20),
                )),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              '^_^',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
  
  _buildRecently(HistoryProvider event) {
     String text = 'Tất cả (${event.allBooks.length})';
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: [
        const SizedBox(height: 10),
        _buildTitle(text),
        const SizedBox(height: 10),
        ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: event.allBooks.length,
            itemBuilder: (context, index) {
              var item = event.allBooks[index];
              if (item is BookDownLoad) {
                return _buildItemBook(item);
              } else if (item is RecentAudioBook) {
                return _buildLItemAudioBook(item);
              }
              return null;
            }),
      ],
    );
  }
_buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        title,
        maxLines: 2,
        style: TextStyle(
          fontSize: 18.0,
          color: ThemeConfig.lightAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  _buildLItemAudioBook(RecentAudioBook item) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: AudioImage(audioBook: item.audioBook, size: 60)),
          ),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SÁCH NÓI',
                      style: TextStyle(color: ThemeConfig.authorColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(item.audioBook.title,
                        style: TextStyle(
                            color: ThemeConfig.lightSecond,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(item.audioBook.author)
                  ],
                ),
              )),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              Dialogs().showHistoryDialog(
                  context, item.audioBook);
            },
            color: Colors.black,
          ),
        ],
      ),
    );
  }
  
  _buildItemBook(BookDownLoad item) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item.item.image,
                    fit: BoxFit.fill,
                  )),
            ),
          ),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EBOOK',
                      style: TextStyle(color: ThemeConfig.authorColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(item.item.title,
                        style: TextStyle(
                            color: ThemeConfig.lightSecond,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(item.item.author)
                  ],
                ),
              )),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              Dialogs().showHistoryDialog(context, item.item);
            },
            color: Colors.black,
          ),
        ],
      ),
    );
  }
  
  _buildHistory(BuildContext context, HistoryProvider event) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: size.height / 7,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [ThemeConfig.lightAccent, ThemeConfig.fourthAccent],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                          
                            Text(
                              'Lịch sử nghe / đọc',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                   Expanded(child: Container()),
                  ],
                ),
              )),
          Positioned(
            top: size.height * 0.12,
            left: 0,
            right: 0,
            bottom: 0 ,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              // child:  Column(
              //   children: [
              //     
                 
              //   ],
              // ),
              child:  _buildRecently(event),
            ),
            
          ),
        ],
      ),
    );
  
  }
}
