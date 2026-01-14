//import '../../components/a_upgrade_app/index.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
//import 'package:connectivity_plus/connectivity.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';
import './not_network.dart';
import './index_page.dart';
import '../login/login_start.dart';
import '../../utils/global.dart';
import '../../utils/syncs.dart';
import '../../components/onesignal_wapper/onesignal_wapper.dart';
//import '../../components/a_dialog/index.dart';
//import 'package:notification_permissions/notification_permissions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import flutter_local_notifications

//import 'package:connectivity/connectivity.dart';

class IntoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //        appBar: AppBar(title: Text('Awana'),automaticallyImplyLeading: false),
      body: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key? key}) : super(key: key);
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // Initialize FlutterLocalNotificationsPlugin

  late AnimationController
  _controller; //AnimationController是Animation的一个子类，它可以控制Animation，可以控制动画的时间，类型，过渡3曲线
  late Animation<double> _animation;
  bool _networkAvailable = false;

  Future<void> _checkNetworkAvailability() async {
    final hasNetwork = await G.isHasNetwork();
    setState(() {
      _networkAvailable = hasNetwork;
    });
    if (_networkAvailable) {
      _animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _navigateToAppropriateScreen();
        }
      });
    } else {
      _navigateToNotNetworkScreen();
    }
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _checkNetworkAvailability();
    _initializeNotifications(); // Initialize notifications
    //上面两行代码表示初始化一个Animation控制器， vsync垂直同步，动画执行时间3000毫秒,然后我们设置一个Animation动画，使用上面设置的控制器

    // _animation.addStatusListener((status) async {
    //   if(status == AnimationStatus.completed){
    //     bool result = await Syncs.getInstance();
    //     if(result == true){
    //       OneSignalWapper()..init();
    //       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
    //         if(G.isLogin == true){
    //           return IndexPage();
    //         }else{
    //           return LoginStart();
    //         }
    //       }),(route) => route == null);
    //     }
    //   }
    // });

    /*Future.delayed(Duration.zero, () async {
      G.isHasNetwork(
        onCallback: (hasNetwork) async {
          // print('onCallback====>${hasNetwork}');
          if (hasNetwork == true) {
            //监听动画运行状态，当状态为completed时，动画执行结束，跳转首页
            _animation.addStatusListener((status) async {
              if (status == AnimationStatus.completed) {
                await Syncs.getInstance();
                // bool is_upgrade = await AUpgradeApp.getInstance();
                // // is_upgrade = true;
                // if(is_upgrade == true){
                //   AUpgradeApp.confirm(context);
                // }else{
                //这里最好提示下再让用户去授权
                await _initializeNotifications(); // Call the new initialization function
                await _goToLink();
                /*await NotificationPermissions.gettatus()
                    .then((status) async {
                      // print('status1=======>${status}');
                      if (status == PermissionStatus.denied ||
                          status == PermissionStatus.unknown) {
                        ADialog.confirm(
                          context,
                          content: '請在系統設定開啟應用通知',
                          cancelButtonPress: () async {
                            await _goToLink();
                          },
                          confirmButtonPress: () {
                            NotificationPermissions.requestNotificationPermissions(
                              iosSettings: const NotificationSettingsIos(
                                sound: true,
                                badge: true,
                                alert: true,
                              ),
                            ).then((permissionStatus) {
                              // when finished, check the permission status
                              print('status2=======>${permissionStatus}');
                              // OneSignalWapper()..init();
                            });
                          },
                        );
                      } else {
                        await _goToLink();
                      }
                    });*/
                // }
              }
            });
          } else {
            // Navigator.pushNamedAndRemoveUntil(context, "/not_network", (route) => true);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) {
                  return NotNetwork();
                },
              ),
              (route) => true,
            );
          }
        },
      );
    });*/

    _controller.forward(); // 播放动画
  }

  @override
  void dispose() {
    _controller.dispose(); //释放动画
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        //在這裏，我又回來了
        print('应用程序可见并响应用户输入====>');
        Future.delayed(Duration.zero, () async {
          await Syncs.getInstance();
          await _goToLink();
        });
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
        //   if(G.isLogin == true){
        //     return IndexPage();
        //   }else{
        //     return LoginStart();
        //   }
        // }),(route) => route == null);
        break;
      case AppLifecycleState.inactive:
        print('应用程序处于非活动状态，并且未接收用户输入====>');
        break;
      case AppLifecycleState.paused:
        print('用户当前看不到应用程序，没有响应====>');
        break;
      case AppLifecycleState.detached:
        print('应用程序将detached=====>');
        break;
      default:
    }
  }

  Future<void> _navigateToAppropriateScreen() async {
    try{
      print("G.isLogin111: ${G.isLogin}");
      await Syncs.getInstance();
      // Add any upgrade check here if needed
      print("G.isLogin: ${G.isLogin}");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => G.isLogin ? IndexPage() : LoginStart(),
        ),
            (route) => false, // Remove all previous routes
      );
    } catch(err){
      log('init error :::::::::: $err');
    }

  }

  void _navigateToNotNetworkScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => NotNetwork()),
      (route) => false, // Remove all previous routes
    );
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        ); // Replace with your app icon

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _goToLink() async {
    OneSignalWapper()..init();
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) {
          if (G.isLogin == true) {
            return IndexPage();
          } else {
            return LoginStart();
          }
        },
      ),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      //透明度动画组件
      opacity: _animation, //动画
      //      child: ConstrainedBox(
      //        constraints: BoxConstraints.expand(),
      //        child: new Image.asset(
      //          "lib/assets/images/bg.jpg",
      //          fit: BoxFit.fill,
      //        ),
      //      ),
      child: Stack(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: new Image.asset(
              "lib/assets/images/bg.jpg",
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: G.screenHeight() / 8.5,
            child: Container(
              width: G.screenWidth(),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                child: new Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 50, right: 50),
                      child: Image.asset(
                        './lib/assets/images/logo-w.png',
                        width: 250,
                        fit: BoxFit.contain,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 30),
                      padding: EdgeInsets.only(left: 50, right: 50),
                      alignment: Alignment.center,
                      // A Simple way to pray,support,and stay connected with your Christian community.
                      child: Text(
                        '讓你分享勵志文章、見證影音、呼籲代禱及結連互助的社交平台。',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
