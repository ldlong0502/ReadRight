

import 'package:ebook/models/book.dart';
import 'package:ebook/view_models/book_mark_provider.dart';
import 'package:ebook/views/mainScreen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../theme/theme_config.dart';
import '../ebook/details_ebook.dart';

class BookMark extends StatefulWidget {
  const BookMark({super.key});

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {

   @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<BookMarkProvider>(context, listen: false)
            .getInfo();
        
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<BookMarkProvider>(
      builder: (context , event , _) => Scaffold(
        appBar: AppBar(
          title: const Text('Danh sách yêu thích'),
        ),
        body: event.bookMarkList.isEmpty ? _buildEmptyList() : _buildBodyList(event)
      ));
  }
  
  _buildBodyList(BookMarkProvider event) {
    return RefreshIndicator(
      onRefresh: () => event.getInfo(),
      child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: event.bookMarkList.length,           
              itemBuilder: (context, index) {             
                var item = event.bookMarkList[index];             
                return InkWell(
                  onTap: () async {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: DetailsEbook(book: item,)));
                  },
                  child: Slidable(
                    key: ValueKey<Book>(item),
                    endActionPane:  ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      // An action can be bigger than the others.
                      flex: 1,
                      onPressed: (_){
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
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration:  const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                          )
                        ),
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
                                      children:  [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children:   [
                                          const Icon(Icons.menu_book),
                                          const SizedBox(
                                              width: 5,
                                            ),
                                          Text(item.pages.toString())
                                        ],),
                                        const SizedBox(width: 15,),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children:  [
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
                                          children:  [
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
              }),
    );
  }
  
  _buildEmptyList() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Center(
             child: Container(
              width: MediaQuery.of(context).size.width *0.7,
              alignment: Alignment.center,
              child: const Text('Danh sách trống! Bạn hãy thêm sách yêu thích vào nhé.',
              maxLines: 2,
               style: TextStyle(
                fontSize: 20
              ),)),
           ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text('^_^',
              style: TextStyle(fontSize: 20),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(ThemeConfig.lightAccent)
            ),
            onPressed: (){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false);
            }, child: const Text('Chọn sách', style: TextStyle(
              fontSize: 20,
              color: Colors.white
            ),)),
        ],
      ),
    );
  }
}