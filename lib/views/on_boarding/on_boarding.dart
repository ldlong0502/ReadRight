import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/util/route.dart';
import 'package:ebook/view_models/app_provider.dart';
import 'package:ebook/views/mainScreen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int currentIndex = 0;
  var listGenre = [
    {
      'name': 'Lịch sử',
      'asset': 'assets/images/history.png',
      'isChoose': false
    },
    {
      'name': 'Tiên hiệp & Huyền huyễn',
      'asset': 'assets/images/fairy.png',
      'isChoose': false
    },
    {
      'name': 'Văn học',
      'asset': 'assets/images/literature.png',
      'isChoose': false
    },
    {'name': 'Truyện', 'asset': 'assets/images/story.png', 'isChoose': false},
    {
      'name': 'Tài chính',
      'asset': 'assets/images/financial.png',
      'isChoose': false
    }
  ];
  @override
  Widget build(BuildContext context) => SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
                title: 'Hãy chọn một vài thể loại bạn yêu thích',
                useScrollView: true,
                image: buildImage('assets/images/step1.jpg'),
                decoration: getPageDecoration(),
               
                
                bodyWidget: Column(
                  children: [
                   
                    Column(
                      children: _buildGenre(MediaQuery.of(context).size),
                    ),
                  ],
                )),
            PageViewModel(
              title: 'Trải nghiệm với Sách nói',
              body: 'Nghe ở bất cứ đâu mà bạn muốn, tận hưởng trải nghiệm thú vị và mới lạ.',
              image: buildImage('assets/images/step2.jpg'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Ebook - Nâng tầm tri trức',
              body: 'Hàng ngàn cuốn sách đang chờ đón bạn , cùng khám phá nào.',
              image: buildImage('assets/images/step3.jpg'),
              decoration: getPageDecoration(),
            ),
          ],

          done:
              const Text('Khám phá', style: TextStyle(fontWeight: FontWeight.w600)),
          onDone: () => goToHome(context),
          showSkipButton: currentIndex == 0 ? false : true,
          
          skip: const Text('Skip'),
          onSkip: () => goToHome(context),
          next: const Icon(Icons.arrow_forward),

          dotsDecorator: getDotDecoration(),
          onChange: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          globalBackgroundColor: Theme.of(context).primaryColor,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          nextFlex: 1,
       
          // isProgressTap: false,
          // isProgress: false,
          showNextButton: isShowSkipButton() ? true : false,
        
          freeze: true,
          animationDuration: 1000,
        ),
      );

  void goToHome(BuildContext context) {
    final list = Hive.box('genre');
    listGenre.forEach((element) { 
      int i = 0;
      var temp = (element['name'] as String).split(' & ');
      temp.forEach((g) async {
        await list.put(i++, g);
      });
      
    });
    context.read<AppProvider>().setWelcome(true, 'true');
    MyRouter.pushPageReplacement(context, const MainScreen());
  }

  Widget buildImage(String path) =>
      Center(child: Image.asset(path,height: MediaQuery.of(context).size.height * 0.3, width: MediaQuery.of(context).size.width * 0.8 , fit: BoxFit.fill,));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: ThemeConfig.fourthAccent,
        activeColor: Colors.orange,
        size: const Size(10, 10),
        activeSize: const Size(30, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() =>  PageDecoration(
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold , color: ThemeConfig.thirdAccent),
        bodyTextStyle:  TextStyle(fontSize: 20 ,color: ThemeConfig.lightAccent),
        imagePadding: const EdgeInsets.all(24),
        pageColor: Colors.white,
      );
  bool isShowSkipButton(){
    return listGenre.where((element) => element['isChoose'] as bool).isNotEmpty;
  }
  _buildGenre(Size size) {
    return listGenre.asMap().entries.map((e) {
      return InkWell(
        onTap: () {
          setState(() {
            listGenre[e.key]['isChoose'] =
                !(listGenre[e.key]['isChoose'] as bool);
          });
        },
        child: Container(
          height: 50,
          width: size.width * 0.8,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            top: 10,
          ),
          padding: const EdgeInsets.only(left: 30),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                  width: 2,
                  color: e.value['isChoose'] as bool
                      ? Colors.amber
                      : Colors.grey)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                e.value['asset'] as String,
                height: 25,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                e.value['name'] as String,
                style: TextStyle(fontSize: 16, color: ThemeConfig.lightAccent),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
