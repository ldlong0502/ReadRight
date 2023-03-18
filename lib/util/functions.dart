
import 'dart:convert';
import 'dart:io';

import 'package:ebook/theme/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

import '../models/book.dart';
import '../models/book_download.dart';


class Functions {

  final defaultLocation = {
	"bookId": "2239",
	"href": "/OEBPS/ch06.xhtml",
	"created": 1539934158390,
	"locations": {
	"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
	  }
	};
  final hiveBookReading = Hive.box('book_reading_books');
  

  static bool checkConnectionError(e) {
    if (e.toString().contains('SocketException') ||
        e.toString().contains('HandshakeException')) {
      return true;
    } else {
      return false;
    }
  }

  Future<Color> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor!.color;
  }

  void openEpub(filePath , context , Book book) async {
   print(hiveBookReading.get(book.id)) ;
    var data =BookDownLoad.fromJson(hiveBookReading.get(book.id));


    VocsyEpub.setConfig(
      themeColor: ThemeConfig.lightAccent,
      identifier: "iosBook",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: true,
      enableTts: true,
      nightMode:  false,
    );

    // get current locator
    VocsyEpub.locatorStream.listen((locator) {
      print(locator.toString());
      hiveBookReading.put(book.id, {
        'item': book.toJson(),
        'location': locator
      });
    });

    VocsyEpub.open(
      filePath,
      lastLocation: EpubLocator.fromJson(data.location == '' ? defaultLocation : json.decode(data.location)),
    );

  }

  Future<String> getPath(Book book) async {
     Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    return '${appDocDir!.path}/${book.id}.epub';
  }
}
