//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import '../../utils/syncs.dart';
import '../../model/user_model/data.dart';
import '../../utils/global.dart';
import '../../components/a_article_list/index.dart';
import '../../model/article_cate_model/data.dart';
import '../../components/a_swiper/index.dart';

class TodayPage extends StatefulWidget {
  static _TodayPageState _todayPageState;

  TodayPage() {
    _todayPageState = _TodayPageState();
  }

  getAppBar() => _todayPageState.createAppBar();

  _TodayPageState createState() => _TodayPageState();
}

// class _TodayPageState extends State<TodayPage> with TickerProviderStateMixin{

class _TodayPageState extends State<TodayPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ///see AutomaticKeepAliveClientMixin

  int userid = 0;

  static TabController _tabController;

  static ArticleCateModel articleCate;

  static int curArticleCateId = 0;

  @override
  void initState() {
    super.initState();
    // print('today======>');
    UserDataModel userData = G.user.data;
    userid = userData.id;
    var res = Syncs.getCateList;
    Map result = res.data;
    articleCate = ArticleCateModel.fromJson(result);
    curArticleCateId = articleCate.list[0].cateid;
    _tabController = TabController(
      vsync: this,
      length: articleCate.list.length,
    );
    // print('aaa====>');
    // print(_tabController.length);

    _tabController.addListener(() {
      if (_tabController.index == _tabController.animation.value) {
        if (mounted) {
          setState(() {
            curArticleCateId = articleCate.list[_tabController.index].cateid;
          });
        }
      }
    });
    Future.delayed(Duration.zero, () async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  AppBar createAppBar() {
    // var res = Syncs.getCateList;
    // Map result = res.data;
    // articleCate = ArticleCateModel.fromJson(result);
    // curArticleCateId = articleCate.list[0].cateid;
    // _tabController = TabController(vsync: this, length: articleCate.list.length);

    return customAppbar(title: '今日AA', default_actions: true);
    // return customAppbar(
    //   title: '今日AA',
    //   default_actions: true,
    //   borderBottom: true,
    //   TabContainer: Theme(
    //     data: ThemeData(
    //         splashColor: Colors.transparent,
    //         highlightColor: Colors.transparent
    //     ),
    //     // child: Text('hello')
    //     child:
    //     (_tabController == null)?Container():TabBar(
    //       controller: _tabController,
    //       tabs: (articleCate.list.length > 0) ?
    //       articleCate.list
    //           .asMap()
    //           .keys
    //           .map((f) {
    //         return Text(articleCate.list[f].catename);
    //       }).toList() : Text('全部'),
    //       indicatorColor: rgba(28, 141, 160, 1),
    //       //            indicatorSize: TabBarIndicatorSize.tab,
    //       //          labelPadding: EdgeInsets.only(top: 20,bottom:20,left:20,right:20),
    //       labelPadding: (articleCate.list.length > 4) ? EdgeInsets.only(
    //           top: 20, bottom: 20, left: 20, right: 20) : EdgeInsets.only(
    //           top: 20, bottom: 20),
    //       indicatorPadding: EdgeInsets.only(
    //           top: 10, bottom: 10, left: 20, right: 20),
    //       //          indicator: new ShapeDecoration(shape: new Border.all(color: Colors.redAccent, width: 1.0)),
    //       labelColor: rgba(28, 141, 160, 1),
    //       //          indicatorWeight: 15.0,
    //       labelStyle: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         color: rgba(28, 141, 160, 1),
    //       ),
    //       unselectedLabelStyle: TextStyle(
    //         fontSize: 15,
    //         color: hex('#333'),
    //       ),
    //       unselectedLabelColor: hex('#333'),
    //       isScrollable: (articleCate.list.length > 4) ? true : false,
    //     ),
    //   ),
    // );
  }

  Widget buildTabBarView() {
    int cateid = 0;
    // return Text('hello2.0');
    return TabBarView(
      //        physics: new NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: articleCate.list.asMap().keys.map((f) {
        var articleCateList = articleCate.list[f];
        List<String> items = [];
        cateid = articleCateList.cateid;
        for (int i = 0; i < articleCateList.catepic.length; i++) {
          items.add(articleCateList.catepic[i].pic);
        }
        //          return null;
        return AArticleList(
          uid: userid,
          cateid: cateid,
          isreload: true,
          isShowDesc: true,
          isShowPrayerBtn: false,
          topchild: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
            child: Column(
              children: [
                // Text('asd'),
                TabBar(
                  controller: _tabController,
                  tabs: (articleCate.list.length > 0)
                      ? articleCate.list.asMap().keys.map((f) {
                          return Text(articleCate.list[f].catename);
                        }).toList()
                      : Text('全部'),
                  indicatorColor: rgba(28, 141, 160, 1),
                  //            indicatorSize: TabBarIndicatorSize.tab,
                  //          labelPadding: EdgeInsets.only(top: 20,bottom:20,left:20,right:20),
                  labelPadding: (articleCate.list.length > 4)
                      ? EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                          left: 20,
                          right: 20,
                        )
                      : EdgeInsets.only(top: 20, bottom: 20),
                  indicatorPadding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 20,
                    right: 20,
                  ),
                  //          indicator: new ShapeDecoration(shape: new Border.all(color: Colors.redAccent, width: 1.0)),
                  labelColor: rgba(28, 141, 160, 1),
                  //          indicatorWeight: 15.0,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: rgba(28, 141, 160, 1),
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 15,
                    color: hex('#333'),
                  ),
                  unselectedLabelColor: hex('#333'),
                  isScrollable: (articleCate.list.length > 4) ? true : false,
                ),
                Container(height: 10),
                ASwiper(
                  // items,
                  articleCateList.catepic,
                  height: 150,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    //    return Text('qwe');
    return Container(
      color: hex('#fff'),
      child: buildTabBarView(),
      //      child: Text('123'),
    );
  }
}
