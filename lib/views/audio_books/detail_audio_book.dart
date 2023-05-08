import 'package:ebook/components/audio_image.dart';
import 'package:ebook/models/audio_book.dart';
import 'package:ebook/util/const.dart';
import 'package:ebook/view_models/app_provider.dart';
import 'package:ebook/view_models/library_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../theme/theme_config.dart';
import '../../view_models/audio_provider.dart';
import '../../view_models/details_audioBook_provider.dart';
import '../bookmark/book_mark.dart';

class DetailsAudioBook extends StatefulWidget {
  const DetailsAudioBook({super.key, required this.audioBook});
  final AudioBook audioBook;
  @override
  State<DetailsAudioBook> createState() => _DetailsAudioBookState();
}

class _DetailsAudioBookState extends State<DetailsAudioBook> {
  late ScrollController scrollController;
  bool isShowTitle = false;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(initialScrollOffset: 0);
    scrollController.addListener(() {
      if (scrollController.offset >= MediaQuery.of(context).size.height * 0.4) {
        setState(() {
          isShowTitle = true;
        });
      } else {
        setState(() {
          isShowTitle = false;
        });
      }
    });
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<DetailsAudioBookProvider>(context, listen: false)
            .setAudioBook(widget.audioBook);
        Provider.of<DetailsAudioBookProvider>(context, listen: false)
            .getInfo(widget.audioBook);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<DetailsAudioBookProvider>(builder: (context, event, _) {
      String genre = widget.audioBook.genre.join(', ');
      return Container(
        height: size.height,
        decoration: Constants.linearDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                  onPressed: () async {
                    if (event.isAudioBookMark) {
                      event.removeBookMark();
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
                            const SizedBox(width: 10,),
                            Text(
                              'Đã xóa khỏi danh sách yêu thích!',
                              style: TextStyle(color: ThemeConfig.lightAccent ),
                            ),
                            
                          ],
                        ),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                            bottom: 20, left: 20, right: 15),
                        padding: const EdgeInsets.all(15),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      
                      ));
                    } else {
                      event.addAudioBookMark();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 2),
                        content:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outlined , color: Colors.green,),
                            Text('Đã thêm vào danh sách yêu thích!' , style: TextStyle(
                              color: ThemeConfig.lightAccent
                            ),),
                            InkWell(
                              onTap: () {
                                 if (context.read<AppProvider>().pageIndex ==
                                    1) {
                                  context
                                      .read<LibraryProvider>()
                                      .setCurrentIndex(2);
                                  Navigator.pop(context);
                                } else {
                                  context
                                      .read<LibraryProvider>()
                                      .setCurrentIndex(2);

                                  context.read<AppProvider>().setPageIndex(1);
                                }
                                
                              },
                              child: Text(
                                'Xem',
                                style:
                                    TextStyle(color: ThemeConfig.fourthAccent),
                              ),
                            ),
                          ],
                        ),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(bottom: 20 , left: 20 , right: 20),
                        padding: const EdgeInsets.all(15),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        
                      ));
                    }
                  },
                  icon: Icon(
                    event.isAudioBookMark ? Icons.favorite : Icons.favorite_border_outlined,
                    color: Colors.white,
                  )),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.ios_share_rounded,
                ),
              ),
            ],
            title: isShowTitle
                ? Text(
                    widget.audioBook.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                : null,
            centerTitle: true,
          ),
          body: Stack(
            children: [
              CustomScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: size.height * 0.65,
                    iconTheme: const IconThemeData(color: Colors.white),
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    pinned: true,
                    bottom: scrollController.hasClients
                        ? PreferredSize(
                            preferredSize: const Size.fromHeight(0),
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                height: 50,
                                width: scrollController.offset <=
                                        size.height * 0.45
                                    ? size.width * 0.8
                                    : size.width,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      ThemeConfig.fourthAccent,
                                      Colors.redAccent
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    var event = context.read<AudioProvider>();
                                    event.createPlayer(widget.audioBook,
                                        AudioPlayer(), context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.headphones , size: 20, color: Colors.white,),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('Nghe ngay',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                )),
                          )
                        : null,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Container(
                        child: Column(

                          children: [
                            Expanded(
                                flex: 3,
                                child: SizedBox(
                                  width: 150,
                                  child: AudioImage(audioBook: widget.audioBook, size: 50 ,))),
                            Expanded(
                               flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, top: 10),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.menu_book_rounded,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'SÁCH NÓI',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, top: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                            widget.audioBook.title,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, top: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Tác giả: ${widget.audioBook.author}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, top: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Thể loại: $genre',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, top: 5),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.headphones,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          widget.audioBook.listen.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: Container(),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              'Giới thiệu nội dung',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeConfig.lightAccent),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.audioBook.description,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // scrollController.hasClients
              //     ? Positioned(
              //         top: size.height * 0.52 - scrollController.offset >= -20
              //             ? size.height * 0.52 - scrollController.offset
              //             : -20,
              //         child: AnimatedContainer(
              //             duration: const Duration(milliseconds: 500),
              //             height: 50,
              //             width: size.height * 0.52 - scrollController.offset >=
              //                     -20
              //                 ? size.width * 0.8
              //                 : size.width,
              //             margin: EdgeInsets.only(
              //                 top: 20,
              //                 left: size.height * 0.52 -
              //                             scrollController.offset >=
              //                         -20
              //                     ? size.height * 0.05
              //                     : 0),
              //             decoration: BoxDecoration(
              //               gradient: LinearGradient(
              //                 begin: Alignment.centerRight,
              //                 end: Alignment.centerLeft,
              //                 colors: [
              //                   ThemeConfig.fourthAccent,
              //                   Colors.redAccent
              //                 ],
              //               ),
              //               borderRadius: BorderRadius.circular(30),
              //             ),
              //             child: GestureDetector(
              //               onTap: () {
              //                 Functions().openEpub(
              //                     Functions().getPath(widget.book),
              //                     context,
              //                     widget.book);
              //               },
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   SvgPicture.asset('assets/icons/people_read.svg',
              //                       color: Colors.white, height: 20),
              //                   const SizedBox(
              //                     width: 10,
              //                   ),
              //                   const Text('Đọc ngay',
              //                       style: TextStyle(
              //                           color: Colors.white,
              //                           fontSize: 18,
              //                           fontWeight: FontWeight.bold)),
              //                 ],
              //               ),
              //             )),
              //       )
              //     : Container()
            ],
          ),
        ),
      );
    });
  }

  void goBookMark() {
    Navigator.push(context,
        PageTransition(type: PageTransitionType.fade, child: const BookMark()));
  }
}
