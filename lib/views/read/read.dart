import 'package:ebook/views/read/subject_widget.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/util/dialogs.dart';
import 'package:ebook/view_models/appbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_search.dart';
import 'home.dart';

class Read extends StatefulWidget {
  const Read({super.key, required this.ctx});
  final BuildContext ctx;
  @override
  State<Read> createState() => _ReadState();
}

class _ReadState extends State<Read> with TickerProviderStateMixin {
  var listSubject = [
    {'title': 'Trang chủ', 'widget': const Home()},
    {
      'title': 'Viễn tưởng',
      'widget': const SubjectWidget(
        title: 'Fiction',
      )
    },
    {
      'title': 'Phiêu lưu',
      'widget': const SubjectWidget(
        title: 'Adventure',
      )
    },
    {
      'title': 'Manga',
      'widget': const SubjectWidget(
        title: 'Manga',
      )
    },
    {
      'title': 'Tiểu thuyết',
      'widget': const SubjectWidget(
        title: 'Novels',
      )
    },
    {
      'title': 'Tiên hiệp',
      'widget': const SubjectWidget(
        title: 'Fairy',
      )
    },
    {
      'title': 'Văn học',
      'widget': const SubjectWidget(
        title: 'Literature',
      )
    },
  ];
  late TabController _tabController;
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: listSubject.length)
      ..addListener(() {
        if (_tabController.index != 0) {
          Provider.of<AppBarProvider>(context, listen: false)
              .setEventTriggered(false);
          animationController.forward();
        } else {
          Provider.of<AppBarProvider>(context, listen: false)
              .setEventTriggered(true);
          animationController.reverse();
        }
      });

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });

    animation = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: _buildAppBar(context),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(
                      
                      color: Colors.grey, width: 1))),
            child: TabBar(
              indicatorColor: Theme.of(context).iconTheme.color,
              controller: _tabController,
              isScrollable: true,
              physics: const BouncingScrollPhysics(),
              labelStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              tabs: listSubject
                  .map((e) => Tab(
                        text: e['title'] as String,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: listSubject.map((e) => e['widget'] as Widget).toList(),
      ),
    );
  }

  _buildAppBar(BuildContext context) {
    return [
      Expanded(flex: 1, child: Container()),
      Expanded(
          flex: 6,
          child: Consumer<AppBarProvider>(
            builder: (context, event, _) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () => _searchBook(context),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        decoration: BoxDecoration(
                            color: ThemeConfig.lightSecond,
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(5),
                        width: event.isHome ? 220 : 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Icon(Icons.search,
                                  color: ThemeConfig.darkPrimary),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 120,
                              child: Text(
                                'Tìm kiếm tác giả, tên truyện',
                                maxLines: 1,
                                style: TextStyle(color: ThemeConfig.darkPrimary, overflow: TextOverflow.ellipsis),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    event.isHome
                        ? Container()
                        : IconButton(
                            onPressed: () {
                              Dialogs().showSetUpBottomDialog(context);
                            },
                            icon: const Icon(Icons.swap_vert_outlined))
                  ],
                ),
              );
            },
          )),
    ];
  }

  _searchBook(BuildContext context) {
    showSearch(context: context, delegate: CustomSearch());
  }
}
