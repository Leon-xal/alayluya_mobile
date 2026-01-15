/*
 * @Author: Alfred
 * @since: 2020-03-18 14:23:27
 * @lastTime: 2020-03-18 11:50:01
 * @LastEditors: Alfred
 */
//import 'package:color_dart/color_dart.dart';
//import 'package:connectivity/connectivity.dart';
import 'package:app_links/app_links.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:event_bus/event_bus.dart';
import '../request/request.dart';
import '../components/a_loading/index.dart';
export '../components/custom_appbar/index.dart';
import '../components/a_pull_to_refresh/index.dart';

export './Icon.dart';
import './user.dart';

/// global
class G {
  ///判斷是否登錄狀態 Alfred
  static bool isLogin = false;

  static bool isDev = false;

  ///判斷使用那個版本api
  //  static bool oldApi = true;

  //  static String devapi = 'http://awana.uat4.online/api';
  static String baseurl = 'http://testapi2.alayluya.com';
  // static String baseurl = 'https://api1.alayluya.info';

  // static String prdapi = oldApi ? 'http://testapi2.alayluya.com/api' : 'http://testapi2uat.alayluya.com/api';
  // static String prdapi = 'https://api11.alayluya.info/api';
  static String prdapi = '${baseurl}/api';

  // static String uatapi = 'http://testapi2uat.alayluya.com/api';
  //  static String prdapi = 'http://192.168.1.15/api';

  //  static String prdapi = 'http://192.168.31.249/api';
  //  static String prdapi = 'http://192.168.4.45/api';

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static bool _deeplinkInitialized = false;

  /// toolbar routeName
  static final List toobarRouteNameList = [
    '/home',
    '/today',
    '/article',
    '/membercenter',
  ];
  static final List noLoginRouteNameList = [
    '/into_app',
    '/login_start',
    '/login_mail',
    '/register_page',
    '/forgot_password',
    '/terms_of_use',
  ];
  //  /// 处理商品描述
  //  static String handleGoodsDesc(String str) {
  //    return str.replaceAll(RegExp(',\$'), '').replaceAll(RegExp('规格:|温度:|糖度:|奶油:|无'), '');
  //  }
  /// 初始化request
  static final Request req = Request();

