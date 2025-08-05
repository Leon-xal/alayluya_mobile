import 'package:flutter/cupertino.dart';
import '../../components/a_web_view/index.dart';
import '../../provider/facebookProvider.dart';
//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:url_launcher/url_launcher.dart';
import '../../components/a_row/index.dart';
//import '../components/a_web_view/index.dart';
import '../../components/a_dialog/index.dart';
import '../../components/a_cached_network_image/index.dart';
import '../../model/user_model/data.dart';
import '../../utils/Icon.dart';
import '../../utils/global.dart';

//import '../pages/login_start.dart';

class MemberCenter extends StatefulWidget {
  static _MemberCenterState _memberCenterState;

  MemberCenter() {
    _memberCenterState = _MemberCenterState();
  }

  getAppBar() => _memberCenterState.createAppBar();

  _MemberCenterState createState() => _MemberCenterState();
}

// class _MemberCenterState extends State<MemberCenter> {
class _MemberCenterState extends State<MemberCenter> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; ///see AutomaticKeepAliveClientMixin

  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async{
      prefs = await SharedPreferences.getInstance();
      print('G.user.data===>${G.user.data}');
      if(G.user.data == null){
        prefs.remove('user');
        prefs.remove('domain');
        G.isLogin = false;
        await Provider.of<FacebookProvider>(context,listen: false).logoutByFacebook();
        Navigator.of(context).pushReplacementNamed('/login_start');
      }
      // print('G.user.data.telv====>${G.user.data.telv}');
      // print('G.user.data.emailv===>${G.user.data.emailv}');
      // print('G.user.data.avatar===>${G.user.data.avatar}');

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loginOut(){
    ADialog.confirm(context,
        content: '確認退出？',
        confirmButtonPress: () async {
          print('logout====>,${Provider.of<FacebookProvider>(context,listen: false).isFacebookLogin}');
          prefs.remove('user');
          prefs.remove('domain');
          G.isLogin = false;
          await Provider.of<FacebookProvider>(context,listen: false).logoutByFacebook();
          G.toast('退出成功');
          Navigator.of(context).pushReplacementNamed('/login_start');
        }
    );
  }

  // Future switchApi(bool apiType) async {
  //   SharedPreferences _pref = await SharedPreferences.getInstance();
  //   await _pref.setBool('apiType', apiType);
  //   G.toast('切換成功，請重啟app');
  // }


  ARow buildUser() {
    UserDataModel userData = G.user.data;
    return ARow(
      height: 55,
      color: Colors.transparent,
      border: G.borderBottom(show: false),
      padding: EdgeInsets.all(0),
      leftChild: InkWell(
        child: (userData.avatar == '' || userData.avatar == null) ? ClipRRect(
          borderRadius: new BorderRadius.circular(30),
          child: Image.asset(
            'lib/assets/images/logo.jpg',
            width: 55,
            height: 55,
            fit: BoxFit.cover,
          )
        ) :
        (userData.avatar.contains('img/default_profile.png'))?
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
          ),
          width:55,
          height:55,
          child: AcachedNetworkImage(
            userData.avatar,
            fit: BoxFit.cover,
            // height: 55,
            // width: 55,
            // borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
          ),
        ):ClipRRect(
          borderRadius: new BorderRadius.circular(30),
          child: AcachedNetworkImage(
            userData.avatar,
            fit: BoxFit.fill,
            height: 55,
            width: 55,
          ),
        ),
        onTap: (){
          print('onTap=====>${userData.avatar}');
          // G.toast('請在官網修改頭像');
          G.pushNamed('/edit_profile');
        },
      ),

      centerChild: Container(
        margin: EdgeInsets.only(left: 10),
        child: Text(userData.DisplayName == null ? '' : userData.DisplayName, style: TextStyle(
            color: rgba(255, 255, 255, 1),
            fontSize: 18
        ),),
      ),
//      rightChild: icon_right(size: 25, color: rgba(255,255,255,1)),
      onPressed: () {
        if(userData == null) return G.pushNamed('/login_start');
      },
    );
  }
  AppBar createAppBar() {
    return null;
  }
  @override
  Widget build(BuildContext context) {
//    return Text('member');
//     G.user.data.email = 'AlfredLee90@foxmailaassasddasdasd.com';
    return SingleChildScrollView(
      child: Container(
        color: hex('#fff'),
        child: Column(children: <Widget>[
          // 头部
          Container(
            alignment: Alignment.centerLeft,
            height: 180,
            color: rgba(28, 141, 160, 1),
            padding: EdgeInsets.only(left: 20, right: 20,top: 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(bottom: 20,top:20),
//                    child: icon_member(size: 24, color: rgba(255,255,255,.9))
                ),

                buildUser(),
              ],
            ),
          ),

          Container(
            color: hex('#fff'),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: <Widget>[
                ///判斷是否綁定email
                // Text('${G.user.data.emailv}'),
                if(G.user.data.email != null && G.user.data.email != '' && G.user.data.emailv == '1') ARow(
                  height: 50,
                  padding: EdgeInsets.all(0),
                  leftChild: Container(
                      width: 30,
                      alignment: Alignment.centerLeft,
                      child: icon_email(color: hex('#333'), size: 16)
                  ),
                  centerChild: Container(
                    // width: 120,
                    child: Text(
                      G.user.data.email != null
                          ? '電子郵箱'
                          : '綁定郵箱',
                    ),
                  ),
                  rightChild: Expanded(
                    flex:3,
                    child:Container(
                      alignment: Alignment.centerRight,
                      // width:G.screenWidth()-180,
                      // height:50,
                      padding: EdgeInsets.only(right:15,),
                      child: Text(
                        '${G.user.data.email}',
                        maxLines:2,
                      ),
                    ),
                  ),

                  // rightChild: icon_right(color: hex('#333'), size: 20),
                  onPressed: (){
                    // Navigator.pushNamed(context, '/bind_info',arguments: {'type':'郵箱'});
                  },
                ),
                ///判斷是否綁定手機
                if(G.user.data.mobile != null && G.user.data.mobile != '' && G.user.data.telv == '1') ARow(
                  height: 50,
                  padding: EdgeInsets.all(0),
                  leftChild: Container(
                      width: 30,
                      alignment: Alignment.centerLeft,
                      child: icon_phone(color: hex('#333'), size: 16)
                  ),
                  centerChild: Container(
                    // width: 120,
                    child: Text(
                      G.user.data.mobile != null
                          ? '手機號碼'
                          : '綁定號碼',
                    ),
                  ),
                  rightChild: Expanded(
                    flex:3,
                    child: Container(
                      alignment: Alignment.centerRight,
                      // width:G.screenWidth()-150,
                      padding: EdgeInsets.only(right:15,),
                      child: Text(
                        '${G.user.data.mobile}',
                        maxLines:2,
                      ),
                    ),
                  ),

                  // rightChild: icon_right(color: hex('#333'), size: 20),
                  onPressed: (){
                    // Navigator.pushNamed(context, '/bind_info',arguments: {'type':'號碼'});
                  },
                ),
                ARow(
                  height: 50,
                  padding: EdgeInsets.all(0),
                  leftChild: Container(
                      width: 30,
                      alignment: Alignment.centerLeft,
                      child: icon_profile(color: hex('#333'), size: 16)
                  ),
                  centerChild: Text('個人資料'),
                  rightChild: icon_right(color: hex('#333'), size: 20),
                  onPressed: (){
                    G.pushNamed('/edit_profile');
//                    G.toast(G.user.data.nickname);
                    //                  G.pushNamed('/setting');
                  },
                ),
                ARow(
                  height: 50,
                  padding: EdgeInsets.all(0),
                  leftChild: Container(
                      width: 30,
                      alignment: Alignment.centerLeft,
                      child: icon_favorite(color: hex('#333'), size: 16)
                  ),
                  centerChild: Text('點讚文章'),
                  rightChild: icon_right(color: hex('#333'), size: 20),
                  onPressed: (){
                    G.pushNamed('/article_like');
                  },
                ),
                ARow(
                  height: 50,
                  padding: EdgeInsets.all(0),
                  leftChild: Container(
                      width: 30,
                      alignment: Alignment.centerLeft,
                      child: icon_puls(color: hex('#333'), size: 16)
                  ),
                  centerChild: Text('關注列表'),
                  rightChild: icon_right(color: hex('#333'), size: 20),
                  onPressed: (){
                    G.pushNamed('/my_eland_list');
                  },
                ),
                ARow(
                  height: 50,
                  padding: EdgeInsets.all(0),
                  leftChild: Container(
                      width: 30,
                      alignment: Alignment.centerLeft,
                      child: icon_feedback(color: hex('#333'), size: 16)
                  ),
                  centerChild: Text('用戶條款'),
                  rightChild: icon_right(color: hex('#333'), size: 20),
                  onPressed: (){
  //                  G.toast('功能開發中');
  //                    AWebview.open(context, url: 'http://baidu.com',title: '百度');
  //                  AWebview.open(context, url: 'https://www.alayluya.com/article/201596',title: 'terms of use');
                    G.pushNamed('/terms_of_use');

                  },
                ),
                // new Container(
                //   child: Text('${Provider.of<FacebookProvider>(context,listen: true).isFacebookLogin}'),
                // ),
              ],
            ),
          ),

          Container(
            color: hex('#fff'),
//            padding: EdgeInsets.symmetric(horizontal: 15),
            child: ARow(
              height: 50,
//              margin: EdgeInsets.only(top: 10),
//              padding: EdgeInsets.symmetric(horizontal: 15),
              leftChild: Container(
                width: 30,
                alignment: Alignment.centerLeft,
                child: Container(
                    child: icon_logout(color: hex('#333'), size: 20)
                ),
              ),
              centerChild: Text('退出登錄'),
              rightChild: icon_right(color: hex('#333'), size: 20),
              border: G.borderBottom(show: false),
              onPressed: (){
//              G.toast('功能開發中');
                loginOut();
              },
            ),
          ),

          (G.isDev == true) ? Container(
            color: hex('#fff'),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              decoration: BoxDecoration(
                color: hex('#fff'),
                border: Border(
                    top: BorderSide(
                        width: 1, color: rgba(242, 242, 242, 1))),
              ),
              child: Column(
                  children:[

                    ARow(
                      height: 50,
                      padding: EdgeInsets.all(0),
                      leftChild: Container(
                        width: 30,
                        alignment: Alignment.centerLeft,
                        child: icon_friendcircle(color: hex('#333'), size: 20),
                      ),
                      centerChild: Text('TestWebview'),
                      rightChild: icon_right(color: hex('#333'), size: 20),
                      onPressed: (){
                        AWebview.open(context, url: 'https://alayluya.com/article/%E5%9F%BA%E7%9D%A3%E5%BE%92%E5%A6%82%E4%BD%95%E5%9B%9E%E6%87%89%E7%A5%AD%E7%A5%96%E5%95%8F%E9%A1%8C%E4%B8%8A-%E9%99%B3%E4%B8%80%E8%8F%AF%E7%89%A7%E5%B8%AB', title: 'TestWebview');
                      },
                    ),

                    // ARow(
                    //   height: 50,
                    //   padding: EdgeInsets.all(0),
                    //   leftChild: Container(
                    //     width: 30,
                    //     alignment: Alignment.centerLeft,
                    //     child: icon_friendcircle(color: hex('#333'), size: 20),
                    //   ),
                    //   centerChild: Text('testpage1'),
                    //   rightChild: icon_right(color: hex('#333'), size: 20),
                    //   onPressed: (){
                    //     G.pushNamed('/testpage1');
                    //   },
                    // ),
                    // ARow(
                    //   height: 50,
                    //   padding: EdgeInsets.all(0),
                    //   leftChild: Container(
                    //     width: 30,
                    //     alignment: Alignment.centerLeft,
                    //     child: icon_friendcircle(color: hex('#333'), size: 20),
                    //   ),
                    //   centerChild: Text('testpage2'),
                    //   rightChild: icon_right(color: hex('#333'), size: 20),
                    //   onPressed: (){
                    //     G.pushNamed('/testpage2');
                    //   },
                    // ),
                    ARow(
                      height: 50,
                      padding: EdgeInsets.all(0),
                      leftChild: Container(
                        width: 30,
                        alignment: Alignment.centerLeft,
                        child: icon_friendcircle(color: hex('#333'), size: 20),
                      ),
                      centerChild: Text('Domain：${G.baseurl}'),
                      rightChild: icon_right(color: hex('#333'), size: 20),
                      onPressed: (){
                        G.pushNamed('/setdomain');
                      },
                    ),
                    // ARow(
                    //   height: 50,
                    //   padding: EdgeInsets.all(0),
                    //   leftChild: Container(
                    //     width: 30,
                    //     alignment: Alignment.centerLeft,
                    //     child: icon_friendcircle(color: hex('#333'), size: 20),
                    //   ),
                    //   centerChild: Text('TestModeler'),
                    //   rightChild: icon_right(color: hex('#333'), size: 20),
                    //   onPressed: (){
                    //     G.pushNamed('/test_modeler');
                    //   },
                    // ),
                    // ARow(
                    //   height: 50,
                    //   padding: EdgeInsets.all(0),
                    //   leftChild: Container(
                    //     width: 30,
                    //     alignment: Alignment.centerLeft,
                    //     child: icon_friendcircle(color: hex('#333'), size: 20),
                    //   ),
                    //   centerChild: Text('TestOnesignal'),
                    //   rightChild: icon_right(color: hex('#333'), size: 20),
                    //   border: G.borderBottom(show: false),
                    //   onPressed: (){
                    //     G.pushNamed('/test_onesignal');
                    //   },
                    // ),
                    // ListTile(
                    //     onTap: (){
                    //       setState(() {});
                    //       switchApi(!G.oldApi);
                    //     },
                    //     leading: Icon(Icons.api_outlined),
                    //     title: Text('點擊切換API'),
                    //     subtitle: Text('當前為:${G.oldApi ? '舊版api' : '新版api'}'),
                    //     trailing: Text('切換後請重啟App')
                    // )
                  ]
              ),
            ),

          ) : Container(),

        ],),
      ),
    );

  }



}
