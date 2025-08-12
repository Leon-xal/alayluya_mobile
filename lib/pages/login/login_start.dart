import 'dart:async';
import 'dart:io';

import '../../components/a_dialog/index.dart';
// import 'package:flui/flui.dart';

import '../../utils/syncs.dart';

import '../../provider/facebookProvider.dart';
//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/a_button/index.dart';
import '../../utils/global.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import '../Index/index_page.dart';
import '../../components/onesignal_wapper/onesignal_wapper.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginStart extends StatefulWidget {
  LoginStart({Key? key}) : super(key: key);

  _LoginStartState createState() => _LoginStartState();
}

class _LoginStartState extends State<LoginStart> {
  SharedPreferences? prefs;
  bool is_open_facebook_login = false;
  bool is_open_apple_login = false;
  bool _loginByFacebook_i = false;
  // static final FacebookLogin facebookSignIn = new FacebookLogin();
  bool _login_i = false;

  int clickNumOneOpenDev = 0;
  int clickNumTwoOpenDev = 0;

  var systemInfo = null;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      if (G.isLogin == true) G.pop();

      systemInfo = Syncs.getSystemInfo;
      print('systemInfo2====>${systemInfo}');
      setState(() {
        if (Platform.isIOS) {
          is_open_apple_login = (systemInfo == null)
              ? false
              : systemInfo['is_open_apple_login'];
        }
        is_open_facebook_login = (systemInfo == null)
            ? false
            : systemInfo['is_open_facebook_login'];

        // is_open_facebook_login = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loginByApple() async {
    int errInt = 0;
    String PARAMETERS_FROM_CALLBACK_BODY = '';
    final credential =
        await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
            clientId: 'com.loopin.nepalayluyav3',
            redirectUri: Uri.parse(
              'intent://callback?${PARAMETERS_FROM_CALLBACK_BODY}#Intent;package=com.loopin.nepalayluyav3;scheme=signinwithapple;end',
            ),
          ),
          // TODO: Remove these if you have no need for them
          // nonce: 'example-nonce',
          // state: 'example-state',
        ).catchError((err) {
          String errStr = err.toString();
          errInt = errStr.indexOf('Unsupported platform version');
          if (errInt > 0) {
            String errStrRs = errStr.substring(errInt, errStr.length - 1);
            G.toast('${errStrRs}');
            // FLToast.showText(text: '${errStrRs}', position: FLToastPosition.top);
            // print('Leo sign in with apple id err0========>>>>>>>>${errStrRs}');
          }
          print(
            'Leo sign in with apple id err========>>>>>>>>${err.toString()}',
          );
          // print('Leo sign in with apple id err2========>>>>>>>>${errInt}');
          return AuthorizationCredentialAppleID(
            userIdentifier: '', // Replace with a suitable default
            authorizationCode: '', // Replace with a suitable default
            identityToken: null, // Or a suitable default
            email: null, // Or a suitable default
            familyName: null, // Or a suitable default
            givenName: null, // Or a suitable default
            state: null, // Or a suitable default
          ); // Return default credential
        });
    if (errInt > 0) {
      return;
    }
    print('credential======>');
    print('credential=====>${credential}');
    print('credential.email=====>${credential.email}');
    print('credential.userIdentifier=====>${credential.userIdentifier}');
    // print('credential.identityToken=====>${credential.identityToken}');
    print('credential.familyName=====>${credential.familyName}');
    print('credential.givenName=====>${credential.givenName}');
    // print('credential.state=====>${credential.state}');
    print('credential.authorizationCode=====>${credential.authorizationCode}');
    // 登录前移除user， 不然登录会提示token错误
    prefs?.remove('user');

