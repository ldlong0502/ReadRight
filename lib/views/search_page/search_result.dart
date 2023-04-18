import 'package:ebook/components/audio_image.dart';
import 'package:ebook/components/build_body.dart';
import 'package:ebook/util/route.dart';
import 'package:ebook/view_models/search_provider.dart';
import 'package:ebook/views/audio_books/detail_audio_book.dart';
import 'package:ebook/views/ebook/details_ebook.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_config.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key, required this.index});
  final int index;
  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) =>
        Provider.of<SearchProvider>(context, listen: false)
            .searchBook(''));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<SearchProvider>(
        builder: (BuildContext context, SearchProvider event, Widget? child) {
      return BuildBody(
          apiRequestStatus: event.apiRequestStatus,
          child: _buildBodyList(event, size),
          reload: () => event.searchBook(event.query));
    });
  }

  _buildBodyList(SearchProvider event, Size size) {
    if (widget.index == 0) {
      return _buildAllResult(event);
    }
    else if (widget.index == 1) {
      return _buildAudioBookResult(event);
    }
    else {
      return _buildEbookResult(event);
    }
    
  }

  _buildAllResult(SearchProvider event) {
    if (event.query.isEmpty || event.query == '') {
      return _buildAllRecommend(event);
    }
    else{
      if(event.listAudioBooks.isEmpty && event.listBooks.isEmpty){
        return _buildEmpty(event.query);
      }
      else {
         return _buildAllSearch(event);
      }
    }
  }
  _buildAudioBookResult(SearchProvider event) {
    if (event.query.isEmpty || event.query == '') {
      return RefreshIndicator(
        onRefresh: () => event.searchBook(event.query),
        child: ListView(
          primary: false,
          shrinkWrap: true,
          children:  <Widget>[
          const SizedBox(height: 10,),
          _buildTitle('Đề xuất cho bạn'),
          _buildAudioBook(event),
          ],
        ),
      );
    }
    else{
      if(event.listAudioBooks.isEmpty) {
        return _buildEmpty(event.query);
      }
      else {
        String text = '(${event.listAudioBooks.length}) kết quả được tìm thấy \nvới từ khóa "${event.query}"';
        return RefreshIndicator(
          onRefresh: () => event.searchBook(event.query),
          child: ListView(
            primary: false,
            shrinkWrap: true,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              _buildTitle(text),
              _buildAudioBook(event),
            ],
          ),
        );
      }
    }
  }

  _buildEbookResult(SearchProvider event) {
    if (event.query.isEmpty || event.query == '') {
      return RefreshIndicator(
        onRefresh: () => event.searchBook(event.query),
        child: ListView(
          primary: false,
          shrinkWrap: true,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            _buildTitle('Đề xuất cho bạn'),
            _buildEbook(event),
          ],
        ),
      );
      
    }
    else {
      if (event.listBooks.isEmpty) {
        return _buildEmpty(event.query);
      } else {
        String text =
            '(${event.listBooks.length}) kết quả được tìm thấy \nvới từ khóa "${event.query}"';
        return RefreshIndicator(
          onRefresh: () => event.searchBook(event.query),
          child: ListView(
            primary: false,
            shrinkWrap: true,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              _buildTitle(text),
              _buildEbook(event),
            ],
          ),
        );
      }
    }
  }
  _buildAllRecommend(SearchProvider event) {
    return RefreshIndicator(
      onRefresh: () => event.searchBook(event.query),
      child: ListView(
        primary: false,
        shrinkWrap: true,
        children:  <Widget>[
          const SizedBox(height: 10,),
          _buildTitle('Đề xuất cho bạn'),
          const SizedBox(
            height: 20,
          ),
          _buildTitle('Sách nói'),
          _buildAudioBook(event),
          const SizedBox(
            height: 20,
          ),
          _buildTitle('Ebook'),
          _buildEbook(event),
        ],
      ),
    );
  }
  _buildAllSearch(SearchProvider event) {
    return RefreshIndicator(
      onRefresh: () => event.searchBook(event.query),
      child: ListView(
        primary: false,
        shrinkWrap: true,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            _buildTitle('Sách nói'),
            _buildAmount(event, 1 , event.listAudioBooks.length),
          ],),
          _buildAudioBook(event),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTitle('Ebook'),
              _buildAmount(event , 2 , event.listBooks.length),
            ],
          ),
          _buildEbook(event),
        ],
      ),
    );
  }
  
  _buildTitle(String title ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        title,
        maxLines: 2,
        style: TextStyle(
          fontSize: 18.0,
          
          color: ThemeConfig.lightAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  _buildAudioBook(SearchProvider event) {
    return ListView.builder(
            shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      itemCount: event.listAudioBooks.length,
      itemBuilder: (context , index) {
      var item = event.listAudioBooks[index];
      return InkWell(
        onTap: () {
              MyRouter.pushAnimation(context, DetailsAudioBook(audioBook: item));
            },
        child: ListTile(
          leading: AudioImage(audioBook: item , size: 25, ),
          title: Text(item.title , style: const TextStyle(
            fontWeight: FontWeight.bold
          ),),
          subtitle: Text(item.author),
          visualDensity:  const VisualDensity(vertical: 4),
        ),
      );
    });
  }
  _buildEbook(SearchProvider event) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: event.listBooks.length,
        itemBuilder: (context, index) {
          var item = event.listBooks[index];
          return InkWell(
            onTap: () {
              MyRouter.pushAnimation(context, DetailsEbook(book: item));
            },
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(item.image,fit: BoxFit.fill,width: 60,)),
              title: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item.author),
              visualDensity: const VisualDensity(vertical: 4),
            ),
          );
        });
        
  }
  
  _buildEmpty(String query) {
    String text1 = 'Không tìm thấy kết quả với từ khóa';
    String text2 = '"$query"';
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/images/sorry.png' ,height: 100,),
        const SizedBox(height: 10,),
        _buildTitle(text1),
        _buildTitle(text2),
      ],
    );
  }
  
  _buildAmount(SearchProvider event, int index, int length ) {
    return InkWell(
      onTap: (){
        event.setCurrentIndex(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          'Xem kết quả ($length)',
          style: TextStyle(
            fontSize: 18.0,
            color: ThemeConfig.fourthAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
