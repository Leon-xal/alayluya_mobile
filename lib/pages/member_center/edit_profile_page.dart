import 'dart:async';
//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import '../../components/a_button/index.dart';
import '../../utils/global.dart';
import '../../model/user_model/data.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key}) : super(key: key);

  _EditProfilePage createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  int uid = 0;

  static Map firstname = {"value": null, "verify": true};
  static Map lastname = {"value": null, "verify": true};
  static Map nickname = {"value": null, "verify": true};

  //  SharedPreferences prefs;
  //  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    //    _controller = new TextEditingController(text: '初始值');
    Future.delayed(Duration.zero, () async {
      //      prefs = await SharedPreferences.getInstance();
      //      if(G.isLogin == true) G.pop();

      setState(() {
        UserDataModel userData = G.user.data;
        firstname['value'] = userData.FirstName;
        lastname['value'] = userData.LastName;
        nickname['value'] = userData.DisplayName;
        uid = userData.id;
        //        print('firstname=====>${firstname}');
        //        print('lastname=====>${lastname}');
        //        print('nickname=====>${nickname}');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  sureAction() async {
    FocusScope.of(context).requestFocus(FocusNode());
    //    return G.toast('输入邮箱有误');
    if (!firstname['verify'] || firstname['value'] == null) {
      return G.toast('姓 有誤');
    }
    if (!lastname['verify'] || lastname['value'] == null) {
      return G.toast('名 有誤');
    }
    if (!nickname['verify'] || nickname['value'] == null) {
      return G.toast('顯示名字 有誤');
    }
    //    prefs.remove('user');
    try {
      var res = await G.req.user.edit_profile(
        id: uid,
        firstname: firstname['value'],
        lastname: lastname['value'],
        nickname: nickname['value'],
      );
      var data = res.data;

      if (data == null) return;

      print('editprofile11=====>${data}');
      //      print('editprofile22=====>${data['code']}');

      if (data['code'] == 200) {
        G.toast('修改成功');
        await getUserDetail(uid);
      } else {
        G.toast('修改失敗');
      }
    } catch (e) {
      print("editprofile fail==========>,${e}");
      G.toast('提交失敗');
    }
  }

  getUserDetail(int userid) async {
    var res = await G.req.user.detail(id: userid);
    Map data = res.data;
    Map<dynamic, dynamic> json = data['data'];
    G.user.init(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '更改資料', textcenter: false),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            height: G.screenHeight() - 80,
            color: hex('#fff'),
            padding: EdgeInsets.only(left: 35, right: 35, top: 35),
            child: Column(
              children: <Widget>[
                /// 输入First Name
                Container(
                  height: 55,
                  decoration: BoxDecoration(border: G.borderBottom()),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text:
                            (firstname['value'] == null ||
                                firstname['value'] == '')
                            ? ''
                            : firstname['value'],

                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset:
                                (firstname['value'] == null ||
                                    firstname['value'] == '')
                                ? 0
                                : firstname['value'].length,
                          ),
                        ),
                      ),
                    ),
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
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text:
                            (lastname['value'] == null ||
                                lastname['value'] == '')
                            ? ''
                            : lastname['value'],

                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset:
                                (lastname['value'] == null ||
                                    lastname['value'] == '')
                                ? 0
                                : lastname['value'].length,
                          ),
                        ),
                      ),
                    ),
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

                /// 输入顯示名字
                Container(
                  height: 55,
                  decoration: BoxDecoration(border: G.borderBottom()),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text:
                            (nickname['value'] == null ||
                                nickname['value'] == '')
                            ? ''
                            : nickname['value'],
                        selection: TextSelection.fromPosition(
                          TextPosition(
                            affinity: TextAffinity.downstream,
                            offset:
                                (nickname['value'] == null ||
                                    nickname['value'] == '')
                                ? 0
                                : nickname['value'].length,
                          ),
                        ),
                      ),
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      hintText: '顯示名字',
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                    onChanged: (e) {
                      //                  RegExp regExp = RegExp("^[a-zA-Z0-9_-\.]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+");
                      setState(() {
                        //                    email['value'] = e;
                        //                    email['verify'] = regExp.hasMatch(e);
                        nickname['value'] = e;
                        nickname['verify'] = (e == '') ? false : true;
                      });
                    },
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: AButton.normal(
                    width: 300,
                    child: Text('確認'),
                    bgColor: rgba(28, 141, 160, 0.7),
                    color: hex('#fff'),
                    borderColor: rgba(28, 141, 160, 0.7),
                    plain: true,
                    borderRadius: BorderRadius.circular(40),
                    onPressed: () => sureAction(),
                  ),
                ),
                // GestureDetector(
                //     child: Image.network('https://loopin.blob.core.windows.net/common/ORG_Q/21062112554064337142468466.jpeg'),
                //     onTap: (){
                //       APhotoview.show(context, url: 'https://loopin.blob.core.windows.net/common/ORG_Q/21062112554064337142468466.jpeg');
                //     },
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
