import 'dart:async';
import './components/region_code.dart';
import './components/phone_register.dart';
//import 'package:color_dart/color_dart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import '../../components/a_web_view/index.dart';
import '../../components/a_button/index.dart';
import '../../utils/global.dart';
import '../../components/a_dialog/index.dart';
//import '../pages/index_page.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  static Map firstname = {"value": null, "verify": true};
  static Map lastname = {"value": null, "verify": true};
  static Map email = {"value": null, "verify": true};
  static Map password = {"value": null, "verify": true};
  static Map repassword = {"value": null, "verify": true};

  static Map phoneFirstname = {"value": null, "verify": true};
  static Map phoneLastname = {"value": null, "verify": true};
  static Map phone = {"value": null, "verify": true};
  static Map phonePassword = {"value": null, "verify": true};
  static Map phoneRepassword = {"value": null, "verify": true};
  static Map phoneCode = {"value": null, "verify": true};

  //  SharedPreferences prefs;
  bool usePhoneNumberToRegister = true;
  var areaCode = regionCode[0]['code'];
  String sid = null;

  bool _submit_i = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      //      prefs = await SharedPreferences.getInstance();
      if (G.isLogin == true) G.pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void phoneRegister() async {
    // print('$phone');
    FocusScope.of(context).requestFocus(FocusNode());
    if (!phoneFirstname['verify'] || phoneFirstname['value'] == null) {
      return G.toast('姓 有誤');
    }
    if (!phoneLastname['verify'] || phoneLastname['value'] == null) {
      return G.toast('名 有誤');
    }
    if (!phone['verify'] || phone['value'] == null) {
      return G.toast('輸入手機號碼有誤');
    }
    if (!phoneCode['verify'] || phoneCode['value'] == null) {
      return G.toast('請輸入驗證碼');
    }
    if (!phonePassword['verify'] || phonePassword['value'] == null) {
      return G.toast('密碼有誤');
    }
    if (!phoneRepassword['verify'] || phoneRepassword['value'] == null) {
      return G.toast('請確認密碼是否一致');
    }
    // print('phone=====>${phone}');
    // print('phoneCode=====>${phoneCode}');
    // print('phoneFirstname=====>${phoneFirstname}');
    // print('phoneLastname=====>${phoneLastname}');
    // print('phonePassword=====>${phonePassword}');
    // print('phoneRepassword=====>${phoneRepassword}');
    // print('areaCode=====>${areaCode}');
    // print('sid=====>${sid}');
    try {
      if (_submit_i == true) return;
      _submit_i = true;
      var res = await G.req.user.registerByMobile(
        firstname: phoneFirstname['value'],
        lastname: phoneLastname['value'],
        phone: '+${areaCode}${phone['value']}',
        phoneCode: phoneCode['value'],
        password: phonePassword['value'],
        repassword: phoneRepassword['value'],
        sid: sid,
      );
      var data = res.data;
      if (data == null) {
        _submit_i = false;
        return;
      }
      //      print('register11=====>${data}');
      //      print('register22=====>${data['code']}');
      _submit_i = false;
      if (data['code'] == 200) {
        ADialog.confirm(
          context,
          content: data['msg'],
          confirmButtonPress: () {
            Navigator.of(context).pushReplacementNamed('/login_mail');
          },
        );
      } else {
        G.toast('註冊失败');
      }
    } catch (e) {
      _submit_i = false;
      print("register fail==========>,${e}");
      G.toast('註冊失败');
    }
  }

  /// 註冊
  register() async {
    FocusScope.of(context).requestFocus(FocusNode());
    //    return G.toast('输入邮箱有误');
    if (!firstname['verify'] || firstname['value'] == null) {
      return G.toast('姓 有誤');
    }
    if (!lastname['verify'] || lastname['value'] == null) {
      return G.toast('名 有誤');
    }
    if (!email['verify'] || email['value'] == null) {
      return G.toast('輸入電郵有誤');
    }
    if (!password['verify'] || password['value'] == null) {
      return G.toast('請輸入密碼');
    }
    if (!repassword['verify'] || repassword['value'] == null) {
      return G.toast('請確認密碼是否一致');
    }
    //    prefs.remove('user');
    try {
      if (_submit_i == true) return;
      _submit_i = true;
      var res = await G.req.user.register(
        firstname: firstname['value'],
        lastname: lastname['value'],
        email: email['value'],
        password: password['value'],
        repassword: repassword['value'],
      );
      //      print('ppp111=====${res.data['msg']}');
      var data = res.data;
      if (data == null) {
        _submit_i = false;
        return;
      }

      //      print('register11=====>${data}');
      //      print('register22=====>${data['code']}');
      _submit_i = false;
      if (data['code'] == 200) {
        ADialog.confirm(
          context,
          content: data['msg'],
          confirmButtonPress: () {
            Navigator.of(context).pushReplacementNamed('/login_mail');
          },
        );
      } else {
        G.toast('註冊失败');
      }

      //      await getUserDetail(data['data']['id']);
      //
      //      await G.toast('註冊成功');
      //      G.isLogin = true;
      //
      //      Navigator.of(context).pushAndRemoveUntil(
      //          MaterialPageRoute(builder: (context){
      //            return IndexPage();
      //          }),(route) => route == null
      //      );
    } catch (e) {
      _submit_i = false;
      print("register fail==========>,${e}");
      G.toast('註冊失败');
    }
  }

  //  getUserDetail(int userid) async {
  //    var res = await G.req.user.detail(
  //      id: userid,
  //    );
  //
  //    Map data = res.data;
  ////    print('data=====>${data}');
  ////    Map json = data['data'];
  //    Map<dynamic, dynamic> json = data['data'];
  ////    print('json=====>${json}');
  ////    json['token'] = token;
  ////    print('getUserDetail=====>${json}');
  //    G.user.init(json);
  //  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '註冊', textcenter: true),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            // height: G.screenHeight()-100,
            color: hex('#fff'),
            padding: EdgeInsets.only(left: 35, right: 35, top: 35),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      usePhoneNumberToRegister = !usePhoneNumberToRegister;
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      usePhoneNumberToRegister ? '電子郵箱註冊?' : '手機號碼註冊?',
                      style: TextStyle(color: rgba(28, 141, 160, 0.7)),
                    ),
                  ),
                ),

                ///手機號碼註冊
                if (usePhoneNumberToRegister == true)
                  Container(
                    child: PhoneRegister(
                      phone: phone,
                      phoneCode: phoneCode,
                      phoneFirstname: phoneFirstname,
                      phoneLastname: phoneLastname,
                      phonePassword: phonePassword,
                      phoneRepassword: phoneRepassword,
                      code: areaCode,
                      returnSid: (result) {
                        //VAd196ea3586226eca80b9fd85f48b2059
                        setState(() {
                          sid = result;
                        });
                      },
                      callback: (code) {
                        setState(() {
                          areaCode = code;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),

                ///電子郵箱註冊
                if (usePhoneNumberToRegister == false)
                  Container(
                    child: Column(
                      children: [
                        /// 输入First Name
                        Container(
                          height: 55,
                          decoration: BoxDecoration(border: G.borderBottom()),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: '姓',
                              hintStyle: TextStyle(fontSize: 14),
                            ),
                            onChanged: (e) {
                              setState(() {
                                firstname['value'] = e;
                                firstname['verify'] = (e == '') ? false : true;
                              });
                            },
                          ),
                        ),

                        /// Last Name
                        Container(
                          height: 55,
                          decoration: BoxDecoration(border: G.borderBottom()),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: '名',
                              hintStyle: TextStyle(fontSize: 14),
                            ),
                            onChanged: (e) {
                              setState(() {
                                lastname['value'] = e;
                                lastname['verify'] = (e == '') ? false : true;
                              });
                            },
                          ),
                        ),

                        /// 输入邮箱
                        Container(
                          height: 55,
                          decoration: BoxDecoration(border: G.borderBottom()),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: '電郵地址',
                              hintStyle: TextStyle(fontSize: 14),
                            ),
                            onChanged: (e) {
                              //                  RegExp regExp = RegExp("^[a-zA-Z0-9_-\.]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+");
                              setState(() {
                                //                    email['value'] = e;
                                //                    email['verify'] = regExp.hasMatch(e);
                                email['value'] = e;
                                email['verify'] = (e == '') ? false : true;
                              });
                            },
                          ),
                        ),

                        /// 輸入密碼
                        Container(
                          height: 55,
                          decoration: BoxDecoration(border: G.borderBottom()),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: '密碼',
                              hintStyle: TextStyle(fontSize: 14),
                            ),
                            obscureText: true,
                            onChanged: (e) {
                              setState(() {
                                password['value'] = e;
                                password['verify'] = (e == '') ? false : true;
                              });
                            },
                          ),
                        ),

                        /// 再次輸入密碼
                        Container(
                          height: 55,
                          decoration: BoxDecoration(border: G.borderBottom()),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: '再次輸入新密碼',
                              hintStyle: TextStyle(fontSize: 14),
                            ),
                            obscureText: true,
                            onChanged: (e) {
                              setState(() {
                                repassword['value'] = e;
                                repassword['verify'] =
                                    (e == '' || e != password['value'])
                                    ? false
                                    : true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                /// 确认登綠
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: AButton.normal(
                    width: 250,
                    child: Text('註冊'),
                    bgColor: rgba(28, 141, 160, 0.7),
                    color: hex('#fff'),
                    borderColor: rgba(28, 141, 160, 0.7),
                    plain: true,
                    borderRadius: BorderRadius.circular(40),
                    // onPressed: () => register()
                    onPressed: () {
                      usePhoneNumberToRegister ? phoneRegister() : register();
                    },
                  ),
                ),

                /// 描述
                Container(
                  margin: EdgeInsets.only(top: 40),
                  padding: EdgeInsets.only(bottom: 50),
                  alignment: Alignment.center,
                  child: Text.rich(
                    new TextSpan(
                      children: <TextSpan>[
                        new TextSpan(
                          text:
                              "By Sign up you agree to Alayluya terms and condition.For more details please read out ",
                          style: new TextStyle(
                            color: rgba(51, 51, 51, 1),
                            fontSize: 10,
                            height: 2,
                            //                              letterSpacing: 10.0,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        new TextSpan(
                          text: "terms of use",
                          style: new TextStyle(
                            color: rgba(57, 139, 161, 1),
                            fontSize: 10,
                            height: 2,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              //                              print('点击了隐私政策');
                              //                              AWebview.open(context, url: 'https://www.alayluya.com/article/201596',title: 'terms of use');
                              G.pushNamed('/terms_of_use');
                            },
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  //                Row(
                  //            children: <Widget>[
                  //            Text('111By Sign up you agree to Alayluya terms and condition.\nFor more details please read out ', style: TextStyle(
                  //                color: rgba(51, 51, 51, 1),
                  //                fontSize: 15)
                  //            ),
                  ////                  Text('terms of use', style: TextStyle(
                  ////                      color: rgba(85, 122, 157, 1),
                  ////                      fontSize: 15)
                  ////                  ),
                  //          ],
                  //        ),

                  //              InkWell(
                  //                child: Text('Forgot Password', style: TextStyle(
                  //                    color: rgba(85, 122, 157, 1),
                  //                    fontSize: 12
                  //                ),),
                  //                onTap: () => Navigator.pushNamed(context, '/forgot_password'),
                  //              ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
