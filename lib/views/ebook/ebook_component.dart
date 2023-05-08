
import 'package:ebook/components/build_body.dart';
import 'package:ebook/models/book.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/util/route.dart';
import 'package:ebook/views/ebook/details_ebook.dart';
import 'package:ebook/views/ebook/ebook_subject.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/cache_image_ebook.dart';
import '../../view_models/home_provider.dart';
import '../home/top5_widget.dart';

class EbookComponent extends StatefulWidget {
  const EbookComponent({super.key});

  @override
  State<EbookComponent> createState() => _EbookComponentState();
}

class _EbookComponentState extends State<EbookComponent> {
  @override
  void initState() {
    super.initState();

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
        primary: false,
        shrinkWrap: true,

        children: <Widget>[
          _buildSectionTitle('Danh mục'),
          const SizedBox(height: 20.0),
          _buildGenre(homeProvider, size),
          const SizedBox(height: 20.0),
          _buildSectionTitle('Top 5 trending'),
          _buildSlider(homeProvider, size),
          const SizedBox(height: 10.0),
          _buildSectionTitle('Mới nhất'),
          const SizedBox(height: 10.0),
          _buildRecentBooks(homeProvider),
          // SizedBox(height: 20.0),
          // _buildRecentBooks('Recently Added'),
        ],
      ),
    );
  }

  _buildSlider(HomeProvider homeProvider, Size size) {
    final list = homeProvider.autoSubject.books;
     final listWidget = List.generate(
        list.length, (index) => _buildBook(list[index] , index),)
      ..add(IconButton(onPressed: () {
          MyRouter.pushAnimation(
              context,
              Top5Widget(
                list: homeProvider.autoSubject.books,
              ));
      }, icon: CircleAvatar(
            backgroundColor: ThemeConfig.fourthAccent,
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
            ))));
    return Container(
      height: 170,
      
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10 ),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: listWidget
      )
              
    );
  }

  _buildSectionTitle(String title) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              color: ThemeConfig.lightAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBook(Book book , int index) {
    return InkWell(
      onTap: (){
        MyRouter.pushAnimation(context, DetailsEbook(book: book));
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only( left: 20.0),
            width: 120,
            child: CacheImageEbook(url: book.image),
          ),
           Positioned(
            bottom: 10,
            left: 30,
            child: CircleAvatar(
              radius: 20,
               backgroundColor: ThemeConfig.fourthAccent,
              child: Text((index + 1).toString(), style:  const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),),
            ) )
        
        ],
      ),
    );
  }
  _buildRecentBooks(HomeProvider homeProvider) {
    return ListView.builder(
      primary: false,
      padding: const EdgeInsets.only(left: 15.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: homeProvider.recent.books.length,
      itemBuilder: (BuildContext context, int index) {
        var book = homeProvider.recent.books[index];

        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            child: GestureDetector(
              onTap: () {
                 MyRouter.pushAnimation(context, DetailsEbook(book: book));
              },
              child: SizedBox(
                height: 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: CacheImageEbook(
                          url: book.image,

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

  _buildGenre(HomeProvider event, Size size) {
    var listGenre = [
      {'name': 'Lịch sử', 'asset': 'assets/images/history.png'},
      {'name': 'Tiên hiệp & Huyền huyễn', 'asset': 'assets/images/fairy.png'},
      {
        'name': 'Sách truyền cảm hứng',
        'asset': 'assets/images/inspiration.png'
      },
      {'name': 'Truyện', 'asset': 'assets/images/story.png'},
      {'name': 'Tài chính', 'asset': 'assets/images/financial.png'}
    ];
    var listGenre1 = [
      {'name': 'Khoa học viễn tưởng', 'asset': 'assets/images/science.png'},
     
       {'name': 'Văn học', 'asset': 'assets/images/literature.png'},
      {'name': 'Dạy làm giàu', 'asset': 'assets/images/rich.png'},
      {'name': 'Nấu ăn', 'asset': 'assets/images/cook.png'},
      {'name': 'Ôn thi THPT', 'asset': 'assets/images/school.png'}
    ];
    return SizedBox(
        height: size.height * 0.12,
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildRowGenre(listGenre, size),
              const SizedBox(
                height: 10,
              ),
              _buildRowGenre(listGenre1, size),
            ],
          ),
        ));
  }

  _buildRowGenre(value, size) {
    return SizedBox(
      height: size.height * 0.05,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: value.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _buildItemGenre(value[index]);
          }),
    );
  }

  _buildItemGenre(value) {
    return InkWell(
      onTap: () {
        MyRouter.pushAnimation(context, EbookSubject(genre: value));
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
          left: 20.0,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                value['asset']!,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                value['name']!,
                style: TextStyle(fontSize: 14, color: ThemeConfig.lightAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}
