import 'package:ebook/view_models/library_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/const.dart';
import 'library_result.dart';

class BookLibrary extends StatefulWidget {
  const BookLibrary({super.key});

  @override
  State<BookLibrary> createState() => _BookLibraryState();
}

class _BookLibraryState extends State<BookLibrary> {
  TextEditingController controller = TextEditingController();
  int currentIndex = 0;
  var listMenu = [
    {
      'title': 'Tất cả',
      'image': 'assets/images/all.png',
    },
    {
      'title': 'Đã tải',
      'image': 'assets/images/download.png',
    },
    {
      'title': 'Yêu thích', 
      'image': 'assets/images/love.png'
    }
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<LibraryProvider>(
      builder: (context, event ,_) {
        return Container(
          decoration: Constants.linearDecoration,
          child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                toolbarHeight: 70,
                title: const Text("Thư viện" , style: TextStyle(
                  color: Colors.white,
                  
                ),),
              ),
              body: Stack(
                children: [
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: size.height * 0.15,
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: listMenu
                              .asMap()
                              .entries
                              .map((e) => InkWell(
                                    
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                     event.setCurrentIndex(e.key);
                                    },
                                    child: Container(
                                      width: 100,
                                      color: Colors.transparent,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor: e.key == event.currentIndex
                                                ? Colors.white
                                                : Colors.grey,
                                            child: Image.asset(
                                                e.value['image'] as String,
                                                fit: BoxFit.cover,
                                                height: 40),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            (e.value['title'] as String)
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: e.key == event.currentIndex
                                                    ? Colors.white
                                                    : Colors.grey[400],
                                                fontSize: 14),
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      )),
                  Positioned(
                    top: size.height * 0.15,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: LibraryResult(index: event.currentIndex )),
                    ),
                  
                ],
              )),
        );
      }
    );
  }

  
}

  