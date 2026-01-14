import 'dart:convert';

import '../../components/a_web_view/index.dart';
//import 'package:color_dart/RgbaColor.dart';
//import 'package:flutter/material.dart';

import '../../model/user_model/data.dart';
import '../../utils/global.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:io';
//import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart';
//import 'package:notification_permissions/notification_permissions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; //Import flutter_local_notifications
import '../../config/config.dart';
import '../../utils/syncs.dart';
//import '../../components/a_dialog/index.dart';
//import '../../components/a_button/index.dart';

class OneSignalWapper {
  bool _requireConsent = true;
  //SharedPreferences? _prefs;
  String linkUrl = '';
  bool is_open_onesignal_push = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin(); // Initialize FlutterLocalNotificationsPlugin

  init() async {
    var systemInfo = Syncs.getSystemInfo;
    is_open_onesignal_push = (systemInfo == null)
        ? false
        : systemInfo['is_open_onesignal_push'];
    print('is_open_onesignal_push1======>${is_open_onesignal_push}');
    if (kOneSignalKey['appID'] != '' && is_open_onesignal_push == true) {
      // print("OneSignalWapper=======>${kOneSignalKey['appID']}");
      await _initializeNotifications(); // Initialize notifications before OneSignal setup
      await _setupOneSignal();
      /* Future.delayed(Duration.zero, () async {
        NotificationPermissions.getNotificationPermissionStatus().then((
          status,
        ) async {
          if (status == PermissionStatus.granted) {
            OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

            OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

            /*var settings = {
              OSiOSSettings.autoPrompt: false,
              OSiOSSettings.inAppLaunchUrl: false,
              OSiOSSettings.promptBeforeOpeningPushUrl: true,
            };*/
            // OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
            //   print("Received notification=======>: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}");
            // });

            OneSignal.shared.setNotificationOpenedHandler((
              OSNotificationOpenedResult result,
            ) {
              print(
                "Opened notification=======>: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}",
              );

              // print('Opened notification2=======>${result.notification.payload.rawPayload}');
              // print('Opened notification3=======>${result.notification.payload.rawPayload['custom']}');

              var custom = null;
              if (Platform.isAndroid) {
                custom = jsonDecode(result.notification.rawPayload!['custom']);
              } else {
                custom = result.notification.rawPayload!['custom'];
              }

              print('Opened notification4=======>${custom}');

              if (custom.containsKey('a')) {
                if (custom['a'].containsKey('article')) {
                  String title = custom['a']['article'];
                  String hrefVal =
                      'https://alayluya.com/article/' +
                      Uri.encodeComponent(title);
                  // print('hrefVal======>${hrefVal}');
                  AWebview.open(
                    G.getCurrentContext(),
                    url: hrefVal,
                    title: title,
                  );
                }
              }

              // G.getCurrentState().pushNamed('/entry');
              // G.getCurrentState().pushReplacementNamed('/entry');
              // G.pushNamed( '/article_detail',arguments: {'pushUrl':custom['u']});
            });

            OneSignal.shared.setInAppMessageClickedHandler((
              OSInAppMessageAction action,
            ) {
              print(
                "In App Message Clicked=======>: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}",
              );
            });

            OneSignal.shared.setSubscriptionObserver((
              OSSubscriptionStateChanges changes,
            ) {
              print(
                "SUBSCRIPTION STATE CHANGED=======>: ${changes.jsonRepresentation()}",
              );
            });

            OneSignal.shared.setPermissionObserver((
              OSPermissionStateChanges changes,
            ) {
              print(
                "PERMISSION STATE CHANGED=======>: ${changes.jsonRepresentation()}",
              );
            });

            OneSignal.shared.setEmailSubscriptionObserver((
              OSEmailSubscriptionStateChanges changes,
            ) {
              print(
                "EMAIL SUBSCRIPTION STATE CHANGED=======> ${changes.jsonRepresentation()}",
              );
            });

            await OneSignal.shared.setAppId(kOneSignalKey['appID']!);

            // NOTE: Replace with your own app ID from https://www.onesignal.com
            // await OneSignal.shared.init(kOneSignalKey['appID'], iOSSettings: settings);
            // OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

            // OneSignal.shared.consentGranted(false);
            bool requiresConsent = await OneSignal.shared
                .requiresUserPrivacyConsent();
            print('requiresConsent=====>${requiresConsent}');
            if (requiresConsent == true) {
              await OneSignal.shared.consentGranted(true);
            }

            // if (Platform.isIOS) {
            //   // OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
            //   //   print("Accepted permission=======>: $accepted");
            //   // });
            //   bool accepted = await OneSignal.shared.promptUserForPushNotificationPermission();
            //   print("Accepted permission=======>: ${accepted}");
            // }

            bool accepted = await OneSignal.shared
                .promptUserForPushNotificationPermission();
            print("Accepted permission=======>: ${accepted}");
            // if(accepted == false){ //強制用戶去開啟推送功能

            // }

            // Map<Permission, PermissionStatus> statuses = await [
            //   Permission.notification,
            // ].request();
            //
            // if (statuses[Permission.notification] == PermissionStatus.granted) {
            //   print('Permission.notification1===>${statuses[Permission.notification]}');
            // } else {
            //   print('Permission.notification2===>${statuses[Permission.notification]}');
            // }
          }
        });
      });*/
    }
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

  Future<void> _setupOneSignal() async {
    // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    // OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    // OneSignal.consentRequired(_requireConsent);
    //OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    // OneSignal.Notifications.addClickListener((OSNotificationClickEvent result) {
    //   // ... (Notification handling remains unchanged) ...
    //   print(
    //     "Opened notification=======>: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}",
    //   );

    // print('Opened notification2=======>${result.notification.payload.rawPayload}');
    // print('Opened notification3=======>${result.notification.payload.rawPayload['custom']}');

    //   var custom = null;
    //   if (Platform.isAndroid) {
    //     custom = jsonDecode(result.notification.rawPayload!['custom']);
    //   } else {
    //     custom = result.notification.rawPayload!['custom'];
    //   }
    //
    //   print('Opened notification4=======>${custom}');
    //
    //   if (custom.containsKey('a')) {
    //     if (custom['a'].containsKey('article')) {
    //       String title = custom['a']['article'];
    //       String hrefVal =
    //           'https://alayluya.com/article/' + Uri.encodeComponent(title);
    //       // print('hrefVal======>${hrefVal}');
    //       AWebview.open(G.getCurrentContext(), url: hrefVal, title: title);
    //     }
    //   }
    // });

    // ... (Other OneSignal handlers remain unchanged) ...
    /*OneSignal.setInAppMessageClickedHandler((
      OSInAppMessageAction action,
    ) {
      print(
        "In App Message Clicked=======>: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}",
      );
    });*/

    /*OneSignal.Notifications.addClickListener((
      OSSubscriptionStateChanges changes,
    ) {
      print(
        "SUBSCRIPTION STATE CHANGED=======>: ${changes.jsonRepresentation()}",
      );
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print(
        "PERMISSION STATE CHANGED=======>: ${changes.jsonRepresentation()}",
      );
    });

    OneSignal.shared.setEmailSubscriptionObserver((
      OSEmailSubscriptionStateChanges changes,
    ) {
      print(
        "EMAIL SUBSCRIPTION STATE CHANGED=======> ${changes.jsonRepresentation()}",
      );
    });*/

    //await OneSignal.shared.setAppId(kOneSignalKey['appID']!);
    // OneSignal.initialize(kOneSignalKey['appID']!);

    /*bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();
    print('requiresConsent=====>${requiresConsent}');
    if (requiresConsent == true) {*/
    // if (_requireConsent == true) {
    //   //await OneSignal.shared.consentGranted(true);
    //   await OneSignal.consentGiven(true);
    // }

    /*bool accepted = await OneSignal.shared
        .promptUserForPushNotificationPermission();
    print("Accepted permission=======>: ${accepted}");
  }*/
    // bool accepted = await OneSignal.Notifications.requestPermission(true);
    // print("Accepted permission=======>: ${accepted}");
  }
  /*loginInit() async {
    NotificationPermissions.getNotificationPermissionStatus().then((
      status,
    ) async {
      if (status == PermissionStatus.granted) {
        var systemInfo = Syncs.getSystemInfo;
        is_open_onesignal_push = (systemInfo == null)
            ? false
            : systemInfo['is_open_onesignal_push'];
        print('is_open_onesignal_push2======>${is_open_onesignal_push}');
        if (kOneSignalKey['appID'] != '' && is_open_onesignal_push == true) {
          // UserDataModel info = G.user.info;
          UserDataModel userData = G.user.data!;
          Future.delayed(Duration.zero, () async {
            print("External user id set1=======>: ${userData.id.toString()}");
            OneSignal.shared.setExternalUserId(userData.id.toString()).then((
              results,
            ) {
              print("External user id set2=======>: ${results}");
            });

            OneSignal.shared
                .setEmail(email: '${userData.email}')
                .whenComplete(() {
                  print("Successfully set email======>");
                })
                .catchError((error) {
                  print("Failed to set email with error======>: $error");
                });
            // OneSignal.shared.sendTag('email', '${userData.email}').then((response) {
            //   print("Successfully sent tags with response2===>: $response");
            // }).catchError((error) {
            //   print("Encountered an error sending tags===>: $error");
            // });
            // print('Successfully sent tags with response1===>: {"id":"${userData.id.toString()}","email":"${userData.email}"}');
            OneSignal.shared
                .sendTags({
                  "id": "${userData.id.toString()}",
                  "email": "${userData.email}",
                })
                .then((response) {
                  print("Successfully sent tags with response2===>: $response");
                })
                .catchError((error) {
                  print("Encountered an error sending tags===>: $error");
                });
            // await OneSignal.shared.getPermissionSubscriptionState().then((status) async {
            //   print("Getting permissionSubscriptionState_permissionStatus=======>: ${status.permissionStatus.status}");
            //   print("Getting permissionSubscriptionState_subscriptionStatus_subscribed=======>: ${status.subscriptionStatus.subscribed.toString()}");
            //   print("Getting permissionSubscriptionState_subscriptionStatus_userSubscriptionSetting=======>: ${status.subscriptionStatus.userSubscriptionSetting.toString()}");
            //   print("Getting permissionSubscriptionState_subscriptionStatus_pushToken=======>: ${status.subscriptionStatus.pushToken.toString()}");
            //   print("Getting permissionSubscriptionState_subscriptionStatus_userId=======>: ${status.subscriptionStatus.userId.toString()}");
            //   print("Getting permissionSubscriptionState_subscriptionStatus=======>: ${status.subscriptionStatus.subscribed.toString()}");
            //   print("Getting permissionSubscriptionState=======>: ${status.jsonRepresentation()}");
            //
            //   String deviceId = status.subscriptionStatus.userId;
            //
            //   print("deviceId=====>${deviceId}");
            //
            //   // String userId = G.userName;
            //   //
            //   // await Future.delayed(Duration.zero, () async {
            //   //   _prefs = await SharedPreferences.getInstance();
            //   //   _prefs.setString('_deviceId', deviceId);
            //   //   await G.req.user.onesignal_login_user(
            //   //     deviceId: deviceId,
            //   //     userId: userId,
            //   //   ).then((res){
            //   //     print('onesignal_init_user1====>${res}');
            //   //
            //   //     Map result = res.data;
            //   //
            //   //     if(result['status'] == 200){
            //   //       print('onesignal_update_user success=====>');
            //   //     }else{
            //   //       G.toast('Push authorization failed');
            //   //     }
            //   //   });
            //   // });
            // });
          });
        }
      }
    });
  }*/

  loginInit() async {
    var systemInfo = Syncs.getSystemInfo;
    is_open_onesignal_push = (systemInfo == null)
        ? false
        : systemInfo['is_open_onesignal_push'];
    print('is_open_onesignal_push2======>${is_open_onesignal_push}');
    if (kOneSignalKey['appID'] != '' && is_open_onesignal_push == true) {
      UserDataModel? userData = G.user.data!;
      Future.delayed(Duration.zero, () async {
        print("External user id set1=======>: ${userData.id.toString()}");
        /*OneSignal.shared.setExternalUserId(userData.id.toString()).then((
          results,
        )*/
        // OneSignal.login(userData.id.toString()).then((results) {
        //   // print("Successfully set external user id
        //   //print("External user id set2=======>: ${results}");
        // });

        // ... (Email and tag setting remains unchanged) ...
      });
    }
  }

  logout() async {}
}
