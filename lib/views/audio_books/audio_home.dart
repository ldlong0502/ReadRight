import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/util/const.dart';
import 'package:flutter/material.dart';

import 'audio_book_component.dart';

class AudioHome extends StatefulWidget {
  const AudioHome({super.key});

  @override
  State<AudioHome> createState() => _AudioHomeState();
}

class _AudioHomeState extends State<AudioHome> {
  late ScrollController scrollController;
  bool isShowTitle = false;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >= 100) {
        setState(() {
          isShowTitle = true;
        });
      }
      else{
        setState(() {
          isShowTitle = false;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 180,
              title: isShowTitle ? const Text(
                      'Sách Nói',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ) : null,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(20),
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      width: double.infinity,
                      child: const Text(''),)),
              automaticallyImplyLeading: true,
              backgroundColor: ThemeConfig.lightAccent,

              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: Constants.linearDecoration,
                  child: Column(
                      
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Image.asset('assets/images/audio_book.png'),
                      const SizedBox(
                      height: 10,
                    ),
                      const Text(
                        'Sách Nói',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: AudioBookComponent(),
            )
          ],
        ),
      );
  
  }
}
