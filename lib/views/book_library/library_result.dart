import 'package:ebook/components/audio_image.dart';
import 'package:ebook/components/cache_image_ebook.dart';
import 'package:ebook/models/book_download.dart';
import 'package:ebook/models/fav_audioBook.dart';
import 'package:ebook/models/fav_ebook.dart';
import 'package:ebook/util/dialogs.dart';
import 'package:ebook/util/route.dart';
import 'package:ebook/view_models/library_provider.dart';
import 'package:ebook/views/audio_books/detail_audio_book.dart';
import 'package:ebook/views/ebook/details_ebook.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_config.dart';

class LibraryResult extends StatefulWidget {
  const LibraryResult({super.key, required this.index});
  final int index;

  @override
  State<LibraryResult> createState() => _LibraryResultState();
}

class _LibraryResultState extends State<LibraryResult> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
        (_) => Provider.of<LibraryProvider>(context, listen: false).getData());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<LibraryProvider>(
        builder: (BuildContext context, LibraryProvider event, Widget? child) {
      return _buildBodyList(event, size);
    });
  }

  _buildBodyList(LibraryProvider event, Size size) {
    if (widget.index == 0) {
      return _buildAllResult(event);
    } else if (widget.index == 1) {
      return _buildDownloadResult(event);
    } else {
      return _buildFavoriteResult(event);
    }
  }

  _buildAllResult(LibraryProvider event) {
    if (event.listDownloads.isEmpty && event.listFavorites.isEmpty) {
      return _buildEmpty();
    } else {
      return ListView(shrinkWrap: true, primary: true, children: [
        const SizedBox(
          height: 10,
        ),
        _buildSeeMoreDownLoads(event),
        const SizedBox(
          height: 10,
        ),
        _buildSeeMoreFavorites(event),
      ]);
    }
  }

  _buildDownloadResult(LibraryProvider event) {
    if (event.listDownloads.isNotEmpty) {
      String text = 'Đã tải (${event.listDownloads.length})';
      return ListView(
        primary: false,
        shrinkWrap: true,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          _buildTitle(text),
          const SizedBox(
            height: 10,
          ),
          _buildDownloads(event),
        ],
      );
    } else {
      return _buildEmpty();
    }
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

  _buildTitleSeeAll(LibraryProvider event, String title, int index) {
    return InkWell(
      onTap: (){
        event.setCurrentIndex(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          title,
          maxLines: 2,
          style: TextStyle(
            fontSize: 15.0,
            color: ThemeConfig.fourthAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  _buildDownloads(LibraryProvider event) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: event.listDownloads.length,
        itemBuilder: (context, index) {
          var item = event.listDownloads[index];
          return _buildLibraryDownloadItem(item);
        });
  }

  _buildEmpty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/sorry.png',
          height: 100,
        ),
        const SizedBox(
          height: 10,
        ),
        // _buildTitle(text1),
        // _buildTitle(text2),
      ],
    );
  }

  _buildFavoriteResult(LibraryProvider event) {
    if (event.listFavorites.isEmpty) {
      return _buildEmpty();
    } else {
      String text = 'Yêu thích (${event.listFavorites.length})';
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
              itemCount: event.listFavorites.length,
              itemBuilder: (context, index) {
                var item = event.listFavorites[index];
                if (item is FavoriteAudioBook) {
                  return _buildLibraryFavoritesItemAudioBook(item);
                } else if (item is FavoriteEbook) {
                  return _buildLibraryFavoritesItemBook(item);
                }
                return null;
              }),
        ],
      );
    }
  }

  Widget _buildLibraryDownloadItem(BookDownLoad item) {
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
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: CacheImageEbook(url: item.item.image),
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
              Dialogs().showDownloadsDialog(context, item.item);
            },
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryFavoritesItemAudioBook(FavoriteAudioBook item) {
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
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: AudioImage(audioBook: item.audioBook, size: 40)),
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
               Dialogs().showFavoritesDialog(context, item.audioBook);
            },
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryFavoritesItemBook(FavoriteEbook item) {
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
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: CacheImageEbook(url: item.book.image),
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
                    Text(item.book.title,
                        style: TextStyle(
                            color: ThemeConfig.lightSecond,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(item.book.author)
                  ],
                ),
              )),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
               Dialogs().showFavoritesDialog(context, item.book);
            },
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildSeeMoreDownLoads(LibraryProvider event) {
    String text1 = 'Đã tải';
    String text2 = 'Xem tất cả (${event.listDownloads.length})';
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTitle(text1),
            _buildTitleSeeAll(event, text2, 1),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: event.listDownloads.length >= 2 ? 2 : event.listDownloads.length,
            itemBuilder: (context, index) {
              var item = event.listDownloads[index];
              return InkWell(
                onTap: (){
                  MyRouter.pushAnimation(context, DetailsEbook(book: item.item));
                },
                child: ListTile(
                  leading: SizedBox(
                      width: 60, child: CacheImageEbook(url: item.item.image)),
                  title: Text(
                    item.item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(item.item.author),
                  visualDensity: const VisualDensity(vertical: 4),
                ),
              );
            })
      ],
    );
  }

  Widget _buildSeeMoreFavorites(LibraryProvider event) {
    String text1 = 'Yêu thích';
    String text2 = 'Xem tất cả (${event.listFavorites.length})';
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTitle(text1),
            _buildTitleSeeAll(event, text2, 2 ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: event.listFavorites.length >= 2
                ? 2
                : event.listFavorites.length,
            itemBuilder: (context, index) {
              var item = event.listFavorites[index];
              if(item is FavoriteAudioBook){
                 return InkWell(
                  onTap: () {
                    MyRouter.pushAnimation(context, DetailsAudioBook(audioBook: item.audioBook));
                  },
                   child: ListTile(
                    leading: SizedBox(
                      width: 60,
                      child: AudioImage(
                        audioBook: item.audioBook,
                        size: 25,
                      ),
                    ),
                    title: Text(
                      item.audioBook.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item.audioBook.author),
                    visualDensity: const VisualDensity(vertical: 4),
                                 ),
                 );
              }
              else if(item is FavoriteEbook){
                return InkWell(
                  onTap: () {
                    MyRouter.pushAnimation(context, DetailsEbook(book: item.book));
                  },
                  child: ListTile(
                    leading: SizedBox(
                      width: 60,
                      child: CacheImageEbook(url: item.book.image)),
                    title: Text(
                      item.book.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item.book.author),
                    visualDensity: const VisualDensity(vertical: 4),
                  ),
                );
              }
              return null;
            })
      ],
    );
  }
}
