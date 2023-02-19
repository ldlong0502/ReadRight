

import 'package:ebook/components/side_menu_title.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/util/const.dart';
import 'package:flutter/material.dart';

class SliderMenu extends StatefulWidget {
  const SliderMenu({super.key});

  @override
  State<SliderMenu> createState() => _SliderMenuState();
}

class _SliderMenuState extends State<SliderMenu> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: ThemeConfig.lightAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.menu_book_outlined,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              title: Text(Constants.appName, style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
              
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'A person who won’t read has no advantage over one who can’t read. (Mark Twain)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            
            const SideMenuTitle(),
          ],
        ),
      ),
    );
  }
}