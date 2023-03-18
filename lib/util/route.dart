import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class MyRouter {
  static Future pushPage(BuildContext context, Widget page) {
    var val = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );

    return val;
  }

  static Future pushPageDialog(BuildContext context, Widget page) {
    var val = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
        fullscreenDialog: true,
      ),
    );

    return val;
  }

  static pushPageReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }

  static pushAnimation(BuildContext context, Widget page){
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: page));
  }
  static pushAnimationChooseType(BuildContext context, Widget page, PageTransitionType type) {
    Navigator.push(context,
        PageTransition(type: type, child: page));
  }
  static pushReplacementAnimation(BuildContext context, Widget page) {
    Navigator.pushReplacement(context,
        PageTransition(type: PageTransitionType.rightToLeft, child: page));
  }
}
