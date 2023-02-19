import 'package:ebook/view_models/appbar_provider.dart';
import 'package:ebook/view_models/home_provider.dart';
import 'package:ebook/view_models/subject_provider.dart';
import 'package:ebook/views/mainScreen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/theme_config.dart';
import 'util/const.dart';
import 'view_models/app_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => AppBarProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
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
          darkTheme: themeData(ThemeConfig.darkTheme),
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
