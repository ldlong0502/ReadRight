import 'dart:io';

import 'package:ebook/components/chapter_dialog.dart';
import 'package:ebook/components/download_alert.dart';
import 'package:ebook/models/audio_book.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/util/enum.dart';
import 'package:ebook/util/route.dart';
import 'package:ebook/view_models/app_provider.dart';
import 'package:ebook/view_models/audio_provider.dart';
import 'package:ebook/view_models/library_provider.dart';
import 'package:ebook/views/audio_books/detail_audio_book.dart';
import 'package:ebook/views/ebook/details_ebook.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../components/custom_alert.dart';
import '../components/speed_dialog.dart';
import '../models/book.dart';
import '../view_models/subject_provider.dart';
import 'const.dart';

class Dialogs {
  showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomAlert(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 15.0),
              Text(
                Constants.appName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 25.0),
              const Text(
                'Bạn muốn thoát?',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                    width: 130.0,
                    child: TextButton(
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                    width: 130.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => exit(0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  showSetUpBottomDialog(BuildContext context) {
     var appContext = context.read<AppProvider>().appContext;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: appContext,
        builder: (appContext) {
          return Container(
            height: 400,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                _buildTitle(appContext , 'Thiết lập'),
                const SizedBox(
                  height: 10,
                ),
                _buildText('Hiển thị'),
                _buildDisplay(context),
                _buildText('Sắp xếp'),
                _buildSort(context),
              ],
            ),
          );
        });
  }

