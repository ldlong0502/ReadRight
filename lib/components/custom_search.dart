import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/util/api.dart';
import 'package:ebook/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../models/book.dart';
import '../views/ebook/details_ebook.dart';

class CustomSearch extends SearchDelegate {
  BooksApi api = BooksApi();
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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var url = '${api.bookUrlKey}?q=$query';
    return Container(
      color: Colors.transparent,
      child: FutureBuilder<List<Book>?>(
        future: api.getFilterBooks(url),
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
            onTap: ()  { 
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: DetailsEbook(
                        book: result,

                      )));
            },
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        result.image != '' ? NetworkImage(result.image) : null,
                  ),
                  title: Text(result.title),
                  subtitle: Text(result.author),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                ),
                Divider(color: ThemeConfig.authorColor, indent: 20)
              ],
            ),
          );
        });
  }
}
