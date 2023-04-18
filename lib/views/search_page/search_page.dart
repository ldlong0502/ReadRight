import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/view_models/search_provider.dart';
import 'package:ebook/views/search_page/search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../util/const.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  var listMenu = [
    {
      'title': 'Tất cả',
      'image': 'assets/images/all.png',
    },
    {
      'title': 'Sách nói',
      'image': 'assets/images/audio_book.png',
    },
    {
      'title': 'Ebook',
      'image': 'assets/images/ebook.png'
    }
  ];
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<SearchProvider>(context, listen: false).setCurrentIndex(0);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<SearchProvider>(
        builder: (context, event , _) {
        return Container(
          decoration: Constants.linearDecoration,
          child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                toolbarHeight: 70,
                title: _buildSearch(event),
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
                          children: listMenu.asMap().entries.map((e) => InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                             if (event.currentIndex == e.key) return;
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
                                    backgroundColor: e.key == event.currentIndex ?  Colors.white : Colors.grey,
                                    
                                    child: Image.asset(e.value['image'] as String , fit: BoxFit.cover,height: 40),
                                  ),
                                  const SizedBox(height: 10,),
                                  Text((e.value['title'] as String).toUpperCase() , style: TextStyle(
                                    color: e.key == event.currentIndex
                                                  ? Colors.white
                                                  : Colors.grey[400],
                                    fontSize: 14
                                  ),)
                                ],
                              ),
                            ),
                          )).toList(),
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
                        child: SearchResult(index: event.currentIndex ),
                      ),
                    )
                ],
              )),
        );
      }
    );
  }

  _buildSearch(SearchProvider event) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
                color: ThemeConfig.lightSecond.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10)),
            height: 50,
            child:  TextField(
              autofocus: true,
              controller: controller,
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm tác giả, tên sách...',
                prefixIconColor: Colors.white,
                
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value)  {
                event.searchBook(controller.text);
              },
            ),
          ),
        ),
         Expanded(
          child: InkWell(
            onTap: () {
              
              Navigator.pop(context);
            },
            child: const Center(
              child: Text('Hủy', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),)),
          ))
      ],
    );
  }
  
}
