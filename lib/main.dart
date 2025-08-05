/*
* Alayluya 2.0
* rm -rf ios/Flutter/App.framework ios/Runner.xcworkspace ios/Pods && fvm flutter clean && fvm flutter pub get && cd ios/ && pod install
* flutter packages pub run build_runner watch
* flutter packages pub run build_runner build  --delete-conflicting-outputs
* https://material.io/resources/icons/?style=baseline
* https://www.flui.xin/guide.html
* flutter build apk --split-per-abi
* https://caijinglong.github.io/json2dart/index.html
* pod install --verbose --no-repo-update
* */

import 'dart:convert';
import 'dart:io';

//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
// import 'package:flui/flui.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './provider/do_like_method.dart';
import './provider/facebookProvider.dart';
import './routes/index.dart' as myRouter;
import './utils/global.dart';
import './utils/syncsdart';

final myRouter.Router router = myRouter.Router();

void main() async {
  // const MethodChannel('plugins.flutter.io/shared_preferences').setMockMethodCallHandler((MethodCall methodCall) async {
  //   if (methodCall.method == 'getAll') {
  //     return <String, dynamic>{}; // set initial values here if desired
  //   }
  //   return null;
  // });
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    print('ANDROID自动登陆开发中====>');
  } else {
    print('IOS自动登陆开发中====>');
  }
  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // await Syncs.getInstance();
  // SharedPreferences.setMockInitialValues({});

  SharedPreferences prefs = await SharedPreferences.getInstance();
  //  _shoppingCart = prefs.getString('shoppingCart');
  String user = prefs.getString('user');
  // G.oldApi = prefs.getBool('apiType') ?? true;
  //
  // if(G.oldApi == true){
  //   print('使用api類型=========使用舊版api');
  // }else{
  //   print('使用api類型=========使用新版api');
  // }

  //    print('user===>${json.decode(user)}');
  if (user.isNotEmpty) {
    /// 初始化user

    G.user.init(json.decode(user));
    G.isLogin = true;
  } else {
    G.isLogin = false;
  }

  String domain = prefs.getString('domain');
  //  prefs.setString('domain', null);
  if (domain.isNotEmpty) {
    G.isDev = true;
    G.baseurl = domain;
    // G.baseurl = 'http://testapi2.alayluya.com';
    print('G.baseurl======>${G.baseurl}');
    print('G.isDev======>${G.isDev}');
    print('G.isLogin======>${G.isLogin}');

    G.prdapi = G.baseurl + '/api';
  }

  print('G.prdapi=======>${G.prdapi}');

  // runApp(
  //     MyApp()
  // );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: FacebookProvider()),
        ChangeNotifierProvider.value(value: DoLikeMethod()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  //###Leo
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // FLToastDefaults _toastDefaults = FLToastDefaults();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //    final ShoppingCartModel _shoppingCartModel = Provider.of<ShoppingCartModel>(context);
    //
    //    if(_shoppingCart != null) {
    //      Map data = json.decode(_shoppingCart);
    //      _shoppingCartModel.init(data);
    //    }

    //  SystemChrome.setEnabledSystemUIOverlays([]);
    //  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.black);
    //  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarBrightness: Brightness.light,
      ),
    );
    //    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarBrightness: Brightness.dark));
    //    print("init====>");

    // return MultiProvider(
    //   providers: [
    //     Provider<FacebookProvider>.value(value: _facebook_provider),
    //   ],
    //   child:
    return RefreshConfiguration(
      headerTriggerDistance: 30.0,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: G.navigatorKey,
        title: 'Alayluya',
        theme: ThemeData(
          fontFamily: "yahei",
          appBarTheme: AppBarTheme(
            actionsIconTheme: IconThemeData(color: rgba(0, 0, 0, 0)),
            elevation: 0,
          ),
        ),
        //      initialRoute: '/into_app',
        initialRoute: '/',
        onGenerateRoute: router.getRoutes,
        //###Leo
        navigatorObservers: [MyApp.routeObserver],
        builder: (BuildContext context, Widget child) {
          return child;
          // return FLToastProvider(
          //     defaults: _toastDefaults,
          //     child: child
          // );
        },
      ),
    );
    // );
  }
}

//import 'pages/into_app.dart';
//import 'pages/index_page.dart';
//import 'pages/test_page1.dart';
//import 'pages/eland_info.dart';
//void main() => runApp(MyApp());
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      initialRoute: '/',
//      routes: <String, WidgetBuilder> {
//        '/': (BuildContext context) => ElandInfo(),
//        '/index_page': (BuildContext context) => IndexPage(),
//        '/into_app': (BuildContext context) => IntoApp(),
//        '/test_page1': (BuildContext context) => TestPage1(),
//      },
//    );
//  }
//}