  static Future toast(String text) => Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromARGB(204, 40, 40, 40),
    textColor: Colors.white,
    fontSize: 14.0,
  );

  //  static Future toastCb({ String text='helloworld',Function callbackfunc = null, }){
  //    print("我是在请求数据后面的代码呦！start====>");
  //    Fluttertoast.showToast(
  //      msg: text,
  //      toastLength: Toast.LENGTH_SHORT,
  //      gravity: ToastGravity.CENTER,
  //      timeInSecForIos: 1,
  //      backgroundColor: rgba(40, 40, 40, 0.8),
  //      textColor: Colors.white,
  //      fontSize: 14.0,
  //    ).then((result) {
  //      print("返回的数据是====>${result}");
  //    }).whenComplete((){
  ////        print('aaaaa====>');
  //        Future.delayed(Duration(seconds: 3), () {
  ////          print("延时三秒后请求数据");
  //          callbackfunc();
  //        });
  //
  //    }).catchError((){
  //      print("出现异常了====>");
  //    });
  ////    print("我是在请求数据后面的代码呦！end====>");
  //  }

  /// 初始化loading
  static final ALoading loading = ALoading();

  /// 手动延时
  static sleep({int milliseconds = 1000}) async =>
      await Future.delayed(Duration(milliseconds: milliseconds));

  /// 下拉刷新样式
  static final APullToRefresh pullToRefresh = APullToRefresh();

  // 获取当前的state
  static NavigatorState getCurrentState() => navigatorKey.currentState!;

  /// 获取当前的context
  static BuildContext getCurrentContext() => navigatorKey.currentContext!;

  /// 获取屏幕上下边距
  /// 用于兼容全面屏，刘海屏
  static EdgeInsets screenPadding() =>
      MediaQuery.of(getCurrentContext()).padding;

  /// 获取屏幕宽度
  static double screenWidth() => MediaQuery.of(getCurrentContext()).size.width;

  /// 获取屏幕高度
  static double screenHeight() =>
      MediaQuery.of(getCurrentContext()).size.height;

  /// 跳转页面使用 G.pushNamed
  static void pushNamed(String routeName, {Object? arguments}) {
    // 如果跳转到toolbar页面  不能返回

    if (toobarRouteNameList.indexOf(routeName) > -1) {
      //      print('routeName11====>${routeName}');
      getCurrentState().pushReplacementNamed(routeName, arguments: arguments);
    } else {
      //      print('routeName22====>${routeName}');
      getCurrentState().pushNamed(routeName, arguments: arguments);
    }
  }

  /// 返回页面
  static void pop() => getCurrentState().pop();

  /// 頂部border
  /// ```
  /// @param {Color} color
  /// @param {bool} show  是否显示頂部border
  /// ```
  static Border borderTop({Color? color, bool show = true}) {
    return Border(
      top: BorderSide(
        color: (!show)
            ? (show ? Color.fromARGB(255, 204, 204, 204) : Colors.transparent)
            : color ?? Colors.grey, // Provide a default color
        width: 1,
      ),
    );
  }

  /// 底部border
  /// ```
  /// @param {Color} color
  /// @param {bool} show  是否显示底部border
  /// ```
  static Border borderBottom({Color? color, bool show = true}) {
    return Border(
      bottom: BorderSide(
        color: (!show)
            ? (show ? Color.fromARGB(255, 204, 204, 204) : Colors.transparent)
            : color ?? Colors.grey, // Provide a default color
        width: 1,
      ),
    );
  }

  //
  /// 获取时间戳
  /// 不传值 代表获取当前时间戳
  static int getTime([DateTime? time]) {
    return (time!.millisecondsSinceEpoch / 1000).round();
  }

  static bool is_http(String str) {
    if (str.contains('http://') || str.contains('https://')) {
      return true;
    } else {
      return false;
    }
  }

  /// user信息
  static final User user = User();

  static Future<bool> isHasNetwork({Function? onCallback}) async {
    bool hasNetwork;
    try {
      final List<ConnectivityResult> connectivityResult = await Connectivity()
          .checkConnectivity();
      print('connectivityResult====>${connectivityResult}'); // Log the result
      print(
        'connectivityResult type: ${connectivityResult.runtimeType}',
      ); // Log the type

      // Use identical for more reliable comparison
      if (connectivityResult.contains(ConnectivityResult.mobile)) {
        print('I am connected to a mobile network====>.');
        hasNetwork = true;
      } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
        print('I am connected to a wifi network====>.');
        hasNetwork = true;
      } else {
        print('no network====>');
        hasNetwork = false;
      }
    } catch (e) {
      print(
        'Error checking network connectivity: $e',
      ); // Handle potential errors
      hasNetwork = false;
    }
    onCallback?.call(hasNetwork); // Call the callback if provided
    return hasNetwork;
  }

  static void setDomain(String doMainStr, {Function? onCallback}) async {
    SharedPreferences prefs;
    bool ishttp = false;
    String domainStr = '';
    prefs = await SharedPreferences.getInstance();
    prefs.setString('domain', doMainStr);

    Future.delayed(Duration.zero, () async {
      domainStr = prefs.getString('domain') ?? 'http://testapi2.alayluya.com';
      ishttp = G.is_http(domainStr);
      print('domain2====>${domainStr} ${ishttp}');
      if (ishttp == true) {
        G.baseurl = domainStr;
        G.prdapi = domainStr + '/api';
        onCallback!(true);
      } else {
        onCallback!(false);
      }
    });
  }

  static listenDeeplink() async {
    if (_deeplinkInitialized) {
      return;
    }
    _deeplinkInitialized = true;
    AppLinks().uriLinkStream.listen((uri) async {
      print('uriLinkStream======>${uri}');
      print('uriLinkStream112======>${uri.fragment}');
      print('uriLinkStream223======>${uri.host}');
      print('uriLinkStream334======>${uri.scheme}');
      print('uriLinkStream445======>${uri.queryParametersAll}');
      print('uriLinkStream556======>${uri.pathSegments}');
      List<String> segments = uri.pathSegments;
      // List<String> segments = ['article','基督教靈糧世界佈道會香港靈糧堂-0103-牧者的話1935652056'];
      if(segments.isNotEmpty && segments.length >= 2) {
        if(segments[0] == 'article') {
          Response data = await G.req.article_cate.request_article_id_by_title(title: '${segments[1]}');
          if(data.statusCode == 200 && data.data != null) {
            String id = '${data.data['result']['id']}';
            G.pushNamed('/article_detail', arguments: {'id': int.parse(id)});
          }
        }
      }
    });
  }
  //  static void openSource(){
  //
  //  }

  //  static EventBus eventBus(){
  //    EventBus eventBus = new EventBus();
  //    print('eventBus${eventBus}');
  //    return eventBus;
  //  }
}
