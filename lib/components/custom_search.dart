import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/util/api.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';

class CustomSearch extends SearchDelegate {
  List allBook = ['Tôi ngu', 'Naruto', 'Doraemon'];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {

    List<String> matchQuery = [];
    for(var item in allBook){
      if(item.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context , index){
        var result =  matchQuery[index];
         return InkWell(
            onTap: () {},
            child: ListTile(
              title: Text(result),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
          );
      });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in allBook) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return Container(
      color: Colors.transparent,
      child: FutureBuilder<List<Book>?>(
        future: BooksApi().getBooks('https://www.googleapis.com/books/v1/volumes?q=$query'),
        builder: (context, snapshot) {
          if (query.isEmpty) return buildNoSuggestions();

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError || snapshot.data!.isEmpty) {
                return buildNoSuggestions();
              } else {
                return buildSuggestionsSuccess(snapshot.data);
              }
          }
        },
      ),
    );
  }
  
  Widget buildNoSuggestions() {
    return Container();
  }
  
  Widget buildSuggestionsSuccess(List<Book>? data) {
    return ListView.builder(
        itemCount: data!.length,
        itemBuilder: (context, index) {
          var result = data[index];
          return InkWell(
            onTap: () {},
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: result.thumbnailUrl != '' ? NetworkImage(result.thumbnailUrl) : null,
                  ),
                  title: Text(result.title),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                ),
                Divider(color: ThemeConfig.authorColor, indent: 20)
              ],
            ),
          );
        });
  }
}
