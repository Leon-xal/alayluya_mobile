import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model/data.dart';

class User {
  UserDataModel? _user;

  /// 获取user
  UserDataModel? get data => _user;

  SharedPreferences? _prefs;

  init(Map userJson) async {
    try {
      //      print('userJson=====>${userJson}');
      _user = UserDataModel.fromJson(userJson as Map<String, dynamic>);
      //      print('_user=====>${_user.toJson()}');
    } catch (e) {
      return print('user init error, msg: $e');
    }

    await setString(userJson);

    return _user;
  }

  /// 保存到本地缓存
  setString(Map userJson) async {
    _prefs = await SharedPreferences.getInstance();
    //    print('userJson=====>${userJson}');
    //    print('userJsonEncode=====>${json.encode(userJson)}');
    _prefs!.setString('user', json.encode(userJson));
  }
}
