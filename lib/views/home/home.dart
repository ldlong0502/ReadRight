import 'dart:math';

import 'package:ebook/components/build_body.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../components/audio_image.dart';
import '../../components/cache_image_ebook.dart';
import '../../components/two_side_rounded_button.dart';
import '../../models/audio_book.dart';
import '../../models/book.dart';
import '../../util/dialogs.dart';
import '../../util/route.dart';
import '../../view_models/audio_provider.dart';
import '../../view_models/home_provider.dart';
import '../audio_books/detail_audio_book.dart';
import '../ebook/details_ebook.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
     SchedulerBinding.instance.addPostFrameCallback(
      (_) => Provider.of<AudioProvider>(context, listen: false).getBooks(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<HomeProvider>(builder:
        (BuildContext context, HomeProvider homeProvider, Widget? child) {
      return BuildBody(
          apiRequestStatus: homeProvider.apiRequestStatus,
          child: _buildBodyList(homeProvider, size),
          reload: () => homeProvider.getBooks());
    });
  }

  _buildBodyList(HomeProvider homeProvider, Size size) {
    return RefreshIndicator(
      onRefresh: () => homeProvider.getBooks(),
      child: Consumer<AudioProvider>(
        builder: (context, event, _) {
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              const SizedBox(height: 10.0),
              _buildSectionTitle('Top thịnh hành '),
              _buildBodyGrid(homeProvider, size),
              const SizedBox(height: 20.0),
              _buildSectionTitle('Những cuốn sách hay bạn nên nghe'),
              const SizedBox(height: 10.0),
              _buildAudioBookSlider(event),
              const SizedBox(height: 20.0),
              _buildSectionTitle('Những cuốn sách hay bạn nên đọc'),
              const SizedBox(height: 10.0),
              _buildEbookSlider(homeProvider),
               const SizedBox(height: 20.0),
              _buildSectionTitle('Dựa trên sở thích của bạn'),
               const SizedBox(height: 10.0),
              _buildEbookSlider(homeProvider),
              // SizedBox(height: 20.0),
              // _buildRecentBooks('Recently Added'),
            ],
          );
        }
      ),
    );
  }
  Widget _buildAudioBook( AudioBook book, int index) {
    return InkWell(
      onTap: () async {
        MyRouter.pushAnimation(context, DetailsAudioBook(audioBook: book));
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SizedBox(
              width: 120,
              child: AudioImage(
                audioBook: book,
                size: 50,
              ),
            ),
          ),
         
        ],
      ),
    );
  }
  _buildAudioBookSlider(AudioProvider event) {
    final list = event.top5;
    final listWidget = List.generate(
      list.length,
      (index) => _buildAudioBook(list[index], index),
    )..add(IconButton(
        onPressed: () {
         
        },
        icon: const CircleAvatar(
            backgroundColor: Colors.amber,
            child: Icon(Icons.arrow_forward_rounded , color: Colors.white,))));
    return Container(
        height: 170,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: listWidget));
  }
  Widget _buildEbook(Book book, int index) {
    return InkWell(
      onTap: () {
        MyRouter.pushAnimation(context, DetailsEbook(book: book));
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  book.image,
                  fit: BoxFit.cover,
                  width: 120,
                )),
          ),
         
        ],
      ),
    );
  }
  _buildEbookSlider(HomeProvider homeProvider) {
    final list = homeProvider.autoSubject.books;
    final listWidget = List.generate(
      list.length,
      (index) => _buildEbook(list[index], index),
    )..add(IconButton(
        onPressed: () {},
        icon: const CircleAvatar(
            backgroundColor: Colors.amber,
            child: Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
            ))));
    return Container(
        height: 170,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: listWidget));
  }
  _buildBodyGrid(HomeProvider event, size) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: event.autoSubject.books.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            mainAxisExtent: 200,
          ),
          itemBuilder: (context, index) {
          
            var item =  event.autoSubject.books[index];
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
                        width: 120,
                        height: 140,
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
  _buildSlider(HomeProvider homeProvider, Size size) {
    final list = homeProvider.autoSubject.books;
    return Container(
      height: 220,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
        ),
        items: list.map((e) {
          return Stack(
            children: [
              Positioned(
                  child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: DetailsEbook(
                            book: e,
                          ))).then((value) => setState(() {}));
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ThemeConfig.lightAccent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 150),
                        margin: const EdgeInsets.only(top: 10, left: 20),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          e.genre.join(', '),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 20),
                        width: 180,
                        child: Text(
                          e.title,
                          maxLines: 2,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 20),
                        width: 180,
                        child: Text(
                          e.author,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: ThemeConfig.lightAccent,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              Positioned(
                right: 0,
                top: 5,
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.01)
                    ..rotateY(-20 * pi / 180),
                  alignment: Alignment.center,
                  child: Image.network(
                    e.image,
                    height: 120,
                    width: size.width * .32,
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                right: 0,
                child: SizedBox(
                  height: 40,
                  width: size.width * .3,
                  child: TwoSideRoundedButton(
                    text: "Đọc",
                    radius: 24,
                    press: () {
                      Dialogs().showEpub(context, e);
                    },
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style:  TextStyle(
              fontSize: 18.0,
              color: ThemeConfig.lightAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _buildRecentBooks(HomeProvider homeProvider) {
    return ListView.builder(
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: homeProvider.recent.books.length,
      itemBuilder: (BuildContext context, int index) {
        var book = homeProvider.recent.books[index];

        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: DetailsEbook(
                          book: book,
                        )));
              },
              child: SizedBox(
                height: 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: Image.network(
                            book.image,
                            fit: BoxFit.fill,
                          ),
                        )),
                    Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 180,
                              child: Text(
                                book.title,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: 180,
                              child: Text(
                                book.author,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: ThemeConfig.lightAccent,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: 180,
                              child: Text(
                                book.description,
                                maxLines: 3,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: ThemeConfig.authorColor,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ));
      },
    );
  }

  
}
