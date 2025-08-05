/*
 * @Author: Alfred
 * @since: 2020-03-18 14:23:27
 * @lastTime: 2020-03-18 11:50:01
 * @LastEditors: Alfred
 */
//import 'package:color_dart/color_dart.dart';
import 'package:connectivity/connectivity.dart';
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
  /// toolbar routeName
  static final List toobarRouteNameList = ['/home', '/today', '/article', '/membercenter'];
  static final List noLoginRouteNameList = ['/into_app', '/login_start', '/login_mail', '/register_page', '/forgot_password','/terms_of_use'];
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
      timeInSecForIos: 1,
      backgroundColor: rgba(40, 40, 40, 0.8),
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
  static sleep({ int milliseconds = 1000 }) async => await Future.delayed(Duration(milliseconds: milliseconds));

  /// 下拉刷新样式
  static final APullToRefresh pullToRefresh = APullToRefresh();

  // 获取当前的state
  static NavigatorState getCurrentState() => navigatorKey.currentState;

  /// 获取当前的context
  static BuildContext getCurrentContext() => navigatorKey.currentContext;

  /// 获取屏幕上下边距
  /// 用于兼容全面屏，刘海屏
  static EdgeInsets screenPadding() => MediaQuery.of(getCurrentContext()).padding;

  /// 获取屏幕宽度
  static double screenWidth() => MediaQuery.of(getCurrentContext()).size.width;

  /// 获取屏幕高度
  static double screenHeight() => MediaQuery.of(getCurrentContext()).size.height;

  /// 跳转页面使用 G.pushNamed
  static void pushNamed(String routeName, {Object arguments}){
    // 如果跳转到toolbar页面  不能返回

    if(toobarRouteNameList.indexOf(routeName) > -1) {
//      print('routeName11====>${routeName}');
      getCurrentState().pushReplacementNamed(routeName, arguments: arguments,);
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
  static Border borderTop({Color color, bool show = true}){
    return Border(
        top: BorderSide(
            color: (color == null || !show)  ? (show ? rgba(204, 204, 204, 1) : Colors.transparent) : color,
            width: 1
        )
    );
  }

  /// 底部border
  /// ```
  /// @param {Color} color
  /// @param {bool} show  是否显示底部border
  /// ```
  static Border borderBottom({Color color, bool show = true}){
    return Border(
        bottom: BorderSide(
            color: (color == null || !show)  ? (show ? rgba(204, 204, 204, 1) : Colors.transparent) : color,
            width: 1
        )
    );
  }
//
  /// 获取时间戳
  /// 不传值 代表获取当前时间戳
  static int getTime([DateTime time]) {
    if(time == null) {
      return (DateTime.now().millisecondsSinceEpoch/1000).round();
    } else {
      return (time.millisecondsSinceEpoch/1000).round();
    }
  }

  static bool is_http(String str){
    if(str.contains('http://') || str.contains('https://')){
      return true;
    }else{
      return false;
    }
  }

  /// user信息
  static final User user = User();

  static void isHasNetwork({Function onCallback}) async {
    bool hasNetwork = null;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print('I am connected to a mobile network====>.');
      hasNetwork = true;
      onCallback(hasNetwork);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print('I am connected to a wifi network====>.');
      hasNetwork = true;
      onCallback(hasNetwork);
    }else{
      print('no network====>');
      hasNetwork = false;
      onCallback(hasNetwork);
    }
  }

  static void setDomain(String doMainStr,{Function onCallback}) async {
    SharedPreferences prefs;
    bool ishttp = false;
    String domainStr = '';
    prefs = await SharedPreferences.getInstance();
    prefs.setString('domain', doMainStr);

    Future.delayed(Duration.zero, () async {
      domainStr = prefs.getString('domain');
      ishttp = G.is_http(domainStr);
      print('domain2====>${domainStr}，${ishttp}');
      if(ishttp == true){
        G.baseurl = domainStr;
        G.prdapi = domainStr+'/api';
        if(onCallback is Function) onCallback(true);
      }else{
        if(onCallback is Function) onCallback(false);
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