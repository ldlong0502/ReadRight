import 'package:ebook/views/read/subject_widget.dart';
import 'package:flutter/material.dart';

import '../../theme/theme_config.dart';
import '../../util/dialogs.dart';

class EbookSubject extends StatefulWidget {
  const EbookSubject({super.key, required this.genre});
  final Map genre;
  @override
  State<EbookSubject> createState() => _EbookSubjectState();
}

class _EbookSubjectState extends State<EbookSubject> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: size.height / 7,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [ThemeConfig.lightAccent, ThemeConfig.fourthAccent],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(widget.genre['asset'] , height: 20,),
                            const SizedBox(width: 10,),
                            Text(
                              widget.genre['name'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child:  IconButton(
                                onPressed: () {
                                   Dialogs().showSetUpBottomDialog(context);
                                },
                                icon: const Icon(Icons.swap_vert_outlined , color: Colors.white,))
                      )
                    ),
                  ],
                ),
              )),
          Positioned(
            top: size.height * 0.12,
            left: 0,
            right: 0,
            height: size.height ,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              // child:  Column(
              //   children: [
              //     
                 
              //   ],
              // ),
              child:  SubjectWidget(title: widget.genre['name']),
            ),
            
          ),
        ],
      ),
    );
  }
}
