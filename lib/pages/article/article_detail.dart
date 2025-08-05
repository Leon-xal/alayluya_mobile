import 'dart:io';
import 'dart:async';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../provider/do_like_method.dart';
import 'package:provider/provider.dart';

import '../../components/a_web_view/index.dart';

import '../../components/a_pdfview/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:social_share_plugin/social_share_plugin.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import '../../model/user_model/data.dart';
import '../../model/article_detail_model/data.dart';
import '../../components/a_button/index.dart';
import '../../utils/global.dart';
import '../../components/a_photoview/index.dart';
// import 'package:social_share/social_share.dart';

class ArticleDetail extends StatefulWidget {
  final Map args;
  ArticleDetail({
    Key key,
    this.args,
  }) : super(key: key);
  @override
  createState() => _ArticleDetailState();
}


class _ArticleDetailState extends State<ArticleDetail> {

  static Map args;
  int id = 0;
  int userid = 0;
  String header_title = '';
  ArticleDetailModel article_info;
  ArticleDetailData article;
  ScrollController scrollController = ScrollController();
  InAppWebViewController webView;
  bool isloading = true;
  String share_url = "";
  String share_text = "";

  double custom_font_size = 16.0;

  SharedPreferences _prefs;

  bool _submit_i = false;

  @override
  void initState() {
    super.initState();
    UserDataModel userData = G.user.data;
    userid = userData.id;
    args = widget.args;
    if(args != null){
      id = args['id'];
      Future.delayed(Duration.zero, () async{
        _prefs = await SharedPreferences.getInstance();
        String _custom_font_size_str = _prefs.getString('_custom_font_size');
        if(_custom_font_size_str != null && _custom_font_size_str.isNotEmpty) {
          custom_font_size = double.parse(_custom_font_size_str);
        }else{
          _prefs.setString('_custom_font_size', custom_font_size.toString());
        }
        _loadData(
          id: id,
          uid: userid,
        );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _loadData({int id=0,int uid=0}) async {
    try {
//      print('sssss--userid====>${uid}');

      var res = await G.req.article.detail(
        id: id,
        userid: uid,
      );

      if(res.data != null){
        Map result = res.data;
        // print('result111===>${result}');
        setState(() {
          article_info = ArticleDetailModel.fromJson(result);
          header_title = article_info.data.title;

          if(article_info.data != null){
            article = article_info.data;
            // share_url = 'https://alayluya.com/article/${id}';
            // print('result111===>${share_url}');
            share_url = article.content_app_link;
            // print('result112===>${article.content_app_link}');
            // print('result113===>${article.MobileViewUrl}');
            // print('result114===>${article.MobileAppViewUrl}');
            share_text = article.title;
//            print('result222===>${article.MobileAppViewUrl + "/?user_id=${userid}"}');
//            print('result222===>${article_info.data.tags[0].name}');

            Map map = {
              "isLike":article.ilike,
              'id':article.id,
              'num':article.like
            };
            Provider.of<DoLikeMethod>(context,listen: false).getPopIsLike(map);


          }

        });
      }

    }catch(e) {
      print('dataArtilceInfoCatch===>${e}');
    }
  }

  _clickElandFollow(item){

    int uid = G.user.data.id;
    int itemid = item.eland_id;
//    print('aaa===>${uid}/${itemid}');
    try {
      Future.delayed(Duration.zero, () async{
        var res = await G.req.eland.dofollow(eland_id: itemid, userid: uid);
        Map result = res.data;
        if(result['code'] == 200){
          setState(() {
//            print("aaaa=====>"+article.content_app_link+"/?user_id=${userid}");
            if(item.eland_ifollow == true && item.eland_follow > 0){
              article.eland_follow = item.eland_follow-1;
              article.eland_ifollow = false;
//              print("follow_eland_dom===>false");
              webView.evaluateJavascript(source: """
              var follow_eland_dom = document.getElementById('follow_eland');
              follow_eland_dom.innerHTML = '關注';
              """);
            }else{
              article.eland_follow = item.eland_follow+1;
              article.eland_ifollow = true;
//              print("follow_eland_dom===>true");
              webView.evaluateJavascript(source: """
              var follow_eland_dom = document.getElementById('follow_eland');
              follow_eland_dom.innerHTML = '已關注';
              """);
            }
          });
        }
      });
    }catch(e){
      print('articledocollect===>${e}');
    }
  }

  _clickDoLike(item){
    int uid = G.user.data.id;
    int itemid = item.id;
    try {
      Future.delayed(Duration.zero, () async{
        if(_submit_i == true) return;
        _submit_i = true;
        var res = await G.req.article.dolike(articleid: itemid, userid: uid);
        Map result = res.data;
        if (result == null){
          _submit_i = false;
          return;
        }

        _submit_i = false;
        if(result['code'] == 200){
          setState(() {
            if(item.ilike == true && item.like > 0){
              article.like = item.like-1;
              article.ilike = false;
            }else{
              article.like = item.like+1;
              article.ilike = true;
            }
          });
        }
      });
    }catch(e){
      print('articledolike===>${e}');
    }
  }

  _clickDoReport(item){
    int uid = G.user.data.id;
    int itemid = item.id;
    try {
      Future.delayed(Duration.zero, () async{
        var res = await G.req.article.report(articleid: itemid, userid: uid);
        Map result = res.data;
        if(result['code'] == 200){
          await G.toast('報告成功');
        }
      });
    }catch(e){
      print('articledoReport===>${e}');
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: 1.0,
          child: new CircularProgressIndicator(
            backgroundColor: rgba(28, 141, 160, 1),
            valueColor: new AlwaysStoppedAnimation<Color>(rgba(255, 255, 255, 1)),
          ),
        ),
      ),
    );
  }

  Widget _showSetFontSizeBlock() {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setDialogState) {
//                print("state===>${setDialogState}");
                return Dialog(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Container(
                            child: Stack(
                                children: <Widget>[
                                  Align(
                                    child: InkWell(
                                        child: icon_close(size: 30,color: rgba(28, 141, 160, 1)),
                                        onTap: (){
                                          _prefs.setString('_custom_font_size', custom_font_size.toString());
                                          webView.evaluateJavascript(source: """
                                            var _dom = document.getElementById('article-content');
                                            reFontSize(_dom,"""+custom_font_size.toString()+""");                                            
                                            """);
                                          Navigator.pop(context);
                                        }
                                    ),
                                    alignment: Alignment.topRight,
                                  ),
                                ]),
                          ),
                          new Container(
                              height: 120,
                              child: new Container(
                                alignment: Alignment.center,
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Text('你的字大小', style: new TextStyle(color: Colors.black, fontSize: custom_font_size,)),
                                  ],
                                ),

                              )
                          ),
                          new Container(
                            decoration: BoxDecoration(
                                border: Border(top: BorderSide(color: rgba(242, 242, 242, 1)))
                            ),
                            child: Row(
                              children: <Widget>[
                                // 取消按钮
                                Container(
                                  child: Expanded(child:
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(right: BorderSide(color: rgba(242, 242, 242,1))),
                                    ),
                                    child: AButton.normal(
                                        child: Text('加大'),
                                        color: rgba(28, 141, 160, 1),
                                        onPressed: (){
                                          setDialogState(() {
                                            custom_font_size = custom_font_size+1;
                                            if(custom_font_size > 45.0){
                                              custom_font_size = 45.0;
                                            }
                                          });
                                        }
                                    ),
                                  )
                                  ),
                                ),
                                // 确认按钮
                                Container(
                                  child: Expanded(
                                    child: AButton.normal(
                                        child: Text('縮小'),
                                        color: rgba(28, 141, 160, 1),
                                        onPressed: (){
                                          setDialogState(() {
                                            custom_font_size = custom_font_size-1;
                                            if(custom_font_size < 13.0){
                                              custom_font_size = 13.0;
                                            }
                                          });
                                        }
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                );
              }
          );
        }
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hex('#ccc'),
      appBar: customAppbar(
          context: context,
          title: header_title,
          default_actions: true,
          onGoBackPressed:(){
            if(_submit_i == false){
              Navigator.pop(context);
            }
          },
          actions: <Widget>[
            new Container(
//                alignment: const Alignment(0.0, 1.0),
              margin: EdgeInsets.only(right: 10,),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
//                  color: hex('#fff'),
                border: new Border(left: BorderSide(width: 1.0, color: rgba(229, 229, 229, 1))),
              ),
//                child: InkWell(
//                    child: icon_more_vert(color: rgba(0, 0, 0, 1), size: 20),
//                    onTap: (){
////                      G.pushNamed('/setting');
//                    }
//                ),
              child: new PopupMenuButton<String>(
                  icon: icon_more_vert(color: rgba(0, 0, 0, 1), size: 20),
                  //这是点击弹出菜单的操作，点击对应菜单后，改变屏幕中间文本状态，将点击的菜单值赋予屏幕中间文本
                  onSelected: (String value) {
                    if(value == 'copylink'){
                      Clipboard.setData(ClipboardData(text: share_url));
                      G.toast('已復制連結');
                    }else if(value == 'report'){
                      Navigator.pushNamed(context, '/article_report',arguments: {'articleid':id,'article_title':'${header_title}'});
                      // ADialog.confirm(context,
                      //     content: '確認報告？',
                      //     confirmButtonPress: () {
                      //       _clickDoReport(article);
                      //     }
                      // );
                    }else if(value == 'refontsize'){
                      _showSetFontSizeBlock();
                    }
                    print('onSelected===>${value}');
                  },
                  //这是弹出菜单的建立，包含了两个子项，分别是增加和删除以及他们对应的值
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem(
//                      child: Text('aaa'),
                      child: (article == null)? new Row() : new Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          icon_content_copy(
                              size: 20,
                              color: hex('#333')
                          ),
                          SizedBox(width: 10),
                          new Text('復制邀請連結'),
//                          new Icon(Icons.add_circle)
                        ],
                      ),
                      value: 'copylink',
                    ),
                    PopupMenuItem(
                      child: (article == null)? new Row() : new Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          icon_report(
                              size: 20,
                              color: hex('#333')
                          ),
                          SizedBox(width: 10),
                          new Text('報告'),
//                          new Icon(Icons.add_circle)
                        ],
                      ),
//                      child: Text('bbbbbbbbb'),
                      value: 'report',
                    ),
                    PopupMenuItem(
                      child: (article == null)? new Row() : new Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          icon_text_rotate_up(
                              size: 20,
                              color: hex('#333')
                          ),
                          SizedBox(width: 10),
                          new Text('調整字體大小'),
//                          new Icon(Icons.add_circle)
                        ],
                      ),
//                      child: Text('bbbbbbbbb'),
                      value: 'refontsize',
                    ),
                  ]
              ),
            ),
          ]
      ),
      body: (article == null)? _buildProgressIndicator() : Stack(
        children: <Widget>[
          // Text(article.content_app_link.toString()),
          Container(
            margin: const EdgeInsets.only(left: 10.0,right:10.0,top:10.0,bottom:85.0),
            padding: const EdgeInsets.only(left: 20.0,right:20.0,top:20.0,),
            color: hex('#fff'),
            width: G.screenWidth(),
            height: G.screenHeight(),
            child: InAppWebView(
              initialUrl: article.MobileAppViewUrl + "/?user_id=${userid}",
//              initialUrl: 'https://juejin.im/post/6844904048148086791',
              initialHeaders: {},
              initialOptions: InAppWebViewGroupOptions(
              // initialOptions: InAppWebViewWidgetOptions(
                crossPlatform: InAppWebViewOptions(
                  debuggingEnabled: false,
                  javaScriptEnabled: true,
//                  useShouldOverrideUrlLoading: true,
//                  useOnLoadResource: true,
                  cacheEnabled: true,
                  disableVerticalScroll: false,
                  disableHorizontalScroll: false,
                  verticalScrollBarEnabled: false,
                  horizontalScrollBarEnabled:false,
                ),
                ios: IOSInAppWebViewOptions(
                  isPagingEnabled: false,
                ),
                android: AndroidInAppWebViewOptions(

                ),
              ),

              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
                print('onWebViewCreated=====>${article.MobileAppViewUrl + "/?user_id=${userid}"}');

                webView.addJavaScriptHandler(
                    handlerName: "InAppWebViewGetReadyCallback",
                    callback: (arguments) async {
                      print("InAppWebViewGetReadyCallback====>${arguments}");
                      webView.evaluateJavascript(source: """
                        var _dom = document.getElementById('article-content');
                        reFontSize(_dom,"""+custom_font_size.toString()+""");
                      """);
                    }
                );

                webView.addJavaScriptHandler(
                    handlerName: "InAppWebViewFacebookCallback",
                    callback: (arguments) async {
                      print("InAppWebViewFacebookCallback====>${arguments}");
                      // final result = await SocialSharePlugin.shareToFeedFacebookLink(
                      //   quote: share_text,
                      //   url: share_url,
                      //   onSuccess: (_) {
                      //     print('FACEBOOK SUCCESS======>${_}');
                      //     return;
                      //   },
                      //   onCancel: () {
                      //     print('FACEBOOK CANCELLED======>');
                      //     return;
                      //   },
                      //   onError: (error) {
                      //     print('FACEBOOK ERROR======>${error}');
                      //     return;
                      //   },
                      // );
                      // print("InAppWebViewTwitterFuncCallbackResult====>${result}");
                      print('shareToFacebook======>${share_url}');
                      List<String> share_url_arr = share_url.split('/');
                      String share_url2 = '';
                      if(share_url_arr.length > 0){
                        for(int i=0;i<share_url_arr.length;i++){
                          if(i == share_url_arr.length-1){
                            share_url2 += Uri.encodeComponent(share_url_arr[share_url_arr.length-1]);
                          }else{
                            share_url2 += share_url_arr[i]+'/';
                          }
                        }
                      }
                      print('share_url2====>${share_url2}');
                      // print('share_url_arr====>${share_url_arr[share_url_arr.length-1]}');


                      // String share_url2 = Uri.encodeComponent(share_url);
                      // print('shareToFacebook2======>${share_url2}');
                      var response = FlutterShareMe().shareToFacebook(
                          url: '${share_url2}', msg: '${share_text}');
                      print('shareToFacebook2======>${response}');


                    }
                );

                webView.addJavaScriptHandler(
                    handlerName: "InAppWebViewTwitterFuncCallback",
                    callback: (arguments) async {
//                      print('InAppWebViewTwitterFuncCallback=========>${arguments}');
//                       final result = await SocialSharePlugin.shareToTwitterLink(
//                           text: share_text,
//                           url: share_url,
//                           onSuccess: (_) {
//                             print('TWITTER SUCCESS=====>${_}');
//                             return;
//                           },
//                           onCancel: () {
//                             print('TWITTER CANCELLED=====>');
//                             return;
//                           }
//                       );


//                       SocialShare.shareTwitter("This is Social Share plugin");
                      // response = await flutterShareMe.shareToFacebook(url: url, msg: msg);
                      // response = await flutterShareMe.shareToFacebook(url: url, msg: msg);
                      // FlutterShareMe().shareTwitter("This is Social Share plugin");

                      print('shareToTwitter======>${share_url}');
                      var response = FlutterShareMe().shareToTwitter(
                          url: share_url, msg: share_text);
                      print('shareToTwitter======>${response}');

                    }
                );

                webView.addJavaScriptHandler(
                    handlerName: "InAppWebViewWhatsAppFuncCallback",
                    callback: (arguments) async {
                      print('InAppWebViewWhatsAppFuncCallback=========>${arguments}');

                      if (Platform.isAndroid) {
//                        print('ANDROID自动登陆开发中====>');
                        String response = await FlutterShareMe().shareToWhatsApp(msg: share_url);
                        if (response == 'false' || response == false) {
                          await G.toast('請安裝WhatsApp');
                        }
                      } else {
//                        print('IOS自动登陆开发中====>');
                        String share_url2 = Uri.encodeComponent(share_url);
                        try{
//                          "whatsapp://send?text=${share_url2}"
                          Future<bool> canToWhatsApp = canLaunch("whatsapp://send?text=${share_url2}");
                          canToWhatsApp.then((isCanToWhatsApp) async {
                            if(isCanToWhatsApp == true){
                              launch("whatsapp://send?text=${share_url2}");
                            }else{
                              await G.toast('請安裝WhatsApp');
                            }
                          });

                        }catch(e){
                          print('eeeeeeeeee2======================>${e}');
                        }
                      }
//                      print("InAppWebViewWhatsAppFuncCallbackResult====>${response}");
                    }
                );

                webView.addJavaScriptHandler(
                    handlerName: "InAppWebViewEmailFuncCallback",
                    callback: (arguments) async {
//                      print('InAppWebViewEmailFuncCallback=========>${arguments}');
                      String share_text2 = Uri.encodeComponent(share_text);
                      String share_url2 = Uri.encodeComponent(share_url);
                      try{
                        Future<bool> canToEmail = canLaunch("mailto:?subject=${share_text2}&body=${share_url2}");
                        canToEmail.then((isCanToEmail) async {
                          if(isCanToEmail == true){
                            launch("mailto:?subject=${share_text2}&body=${share_url2}");
                          }else{
                            await G.toast('請安裝第三方郵箱工具');
                          }
                        });

                      }catch(e){
                        print('eeeeeeeeee2======================>${e}');
                      }
//                      launch("mailto:451027779@qq.com");
                    }
                );

                webView.addJavaScriptHandler(
                    handlerName: "InAppWebViewCopyFuncCallback",
                    callback: (arguments) async {
//                      print('InAppWebViewCopyFuncCallback=========>${arguments}');
                      Clipboard.setData(ClipboardData(text: share_url));
                      await G.toast('已復制連結');
//                      print("InAppWebViewCopyFuncCallbackResult====>${result}");
                    }
                );

                webView.addJavaScriptHandler(
                    handlerName: "InAppWebViewHotArticleClickFuncFuncCallback",
                    callback: (arguments) async {
                      print('InAppWebViewHotArticleClickFuncFuncCallback=========>${arguments}');
                      // print(arguments[0] is String);
                      G.pushNamed('/article_detail', arguments: {'id': int.parse(arguments[0])});
                    }
                );

                webView.addJavaScriptHandler(
                    handlerName: "InAppWebViewMoreArticleFuncCallback",
                    callback: (arguments) async {
                      print('InAppWebViewMoreArticleFuncCallback=========>${arguments}');
                      G.pushNamed('/article_list', arguments: {'ishot': true});
                    }
                );

                webView.addJavaScriptHandler(
                    handlerName: "InAppWebViewFollowElandFuncCallback",
                    callback: (arguments) async {
                      print('InAppWebViewFollowElandFuncCallback=========>${arguments}');
                      _clickElandFollow(article);
                    }
                );

                webView.addJavaScriptHandler(
                    handlerName: "InAppWebViewGoElandPageFuncCallback",
                    callback: (arguments) async {
//                      print('InAppWebViewGoElandPageFuncCallback=========>${arguments},${article.eland_id}');
                      G.pushNamed('/eland_info', arguments: {'id': article.eland_id});
                    }
                );

                webView.addJavaScriptHandler(
                    handlerName: "InAppWebViewOpenImageByContentFuncCallback",
                    callback: (arguments) async {
                      print('InAppWebViewOpenImageByContentFuncCallback=========>${arguments}');
                      // print('arguments====>${arguments}');
                      if(arguments.length > 0 && arguments[0] != null){
                        APhotoview.show(context,
                            url:arguments[0]
                        );
                      }
                    }
                );

                webView.addJavaScriptHandler(
                    handlerName: "InAppWebViewOpenHrefByContentFuncCallback",
                    callback: (arguments) async {
                      print('InAppWebViewOpenHrefByContentFuncCallback=========>${arguments}');
                      // print('arguments====>${arguments}');
                      if(arguments.length > 0 && arguments[0] != null){
                        String hrefVal = arguments[0];
                        String extVal = hrefVal.substring(hrefVal.lastIndexOf(".") + 1, hrefVal.length);
                        if(extVal == 'pdf'){
                          APdfview.show(context,
                              url: hrefVal
                          );
                        }else{
                          List hrefValArr = hrefVal.split("/");
                          String pos = hrefValArr[hrefValArr.length-2];
                          String val = hrefValArr[hrefValArr.length-1];
                          print('pos====>${pos}');
                          print('val====>${val}');
                          if(pos == 'article'){
                            G.pushNamed('/article_detail', arguments: {'id': int.parse(val)});
                          }else{
                            if (await canLaunch(hrefVal)) {
                              await launch(hrefVal);
                            } else {
                              AWebview.open(context, url: hrefVal,title: hrefVal);
                            }
                          }
                        }
                      }
                    }
                );

              },
              onLoadStop: (InAppWebViewController controller, String url) async {
                print('onLoadStop=====>');
                setState(() {
                  isloading = false;
                });
              },
              onProgressChanged: (InAppWebViewController controller, int progress) {
//                print('progress====>${progress/100}');
                if((progress/100)>0.90){
//                  print('progress2====>${progress}');
                  setState(() {
                    isloading = false;
                  });
                }
              },
            ),


          ),
          (isloading == false)?Container():
          Positioned(
            top: G.screenHeight()/2 - 100,
            left: G.screenWidth()/2 - 20,
//            child: CircularProgressIndicator(
//              strokeWidth: 2.0,
//              backgroundColor: rgba(28, 141, 160, 1),
//            ),
            child: new Opacity(
              opacity: 1.0,
              child: new CircularProgressIndicator(
                backgroundColor: rgba(28, 141, 160, 1),
                valueColor: new AlwaysStoppedAnimation<Color>(rgba(255, 255, 255, 1)),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: hex('#fff'),
                border: new Border(top: BorderSide(width: 2.0, color: hex('#cacbd1'))),
              ),
              padding: EdgeInsets.only(left: 20.0,right:20.0,top:10.0,bottom:10.0),
              width: G.screenWidth(),
              height: 75,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top:10,bottom:10.0,),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    new Row(
                      children: <Widget>[
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
//                              new Text(article.eland_name, style: new TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 16.0,)),
//                              new Text(article.eland_desc, style: new TextStyle(color: Colors.black54)),

                            Text.rich(
                              new TextSpan(
                                  style: new TextStyle(
                                      color: hex('#333'),
                                      fontSize: 15,
                                      height: 2,
//                              letterSpacing: 10.0,
                                      decoration: TextDecoration.none),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text: "閱讀量：",
                                    ),
                                    new TextSpan(
                                      text: article.read.toString(),
                                    ),
                                  ]),
                            ),

                          ],
                        ),
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        (article.ilike == true && article.like > 0)?
                        AButton.icon(
                            width: 70,height: 25,borderColor: Colors.pink,bgColor: Colors.pink,plain: true,
                            textChild: Text(article.like.toString(), style: TextStyle(
                                color: hex('#fff'),
                                fontSize: 13
                            ),),
                            borderRadius: BorderRadius.circular(40),
                            icon: icon_favorite(
                                size: 13,
                                color: hex('#fff')
                            ),
                            onPressed: (){
                              _clickDoLike(article);
                              //###Leo
                              Map initMap = Provider.of<DoLikeMethod>(context,listen: false).pushLike;
                              Map map = {
                                "isLike":false,
                                'id':initMap['id'],
                                'num':article.like-1
                              };
                              Provider.of<DoLikeMethod>(context,listen: false).getPopIsLike(map);
                            }
                        ) : AButton.icon(
                            width: 70,height: 25,borderColor: Colors.pink,bgColor: hex('#fff'),plain: true,
                            textChild: Text(article.like.toString(), style: TextStyle(
                                color: Colors.pink,
                                fontSize: 13
                            ),),
                            borderRadius: BorderRadius.circular(40),
                            icon: icon_favorite_border(
                                size: 13,
                                color: Colors.pink
                            ),
                            onPressed: (){
                              //###Leo
                              Map initMap = Provider.of<DoLikeMethod>(context,listen: false).pushLike;
                              Map map = {
                                "isLike":true,
                                'id':initMap['id'],
                                'num':article.like+1
                              };
                              Provider.of<DoLikeMethod>(context,listen: false).getPopIsLike(map);
                              _clickDoLike(article);
                            }
                        ),
                        Container(
                          width: 10.0,
                        ),
                        AButton.icon(
                            width: 70,height: 25,borderColor: rgba(28, 141, 160, 1),bgColor: hex('#fff'),plain: true,
                            textChild: (article.comment_num == null) ? Text('0', style: TextStyle(
                                color: rgba(28, 141, 160, 1),
                                fontSize: 13
                            ),) : Text(article.comment_num.toString(), style: TextStyle(
                                color: rgba(28, 141, 160, 1),
                                fontSize: 13
                            ),),
                            borderRadius: BorderRadius.circular(40),
                            icon: icon_comment(
                                size: 13,
                                color: rgba(28, 141, 160, 1)
                            ),
                            onPressed: (){
                              G.pushNamed('/comment_page', arguments: {'id': article.id});
                            }
                        ),


                      ],
                    ),

                  ],
                ),
              ),

            ),
          ),
        ],
      ),
//      bottomNavigationBar: CustomNavbar(onTap:(index) {
//        G.pushNamed(G.toobarRouteNameList[index]);
//      }),
    );
  }


}
