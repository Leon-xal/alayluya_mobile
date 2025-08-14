import 'dart:async';
import 'package:dio/dio.dart';
//import 'package:flutter/material.dart';
import '../utils/global.dart';

/// 用户管理相关
class ReqUser {
  final Dio _dio;

  ReqUser(this._dio);

  /// 登录
  Future<Response> login({
    /// 邮箱
    String? email,

    /// 密码
    String? pwd,
  }) {
    return _dio.post(
      G.prdapi + '/login',
      //        '/login',
      queryParameters: {"email": email, "password": pwd},
    );
  }

  /// 登录
  Future<Response> loginByMobile({
    /// 邮箱
    String? phone,

    /// 密码
    String? pwd,
  }) {
    return _dio.post(
      G.prdapi + '/login-by-mobile',
      //        '/login',
      queryParameters: {"mobile": phone, "password": pwd},
    );
  }

  /// 用Apple登录
  Future<Response> loginByApple({
    String? apple_id,
    String? first_name,
    String? last_name,
    String? apple_token,
    String? email,
  }) {
    return _dio.post(
      G.prdapi + '/login-by-apple',
      queryParameters: {
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "apple_id": apple_id,
        "apple_token": apple_token,
      },
    );
  }

  /// 用Facebook登录
  Future<Response> loginByFacebook({
    String? name,
    String? first_name,
    String? last_name,
    String? facebookid,
    String? facebook_token,
    String? email,
  }) {
    return _dio.post(
      G.prdapi + '/login-by-facebook',
      queryParameters: {
        "name": name,
        "first_name": first_name,
        "last_name": last_name,
        "facebookid": facebookid,
        "facebook_token": facebook_token,
        "email": email,
      },
    );
  }

  /// 註冊
  Future<Response> register({
    String? firstname,
    String? lastname,
    String? email,
    String? password,
    String? repassword,
  }) {
    return _dio.post(
      G.prdapi + '/register',
      //        '/register',
      queryParameters: {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "password": password,
        "repassword": repassword,
      },
    );
  }

  /// 用手機註冊
  Future<Response> registerByMobile({
    String? firstname,
    String? lastname,
    String? phone,
    String? phoneCode,
    String? password,
    String? repassword,
    String? sid,
  }) {
    return _dio.post(
      G.prdapi + '/registermobile',
      queryParameters: {
        "sid": sid,
        "sms": phoneCode,
        "mobile": phone,
        "firstname": firstname,
        "surname": lastname,
        "password": password,
        "password_confirmation": repassword,
      },
    );
  }

  /// 註冊获取验证码
  Future<Response> registermobileverify({String? phone}) {
    print('registermobileverify1====>${G.prdapi + '/registermobileverify'}');
    print('registermobileverify2====>${phone}');
    return _dio.post(
      G.prdapi + '/registermobileverify',
      //        '/register',
      queryParameters: {"mobile": phone},
    );
  }

  /// 忘记email密码
  Future<Response> forgot({String? email}) {
    return _dio.post(
      G.prdapi + '/forgot',
      //        '/forgot',
      queryParameters: {"email": email},
    );
  }

  /// 註冊获取验证码
  Future<Response> forgotmobileverify({String? phone}) {
    print('registermobileverify1====>${G.prdapi + '/registermobileverify'}');
    print('registermobileverify2====>${phone}');
    return _dio.post(
      G.prdapi + '/forgotmobileverify',
      //        '/register',
      queryParameters: {"mobile": phone},
    );
  }

  ///忘记手机密码
  Future<Response> forgotMobile({
    String? phone,
    String? phoneCode,
    String? password,
    String? sid,
  }) {
    return _dio.post(
      G.prdapi + '/forgotmobile',
      //        '/forgot',
      queryParameters: {
        "sid": sid,
        "sms": phoneCode,
        "mobile": phone,
        "password": password,
      },
    );
  }

  /// 获取用户详情
  Future<Response> detail({
    /// 用戶ID
    int? id,
  }) {
    return _dio.post(G.prdapi + '/user-detail', queryParameters: {"id": id});
  }

  /// 修改账号信息
  Future<Response> edit_profile({
    /// 用戶ID
    int? id,
    String? firstname,
    String? lastname,
    String? nickname,
  }) {
    print('id=======>${id}');
    print('firstname=======>${firstname}');
    print('lastname=======>${lastname}');
    print('nickname=======>${nickname}');
    return _dio.post(
      G.prdapi + '/edit-profile',
      queryParameters: {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "nickname": nickname,
      },
    );
  }

  /// 去關注祈祷文章的用户
  Future<Response> do_follow_user({int? userid, int? f_userid}) {
    //    print('elanddofollow-elandid======>${eland_id}');
    //    print('elanddofollow-userid======>${userid}');
    return _dio.post(
      G.prdapi + '/do-follow-user',
      queryParameters: {'user_id': userid, 'f_user_id': f_userid},
    );
  }

  //   Future<Response> get_user_info_by_facebook({
  //     @required String token,
  //   }) {
  // //    print('elanddofollow-elandid======>${eland_id}');
  // //    print('elanddofollow-userid======>${userid}');
  //     return _dio.get(
  //         'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token='+token,
  //     );
  //   }
}
