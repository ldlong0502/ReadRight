import 'package:flutter/material.dart';

import '../theme/theme_config.dart';

class ChapterDialog extends StatefulWidget {
  const ChapterDialog({super.key, required this.listMp3, required this.index, required this.onChooseChapter});
  final List<Map<dynamic, dynamic>> listMp3;
  final int index;
  final Function onChooseChapter;

  @override
  State<ChapterDialog> createState() => _ChapterDialogState();
}

class _ChapterDialogState extends State<ChapterDialog> {

  int index = 0;
  @override
  void initState() {
    super.initState();
    index = widget.index;
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.9,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          buildHeader(height),
          buildListChapter(height),
        ],
      ),
    );
  }

  buildHeader(double height) {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Chương',
              style: TextStyle(
                  color: ThemeConfig.lightAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              height: 30,
              width: 30,
              margin: const EdgeInsets.only(right: 20.0),
              decoration: BoxDecoration(
                  color: ThemeConfig.fourthAccent, shape: BoxShape.circle),
              child: Center(
                  child: IconButton(
                icon: const Icon(Icons.clear_rounded),
                color: Colors.white,
                iconSize: 15,
                onPressed: () {
                  Navigator.pop(context);
                },
              ))),
        ],
      ),
    );
  }

  buildListChapter(double height) {
    return Expanded(
      flex: 9,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: widget.listMp3.asMap().entries.map((entry) {
          int idx = entry.key;
          var val = entry.value;
          var list = val['title'].toString().split(': ');
          return InkWell(
            onTap: () async {
              if( idx == index) return;
              setState(() {
                index = idx;
              });
              await widget.onChooseChapter(idx);
              if(!mounted) return;
              Navigator.pop(context);
            },
            child: Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: index == idx ? Colors.grey[100] : Colors.white), 
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        (idx + 1).toString(),
                        style: TextStyle(
                            color: ThemeConfig.fourthAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(list[0], style: TextStyle(
                                color: ThemeConfig.lightAccent,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        Text(list[1], style: const TextStyle(
                          overflow: TextOverflow.ellipsis
                        ),)
                      ],
                    )
                  ),
                  index == idx ? const Expanded(child: Icon(Icons.headset_mic_rounded , color: Colors.redAccent,)) : Expanded(child: Container())
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
