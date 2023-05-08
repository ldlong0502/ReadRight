import 'dart:io';

import 'package:ebook/view_models/appbar_provider.dart';
import 'package:ebook/view_models/audio_provider.dart';
import 'package:ebook/view_models/details_audioBook_provider.dart';
import 'package:ebook/view_models/details_ebook_provider.dart';
import 'package:ebook/view_models/history_provider.dart';
import 'package:ebook/view_models/home_provider.dart';
import 'package:ebook/view_models/library_provider.dart';
import 'package:ebook/view_models/search_provider.dart';
import 'package:ebook/view_models/speed_provider.dart';
import 'package:ebook/view_models/subject_provider.dart';
import 'package:ebook/views/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/theme_config.dart';
import 'util/const.dart';
import 'view_models/app_provider.dart';
import 'view_models/book_mark_provider.dart';
import 'view_models/book_history_provider.dart';
class PostHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() async {
  HttpOverrides.global =  PostHttpOverrides();
  await Hive.initFlutter();
  await Hive.openBox('bookmark_books');
  await Hive.openBox('bookmark_audioBooks');
  await Hive.openBox('book_reading_books');
  await Hive.openBox('audio_books');
  await Hive.openBox('genre');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()..checkWelcome()),
        ChangeNotifierProvider(create: (_) => AppBarProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()..getBooks()),
        ChangeNotifierProvider(create: (_) => DetailsEbookProvider()),
        ChangeNotifierProvider(create: (_) => DetailsAudioBookProvider()),
        ChangeNotifierProvider(create: (_) => BookMarkProvider()),
        ChangeNotifierProvider(create: (_) => BookHistoryProvider()),
         ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => SpeedProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()..getBooks()),
          ChangeNotifierProvider(create: (_) => LibraryProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => SubjectProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget? child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.appName,
          theme: themeData(appProvider.theme),
          
          home: const SplashScreen(),
        );
      },
    );
  }
  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(
        theme.textTheme,
        
      ),
      colorScheme: theme.colorScheme.copyWith(
        secondary: ThemeConfig.lightAccent,
      ),
      
    );
  }
}
