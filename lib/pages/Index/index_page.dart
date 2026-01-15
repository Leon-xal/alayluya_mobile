import '../../utils/global.dart';
//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
//import '../utils/Icon.dart';
//import '../utils/global.dart';
//import 'package:flutter/services.dart';

import '../../components/custom_navbar/index.dart';
import '../home/home_page.dart';
import '../today/today_page.dart';
import '../article/article_page.dart';
import '../member_center/member_center.dart';

class IndexPage extends StatefulWidget {
  final String routeName;
  final Object arguments;

  static HomePage _homepage = HomePage();
  static ArticlePage _articlepage = ArticlePage();
  static TodayPage _todaypage = TodayPage();
  static MemberCenter _membercenter = MemberCenter();

  /// 所有toolbar页面
  final Map<int, Map> pages = {
    0: _createPage(
      _homepage,
      appbar: _homepage.getAppBar(),
      routeName: '/',
      arg: '11',
    ),
    1: _createPage(
      _todaypage,
      appbar: _todaypage.getAppBar(),
      routeName: '/today',
      arg: '22',
    ),
    2: _createPage(
      _articlepage,
      appbar: _articlepage.getAppBar(),
      routeName: '/article',
      arg: '33',
    ),
    3: _createPage(
      _membercenter,
      //appbar: _membercenter.getAppBar(),
      routeName: '/membercenter',
      arg: '44',
    ),
  };

  /// 创建页面map
  /// ```
  /// @param {Widget} page - 页面
  /// @param {Appbar} appbar - 当前页面是否显示appbar 默认为true
  /// ```
  static Map _createPage(
    Widget page, {
    AppBar? appbar,
    String? routeName,
    Object? arg,
  }) {
    return {
      "widget": page,
      "appbar": appbar,
      "routeName": routeName,
      "arg": arg,
    };
  }

  // IndexPage({
  //   Key key,
  //   this.arguments,
  // }) : super(key: key);

  static IndexPage? _singleton;

  IndexPage.singleton({required this.routeName, required this.arguments});

  factory IndexPage({Key? key, String? routeName, Object? arguments}) {
    print("indexPage --->" + "routeName: $routeName, arguments: $arguments");
    _singleton ??= IndexPage._internal(
      key: key,
      routeName: routeName ?? '/', // Provide a default route name
      arguments: arguments ?? {},
    );
    return _singleton!;
  }

  IndexPage._internal({
    Key? key,
    required this.routeName,
    required this.arguments,
  }) : super(key: key);

  // 通过 routeName 获取对应页面的索引
  getPageIndex(routeName) {
    print('routeName====>${routeName}');
    switch (routeName) {
      case '/home':
        return 0;
      case '/today':
        return 1;
      case '/article':
        return 2;
      case '/membercenter':
        return 3;
      default:
        return 0;
    }
  }

  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<IndexPage> {
  // final Map arguments;
  PageController _pageController = PageController(initialPage: 0);

  static int currentIndex = 0;

  List<Widget> _pages = [];

  _NavigationState();

  @override
  void initState() {
    super.initState();
    // arguments = widget.arguments;

    // Future.delayed(Duration(seconds: 4), () {
    //   print('arguments====>${widget.arguments}');
    // });

    // if(arguments.containsKey('index')){
    //   print('arguments====>${arguments['index']}');
    // }

    // dynamic arg = ModalRoute.of(context).settings.arguments;
    // if (arg != null) {
    //   print('arguments====>${arg}');
    // }

    this._pageController = PageController(initialPage: currentIndex);
    _pages.add(widget.pages[0]?['widget']);
    _pages.add(widget.pages[1]?['widget']);
    _pages.add(widget.pages[2]?['widget']);
    _pages.add(widget.pages[3]?['widget']);

    // print('argumentsCurrentIndex1====>${currentIndex}');

    Future.delayed(Duration.zero, () {
      String? routeName = ModalRoute.of(context)?.settings.name;
      setState(() {
        int tempCurrentIndex = widget.getPageIndex(routeName);
        if (tempCurrentIndex != currentIndex) {
          currentIndex = tempCurrentIndex;
          this._pageController.jumpToPage(currentIndex);
        }

        // print('argumentsCurrentIndex2====>${tempCurrentIndex}');
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        G.listenDeeplink();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic arg = ModalRoute.of(context)?.settings.arguments;
    if (arg != null) {
      print('argumentsIndex====>${arg}');
    }
    //    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarBrightness: Brightness.light));

    Map? page = widget.pages[currentIndex];
    //    List<Widget> _pages = [page[0]['widget'],page[1]['widget'],page[2]['widget'],page[3]['widget']];
    //    return Text('qwe');
    print("currentIndex====>${currentIndex}");
    print("this._pageController======>${this._pageController}");
    //print("this._pages======>${this._pages}");
    print('this._pages length: ${this._pages.length}');
    for (int i = 0; i < this._pages.length; i++) {
      print(
        'this._pages[$i]: ${this._pages[i]}',
      ); //Inspect each element.  A null will be printed as "null"
    }
    print(
      'index-index_page.dart _pageController: $_pageController',
    ); // Print the controller
    var _tmp = NeverScrollableScrollPhysics();
    print('index-index_page.dart _physics: ${_tmp}'); // Print the list of pages
    print(
      'index-index_page.dart _pages : ${_pages}',
    ); //Print the length of the list
    return Scaffold(
      // appBar: (currentIndex == 1)?null:page['appbar'],
      appBar: page!['appbar'],
      body: PageView(
        physics: NeverScrollableScrollPhysics(), //禁止滑动
        controller: this._pageController,
        children: this._pages,
      ),
      bottomNavigationBar: CustomNavbar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
            // print('this._pageController======>${this._pageController}');
            G.isHasNetwork(
              onCallback: (hasNetwork) async {
                if (hasNetwork == true) {
                  this._pageController.jumpToPage(currentIndex);
                } else {
                  G.getCurrentState().pushNamed("/not_network");
                }
              },
            );

            // this._pageController.
            // print('currentIndex2=====>${currentIndex}');
          });
        },
      ),
    );
  }
}
