import 'package:ebook/components/drawer.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/view_models/appbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_search.dart';
import 'home.dart';

class Read extends StatelessWidget {
  const Read({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        actions: _buildAppBar(context),
        
      ),
    body: const Home(),
    );
  }


  _buildAppBar(BuildContext context) {
    return  [
      Consumer<AppBarProvider>(
        builder: (context, event, _) {
          if(event.isHome){
            return InkWell(
              onTap: () => _searchBook(context),
              child: Container(
              width: 285,
              decoration: BoxDecoration(
                color: ThemeConfig.lightSecond,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Icon(Icons.search),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Search',
                    style: TextStyle(color: ThemeConfig.darkPrimary),
                  )
                ],
              ),
                      ),
            );
          }
          else{
            return InkWell(
              onTap: () => _searchBook(context),
              child: Container(
                
              width: 230,
              decoration: BoxDecoration(
                color: ThemeConfig.lightSecond,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(top: 10, right: 15, bottom: 10),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Icon(Icons.search),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Search',
                    style: TextStyle(color: ThemeConfig.darkPrimary),
                  )
                ],
              ),
                      ),
            );
          }
        }
      ),
      IconButton(onPressed: (){}, icon: const Icon(Icons.favorite_border)),
       Consumer<AppBarProvider>(builder: (context, event, _) {
        if (event.isHome) {
          return Container();
        } else {
           return IconButton(
              onPressed: () {}, icon: const Icon(Icons.arrow_back));
        }
      }),
    ];  
  }
  
  _searchBook(BuildContext context) {
    showSearch(
    context: context, 
    delegate: CustomSearch());
  }
}
