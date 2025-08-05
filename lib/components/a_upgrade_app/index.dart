import 'package:flutter/services.dart';

import '../../utils/syncs.dart';
//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../components/a_button/index.dart';
import '../../utils/global.dart';
import 'dart:io';
import 'package:launch_review/launch_review.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info/device_info.dart';

class AUpgradeApp {
  final BuildContext context;

  static String user_version='';
  static int user_version_int=0;
  static String apponline_android_version='';
  static int apponline_android_version_int = 0;
  static String apponline_ios_version = '';
  static int apponline_ios_version_int = 0;

  static Future<bool> getInstance() async {
    var systemInfo = Syncs.getSystemInfo;
    if(systemInfo == null){
      return false;
    }
    // 如果Android用户装了两个应用市场，这样有可能是不能跳转到google play的，这种情况怎样处理？
    // return true;

    if (Platform.isAndroid && (systemInfo['apponline_android_version'] == '--' || systemInfo['apponline_android_version'] == '')) {
      return false;
    }
    if (Platform.isIOS && (systemInfo['apponline_ios_version'] == '--' || systemInfo['apponline_ios_version'] == '')) {
      return false;
    }

    user_version = systemInfo['user_version'];
    user_version = user_version.replaceAll(RegExp(r'[\.\+\-]'), '');
    user_version_int = int.parse(user_version);

    if (Platform.isAndroid) {
      apponline_android_version = systemInfo['apponline_android_version'];
      apponline_android_version = apponline_android_version.replaceAll(RegExp(r'[\.\+\-]'), '');
      if(apponline_android_version == '') apponline_android_version = '0';
      apponline_android_version_int = int.parse(apponline_android_version);
      if(apponline_android_version_int > user_version_int) return true;
    } else {
      apponline_ios_version = systemInfo['apponline_ios_version'];
      apponline_ios_version = apponline_ios_version.replaceAll(RegExp(r'[\.\+\-]'), '');
      if(apponline_ios_version == '') apponline_ios_version = '0';
      apponline_ios_version_int = int.parse(apponline_ios_version);
      if(apponline_ios_version_int > user_version_int) return true;
    }
    return false;
  }

  static Future<void> goLaunch() async {
    var systemInfo = Syncs.getSystemInfo;
    if(systemInfo == null){
      return;
    }
    String show_version = '';
    if (Platform.isAndroid) {
      show_version = systemInfo['apponline_android_version'];
    } else {
      show_version = systemInfo['apponline_ios_version'];
    }
    if (Platform.isAndroid) {
      GooglePlayServicesAvailability playStoreAvailability;
      try {
        playStoreAvailability = await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability(false);
      } on PlatformException {
        playStoreAvailability = GooglePlayServicesAvailability.unknown;
      }

      // print('playStoreAvailability======>${playStoreAvailability}');
      // playStoreAvailability======>GooglePlayServicesAvailability.serviceInvalid

      DeviceInfoPlugin dip = new DeviceInfoPlugin();
      AndroidDeviceInfo dipInfo = await dip.androidInfo;
      // print('os1=====>${dipInfo.hardware}');
      // print('os2=====>${dipInfo.device}');
      // print('os3=====>${dipInfo.androidId}');
      // print('os4=====>${dipInfo.board}');
      // print('os5=====>${dipInfo.bootloader}');
      // print('os6=====>${dipInfo.brand}');
      // print('os7=====>${dipInfo.display}');
      // print('os8=====>${dipInfo.fingerprint}');
      // print('os9=====>${dipInfo.manufacturer}');
      // print('os10=====>${dipInfo.model}');

      if(dipInfo.manufacturer == 'HUAWEI' || playStoreAvailability == GooglePlayServicesAvailability.serviceInvalid || playStoreAvailability == GooglePlayServicesAvailability.unknown){
        //要到官网下载apk就可以了。
        // https://testapi2.alayluya.com/apk/alayluya-1.0.0+100.apk
        launch('${G.baseurl}/apk/alayluya-${show_version}.apk');
      }else{
        LaunchReview.launch(androidAppId: 'com.loopin.nepalayluya', iOSAppId: 'id1506175100');
      }
    }else{
      LaunchReview.launch(androidAppId: 'com.loopin.nepalayluya', iOSAppId: 'id1506175100');
    }
    return null;
  }

  AUpgradeApp.confirm(this.context) {
    var systemInfo = Syncs.getSystemInfo;
    if(systemInfo == null){
      return;
    }
    String show_version = '';
    if (Platform.isAndroid) {
      show_version = systemInfo['apponline_android_version'];
    } else {
      show_version = systemInfo['apponline_ios_version'];
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setDialogState) {
                return Dialog(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 24,horizontal: 15),
                            child: icon_info(size: 70,color: Colors.redAccent),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 24),

                            child: Text('新版本，${show_version}',
                              style: TextStyle(
                                color: rgba(153, 153, 153, 1),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border(top: BorderSide(color: rgba(242, 242, 242, 1)))
                            ),
                            child: Row(
                              children: <Widget>[
                                // 确认按钮
                                Container(

                                  child: Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(right: BorderSide(color: rgba(242, 242, 242, 1)))
                                      ),
                                      child: AButton.normal(
                                          child: Text('關閉'),
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                                          color: rgba(153, 153, 153, 1),
                                          onPressed: () async {
                                            print('alayluya-app-release=======>${G.baseurl}/apk/alayluya-${show_version}.apk');
                                            Navigator.pop(context);
                                          }
                                      ),
                                    ),

                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: AButton.normal(
                                        child: Text('升級'),
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                                        color: rgba(28, 141, 160, 1),
                                        onPressed: () async {
                                          await AUpgradeApp.goLaunch();
                                        }
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                );
              }
          );
        }
    );
  }
}
