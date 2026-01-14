import 'dart:async';

import 'components/region_code.dart';
import 'package:flutter/cupertino.dart';

//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/a_button/index.dart';
import '../../utils/global.dart';

import '../Index/index_page.dart';
//import '../pages/home_page.dart';
import '../../components/onesignal_wapper/onesignal_wapper.dart';

class LoginMail extends StatefulWidget {
  LoginMail({Key? key}) : super(key: key);

  _LoginMailState createState() => _LoginMailState();
}

class _LoginMailState extends State<LoginMail> {
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController phonePassController = TextEditingController();

  SharedPreferences? prefs;
  bool _login_i = false;
  bool userPhoneToLogin = true;
  int areaCodeIndex = 0;
  int areaCode = regionCode[0]['code'];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      print("G.isLogin: ${G.isLogin}");
      if (G.isLogin == true) G.pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///選擇區號
  Future clickAreaCode(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: 380,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        areaCodeIndex = value;
                      });
                    },
                    children: regionCode.map((areaCode) {
                      return Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${areaCode['zh']} +' + '${areaCode['code']}',
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    areaCode = regionCode[areaCodeIndex]['code'];
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1, color: Colors.grey),
                    ),
                  ),
                  child: Text(
                    '確認',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(176, 28, 141, 160),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1, color: Colors.grey),
                    ),
                  ),
                  child: Text(
                    '取消',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 登录
  void login() async {
    // print('aaaa=====>');
    FocusScope.of(context).requestFocus(FocusNode());
    //    RegExp regExp = RegExp("^[a-zA-Z0-9_-\.]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+");
    //    if(!regExp.hasMatch(emailController.text) || emailController.text == null || emailController.text.trim() == '') {
    //      return G.toast('輸入郵箱有誤');
    //    }

    if (userPhoneToLogin == true) {
      if (phoneController.text.trim() == '') {
        return G.toast('輸入號碼有誤');
      }

      if (phonePassController.text.length == 0 ||
          phonePassController.text.trim() == '') {
        return G.toast('請輸入密碼');
      }
    } else {
      if (emailController.text.trim() == '') {
        return G.toast('輸入郵箱有誤');
      }

      if (passController.text.length == 0 || passController.text.trim() == '') {
        return G.toast('請輸入密碼');
      }
    }

    // 登录前移除user， 不然登录会提示token错误
    prefs?.remove('user');

    try {
      if (_login_i == true) return;
      _login_i = true;
      var res;
      if (userPhoneToLogin == true) {
        // print('phoneController.text===>${phoneController.text}');
        // print('areaCode.text===>${areaCode}');
        res = await G.req.user.loginByMobile(
          phone: '+' + areaCode.toString() + phoneController.text.trim(),
          pwd: phonePassController.text.trim(),
        );
      } else {
        res = await G.req.user.login(
          email: emailController.text.trim(),
          pwd: passController.text.trim(),
        );
      }

      var data = res.data;

      // print("sss====>${data}");
      // _login_i = false;
      // return;

      if (data == null) {
        _login_i = false;
        return;
      }

      await getUserDetail(data['data']['id']);

      await G.toast('登錄成功');
      await Future.delayed(Duration(seconds: 3), () async {
        print("延时三秒后请求数据====>");
        if (userPhoneToLogin == true) {
          phoneController.clear();
          phonePassController.clear();
        } else {
          emailController.clear();
          passController.clear();
        }

        G.isLogin = true;
        _login_i = false;

        if (G.isLogin == true) {
          await OneSignalWapper()
            ..loginInit();
        }

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              return IndexPage();
            },
          ),
          (route) => route == null,
        );
      });
    } catch (e) {
      print("login fail==========>,${e}");
      _login_i = false;
      G.toast('登錄失敗');
    }
  }

  getUserDetail(int userid) async {
    var res = await G.req.user.detail(id: userid);

    Map data = res.data;
    //    print('data=====>${data}');
    //    Map json = data['data'];
    Map<dynamic, dynamic> json = data['data'];
    print('json=====>${json}');
    //    json['token'] = token;
    print('getUserDetail=====>${json}');
    G.user.init(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '登入', textcenter: true),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            height: G.screenHeight() - 100,
            color: Color(0xffffffff),
            padding: EdgeInsets.only(left: 35, right: 35, top: 35),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // new Container(
                //   child: Text('${Provider.of<FacebookProvider>(context,listen: true).isFacebookLogin}'),
                // ),
                Container(
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            userPhoneToLogin = !userPhoneToLogin;
                          });
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            userPhoneToLogin ? '電子郵箱登錄?' : '手機號碼登錄?',
                            style: TextStyle(
                              color: Color.fromARGB(255, 28, 141, 160),
                            ),
                          ),
                        ),
                      ),

                      /// 输入手機號碼
                      if (userPhoneToLogin == true)
                        Container(
                          height: 48,
                          decoration: BoxDecoration(border: G.borderBottom()),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => clickAreaCode(context),
                                child: Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 204, 204, 204),
                                  ),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 10, bottom: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$areaCode',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    hintText: '手機號碼',
                                    hintStyle: TextStyle(fontSize: 14),
                                  ),
                                  autofocus: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (userPhoneToLogin == true) SizedBox(height: 10),

                      /// 輸入密碼
                      if (userPhoneToLogin == true)
                        Container(
                          height: 48,
                          decoration: BoxDecoration(border: G.borderBottom()),
                          child: TextField(
                            controller: phonePassController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: '密碼',
                              hintStyle: TextStyle(fontSize: 14),
                            ),
                            obscureText: true,
                            //                          onChanged: (e) {
                            //                            setState(() {
                            //
                            //                            });
                            //                          },
                          ),
                        ),

                      /// 输入邮箱
                      if (userPhoneToLogin == false)
                        Container(
                          height: 55,
                          decoration: BoxDecoration(border: G.borderBottom()),
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: '電郵地址',
                              hintStyle: TextStyle(fontSize: 14),
                            ),
                            //                          onChanged: (e) {
                            //                            RegExp regExp = RegExp("^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+");
                            //                            setState(() {
                            //                              email['value'] = e;
                            //                              email['verify'] = regExp.hasMatch(e);
                            //                              print('changedEmailInput======>${email}');
                            //                            });
                            //                          },
                            autofocus: false,
                          ),
                        ),

                      /// 輸入密碼
                      if (userPhoneToLogin == false)
                        Container(
                          height: 55,
                          decoration: BoxDecoration(border: G.borderBottom()),
                          child: TextField(
                            controller: passController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: '密碼',
                              hintStyle: TextStyle(fontSize: 14),
                            ),
                            obscureText: true,
                            //                          onChanged: (e) {
                            //                            setState(() {
                            //
                            //                            });
                            //                          },
                          ),
                        ),

                      /// 忘記密碼
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.topRight,
                        child: InkWell(
                          child: Text(
                            '忘記密碼',
                            style: TextStyle(
                              color: Color.fromARGB(255, 85, 122, 157),
                              fontSize: 12,
                            ),
                          ),
                          // onTap: () => G.pushNamed('/search_result', arguments: {'result': item.value});
                          onTap: () {
                            // Navigator.pushNamed(context, '/forgot_password'),
                            G.pushNamed(
                              '/forgot_password',
                              arguments: {'userPhoneToLogin': userPhoneToLogin},
                            );
                            // Navigator.pushNamed(context, '/forgot_password', arguments: {'userPhoneToLogin': userPhoneToLogin});
                          },
                        ),
                      ),

                      /// 确认登綠
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        child: AButton.normal(
                          width: 250,
                          child: Text('登入'),
                          //                            rgba(169, 211, 218, 1)
                          bgColor: Color.fromARGB(255, 28, 141, 160),
                          color: Color(0xffffffff),
                          borderColor: Color.fromARGB(255, 28, 141, 160),
                          plain: true,
                          borderRadius: BorderRadius.circular(40),
                          onPressed: () => login(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: new Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        alignment: Alignment.center,
                        child: Text(
                          '非會員請點擊這裡',
                          style: TextStyle(
                            color: Color.fromARGB(255, 51, 51, 51),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 50),
                        child: AButton.normal(
                          width: 250,
                          child: new Text('註冊'),
                          color: Color.fromARGB(255, 51, 51, 51),
                          bgColor: Color.fromARGB(255, 255, 255, 255),
                          borderColor: Color.fromARGB(255, 204, 204, 204),
                          plain: true,
                          borderRadius: BorderRadius.circular(40),
                          onPressed: () => G.pushNamed('/register'),
                          //                        onPressed: () => Navigator.pushNamed(context, '/register_page'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
