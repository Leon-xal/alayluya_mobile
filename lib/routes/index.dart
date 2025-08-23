import 'package:flutter/material.dart';

import '../pages/article/article_report.dart';

import '../pages/eland/my_eland_list.dart';

import '../pages/member_center/bind_email_or_phone.dart';

import '../pages/Index/into_app.dart';
import '../pages/Index/index_page.dart';
import '../pages/Index/not_network.dart';

//import '../pages/home_page.dart';
//import '../pages/today_page.dart';
//import '../pages/article_page.dart';
//import '../pages/member_center.dart';

import '../pages/login/login_start.dart';
import '../pages/login/login_mail.dart';
import '../pages/login/register_page.dart';
import '../pages/login/forgot_password.dart';
import '../pages/member_center/setting_page.dart';
import '../pages/search/search_page.dart';
import '../pages/search/search_result.dart';
import '../pages/eland/eland_list.dart';
import '../pages/article/article_detail.dart';
import '../pages/article/article_like_page.dart';
import '../pages/article/article_list_page.dart';
import '../pages/eland/eland_info.dart';
import '../pages/eland/eland_prayers_list_page.dart';
import '../pages/member_center/terms_of_use.dart';
import '../pages/eland/prayers_detail.dart';
import '../pages/member_center/edit_profile_page.dart';

import '../pages/article/comment_page.dart';

import '../pages/article/reply_comment.dart';
import '../pages/setdomain/setdomain.dart';

import '../pages/test_until/test_page1.dart';
import '../pages/test_until/test_page2.dart';

import '../pages/test_until/test_facebook_login.dart';
import '../pages/test_until/test_modeler.dart';

class Router {
  static final _routes = {
    /// TODO: 从非toolbar页面跳转到toolbar页面的入场动画不一致
    // 从非toolbar页面（子页面）跳转到toolbar页面（主页）实现：
    // pushName到对应的路由，因为Toolbar是单例模式，所以只会创建一个
    // pushName之后，在ToolBar，initState中获取当前的路由，实现切换页面
    '/': (BuildContext context, {Object? args}) => IntoApp(),
    '/not_network': (BuildContext context, {Object? args}) => NotNetwork(),
    '/index': (BuildContext context, {Object? args}) =>
        IndexPage(arguments: args),
    '/home': (BuildContext context, {Object? args}) =>
        IndexPage(arguments: args),
    '/today': (BuildContext context, {Object? args}) =>
        IndexPage(arguments: args),
    '/article': (BuildContext context, {Object? args}) =>
        IndexPage(arguments: args),
    '/membercenter': (BuildContext context, {Object? args}) =>
        IndexPage(arguments: args),
    '/eland_prayers': (BuildContext context, {Object? args}) =>
        ElandPrayersListPage(args: args is Map<dynamic, dynamic> ? args : {}),
    '/article_like': (BuildContext context, {Object? args}) =>
        ArticleLikePage(),
    '/article_list': (BuildContext context, {Object? args}) =>
        ArticleListPage(args: args is Map<dynamic, dynamic> ? args : {}),
    '/article_report': (BuildContext context, {Object? args}) =>
        ArticleReport(args: args is Map<dynamic, dynamic> ? args : {}),
    '/my_eland_list': (BuildContext context, {Object? args}) =>
        MyElandList(args: args is Map<dynamic, dynamic> ? args : {}),
    '/eland_list': (BuildContext context, {Object? args}) =>
        ElandList(args: args is Map<dynamic, dynamic> ? args : {}),
    '/eland_info': (BuildContext context, {Object? args}) =>
        ElandInfo(args: args is Map<dynamic, dynamic> ? args : {}),
    '/login_start': (BuildContext context, {Object? args}) => LoginStart(),
    '/login_mail': (BuildContext context, {Object? args}) => LoginMail(),
    '/register': (BuildContext context, {Object? args}) => RegisterPage(),
    '/edit_profile': (BuildContext context, {Object? args}) =>
        EditProfilePage(),
    '/bind_info': (BuildContext context, {Object? args}) => BindEmailOrPhone(
      type: args is Map<dynamic, dynamic> ? args['type'] : null,
    ),

    '/forgot_password': (BuildContext context, {Object? args}) =>
        ForgotPassword(args: args is Map<dynamic, dynamic> ? args : {}),
    '/setting': (BuildContext context, {Object? args}) => SettingPage(),
    '/search': (BuildContext context, {Object? args}) => SearchPage(),
    '/search_result': (BuildContext context, {Object? args}) =>
        SearchResult(args: args is Map<dynamic, dynamic> ? args : {}),
    '/article_detail': (BuildContext context, {Object? args}) =>
        ArticleDetail(args: args is Map<dynamic, dynamic> ? args : {}),
    '/terms_of_use': (BuildContext context, {Object? args}) => TermsOfUse(),
    '/prayers_detail': (BuildContext context, {Object? args}) =>
        PrayersDetail(args: args is Map<dynamic, dynamic> ? args : {}),
    '/comment_page': (BuildContext context, {Object? args}) =>
        CommentPage(args: args is Map<dynamic, dynamic> ? args : {}),
    '/reply_comment': (BuildContext context, {Object? args}) =>
        ReplyComment(args: args is Map<dynamic, dynamic> ? args : {}),
    '/setdomain': (BuildContext context, {Object? args}) => SetDomain(),

    '/testpage1': (BuildContext context, {Object? args}) => TestPage1(),
    '/testpage2': (BuildContext context, {Object? args}) => TestPage2(),
    '/test_facebook_login': (BuildContext context, {Object? args}) =>
        TestFacebookLogin(),
    // '/test_onesignal': (BuildContext context, { Object args }) => TestOnesignal(),
    //    '/menu': (BuildContext context, { Object args }) => Toolbar(arguments: args,),
    '/test_modeler': (BuildContext context, {Object? args}) =>
        TestModeler(args: args is Map<dynamic, dynamic> ? args : {}),
  };

  static final Router _singleton = Router._internal();
  Router._internal();

  factory Router() {
    return _singleton; //No need for null check
  }
  /*static Router? _singleton;

  Router._internal();

  factory Router() {
    return _singleton;
  }*/

  /// 监听route
  Route getRoutes(RouteSettings settings) {
    String routeName = settings.name!;
    final Function builder = Router._routes[routeName]!;

    print("getRoutes====>${routeName}<<<<<<<==========================");

    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        return builder(context, args: settings.arguments);
      },
    );
  }
}
