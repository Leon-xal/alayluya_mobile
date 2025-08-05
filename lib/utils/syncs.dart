/*
* 用於異步轉同步
* */
import 'package:package_info_plus/package_info_plus.dart';
import '../utils/global.dart';

class Syncs{
  static PackageInfo packageInfo;
  static var getCateList;
  static var getSystemInfo = null;
  static Future<bool> getInstance() async{
    packageInfo = await PackageInfo.fromPlatform();
    getCateList = await G.req.article_cate.list(cateid: 0);
    String user_version = '${packageInfo.version}+${packageInfo.buildNumber}';
    var res = await G.req.setting.getSetting(user_version: '${user_version}');
    var data = res.data;
    getSystemInfo = data['data'];
    print('user_version===>${user_version}');
    print('getSystemInfo===>${getSystemInfo}');
    return true;
  }


}