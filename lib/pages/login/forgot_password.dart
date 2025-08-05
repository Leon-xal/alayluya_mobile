import 'dart:async';
import './components/region_code.dart';
import './components/phone_forgot.dart';
//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/a_button/index.dart';
import '../../components/a_dialog/index.dart';
import '../../utils/global.dart';

class ForgotPassword extends StatefulWidget {
  final Map args;

  ForgotPassword({Key key, this.args}) : super(key: key);

  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  static Map args;

  static Map phone = {"value": null, "verify": true};
  static Map phonePassword = {"value": null, "verify": true};
  static Map phoneCode = {"value": null, "verify": true};

  bool userPhoneToLogin = null;
  var areaCode = regionCode[0]['code'];
  String sid = null;

  bool _submit_i = false;

  static Map email = {"value": null, "verify": true};

  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    args = widget.args;
    userPhoneToLogin = args['userPhoneToLogin'];
    if (userPhoneToLogin == true) {
      print('userPhoneToLogin1====>${userPhoneToLogin}');
    } else {
      print('userPhoneToLogin2====>${userPhoneToLogin}');
    }
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      if (G.isLogin == true) G.pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 登录
  void _submit() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (!email['verify'] || email['value'] == null) {
      return G.toast('輸入電郵有誤');
    }
    try {
      if (_submit_i == true) return;
      _submit_i = true;
      var res = await G.req.user.forgot(email: email['value']);
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
        G.toast('提交失败，請重新再試');
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
      print("forgot fail==========>,${e}");
      G.toast('提交失败');
    }
  }

  void _submitMobile() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (!phone['verify'] || phone['value'] == null) {
      return G.toast('輸入手機號碼有誤');
    }
    if (!phoneCode['verify'] || phoneCode['value'] == null) {
      return G.toast('請輸入驗證碼');
    }
    if (!phonePassword['verify'] || phonePassword['value'] == null) {
      return G.toast('請輸入新密碼');
    }
    print('phone=====>${phone}');
    print('phoneCode=====>${phoneCode}');
    print('phonePassword=====>${phonePassword}');
    print('areaCode=====>${areaCode}');
    print('sid=====>${sid}');
    try {
      if (_submit_i == true) return;
      _submit_i = true;
      var res = await G.req.user.forgotMobile(
        phone: '+${areaCode}${phone['value']}',
        phoneCode: phoneCode['value'],
        password: phonePassword['value'],
        sid: sid,
      );
      print('aaa=====${res}');
      var data = res.data;
      if (data == null) {
        _submit_i = false;
        return;
      }
      print('bbb=====${data}');
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
        G.toast('修改失败');
      }
    } catch (e) {
      _submit_i = false;
      print("forgot fail==========>,${e}");
      G.toast('修改失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '忘記密碼', textcenter: true),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            height: G.screenHeight() - 100,
            color: hex('#fff'),
            padding: EdgeInsets.only(left: 35, right: 35, top: 35),
            child: Container(
              child: Column(
                children: <Widget>[
                  /// 输入邮箱
                  if (userPhoneToLogin == false)
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
                          //                    RegExp regExp = RegExp("^[a-zA-Z0-9_-\.]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+");
                          setState(() {
                            //                      email['value'] = e;
                            //                      email['verify'] = regExp.hasMatch(e);
                            email['value'] = e;
                            email['verify'] = (e == '') ? false : true;
                          });
                        },
                      ),
                    ),

                  if (userPhoneToLogin == true)
                    Expanded(
                      child: PhoneForgot(
                        phone: phone,
                        phoneCode: phoneCode,
                        phonePassword: phonePassword,
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

                  /// 确认登綠
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: AButton.normal(
                      width: 250,
                      child: Text('提交'),
                      //                            rgba(169, 211, 218, 1)
                      bgColor: rgba(28, 141, 160, 1),
                      color: hex('#fff'),
                      borderColor: rgba(28, 141, 160, 1),
                      plain: true,
                      borderRadius: BorderRadius.circular(40),
                      onPressed: () => (userPhoneToLogin == true)
                          ? _submitMobile()
                          : _submit(),
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.only(top:40),
                    padding: EdgeInsets.only(bottom: 50),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