  showChapterBottomDialog(
      BuildContext context,
      List<Map<dynamic, dynamic>> listMp3,
      int index,
      Function onChooseChapter) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return ChapterDialog(
            listMp3: listMp3,
            index: index,
            onChooseChapter: onChooseChapter,
          );
        });
  }

  showSpeedBottomDialog(BuildContext context, Function onChooseSpeed) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SpeedDialog(
            onChooseSpeed: onChooseSpeed,
          );
        });
  }

  showDownloadsDialog(BuildContext context , Book book) {
    var appContext = context.read<AppProvider>().appContext;
    var actionDownloads = [
      {
        'icon': Icon(
          Icons.menu_book_rounded,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Đọc ngay',
        'onTap': () async {
          Navigator.of(appContext).pop();
          Dialogs().showEpub(context, book);
        }
      },
      {
        'icon': Icon(
          Icons.info,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Thông tin sách',
        'onTap': () {
          Navigator.of(appContext).pop();
          MyRouter.pushAnimation(context, DetailsEbook(book: book));
        }
      },
      {
        'icon': Icon(
          Icons.share,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Chia sẻ',
        'onTap': () {
         Navigator.of(appContext).pop();
        }
      },
      {
        'icon': Icon(
          Icons.remove_circle_outline_rounded,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Xóa khỏi danh sách đã tải/đang đọc',
        'onTap': () {
          Navigator.of(appContext).pop();
          context.read<LibraryProvider>().removeBookDownload(book);
          showSnackBar(context, 'Đã xóa khỏi danh sách');
        }
      }
    ];
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: appContext,
        builder: (appContext) {
          return Container(
            height: MediaQuery.of(appContext).size.height * 0.45 + 20,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                _buildTitle(appContext, 'Tùy chọn thêm'),
                ListView(
                  shrinkWrap: true,
                  children: actionDownloads
                      .asMap()
                      .entries
                      .map((e) => InkWell(
                        onTap: e.value['onTap'] as Function(),
                        child: ListTile(
                          leading: e.value['icon'] as Widget,
                          title: Text(e.value['title'] as String),
                        ),
                      ))
                      .toList(),
                ),
              ],
            ),
          );
        });
  }

  showFavoritesDialog(BuildContext context, dynamic item) {
    var appContext = context.read<AppProvider>().appContext;
    var actionFavorites = [
      {
        'icon': Icon(
         item is Book ? Icons.menu_book_rounded : Icons.headphones,
          color: ThemeConfig.thirdAccent,
        ),
        'title': item is Book ? 'Đọc ngay' : 'Nghe ngay',
        'onTap': () async {
          Navigator.of(appContext).pop();
          if(item is Book) {
             Dialogs().showEpub(context, item);
          }
          else if (item is AudioBook){
            context.read<AudioProvider>().createPlayer(item, AudioPlayer(), context);
          }
        }
      },
      {
        'icon': Icon(
          Icons.info,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Thông tin sách',
        'onTap': () {
          Navigator.of(appContext).pop();
          if(item is Book){
            MyRouter.pushAnimation(context, DetailsEbook(book: item));
          }
          else if (item is AudioBook){
              MyRouter.pushAnimation(context, DetailsAudioBook(audioBook: item));
          }
        }
      },
      {
        'icon': Icon(
          Icons.share,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Chia sẻ',
        'onTap': () {
          Navigator.of(appContext).pop();
        }
      },
      {
        'icon': Icon(
          Icons.remove_circle_outline_rounded,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Xóa khỏi danh sách yêu thích',
        'onTap': () {
          Navigator.of(appContext).pop();
          if(item is Book){
             context.read<LibraryProvider>().removeBookFavorites(item);
          }
         else if (item is AudioBook){
          context.read<LibraryProvider>().removeAudioBookFavorites(item);
         }
         showSnackBar(context, 'Đã xóa khỏi danh sách');
        }
      }
    ];
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: appContext,
        builder: (appContext) {
          return Container(
            height: MediaQuery.of(appContext).size.height * 0.45 + 20,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                _buildTitle(appContext, 'Tùy chọn thêm'),
                ListView(
                  shrinkWrap: true,
                  children: actionFavorites
                      .asMap()
                      .entries
                      .map((e) => InkWell(
                            onTap: e.value['onTap'] as Function(),
                            child: ListTile(
                              leading: e.value['icon'] as Widget,
                              title: Text(e.value['title'] as String),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          );
        });
  }

  showHistoryDialog(BuildContext context, dynamic item) {

    var appContext = context.read<AppProvider>().appContext;
    var actionFavorites = [
      {
        'icon': Icon(
          item is Book ? Icons.menu_book_rounded : Icons.headphones,
          color: ThemeConfig.thirdAccent,
        ),
        'title': item is Book ? 'Đọc ngay' : 'Nghe ngay',
        'onTap': () async {
          Navigator.of(appContext).pop();
          if (item is Book) {
            Dialogs().showEpub(context, item);
          } else if (item is AudioBook) {
            context
                .read<AudioProvider>()
                .createPlayer(item, AudioPlayer(), context);
          }
        }
      },
      {
        'icon': Icon(
          Icons.info,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Thông tin sách',
        'onTap': () {
          Navigator.of(appContext).pop();
          if (item is Book) {
            MyRouter.pushAnimation(context, DetailsEbook(book: item));
          } else if (item is AudioBook) {
            MyRouter.pushAnimation(context, DetailsAudioBook(audioBook: item));
          }
        }
      },
      {
        'icon': Icon(
          Icons.share,
          color: ThemeConfig.thirdAccent,
        ),
        'title': 'Chia sẻ',
        'onTap': () {
          Navigator.of(appContext).pop();
        }
      },
    ];
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: appContext,
        builder: (appContext) {
          return Container(
            height: MediaQuery.of(appContext).size.height * 0.35 + 20,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                _buildTitle(appContext, 'Tùy chọn thêm'),
                ListView(
                  shrinkWrap: true,
                  children: actionFavorites
                      .asMap()
                      .entries
                      .map((e) => InkWell(
                            onTap: e.value['onTap'] as Function(),
                            child: ListTile(
                              leading: e.value['icon'] as Widget,
                              title: Text(e.value['title'] as String),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          );
        });
  }
  _buildTitle(context, String s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
       
         Center(
           child: Text(
             s,
             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold , color: ThemeConfig.lightAccent),
           ),
         ),
        Center(
          child: CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: 18,
            child: IconButton(
              icon: const Icon(Icons.clear_outlined , size: 18,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ]),
    );
  }

  _buildDisplay(BuildContext context) {
    var listDisplay = [
      {
        'icon': const Icon(Icons.grid_view),
        'title': 'Lưới',
        'value': EnumDisplay.grid,
        'text': 'grid'
      },
      {
        'icon': const Icon(Icons.list_rounded),
        'title': 'Danh sách',
        'value': EnumDisplay.list,
        'text': 'list'
      }
    ];
    return Consumer<SubjectProvider>(
      builder: (context, event, _) {
        return SizedBox(
          height: 110,
          child: ListView.builder(
              itemCount: listDisplay.length,
              itemBuilder: (ctx, index) => ListTile(
                    onTap: () {
                      if (listDisplay[index]['value'] == event.display) {
                        Navigator.pop(context);
                        return;
                      }
                      Provider.of<SubjectProvider>(context, listen: false)
                          .setDisplay(listDisplay[index]['value'],
                              listDisplay[index]['text']);
                      Navigator.pop(context);
                    },
                    leading: listDisplay[index]['icon'] as Icon,
                    title: Text(listDisplay[index]['title'] as String),
                    trailing: event.display ==
                            (listDisplay[index]['value'] as EnumDisplay)
                        ? const Icon(Icons.check)
                        : null,
                  )),
        );
      },
    );
  }

  _buildSort(BuildContext context) {
    var listSort = [
      {'title': 'Mới nhất', 'value': EnumSort.latest, 'text': 'latest'},
      {'title': 'Nổi bật', 'value': EnumSort.outstanding, 'text': 'outstanding'}
    ];
    return Consumer<SubjectProvider>(
      builder: (context, event, _) {
        return SizedBox(
          height: 110,
          child: ListView.builder(
              itemCount: listSort.length,
              itemBuilder: (ctx, index) => ListTile(
                  onTap: () {
                    if (listSort[index]['value'] == event.sort) {
                      Navigator.pop(context);
                      return;
                    }
                    Provider.of<SubjectProvider>(context, listen: false)
                        .setSort(
                            listSort[index]['value'], listSort[index]['text']);
                    Navigator.pop(context);
                  },
                  title: Text(listSort[index]['title'] as String),
                  trailing: event.sort == (listSort[index]['value'] as EnumSort)
                      ? const Icon(Icons.check)
                      : null)),
        );
      },
    );
  }

  _buildText(String s) {
    return SizedBox(
      height: 50,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            s,
            style:  TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ThemeConfig.thirdAccent
            ),
          ),
        ),
        const Divider(
          indent: 10,
          endIndent: 10,
          thickness: 1,
        )
      ]),
    );
  }

  showEpub(context, Book book) {
   
    showDialog(
        context: context,
        builder: (context) => DownloadAlert(
              book: book,
            ));
  }


  showSnackBar( BuildContext context ,String title){ 
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outlined,
            color: Colors.green,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(color: ThemeConfig.lightAccent),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 15),
      padding: const EdgeInsets.all(15),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ));
  }
}
