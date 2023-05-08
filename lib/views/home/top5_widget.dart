import 'package:ebook/models/audio_book.dart';
import 'package:ebook/views/audio_books/detail_audio_book.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../components/audio_image.dart';
import '../../components/cache_image_ebook.dart';
import '../../models/book.dart';
import '../../theme/theme_config.dart';
import '../ebook/details_ebook.dart';

class Top5Widget extends StatefulWidget {
  const Top5Widget({super.key, required this.list});
  final List<dynamic> list;
  @override
  State<Top5Widget> createState() => _Top5WidgetState();
}

class _Top5WidgetState extends State<Top5Widget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return widget.list.isEmpty
        ? _buildEmpty()
        : _buildTop5();
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



  _buildTop5() {
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
                              'Top trending',
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
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              // child:  Column(
              //   children: [
              //

              //   ],
              // ),
              child: widget.list is List<Book> ? _buildListBook() : _buildListAudioBook(),
            ),
          ),
        ],
      ),
    );
  }
  
  _buildListAudioBook() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: widget.list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            mainAxisExtent: 300,
          ),
          itemBuilder: (context, index) {
           
            var item =  widget.list[index] as AudioBook;
            return InkWell(
              onTap: () async {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: DetailsAudioBook(
                          audioBook: item,
                        )));
              },
              child: Container(
                margin: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 200,
                        height: 230,
                        child: AudioImage(audioBook: item ,size: 50,)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        item.title,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Text(
                      item.author,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: ThemeConfig.lightAccent,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            );
          }),
    );

  }
  
  _buildListBook() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: widget.list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            mainAxisExtent: 300,
          ),
          itemBuilder: (context, index) {
           
            var item =  widget.list[index] as Book;
            return InkWell(
              onTap: () async {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: DetailsEbook(
                          book: item,
                        )));
              },
              child: Container(
                margin: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 200,
                        height: 230,
                        child: CacheImageEbook(url: item.image)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        item.title,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Text(
                      item.author,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: ThemeConfig.lightAccent,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
