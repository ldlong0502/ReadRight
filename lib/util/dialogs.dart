import 'dart:io';

import 'package:ebook/components/download_alert.dart';
import 'package:ebook/util/enum.dart';
import 'package:ebook/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/custom_alert.dart';
import '../models/book.dart';
import '../view_models/subject_provider.dart';
import 'const.dart';

class Dialogs {
  showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomAlert(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 15.0),
              Text(
                Constants.appName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 25.0),
              const Text(
                'Are you sure you want to quit?',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                    width: 130.0,
                    child: TextButton(
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                    width: 130.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => exit(0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  showSetUpBottomDialog(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: 400,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                color: Functions.isDark(context) ? Colors.black : Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                _buildTitle(context),
                const SizedBox(
                  height: 10,
                ),
                _buildText('Hiển thị'),
                _buildDisplay(context),
                _buildText('Sắp xếp'),
                _buildSort(context),
              ],
            ),
          );
        });
  }

  _buildTitle(context) {
    return SizedBox(
      height: 50,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: Container(),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Thiết lập',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.clear_outlined),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ]),
    );
  }

  _buildDisplay(BuildContext context) {
    var listDisplay = [
      {
        'icon': const Icon(Icons.grid_view),
        'title': 'Lưới',
        'value': EnumDisplay.grid,
        'text': 'grid'
      },
      {
        'icon': const Icon(Icons.list_rounded),
        'title': 'Danh sách',
        'value': EnumDisplay.list,
        'text': 'list'
      }
    ];
    return Consumer<SubjectProvider>(
      builder: (context, event, _) {
        return SizedBox(
          height: 110,
          child: ListView.builder(
              itemCount: listDisplay.length,
              itemBuilder: (ctx, index) => ListTile(
                    onTap: () {
                      if (listDisplay[index]['value'] == event.display) {
                        Navigator.pop(context);
                        return;
                      }
                      Provider.of<SubjectProvider>(context, listen: false).setDisplay(
                          listDisplay[index]['value'],
                          listDisplay[index]['text']);
                      Navigator.pop(context);
                    },
                    leading: listDisplay[index]['icon'] as Icon,
                    title: Text(listDisplay[index]['title'] as String),
                    trailing: event.display ==
                            (listDisplay[index]['value'] as EnumDisplay)
                        ? const Icon(Icons.check)
                        : null,
                  )),
        );
      },
    );
  }

  _buildSort(BuildContext context) {
    var listSort = [
      {'title': 'Mới nhất', 'value': EnumSort.latest, 'text': 'latest'},
      {'title': 'Nổi bật', 'value': EnumSort.outstanding, 'text': 'outstanding'}
    ];
    return Consumer<SubjectProvider>(
      builder: (context, event, _) {
        return SizedBox(
          height: 110,
          child: ListView.builder(
              itemCount: listSort.length,
              itemBuilder: (ctx, index) => ListTile(
                  onTap: () {
                    if (listSort[index]['value'] == event.sort) {
                      Navigator.pop(context);
                      return;
                    }
                    Provider.of<SubjectProvider>(context, listen: false).setSort(
                        listSort[index]['value'], listSort[index]['text']);
                    Navigator.pop(context);
                  },
                  title: Text(listSort[index]['title'] as String),
                  trailing: event.sort == (listSort[index]['value'] as EnumSort)
                      ? const Icon(Icons.check)
                      : null)),
        );
      },
    );
  }

  _buildText(String s) {
    return SizedBox(
      height: 50,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            s,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Divider(
          indent: 10,
          endIndent: 10,
          thickness: 1,
        )
      ]),
    );
  }

  showEpub(context , Book book){
    if(book.epub == ''){
      print('sorry');
      return;
    }
    showDialog(context: context, builder: (context) => DownloadAlert(book: book,));
  }
}
