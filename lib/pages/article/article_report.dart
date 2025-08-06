import 'dart:async';
import '../login/components/region_code.dart';
import 'package:flutter/cupertino.dart';

//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import '../../components/a_button/index.dart';
import '../../utils/global.dart';
import '../../model/user_model/data.dart';

class ArticleReport extends StatefulWidget {
  final Map args;
  ArticleReport({Key key, this.args}) : super(key: key);

  _ArticleReportState createState() => _ArticleReportState();
}

class _ArticleReportState extends State<ArticleReport> {
  static Map args;

  var code = regionCode[0]['code'];
  int userid = 0;
  int articleid = 0;
  String article_title = '';

  TextEditingController contentController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController shopController = TextEditingController();

  bool _submit_i = false;

  @override
  void initState() {
    super.initState();
    UserDataModel userData = G.user.data;
    userid = userData.id;
    args = widget.args;
    articleid = args['articleid'];
    // articleid = 12345678;
    article_title = args['article_title'];
    print('userid=====>${userid}');
    print('articleid=====>${articleid}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 登录
  void _submit() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (contentController.text.trim() == '') {
      return G.toast('請輸入意見回饋');
    }

    if (nameController.text.trim() == '') {
      return G.toast('請輸入聯繫人姓名');
    }

    if (phoneController.text.trim() == '') {
      return G.toast('請輸入電話');
    }

    if (phoneController.text.length < 6) {
      return G.toast('電話號碼不正確');
    }

    final reg = RegExp(r'^-?[0-9]+');
    if (reg.hasMatch(phoneController.text) == false) {
      await G.toast('電話號碼不正確');
      return;
    }

    if (emailController.text.trim() == '') {
      return G.toast('請輸入郵箱');
    }

    if (shopController.text.trim() == '') {
      return G.toast('請輸入教會');
    }

    try {
      if (_submit_i == true) return;
      _submit_i = true;
      var res = await G.req.article.reportArticle(
        articleid: articleid,
        userid: userid,
        content: contentController.text.trim(),
        name: nameController.text.trim(),
        phone: '+${code}${phoneController.text.trim()}',
        email: emailController.text.trim(),
        shop: shopController.text.trim(),
      );
      var data = res.data;
      // print("sss====>${data}");
      // _submit_i = false;
      // return;
      if (data == null) {
        _submit_i = false;
        return;
      }

      await G.toast('${data['msg']}');
      await Future.delayed(Duration(seconds: 3), () async {
        phoneController.clear();
        contentController.clear();
        emailController.clear();
        nameController.clear();
        shopController.clear();
        _submit_i = false;
        G.pop();
      });
    } catch (e) {
      print("error fail==========>,${e}");
      _submit_i = false;
      G.toast('系統錯誤');
    }
  }

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
                        code = regionCode[value]['code'];
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
                  print('code====>${code}');
                  Navigator.pop(context);
                  // widget.callback(code);
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
                      color: rgba(28, 141, 160, 0.7),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: '給Alayluya團隊的意見回饋',
        textcenter: false,
      ),
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
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // new Container(
                //   child: Text('${Provider.of<FacebookProvider>(context,listen: true).isFacebookLogin}'),
                // ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(vertical: 12),
                        child: Text.rich(
                          new TextSpan(
                            children: <TextSpan>[
                              new TextSpan(
                                text: "文章：",
                                style: new TextStyle(
                                  color: rgba(51, 51, 51, 1),
                                  height: 2,
                                ),
                              ),
                              new TextSpan(
                                text: "${article_title}",
                                style: new TextStyle(
                                  color: rgba(28, 141, 160, 1),
                                  height: 2,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),

                      /// 意見回饋
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: rgba(204, 204, 204, 1),
                              width: 1,
                            ),
                            bottom: BorderSide(
                              color: rgba(204, 204, 204, 1),
                              width: 1,
                            ),
                            left: BorderSide(
                              color: rgba(204, 204, 204, 1),
                              width: 1,
                            ),
                            right: BorderSide(
                              color: rgba(204, 204, 204, 1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: TextField(
                          maxLines: 8,
                          controller: contentController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            hintText: '*意見回饋',
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                          autofocus: false,
                        ),
                      ),

                      /// 聯繫人姓名
                      Container(
                        height: 55,
                        decoration: BoxDecoration(border: G.borderBottom()),
                        child: TextField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            hintText: '*聯繫人姓名',
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                          autofocus: false,
                        ),
                      ),

                      /// 電話
                      Container(
                        height: 55,
                        decoration: BoxDecoration(border: G.borderBottom()),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => clickAreaCode(context),
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                  color: rgba(204, 204, 204, 1),
                                ),
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 10, bottom: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${code}',
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
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  hintText: '*電話',
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                                autofocus: false,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// 输入邮箱
                      Container(
                        height: 55,
                        decoration: BoxDecoration(border: G.borderBottom()),
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            hintText: '*電郵地址',
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                          autofocus: false,
                        ),
                      ),

                      /// 教會
                      Container(
                        height: 55,
                        decoration: BoxDecoration(border: G.borderBottom()),
                        child: TextField(
                          controller: shopController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            hintText: '*教會',
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                          autofocus: false,
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
                          onPressed: () => _submit(),
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
