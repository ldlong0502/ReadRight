import 'package:ebook/util/dialogs.dart';
import 'package:ebook/util/functions.dart';
import 'package:ebook/view_models/details_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart';
import '../../theme/theme_config.dart';

class DetailsBook extends StatefulWidget {
  const DetailsBook({super.key, required this.book});
  final Book book;
  @override
  State<DetailsBook> createState() => _DetailsBookState();
}

class _DetailsBookState extends State<DetailsBook> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<DetailsProvider>(context, listen: false)
            .setBook(widget.book);
        Provider.of<DetailsProvider>(context, listen: false)
            .getInfo(widget.book);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailsProvider>(builder: (context, event, _) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  if (event.isBookMark) {
                    event.removeBookMark();
                    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                      duration: const Duration(seconds: 1),
                        content: const Text('Đã xóa khỏi danh sách yêu thích!' ),
                        action: SnackBarAction(
                          textColor: ThemeConfig.lightAccent,
                          label: 'Xem', onPressed: (){}),));
                  } else {
                    event.addBookMark();
                    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                      duration: const Duration(seconds: 1),
                        content: const Text('Đã thêm vào danh sách yêu thích!'),
                        action: SnackBarAction(
                           textColor: ThemeConfig.lightAccent,
                          label: 'Xem', onPressed: (){}),));
                  }
                },
                icon: Icon(
                  Icons.bookmark_add_rounded,
                  color: event.isBookMark ? ThemeConfig.lightAccent : null,
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
        ),
        floatingActionButton: InkWell(
          onTap: () {
            Dialogs().showEpub(context, widget.book);
          },
          child: Container(
              height: 40,
              width: 100,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color:
                      Functions.isDark(context) ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text('Đọc ngay',
                    style: TextStyle(
                      color: Functions.isDark(context)
                          ? Colors.black
                          : Colors.white,
                    )),
              )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: 250,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(widget.book.image)),
                ),
              ),
            
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Text(
                    widget.book.title,
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
                  widget.book.author,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.lightAccent,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              Container(
                height: 70,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              'Nhà xuất bản',
                              style: TextStyle(
                                fontSize: 15,
                                color: ThemeConfig.authorColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.book.publisher,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Text(
                              'Trang',
                              style: TextStyle(
                                fontSize: 15,
                                color: ThemeConfig.authorColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.book.pages.toString(),
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              'Lượt xem',
                              style: TextStyle(
                                fontSize: 15,
                                color: ThemeConfig.authorColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.book.view.toString(),
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              'Năm',
                              style: TextStyle(
                                fontSize: 15,
                                color: ThemeConfig.authorColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.book.year.toString(),
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                      widget.book.description,
                      style: const TextStyle(fontSize: 15),
                    )),
              ),
            ]),
      );
    });
  }
}
