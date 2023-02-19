import 'dart:math';

import 'package:ebook/components/build_body.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../components/two_side_rounded_button.dart';
import '../../view_models/home_provider.dart';

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
      (_) => Provider.of<HomeProvider>(context, listen: false).getBooks(),
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
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          _buildSlider(homeProvider, size),
          const SizedBox(height: 20.0),
          _buildSectionTitle('Recently Added'),
          const SizedBox(height: 20.0),
          _buildRecentBooks(homeProvider),
          // SizedBox(height: 20.0),
          // _buildRecentBooks('Recently Added'),
        ],
      ),
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
                      margin: const EdgeInsets.only(top: 10 , left: 20),
                      padding: const EdgeInsets.symmetric(vertical: 5 , horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(e.categories[0], 
                      style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis, color: Colors.black),),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 20),
                      width: 180,
                      child: Text(
                        e.title,
                        maxLines: 2,
                        style:  const TextStyle(fontWeight: FontWeight.bold , fontSize: 20, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 20),
                      width: 180,
                      child: Text(
                        e.authors[0],
                        style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ThemeConfig.lightAccent, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  
                  ],
                ),
              )),
              Positioned(
                right: 0,
                top: 5,
                child: Transform(
                  
                    transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.01)
                    ..rotateY(- 20 * pi/180),
                    alignment: Alignment.center,
                  child: Image.network(
                    e.thumbnailUrl,
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
                    text: "Read",
                    radius: 24,
                    press: () {},
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
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
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
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: SizedBox(
            height: 180, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.network(book.thumbnailUrl, fit: BoxFit.fill,),
                    )),
                    Expanded(flex: 2,child: Column(
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
                          const SizedBox(height: 5,),
                          SizedBox(
                            width: 180,
                            child: Text(
                              book.authors[0],
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
                    ],))
              ],
            ),
            
            )
        );
      },
    );
  }
}
