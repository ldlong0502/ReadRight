import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebook/util/functions.dart';
import 'package:ebook/view_models/book_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../models/book.dart';
import '../../theme/theme_config.dart';
import '../../util/enum.dart';
import '../ebook/details_ebook.dart';
import '../mainScreen/main_screen.dart';

class Reading extends StatefulWidget {
  const Reading({super.key});

  @override
  State<Reading> createState() => _ReadingState();
}

class _ReadingState extends State<Reading> {
  final quotationsList = [
    {
      'index': 1,
      'des':
          'Một cuốn sách hay cho ta một điều tốt, một người bạn tốt cho ta một điều hay.',
      'author': 'Gustavơ Lebon',
    },
    {
      'index': 2,
      'des':
          'Sách là nguồn của cải quý báu của thế giới và là di sản xứng đáng của các thế hệ và các quốc gia',
      'author': 'Henry David Thoreau',
    },
    {
      'index': 3,
      'des': 'Đọc sách có thể không giàu, nhưng không đọc, chắc chắn nghèo. ',
      'author': 'Sưu tầm',
    },
    {
      'index': 4,
      'des':
          'Nếu tôi có quyền thế, tôi sẽ đem sách mà gieo rắc khắp mặt địa cầu như người ta gieo lúa trong luống cày vậy',
      'author': 'Mann Horace',
    },
    {
      'index': 5,
      'des':
          'Chính nhờ sách mà những người khôn ngoan tìm được sự an ủi khỏi những rắc rối của cuộc đời. ',
      'author': 'Victor Hugo',
    },
  ];
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<BookHistoryProvider>(context, listen: false).getInfo();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookHistoryProvider>(
        builder: (context, event, _) => Scaffold(
            appBar: AppBar(
              title: const Padding(
                padding: EdgeInsets.only(left: 0.0),
                child: Center(child: Text('Thư viện')),
              ),
            ),
            body: event.bookReadingList.isEmpty
                ? _buildEmptyList()
                : _buildBodyList(event)));
  }

  _buildEmptyList() {
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
                  'Danh sách trống! Bạn hãy thêm sách vào nhé.',
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
          TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(ThemeConfig.lightAccent)),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                    (route) => false);
              },
              child: const Text(
                'Chọn sách',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
        ],
      ),
    );
  }

  _buildBodyList(BookHistoryProvider event) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        _buildRecentlyBook(event),
        _buildQuotations(),
        event.bookReadingList.length == 1
            ? Container()
            : const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Gần đây đã đọc',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
        event.bookReadingList.length == 1 ? Container() : _buildMoreBook(event)
      ],
    );
  }

  _buildRecentlyBook(BookHistoryProvider event) {
    var item = event.bookReadingList[0];
    return InkWell(
      onTap: () async {
        var url = await Functions().getPath(item);
        if(!mounted) return;
        Functions().openEpub( url, context , item);
      },
      child: SizedBox(
        height: 300,
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                height: 220,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(item.image)),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Center(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          item.author,
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
                Expanded(flex: 1, child: _buildPopUpMenu(event, item))
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildQuotations() {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
            top: BorderSide(color: Colors.grey),
            bottom: BorderSide(color: Colors.grey)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          autoPlayInterval: const Duration(seconds: 20),
        ),
        items: quotationsList.map((e) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  e['des'] as String,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(e['author'] as String,
                    style: TextStyle(
                        fontSize: 16, color: ThemeConfig.lightAccent)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  _buildMoreBook(BookHistoryProvider event) {
    var list = [...event.bookReadingList];
    list.removeAt(0);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: list.map((item) {
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
          child: Slidable(
            key: ValueKey<Book>(item),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  flex: 1,
                  onPressed: (_) {
                    event.removeBook(item);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                ),
              ],
            ),
            child: Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                  color: Colors.grey,
                )),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item.image,
                      fit: BoxFit.fill,
                      width: 70,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: SizedBox(
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              child: Text(
                                item.title,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                              ),
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
                          Container(
                            height: 30,
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.menu_book),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(item.pages.toString())
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Icon(Icons.remove_red_eye),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(item.view.toString())
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Icon(Icons.calendar_month),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(item.year.toString())
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  _buildPopUpMenu(BookHistoryProvider event , Book item) {
    return PopupMenuButton<ActionBook>(
        onSelected: (ActionBook value) {
          setState(() {
            if (value == ActionBook.details) {
               Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: DetailsEbook(
                        book: item,
                      )));
            } else {
              event.removeBook(item);
            }
          });
        },
        icon: const Icon(Icons.more_vert),
        itemBuilder: (_) => [
              const PopupMenuItem(
                value: ActionBook.details,
                child: Text('Xem chi tiết'),
              ),
              const PopupMenuItem(
                value: ActionBook.delete,
                child: Text('Xóa khỏi danh sách'),
              )
            ]);
  }
}
