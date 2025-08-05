import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/global.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookProvider extends ChangeNotifier {
  SharedPreferences _prefs;

  // static final FacebookLogin facebookSignIn = new FacebookLogin();
  // FacebookLogin facebookSignIn = null;

  bool _isFacebookLogin = false;
  String _message;

  bool get isFacebookLogin => _isFacebookLogin;
  String get message => _message;

  FacebookProvider() {
    // print('FacebookProvider======>init/${facebookSignIn}');
    // if(facebookSignIn == null){
    //   facebookSignIn = new FacebookLogin();
    //   // print('FacebookProvider======>init2/${facebookSignIn}');
    // }
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
      _isFacebookLogin =
          (_prefs.getBool('isFacebookLogin') == false ||
              _prefs.getBool('isFacebookLogin') == null)
          ? false
          : true;
      // print('FacebookProvider======>init3/${_isFacebookLogin}');
    });
  }

  Future<bool> loginByFacebook() async {
    final result = await FacebookAuth.instance.login(permissions: ['email']);
    print('result======>${result}');
    print('result.status======>${result.status}');
    if (result.status == LoginStatus.success) {
      Map<String, dynamic> profile = await FacebookAuth.instance.getUserData(
        fields: "name,first_name,last_name,email",
      );
      final AccessToken accessToken = result.accessToken;
      Map<String, dynamic> accessTokenJson = accessToken.toJson();
      // print('AccessToken=========>${accessTokenJson['token']}');
      // print('name=========>${profile['name']}');
      // print('email=========>${profile['email']}');
      // print('first_name=========>${profile['first_name']}');
      // print('last_name=========>${profile['last_name']}');
      // print('id=========>${profile['id']}');
      // print('_userData=========>${profile}');

      var res = await G.req.user.loginByFacebook(
        name: profile['name'],
        first_name: profile['first_name'],
        last_name: profile['last_name'],
        facebookid: profile['id'],
        facebook_token: accessTokenJson['token'],
        email: profile['email'],
      );

      print('loginByFacebook1=====>${res}');

      var data = res.data;
      // print('loginByFacebook2=====>${data['data']['id']}');
      if (data == null) {
        _isFacebookLogin = false;
        _message = '登錄失敗';
        notifyListeners();
        return false;
      } else {
        if (data['data']['id'] == -1) {
          _isFacebookLogin = false;
          _message = data['msg'];
          print('loginByFacebook3=====>${data['msg']}');
          notifyListeners();
          return false;
        } else {
          await getUserDetail(data['data']['id']);
          _isFacebookLogin = true;
          _message = '登錄成功';
          _prefs.setBool('isFacebookLogin', true);
          notifyListeners();
          return true;
        }
      }
    } else {
      _isFacebookLogin = false;
      _message = '登錄失敗';
      print('FacebookLoginStatus.cancelledByUser=====>${_message}');
      notifyListeners();
      return false;
    }
    // _isFacebookLogin = false;
    // _message = '登錄成功???';
    // notifyListeners();
    // return false;

    // final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    // final facebookLogin = FacebookLogin();
    // final result = await facebookLogin.logIn(['email']);
    // print('result.status=====>${result.status}');
    // switch (result.status) {
    //   case FacebookLoginStatus.loggedIn:
    //     final FacebookAccessToken accessToken = result.accessToken;
    //     print('''
    //      Logged in!
    //
    //      Token: ${accessToken.token}
    //      User id: ${accessToken.userId}
    //      Expires: ${accessToken.expires}
    //      Permissions: ${accessToken.permissions}
    //      Declined permissions: ${accessToken.declinedPermissions}
    //      ''');
    //
    //     String token = accessToken.token;
    //     // await Future.delayed(Duration(milliseconds: 4000));
    //     try {
    //       var response = await Dio().get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token='+token);
    //       // var response = await Dio().get('https://graph.facebook.com/v2.12/me?fields=email&access_token='+token);
    //       var profile = jsonDecode(response.toString());
    //       print('''
    //       profile!
    //
    //       name: ${profile['name']}
    //       first_name: ${profile['first_name']}
    //       last_name: ${profile['last_name']}
    //       email: ${profile['email']}
    //       id: ${profile['id']}
    //       ''');
    //
    //       var res = await G.req.user.loginByFacebook(
    //         name: profile['name'],
    //         first_name: profile['first_name'],
    //         last_name: profile['last_name'],
    //         facebookid: profile['id'],
    //         facebook_token: token,
    //         email: profile['email'],
    //       );
    //
    //       print('loginByFacebook1=====>${res}');
    //
    //       var data = res.data;
    //       print('loginByFacebook2=====>${data['data']['id']}');
    //       if(data == null) {
    //         _isFacebookLogin = false;
    //         _message = '登錄失敗';
    //         notifyListeners();
    //         return false;
    //       }else{
    //         if(data['data']['id'] == -1){
    //           _isFacebookLogin = false;
    //           _message = data['msg'];
    //           print('loginByFacebook3=====>${data['msg']}');
    //           notifyListeners();
    //           return false;
    //         }else{
    //           await getUserDetail(data['data']['id']);
    //           _isFacebookLogin = true;
    //           _message = '登錄成功';
    //           _prefs.setBool('isFacebookLogin', true);
    //           notifyListeners();
    //           return true;
    //         }
    //       }
    //     } catch(e) {
    //       print('eee=====>${e}');
    //       _isFacebookLogin = false;
    //       _message = '登錄失敗';
    //       notifyListeners();
    //       return false;
    //     }
    //     break;
    //   case FacebookLoginStatus.cancelledByUser:
    //     _isFacebookLogin = false;
    //     _message = 'Login cancelled by the user.';
    //     print('FacebookLoginStatus.cancelledByUser=====>${_message}');
    //     notifyListeners();
    //     return false;
    //     break;
    //   case FacebookLoginStatus.error:
    //     _isFacebookLogin = false;
    //     _message = 'Something went wrong with the login process.\n'
    //         'Here\'s the error Facebook gave us: ${result.errorMessage}';
    //     print('FacebookLoginStatus.error=====>${_message}');
    //     notifyListeners();
    //     return false;
    //     break;
    // }
  }

  getUserDetail(int userid) async {
    var res = await G.req.user.detail(id: userid);

    Map data = res.data;
    //    print('data=====>${data}');
    //    Map json = data['data'];
    Map<dynamic, dynamic> json = data['data'];
    //    print('json=====>${json}');
    //    json['token'] = token;
    //    print('getUserDetail=====>${json}');
    G.user.init(json);
  }

  Future<bool> logoutByFacebook() async {
    _prefs.remove('isFacebookLogin');
    _isFacebookLogin = false;
    _message = 'Logout';
    // await facebookSignIn.logOut();
    await FacebookAuth.instance.logOut();
    notifyListeners();
    return true;
  }
}
