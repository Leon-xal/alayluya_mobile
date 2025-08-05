import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/a_eland_dynamic/test.dart';
import '../../components/a_eland_card/index.dart';
import '../../model/user_model/data.dart';
import '../../utils/global.dart';
import '../../components/custom_navbar/index.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:dio/dio.dart';

class TestFacebookLogin extends StatefulWidget {
  TestFacebookLogin({Key key}) : super(key: key);

  @override
  createState() => _TestFacebookLoginState();

}


class _TestFacebookLoginState extends State<TestFacebookLogin> {
  // static final FacebookLogin facebookSignIn = new FacebookLogin();
  // String _message = 'Log in/out by pressing the buttons below.';

  // Future<Null> _login() async {
  //   final FacebookLoginResult result =
  //   await facebookSignIn.logIn(['email']);
  //
  //   switch (result.status) {
  //     case FacebookLoginStatus.loggedIn:
  //       final FacebookAccessToken accessToken = result.accessToken;
  //       _showMessage('''
  //        Logged in!
  //
  //        Token: ${accessToken.token}
  //        User id: ${accessToken.userId}
  //        Expires: ${accessToken.expires}
  //        Permissions: ${accessToken.permissions}
  //        Declined permissions: ${accessToken.declinedPermissions}
  //        ''');
  //
  //       String token = accessToken.token;
  //       // var res = await G.req.user.get_user_info_by_facebook(
  //       //   token: token,
  //       // );
  //       await Future.delayed(Duration(milliseconds: 4000));
  //
  //       // await Future.delayed(Duration.zero);
  //
  //
  //         var response = await Dio().get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token='+token);
  //       // var data = res.data;
  //       var profile = jsonDecode(response.toString());
  //       _showMessage('''
  //       profile!
  //
  //       name: ${profile['name']}
  //       first_name: ${profile['first_name']}
  //       last_name: ${profile['last_name']}
  //       email: ${profile['email']}
  //       id: ${profile['id']}
  //       ''');
  //
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       _showMessage('Login cancelled by the user.');
  //       break;
  //     case FacebookLoginStatus.error:
  //       _showMessage('Something went wrong with the login process.\n'
  //           'Here\'s the error Facebook gave us: ${result.errorMessage}');
  //       break;
  //   }
  // }
  //
  // Future<Null> _logOut() async {
  //   await facebookSignIn.logOut();
  //   _showMessage('Logged out.');
  // }
  //
  // void _showMessage(String message) {
  //   setState(() {
  //     _message = message;
  //   });
  // }

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: customAppbar(context: context,title: 'TestFacebookLogin'),
      body: Container(
        child: Text('TestFacebookLogin'),
        // child: new Center(
        //   child: new Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       new Text(_message),
        //       new RaisedButton(
        //         onPressed: _login,
        //         child: new Text('Log in'),
        //       ),
        //       new RaisedButton(
        //         onPressed: _logOut,
        //         child: new Text('Logout'),
        //       ),
        //     ],
        //   ),
        // ),
      ),
      // bottomNavigationBar: CustomNavbar(onTap:(index) {
      //   G.pushNamed(G.toobarRouteNameList[index]);
      // }),
    );

  }



}