    try {
      if (_login_i == true) return;
      _login_i = true;

      var res = await G.req.user.loginByApple(
        first_name: credential.familyName!,
        last_name: credential.givenName!,
        email: credential.email!,
        apple_id: credential.userIdentifier!,
        apple_token: credential.authorizationCode,
      );

      var data = res.data;

      if (data == null) {
        _login_i = false;
        return;
      }
      if (data['data']['id'] == -1) {
        _login_i = false;
        // await G.toast('${data['msg']}');
        ADialog.alert(context, content: '${data['msg']}');
        return;
      }

      await getUserDetail(data['data']['id']);

      await G.toast('登錄成功');
      await Future.delayed(Duration(seconds: 3), () async {
        print("延时三秒后请求数据====>");
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

  Future<void> _loginByFacebook() async {
    if (_loginByFacebook_i == true) return;
    _loginByFacebook_i = true;

    await G.loading.show(context);

    // _loginByFacebook_i = false;
    // await G.loading.hide(context);

    Provider.of<FacebookProvider>(
      context,
      listen: false,
    ).loginByFacebook().then((value) async {
      // print('loginByFacebookProvider=========>${value}');
      await G.loading.hide(context);
      // _loginByFacebook_i = false;
      if (value == true) {
        G.isLogin = true;
        await Future.delayed(Duration.zero, () async {
          await G.toast(
            Provider.of<FacebookProvider>(context, listen: false).message ??
                '登錄成功',
          );
          await Future.delayed(Duration(seconds: 3), () async {
            _loginByFacebook_i = false;

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
        });
      } else {
        await Future.delayed(Duration.zero, () async {
          _loginByFacebook_i = false;
          await G.toast(
            Provider.of<FacebookProvider>(context, listen: false).message ??
                '登錄失敗',
          );
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //      appBar: customAppbar(title:'asd',textcenter:true, borderBottom: false),
      appBar: null,

      body: new Container(
        //###alfred
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('lib/assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // new Container(
            //   child: Text('${Provider.of<FacebookProvider>(context,listen: false)._message}'),
            // ),
            //   new Container(
            //     child: Text('${Provider.of<FacebookProvider>(context,listen: true).isFacebookLogin}'),
            //   ),
            //   new Container(
            //     padding: EdgeInsets.only(top: 50,),
            //     child: Text('is_open_apple_login====>${is_open_apple_login}'),
            //   ),
            // new Container(
            //   child: Text('systemInfo_is_open_apple_login====>${systemInfo['is_open_apple_login']}'),
            // ),
            // new Container(
            //   child: Text('systemInfo====>${systemInfo}'),
            // ),
            new Container(
              margin: EdgeInsets.only(top: G.screenHeight() / 8.5),
              alignment: Alignment.center,
              child: new Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 50, right: 50),
                    child: InkWell(
                      onTap: () {
                        if (clickNumOneOpenDev >= 10 &&
                            clickNumTwoOpenDev == 0) {
                          G.isDev = false;
                          G.toast('debug mode stop');
                        }
                        if (clickNumOneOpenDev >= 10) {
                          print(
                            "aaa1=====>${clickNumOneOpenDev}/${clickNumTwoOpenDev}",
                          );
                          clickNumTwoOpenDev = 0;
                        } else {
                          clickNumOneOpenDev++;
                          print(
                            "aaa2=====>${clickNumOneOpenDev}/${clickNumTwoOpenDev}",
                          );
                        }
                      },
                      child: Image.asset(
                        './lib/assets/images/logo-w.png',
                        width: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 30),
                    padding: EdgeInsets.only(left: 50, right: 50),
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        if (clickNumOneOpenDev >= 10 &&
                            clickNumTwoOpenDev >= 10) {
                          print(
                            "aaa3=====>${clickNumOneOpenDev}/${clickNumTwoOpenDev}",
                          );
                          G.isDev = true;
                          G.toast('debug mode ready');
                          G.pushNamed('/setdomain');
                        } else {
                          if (clickNumOneOpenDev == 10) {
                            print(
                              "aaa4=====>${clickNumOneOpenDev}/${clickNumTwoOpenDev}",
                            );
                            clickNumTwoOpenDev++;
                          }
                        }
                      },
                      // A Simple way to pray,support,and stay connected with your Christian community.
                      child: Text(
                        '讓你分享勵志文章、見證影音、呼籲代禱及結連互助的社交平台。',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Container(),
            new Column(
              //              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: AButton.normal(
                    width: 250,
                    child: Text('登入'),
                    color: Color(0xffffffff),
                    //                    color: rgba(255, 255, 255, 1),
                    borderColor: Color.fromARGB(255, 28, 141, 160),
                    bgColor: Color.fromARGB(255, 28, 141, 160),
                    plain: true,
                    borderRadius: BorderRadius.circular(40),
                    onPressed: () => G.pushNamed('/login_mail'),
                  ),
                ),
                (is_open_apple_login == true)
                    ? Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Container(
                          width: 250,
                          child: SignInWithAppleButton(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                            onPressed: () {
                              _loginByApple();
                            },
                          ),
                        ),
                      )
                    : Container(),
                (is_open_facebook_login == true)
                    ? Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: AButton.normal(
                          width: 250,
                          child: new Text('Sign In via Facebook'),
                          color: Color(0xffffffff),
                          bgColor: Color.fromARGB(255, 42, 117, 163),
                          borderColor: Color.fromARGB(255, 42, 117, 163),
                          plain: true,
                          borderRadius: BorderRadius.circular(40),
                          onPressed: () {
                            _loginByFacebook();
                          },
                        ),
                      )
                    : Container(),
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  child: AButton.normal(
                    width: 250,
                    child: new Text('註冊'),
                    color: Color.fromARGB(255, 255, 255, 255),
                    bgColor: Color.fromARGB(0, 255, 255, 255),
                    borderColor: Color.fromARGB(255, 255, 255, 255),
                    plain: true,
                    borderRadius: BorderRadius.circular(40),
                    onPressed: () => G.pushNamed('/register'),
                  ),
                ),
              ],
            ),
          ],
        ),
        //      child: Text('test'),
      ),
    );
  }
}
