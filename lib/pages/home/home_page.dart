import '../../components/a_button/index.dart';
//import 'package:color_dart/HexColor.dart';
//import 'package:color_dart/RgbaColor.dart';
// import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/a_upgrade_app/index.dart';
import '../../components/a_eland_dynamic/index.dart';
import '../../components/a_eland_card/index.dart';
import '../../model/user_model/data.dart';
import '../../utils/global.dart';
import '../../utils/syncs.dart';
import '../../main.dart';
import 'dart:io';
//import 'package:launch_review_latest/launch_review_latest.dart';
//import 'package:device_info_plus/device_info_plus.dart';

class HomePage extends StatefulWidget {
  static _HomePageState? _homePageState;

  HomePage() {
    _homePageState = _HomePageState();
  }

  getAppBar() => _homePageState?.createAppBar();

  _HomePageState createState() => _HomePageState();
}

// class _HomePageState extends State<HomePage> {
//###Leo
class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, RouteAware {
  @override
  bool get wantKeepAlive => true;

  ///see AutomaticKeepAliveClientMixin

  SharedPreferences? prefs;

  int userid = 0;
  bool is_upgrade = false;
  String show_version_msg = '';

  @override
  void initState() {
    super.initState();
    // print('home======>');
    UserDataModel userData = G.user.data;
    userid = userData.id ?? 0;

    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      var systemInfo = Syncs.getSystemInfo;
      bool tmp_is_upgrade = await AUpgradeApp.getInstance();

      setState(() {
        is_upgrade = tmp_is_upgrade;
        // is_upgrade = true;
        // print('is_upgrade===========>${is_upgrade}');
        if (systemInfo != null) {
          if (Platform.isAndroid) {
            show_version_msg = systemInfo['apponline_android_version_msg'];
          } else {
            show_version_msg = systemInfo['apponline_ios_version_msg'];
          }
        }
      });
    });
  }

  //###Leo
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic>) {
      MyApp.routeObserver.subscribe(this, route);
    } else {
      // Handle the case where route is null or not a PageRoute
      print('Route is not a PageRoute'); // Or handle it more robustly
    }
  }

  //###Leo
  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
    // print("再次返回頁面");
  }

  @override
  void dispose() {
    super.dispose();
  }

  AppBar createAppBar() {
    return customAppbar(title: 'Alayluya', default_actions: true);
  }

  @override
  Widget build(BuildContext context) {
    //    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarBrightness: Brightness.light));
    //    return Text('123');
    super.build(context);
    return AElandDynamic(
      isshowcenterload: true,
      uid: userid,
      topchild: Container(
        // height: 180,
        height: (is_upgrade == true) ? 227 : 177,
        child: Column(
          children: [
            if (is_upgrade == true)
              Container(
                color: Colors.deepOrange,
                // color: hex("#F48F36FF"),
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 15,
                  right: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${show_version_msg}'),
                    AButton.normal(
                      width: 70,
                      height: 25,
                      borderColor: Color.fromARGB(255, 28, 141, 160),
                      bgColor: Color(0xffffffff),
                      plain: true,
                      child: Text(
                        '查看',
                        style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 13,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(40),
                      // icon: icon_favorite(size: 13,color: hex('#fff')),
                      onPressed: () async {
                        // AUpgradeApp.confirm(context);
                        await AUpgradeApp.goLaunch();
                        // if (Platform.isAndroid) {
                        //   GooglePlayServicesAvailability playStoreAvailability;
                        //   try {
                        //     playStoreAvailability = await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability(false);
                        //   } on PlatformException {
                        //     playStoreAvailability = GooglePlayServicesAvailability.unknown;
                        //   }
                        //
                        //   // print('playStoreAvailability======>${playStoreAvailability}');
                        //   // playStoreAvailability======>GooglePlayServicesAvailability.serviceInvalid
                        //
                        //   DeviceInfoPlugin dip = new DeviceInfoPlugin();
                        //   AndroidDeviceInfo dipInfo = await dip.androidInfo;
                        //   // print('os1=====>${dipInfo.hardware}');
                        //   // print('os2=====>${dipInfo.device}');
                        //   // print('os3=====>${dipInfo.androidId}');
                        //   // print('os4=====>${dipInfo.board}');
                        //   // print('os5=====>${dipInfo.bootloader}');
                        //   // print('os6=====>${dipInfo.brand}');
                        //   // print('os7=====>${dipInfo.display}');
                        //   // print('os8=====>${dipInfo.fingerprint}');
                        //   // print('os9=====>${dipInfo.manufacturer}');
                        //   // print('os10=====>${dipInfo.model}');
                        //
                        //   if(dipInfo.manufacturer == 'HUAWEI' || playStoreAvailability == GooglePlayServicesAvailability.serviceInvalid || playStoreAvailability == GooglePlayServicesAvailability.unknown){
                        //     //要到官网下载apk就可以了。
                        //     // https://testapi2.alayluya.com/apk/alayluya-1.0.0+100.apk
                        //     launch('${G.baseurl}/apk/alayluya-${show_version}.apk');
                        //   }else{
                        //     LaunchReview.launch(androidAppId: 'com.loopin.nepalayluya', iOSAppId: 'id1506175100');
                        //   }
                        // }else{
                        //   LaunchReview.launch(androidAppId: 'com.loopin.nepalayluya', iOSAppId: 'id1506175100');
                        // }
                      },
                    ),
                  ],
                ),
              ),
            // FLNoticeBar.notice(
            //   height: 50,
            //   suffixBuilder: (BuildContext context) {
            //     return AButton.normal(
            //         width: 70,height: 25,borderColor: rgba(28, 141, 160, 1),bgColor: hex('#fff'),plain: true,
            //         child: Text('查看', style: TextStyle(
            //             color: hex('#333'),
            //             fontSize: 13
            //         ),),
            //         borderRadius: BorderRadius.circular(40),
            //         // icon: icon_favorite(size: 13,color: hex('#fff')),
            //         onPressed: () async {
            //           // AUpgradeApp.confirm(context);
            //           await AUpgradeApp.goLaunch();
            //           // if (Platform.isAndroid) {
            //           //   GooglePlayServicesAvailability playStoreAvailability;
            //           //   try {
            //           //     playStoreAvailability = await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability(false);
            //           //   } on PlatformException {
            //           //     playStoreAvailability = GooglePlayServicesAvailability.unknown;
            //           //   }
            //           //
            //           //   // print('playStoreAvailability======>${playStoreAvailability}');
            //           //   // playStoreAvailability======>GooglePlayServicesAvailability.serviceInvalid
            //           //
            //           //   DeviceInfoPlugin dip = new DeviceInfoPlugin();
            //           //   AndroidDeviceInfo dipInfo = await dip.androidInfo;
            //           //   // print('os1=====>${dipInfo.hardware}');
            //           //   // print('os2=====>${dipInfo.device}');
            //           //   // print('os3=====>${dipInfo.androidId}');
            //           //   // print('os4=====>${dipInfo.board}');
            //           //   // print('os5=====>${dipInfo.bootloader}');
            //           //   // print('os6=====>${dipInfo.brand}');
            //           //   // print('os7=====>${dipInfo.display}');
            //           //   // print('os8=====>${dipInfo.fingerprint}');
            //           //   // print('os9=====>${dipInfo.manufacturer}');
            //           //   // print('os10=====>${dipInfo.model}');
            //           //
            //           //   if(dipInfo.manufacturer == 'HUAWEI' || playStoreAvailability == GooglePlayServicesAvailability.serviceInvalid || playStoreAvailability == GooglePlayServicesAvailability.unknown){
            //           //     //要到官网下载apk就可以了。
            //           //     // https://testapi2.alayluya.com/apk/alayluya-1.0.0+100.apk
            //           //     launch('${G.baseurl}/apk/alayluya-${show_version}.apk');
            //           //   }else{
            //           //     LaunchReview.launch(androidAppId: 'com.loopin.nepalayluya', iOSAppId: 'id1506175100');
            //           //   }
            //           // }else{
            //           //   LaunchReview.launch(androidAppId: 'com.loopin.nepalayluya', iOSAppId: 'id1506175100');
            //           // }
            //         }
            //     );
            //   },
            //   text: '${show_version_msg}',
            //   velocity: 1,
            //   loop: false,
            //   delay: Duration(hours: 24),
            // ),
            AElandCard(uid: userid),
          ],
        ),
      ),
    );
  }
}
