import 'package:ebook/views/bookmark/book_mark.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../theme/theme_config.dart';
import '../view_models/app_provider.dart';

class SideMenuTitle extends StatefulWidget {
  const SideMenuTitle({super.key, required this.context});
  final BuildContext context;
  @override
  State<SideMenuTitle> createState() => _SideMenuTitleState();
}

class _SideMenuTitleState extends State<SideMenuTitle> {
  var itemsBrowse = [];
  var itemsAbout = [];
  @override
  void initState() {
    super.initState();
    itemsBrowse = [
      {
        'icon': Icons.invert_colors_on_rounded,
        'title': 'Chế độ',
        'function': () {},
      },
      {
        'icon': Icons.favorite,
        'title': 'Ưa thích',
        'function': () {
          goBookMark();
        },
      },
      {
        'icon': Icons.feedback,
        'title': 'Phản hồi với chúng tôi',
        'function': () {},
      },
    ];
    itemsAbout = [
       {
        'icon': Icons.info,
        'title': 'Thông tin',
        'function': () {},
      },
      {
        'icon': Icons.policy,
        'title': 'Chính sách',
        'function': () {},
      },
    ];
  }
  

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      itemsBrowse.removeWhere((item) => item['title'] == 'Dark');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'TIỆN ÍCH',
            style: TextStyle(
              color: ThemeConfig.secondBackground,
              fontSize: 20,
            ),
          ),
        ),
        _buildBrowse(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'VỀ CHÚNG TÔI',
            style: TextStyle(
              color: ThemeConfig.secondBackground,
              fontSize: 20,
            ),
          ),
        ),
        _buildAbout()
      ],
    );
  }

  _buildBrowse() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemsBrowse.length,
      itemBuilder: (BuildContext context, int index) {
       

        return ListTile(
          onTap: itemsBrowse[index]['function'] as Function(),
          leading: Icon(
            itemsBrowse[index]['icon'] as IconData,
            color: Colors.white,
          ),
          title: Text(
            itemsBrowse[index]['title'] as String,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.white54,
        );
      },
    );
  }

  
  _buildAbout() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemsAbout.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: itemsAbout[index]['function'] as Function(),
          leading: Icon(
            itemsAbout[index]['icon'] as IconData,
            color: Colors.white,
          ),
          title: Text(
            itemsAbout[index]['title'] as String,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.white,
          height: 1,
          thickness: 1,
        );
      },
    );
  }

  void goBookMark() {
    Navigator.push(
        widget.context,
        PageTransition(
            type: PageTransitionType.rightToLeft, child: BookMark()));
  }
}
