import 'package:ebook/view_models/appbar_provider.dart';
import 'package:ebook/view_models/audio_provider.dart';
import 'package:ebook/view_models/details_provider.dart';
import 'package:ebook/view_models/home_provider.dart';
import 'package:ebook/view_models/search_provider.dart';
import 'package:ebook/view_models/speed_provider.dart';
import 'package:ebook/view_models/subject_provider.dart';
import 'package:ebook/views/mainScreen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/theme_config.dart';
import 'util/const.dart';
import 'view_models/app_provider.dart';
import 'view_models/book_mark_provider.dart';
import 'view_models/book_reading_provider.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('bookmark_books');
  await Hive.openBox('book_reading_books');
  await Hive.openBox('audio_books');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => AppBarProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => DetailsProvider()),
        ChangeNotifierProvider(create: (_) => BookMarkProvider()),
        ChangeNotifierProvider(create: (_) => BookReadingProvider()),
        ChangeNotifierProvider(create: (_) => SpeedProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
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
          
          home: const MainScreen(),
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
