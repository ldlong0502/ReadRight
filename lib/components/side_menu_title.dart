import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_config.dart';
import '../view_models/app_provider.dart';


class SideMenuTitle extends StatefulWidget {
  const SideMenuTitle({super.key});

  @override
  State<SideMenuTitle> createState() => _SideMenuTitleState();
}

class _SideMenuTitleState extends State<SideMenuTitle> {
  final itemsBrowse = [
      {
        'icon': Icons.invert_colors_on_rounded,
        'title': 'Mode',
        'function': () {},
      },
      {
        'icon': Icons.download,
        'title': 'Downloads',
        'function': () {},
      },
      {
        'icon': Icons.feedback,
        'title': 'Feedback',
        'function': () {},
      },  
    ];
final itemsAbout = [
    {
      'icon': Icons.info,
      'title': 'Info',
      'function': () {},
    },
    {
      'icon': Icons.policy,
      'title': 'Policy',
      'function': () {},
    }, 
  ];
  @override
  Widget build(BuildContext context) {
    //  if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
    //   itemsBrowse.removeWhere((item) => item['title'] == 'Dark');
    // }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'BROWSE',
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
            'ABOUT',
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
          if (itemsBrowse[index]['title'] == 'Mode') {
            return _buildThemeSwitch(itemsBrowse[index]);
          }

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
          return  const Divider(
            color: Colors.white54,
          );
        },
      );
  }

  Widget _buildThemeSwitch(Map item) {
    return SwitchListTile(
      secondary: Icon(
        item['icon'],
        color: Colors.white,
      ),
      title: Text(
        item['title'],
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      inactiveThumbColor: Colors.white,
      activeColor: Colors.black,
      value: Provider.of<AppProvider>(context).theme == ThemeConfig.lightTheme
          ? false
          : true,
      onChanged: (v) {
        if (v) {
          Provider.of<AppProvider>(context, listen: false)
              .setTheme(ThemeConfig.darkTheme, 'dark');
        } else {
          Provider.of<AppProvider>(context, listen: false)
              .setTheme(ThemeConfig.lightTheme, 'light');
        }
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
}
