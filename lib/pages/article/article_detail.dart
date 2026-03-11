import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart' as web_view;
import '../../provider/do_like_method.dart';
import 'package:provider/provider.dart';
import '../../components/a_web_view/index.dart';
import '../../components/a_pdfview/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:social_share_plugin/social_share_plugin.dart';
// import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:share_plus/share_plus.dart';
import '../../model/user_model/data.dart';
import '../../model/article_detail_model/data.dart';
import '../../components/a_button/index.dart';
import '../../utils/global.dart';
import '../../components/a_photoview/index.dart';
// import 'package:social_share/social_share.dart';

class ArticleDetail extends StatefulWidget {
  final Map args;
  ArticleDetail({Key? key, required this.args}) : super(key: key);
  @override
  createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  static Map? args;
  int id = 0;
  int userid = 0;
  String header_title = '';
  ArticleDetailModel? article_info;
  ArticleDetailData? article;
  ScrollController? scrollController = ScrollController();
  InAppWebViewController? webView;
  bool? isloading;
  String share_url = '';
  String? share_text;

  double custom_font_size = 16.0;

  SharedPreferences? _prefs;

  bool _submit_i = false;

  // final Completer<web_view.WebViewController> _controller = Completer<web_view.WebViewController>();
  web_view.WebViewController? iosController;

  @override
  void initState() {
    super.initState();
    UserDataModel userData = G.user.data!;
    userid = userData.id!;
    args = widget.args;
    id = args?['id'];
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
      String? _custom_font_size_str = _prefs?.getString('_custom_font_size') ?? '16';
      if (_custom_font_size_str.isNotEmpty) {
        custom_font_size = double.parse(_custom_font_size_str);
      } else {
        _prefs?.setString('_custom_font_size', custom_font_size.toString());
      }
      print('initState calling loadData====>${id}');
      _loadData(id: id, uid: userid);
      print('initState completed====>${id}');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _loadData({int id = 0, int uid = 0}) async {
    try {
      //      print('sssss--userid====>${uid}');

      var res = await G.req.article.detail(id: id, userid: uid);
      print('dataArtilceInfo===>${res.data}');

      if (res.data != null) {
        // Map result = res.data;
        Map<String, dynamic> result = Map<String, dynamic>.from(res.data);
        print('result111===>${result}');

        setState(() {
          article_info = ArticleDetailModel.fromJson(result);
          article = article_info?.data;
          if (article != null) {
            header_title = article?.title ?? '';
          }

          print('setState share_url====>${article?.content_app_link}');
          share_url = article?.content_app_link ?? '';
          share_text = article?.title;

          Map map = {
            "isLike": article?.ilike,
            'id': article?.id,
            'num': article?.like,
          };
          print('dataArtilceInfoMap===>${map}');
          Provider.of<DoLikeMethod>(context, listen: false).getPopIsLike(map);
          print(
            'ProviderOfDoLikeMethod===>${Provider.of<DoLikeMethod>(context, listen: false).popIsLike}, ${context}',
          );
          //isloading = false;
        });
      }
    } catch (e) {
      print('dataArtilceInfoCatch===>${e}');
    }
  }

  _clickElandFollow(item) {
    int uid = G.user.data!.id!;
    int itemid = item.eland_id;
    //    print('aaa===>${uid}/${itemid}');
    try {
      Future.delayed(Duration.zero, () async {
        var res = await G.req.eland.dofollow(eland_id: itemid, userid: uid);
        Map result = res.data;
        if (result['code'] == 200) {
          setState(() {
            //            print("aaaa=====>"+article.content_app_link+"/?user_id=${userid}");
            if (item.eland_ifollow == true && item.eland_follow > 0) {
              article?.eland_follow = item.eland_follow - 1;
              article?.eland_ifollow = false;
              //              print("follow_eland_dom===>false");
              webView?.evaluateJavascript(
                source: """
              var follow_eland_dom = document.getElementById('follow_eland');
              follow_eland_dom.innerHTML = '關注';
              """,
              );
            } else {
              article?.eland_follow = item.eland_follow + 1;
              article?.eland_ifollow = true;
              //              print("follow_eland_dom===>true");
              webView?.evaluateJavascript(
                source: """
              var follow_eland_dom = document.getElementById('follow_eland');
              follow_eland_dom.innerHTML = '已關注';
              """,
              );
            }
          });
        }
      });
    } catch (e) {
      print('articledocollect===>${e}');
    }
  }

  _clickDoLike(item) {
    int uid = G.user.data!.id!;
    int itemid = item.id;
    try {
      Future.delayed(Duration.zero, () async {
        if (_submit_i == true) return;
        _submit_i = true;
        var res = await G.req.article.dolike(articleid: itemid, userid: uid);
        Map result = res.data;

        _submit_i = false;
        if (result['code'] == 200) {
          setState(() {
            if (item.ilike == true && item.like > 0) {
              article?.like = item.like - 1;
              article?.ilike = false;
            } else {
              article?.like = item.like + 1;
              article?.ilike = true;
            }
          });
        }
      });
    } catch (e) {
      print('articledolike===>${e}');
    }
  }

  /*_clickDoReport(item) {
    int uid = G.user.data!.id!;
    int itemid = item.id;
    try {
      Future.delayed(Duration.zero, () async {
        var res = await G.req.article.report(articleid: itemid, userid: uid);
        Map result = res.data;
        if (result['code'] == 200) {
          await G.toast('報告成功');
        }
      });
    } catch (e) {
      print('articledoReport===>${e}');
    }
  }*/

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: 1.0,
          child: new CircularProgressIndicator(
            backgroundColor: Color.fromARGB(255, 28, 141, 160),
            valueColor: new AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showSetFontSizeBlock() {
    print('_showSetFontSizeBlock====>${custom_font_size}');
    return FutureBuilder<void>(
      future: showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              //                print("state===>${setDialogState}");
              return Dialog(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Container(
                        child: Stack(
                          children: <Widget>[
                            Align(
                              child: InkWell(
                                child: icon_close(
                                  size: 30,
                                  color: Color.fromARGB(255, 28, 141, 160),
                                ),
                                onTap: () {
                                  _prefs?.setString(
                                    '_custom_font_size',
                                    custom_font_size.toString(),
                                  );
                                  webView?.evaluateJavascript(
                                    source:
                                        """
                                            var _dom = document.getElementById('article-content');
                                            reFontSize(_dom,""" +
                                        custom_font_size.toString() +
                                        """);                                            
                                            """,
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                              alignment: Alignment.topRight,
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        height: 120,
                        child: new Container(
                          alignment: Alignment.center,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                '你的字大小',
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: custom_font_size,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color.fromARGB(255, 242, 242, 242),
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            // 取消按钮
                            Container(
                              child: Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Color.fromARGB(
                                          255,
                                          242,
                                          242,
                                          242,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: AButton.normal(
                                    child: Text('加大'),
                                    color: Color.fromARGB(255, 28, 141, 160),
                                    onPressed: () {
                                      setDialogState(() {
                                        custom_font_size = custom_font_size + 1;
                                        if (custom_font_size > 45.0) {
                                          custom_font_size = 45.0;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            // 确认按钮
                            Container(
                              child: Expanded(
                                child: AButton.normal(
                                  child: Text('縮小'),
                                  color: Color.fromARGB(255, 28, 141, 160),
                                  onPressed: () {
                                    setDialogState(() {
                                      custom_font_size = custom_font_size - 1;
                                      if (custom_font_size < 13.0) {
                                        custom_font_size = 13.0;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while the dialog is open.  This is optional.
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle errors, if any.
          return Text('Error: ${snapshot.error}');
        } else {
          // Dialog is finished.  Return a placeholder or nothing.
          return const SizedBox.shrink(); // Or return any other suitable widget
        }
      },
    );
  }

  // web_view.JavascriptChannel iosJavascript1(BuildContext context) {
  //   return web_view.JavascriptChannel(
  //     name: 'InAppWebViewGetReadyCallback',
  //     onMessageReceived: (web_view.JavascriptMessage message) {
  //       iosController?.evaluateJavascript("""
  //                       var _dom = document.getElementById('article-content');
  //                       reFontSize(_dom,""" +
  //           custom_font_size.toString() +
  //           """);
  //                     """);
  //     },
  //   );
  // }
  //
  // web_view.JavascriptChannel iosJavascript2(BuildContext context) {
  //   return web_view.JavascriptChannel(
  //     name: 'InAppWebViewFacebookCallback',
  //     onMessageReceived: (web_view.JavascriptMessage message) async {
  //       print('shareToFacebook======>${share_url}');
  //       List<String> share_url_arr = share_url.split('/');
  //       String share_url2 = '';
  //       if (share_url_arr.length > 0) {
  //         for (int i = 0; i < share_url_arr.length; i++) {
  //           if (i == share_url_arr.length - 1) {
  //             share_url2 += Uri.encodeComponent(
  //               share_url_arr[share_url_arr.length - 1],
  //             );
  //           } else {
  //             share_url2 += share_url_arr[i] + '/';
  //           }
  //         }
  //       }
  //       print('share_url2====>${share_url2}');
  //       var response = await SharePlus.instance.share(
  //         ShareParams(
  //           uri: Uri.parse(share_url2),
  //           text: share_text,
  //         ),
  //       );
  //       print('shareToFacebook2======>${response}');
  //     },
  //   );
  // }
  //
  // web_view.JavascriptChannel iosJavascript3(BuildContext context) {
  //   return web_view.JavascriptChannel(
  //     name: 'InAppWebViewTwitterFuncCallback',
  //     onMessageReceived: (web_view.JavascriptMessage message) async {
  //       print('shareToTwitter======>${share_url}');
  //       /* var response = FlutterShareMe().shareToTwitter(
  //                           url: share_url,
  //                           msg: share_text!,
  //                         ); */
  //       var response = await SharePlus.instance.share(
  //         ShareParams(
  //           uri: Uri.parse(share_url),
  //           text: share_text,
  //         ),
  //       );
  //       print('shareToTwitter======>${response}');
  //     },
  //   );
  // }
  //
  // web_view.JavascriptChannel iosJavascript4(BuildContext context) {
  //   return web_view.JavascriptChannel(
  //     name: 'InAppWebViewWhatsAppFuncCallback',
  //     onMessageReceived: (web_view.JavascriptMessage message) async {
  //       String share_url2 = Uri.encodeComponent(share_url);
  //       try {
  //         //                          "whatsapp://send?text=${share_url2}"
  //         Future<bool> canToWhatsApp = canLaunchUrl(
  //           Uri.parse("whatsapp://send?text=${share_url2}"),
  //         );
  //         canToWhatsApp.then((isCanToWhatsApp) async {
  //           if (isCanToWhatsApp == true) {
  //             launchUrl(
  //               Uri.parse(
  //                 "whatsapp://send?text=${share_url2}",
  //               ),
  //             );
  //           } else {
  //             await G.toast('請安裝WhatsApp');
  //           }
  //         });
  //       } catch (e) {
  //         print('eeeeeeeeee2======================>${e}');
  //       }
  //     },
  //   );
  // }
  //
  // web_view.JavascriptChannel iosJavascript5(BuildContext context) {
  //   return web_view.JavascriptChannel(
  //     name: 'InAppWebViewEmailFuncCallback',
  //     onMessageReceived: (web_view.JavascriptMessage message) async {
  //       print(
  //         'InAppWebViewEmailFuncCallback=========>${message}',
  //       );
  //       String share_text2 = Uri.encodeComponent(share_text!);
  //       String share_url2 = Uri.encodeComponent(share_url);
  //       try {
  //         Future<bool> canToEmail = canLaunchUrl(
  //           Uri.parse(
  //             "mailto:?subject=${share_text2}&body=${share_url2}",
  //           ),
  //         );
  //         canToEmail.then((isCanToEmail) async {
  //           if (isCanToEmail == true) {
  //             launchUrl(
  //               Uri.parse(
  //                 "mailto:?subject=${share_text2}&body=${share_url2}",
  //               ),
  //             );
  //           } else {
  //             await G.toast('請安裝第三方郵箱工具');
  //           }
  //         });
  //       } catch (e) {
  //         print('eeeeeeeeee2======================>${e}');
  //       }
  //     },
  //   );
  // }
  //
  // web_view.JavascriptChannel iosJavascript6(BuildContext context) {
  //   return web_view.JavascriptChannel(
  //     name: 'InAppWebViewCopyFuncCallback',
  //     onMessageReceived: (web_view.JavascriptMessage message) async {
  //       print(
  //         'InAppWebViewCopyFuncCallback=========>${message}',
  //       );
  //       Clipboard.setData(ClipboardData(text: share_url));
  //       await G.toast('已復制連結');
  //     },
  //   );
  // }
  //
  // web_view.JavascriptChannel iosJavascript7(BuildContext context) {
  //   return web_view.JavascriptChannel(
  //     name: 'InAppWebViewHotArticleClickFuncFuncCallback',
  //     onMessageReceived: (web_view.JavascriptMessage message) async {
  //       print(
  //         'InAppWebViewHotArticleClickFuncFuncCallback=========>${message}',
  //       );
  //       // print(arguments[0] is String);
  //       List res = json.decode(message.message);
  //       G.pushNamed(
  //         '/article_detail',
  //         arguments: {'id': int.parse(res[0])},
  //       );
  //     },
  //   );
  // }
  //
  // web_view.JavascriptChannel iosJavascript8(BuildContext context) {
  //   return web_view.JavascriptChannel(
  //     name: 'InAppWebViewMoreArticleFuncCallback',
  //     onMessageReceived: (web_view.JavascriptMessage message) async {
  //       print(
  //         'InAppWebViewMoreArticleFuncCallback=========>${message}',
  //       );
  //       G.pushNamed(
  //         '/article_list',
  //         arguments: {
  //           'eland_id': article?.eland_id,
  //           'ishot': true,
  //         },
  //       );
  //     },
  //   );
  // }
  //
  // web_view.JavascriptChannel iosJavascript9(BuildContext context) {
  //   return web_view.JavascriptChannel(
  //     name: 'InAppWebViewFollowElandFuncCallback',
  //     onMessageReceived: (web_view.JavascriptMessage message) async {
  //       print(
  //         'InAppWebViewFollowElandFuncCallback=========>${message}',
  //       );
  //       _clickElandFollow(article);
  //     },
  //   );
  // }
  //
  // web_view.JavascriptChannel iosJavascript10(BuildContext context) {
  //   return web_view.JavascriptChannel(
  //     name: 'InAppWebViewGoElandPageFuncCallback',
  //     onMessageReceived: (web_view.JavascriptMessage message) async {
  //       print(
  //         'InAppWebViewGoElandPageFuncCallback=========>${message}',
  //       );
  //       G.pushNamed(
  //         '/eland_info',
  //         arguments: {'id': article?.eland_id},
  //       );
  //     },
  //   );
  // }
  //
  // web_view.JavascriptChannel iosJavascript11(BuildContext context) {
  //   return web_view.JavascriptChannel(
  //     name: 'InAppWebViewOpenImageByContentFuncCallback',
  //     onMessageReceived: (web_view.JavascriptMessage message) async {
  //       print(
  //         'InAppWebViewOpenImageByContentFuncCallback=========>${message}',
  //
  //       );
  //       dynamic res = json.decode(message.message);
  //       // print('arguments====>${arguments}');
  //       if (res.length > 0 && res[0] != null) {
  //         APhotoview.show(context, url: res[0]);
  //       }
  //     },
  //   );
  // }
  //
  // web_view.JavascriptChannel iosJavascript12(BuildContext context) {
  //   return web_view.JavascriptChannel(
  //     name: 'InAppWebViewOpenHrefByContentFuncCallback',
  //     onMessageReceived: (web_view.JavascriptMessage message) async {
  //       print(
  //         'InAppWebViewOpenHrefByContentFuncCallback=========>${message}',
  //       );
  //       dynamic arguments = json.decode(message.message);
  //       // print('arguments====>${arguments}');
  //       if (arguments.length > 0 && arguments[0] != null) {
  //         String hrefVal = arguments[0];
  //         String extVal = hrefVal.substring(
  //           hrefVal.lastIndexOf(".") + 1,
  //           hrefVal.length,
  //         );
  //         if (extVal == 'pdf') {
  //           APdfview.show(context, url: hrefVal);
  //         } else {
  //           List hrefValArr = hrefVal.split("/");
  //           String pos = hrefValArr[hrefValArr.length - 2];
  //           String val = hrefValArr[hrefValArr.length - 1];
  //           print('pos====>${pos}');
  //           print('val====>${val}');
  //           if (pos == 'article') {
  //             G.pushNamed(
  //               '/article_detail',
  //               arguments: {'id': int.parse(val)},
  //             );
  //           } else {
  //             if (await canLaunchUrl(Uri.parse(hrefVal))) {
  //               await launchUrl(Uri.parse(hrefVal));
  //             } else {
  //               AWebview.open(
  //                 context,
  //                 url: hrefVal,
  //                 title: hrefVal,
  //               );
  //             }
  //           }
  //         }
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    print('buildArticleDetail article====>${article}');
    print('buildArticleDetail isloading====>${isloading}');
    print('buildArticleDetail context====>${context}');
    return Scaffold(
      // Ian 20251107 - originally is ffccccc, missing 1 'c'
      backgroundColor: Color(0xffcccccc),
      appBar: customAppbar(
        context: context,
        title: header_title,
        default_actions: true,
        onGoBackPressed: () {
          print('onGoBackPressed====>${_submit_i}');
          if (_submit_i == false) {
            Navigator.pop(context);
          }
        },
        actions: <Widget>[
          new Container(
            //                alignment: const Alignment(0.0, 1.0),
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              //                  color: hex('#fff'),
              border: new Border(
                left: BorderSide(
                  width: 1.0,
                  color: Color.fromARGB(255, 229, 229, 229),
                ),
              ),
            ),
            //                child: InkWell(
            //                    child: icon_more_vert(color: rgba(0, 0, 0, 1), size: 20),
            //                    onTap: (){
            ////                      G.pushNamed('/setting');
            //                    }
            //                ),
            child: new PopupMenuButton<String>(
              icon: icon_more_vert(
                color: Color.fromARGB(255, 0, 0, 0),
                size: 20,
              ),
              //这是点击弹出菜单的操作，点击对应菜单后，改变屏幕中间文本状态，将点击的菜单值赋予屏幕中间文本
              onSelected: (String value) {
                print('onSelected share_url===>${share_url}');
                if (value == 'copylink') {
                  if (share_url.isNotEmpty) {
                    Clipboard.setData(ClipboardData(text: share_url));
                    G.toast('已復制連結');
                  } else {
                    G.toast('沒有可復制的連結');
                  }
                } else if (value == 'report') {
                  Navigator.pushNamed(
                    context,
                    '/article_report',
                    arguments: {
                      'articleid': id,
                      'article_title': '${header_title}',
                    },
                  );
                  // ADialog.confirm(context,
                  //     content: '確認報告？',
                  //     confirmButtonPress: () {
                  //       _clickDoReport(article);
                  //     }
                  // );
                } else if (value == 'refontsize') {
                  _showSetFontSizeBlock();
                }
                print('onSelected===>${value}');
              },
              //这是弹出菜单的建立，包含了两个子项，分别是增加和删除以及他们对应的值
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem(
                  //                      child: Text('aaa'),
                  child: (article == null)
                      ? new Row()
                      : new Row(
                          //                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            icon_content_copy(
                              size: 20,
                              color: Color(0xff333333),
                            ),
                            SizedBox(width: 10),
                            new Text('復制邀請連結'),
                            //                          new Icon(Icons.add_circle)
                          ],
                        ),
                  value: 'copylink',
                ),
                PopupMenuItem(
                  child: (article == null)
                      ? new Row()
                      : new Row(
                          //                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            icon_report(size: 20, color: Color(0xff333333)),
                            SizedBox(width: 10),
                            new Text('報告'),
                            //                          new Icon(Icons.add_circle)
                          ],
                        ),
                  //                      child: Text('bbbbbbbbb'),
                  value: 'report',
                ),
                PopupMenuItem(
                  child: (article == null)
                      ? new Row()
                      : new Row(
                          //                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            icon_text_rotate_up(
                              size: 20,
                              color: Color(0xff333333),
                            ),
                            SizedBox(width: 10),
                            new Text('調整字體大小'),
                            //                          new Icon(Icons.add_circle)
                          ],
                        ),
                  //                      child: Text('bbbbbbbbb'),
                  value: 'refontsize',
                ),
              ],
            ),
          ),
        ],
      ),
      body: (article == null)
          ? _buildProgressIndicator()
          : Stack(
              children: <Widget>[
                // Text(article.content_app_link.toString()),
                 Container(
                  margin: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 10.0,
                    bottom: 85.0,
                  ),
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 20.0,
                  ),
                  color: Color(0xffffffff),
                  width: G.screenWidth(),
                  height: G.screenHeight(),
                  child: InAppWebView(
                    //initialUrlRequest: URLRequest(url: Uri.parse("about:blank")),
                    initialUrlRequest: URLRequest(
                      url: WebUri(article?.MobileAppViewUrl ?? 'about:blank'),
                    ), // Placeholder URL
                    initialSettings: InAppWebViewSettings(
                      useShouldOverrideUrlLoading: true,
                      useOnLoadResource: true,
                      javaScriptEnabled: true,
                      cacheEnabled: true,
                      disableVerticalScroll: false,
                      disableHorizontalScroll: false,
                      verticalScrollBarEnabled: false,
                      horizontalScrollBarEnabled: false,
                      isPagingEnabled: false,
                    ),

                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                      print(
                        'onWebViewCreated=====>${article?.MobileAppViewUrl} + "/?user_id=${userid}"}',
                      );

                      webView?.addJavaScriptHandler(
                        handlerName: "InAppWebViewGetReadyCallback",
                        callback: (arguments) async {
                          print(
                            "InAppWebViewGetReadyCallback====>${arguments}",
                          );
                          webView?.evaluateJavascript(
                            source:
                                """
                        var _dom = document.getElementById('article-content');
                        reFontSize(_dom,""" +
                                custom_font_size.toString() +
                                """);
                      """,
                          );
                        },
                      );

                      webView?.addJavaScriptHandler(
                        handlerName: "InAppWebViewFacebookCallback",
                        callback: (arguments) async {
                          print(
                            "InAppWebViewFacebookCallback====>${arguments}",
                          );
                          print('shareToFacebook======>${share_url}');
                          List<String> share_url_arr = share_url.split('/');
                          String share_url2 = '';
                          if (share_url_arr.length > 0) {
                            for (int i = 0; i < share_url_arr.length; i++) {
                              if (i == share_url_arr.length - 1) {
                                share_url2 += Uri.encodeComponent(
                                  share_url_arr[share_url_arr.length - 1],
                                );
                              } else {
                                share_url2 += share_url_arr[i] + '/';
                              }
                            }
                          }
                          print('share_url2====>${share_url2}');
                          var response = await SharePlus.instance.share(
                            ShareParams(
                              uri: Uri.parse(share_url2),
                              text: share_text,
                            ),
                          );
                          print('shareToFacebook2======>${response}');
                        },
                      );

                      webView?.addJavaScriptHandler(
                        handlerName: "InAppWebViewTwitterFuncCallback",
                        callback: (arguments) async {
                          print('shareToTwitter======>${share_url}');
                          /* var response = FlutterShareMe().shareToTwitter(
                            url: share_url,
                            msg: share_text!,
                          ); */
                          var response = await SharePlus.instance.share(
                            ShareParams(
                              uri: Uri.parse(share_url),
                              text: share_text,
                            ),
                          );
                          print('shareToTwitter======>${response}');
                        },
                      );

                      webView?.addJavaScriptHandler(
                        handlerName: "InAppWebViewWhatsAppFuncCallback",
                        callback: (arguments) async {
                          print(
                            'InAppWebViewWhatsAppFuncCallback=========>${arguments}',
                          );

                          if (Platform.isAndroid) {
                            var response = await SharePlus.instance.share(
                              ShareParams(
                                uri: Uri.parse(share_url),
                                //text: share_text,
                              ),
                            );

                            if (response == 'false' || response == false) {
                              await G.toast('請安裝WhatsApp');
                            }
                          } else {
                            //                        print('IOS自动登陆开发中====>');
                            String share_url2 = Uri.encodeComponent(share_url);
                            try {
                              //                          "whatsapp://send?text=${share_url2}"
                              Future<bool> canToWhatsApp = canLaunchUrl(
                                Uri.parse("whatsapp://send?text=${share_url2}"),
                              );
                              canToWhatsApp.then((isCanToWhatsApp) async {
                                if (isCanToWhatsApp == true) {
                                  launchUrl(
                                    Uri.parse(
                                      "whatsapp://send?text=${share_url2}",
                                    ),
                                  );
                                } else {
                                  await G.toast('請安裝WhatsApp');
                                }
                              });
                            } catch (e) {
                              print('eeeeeeeeee2======================>${e}');
                            }
                          }
                          //                      print("InAppWebViewWhatsAppFuncCallbackResult====>${response}");
                        },
                      );

                      webView?.addJavaScriptHandler(
                        handlerName: "InAppWebViewEmailFuncCallback",
                        callback: (arguments) async {
                          print(
                            'InAppWebViewEmailFuncCallback=========>${arguments}',
                          );
                          String share_text2 = Uri.encodeComponent(share_text!);
                          String share_url2 = Uri.encodeComponent(share_url);
                          try {
                            Future<bool> canToEmail = canLaunchUrl(
                              Uri.parse(
                                "mailto:?subject=${share_text2}&body=${share_url2}",
                              ),
                            );
                            canToEmail.then((isCanToEmail) async {
                              if (isCanToEmail == true) {
                                launchUrl(
                                  Uri.parse(
                                    "mailto:?subject=${share_text2}&body=${share_url2}",
                                  ),
                                );
                              } else {
                                await G.toast('請安裝第三方郵箱工具');
                              }
                            });
                          } catch (e) {
                            print('eeeeeeeeee2======================>${e}');
                          }
                          //                      launch("mailto:451027779@qq.com");
                        },
                      );

                      webView?.addJavaScriptHandler(
                        handlerName: "InAppWebViewCopyFuncCallback",
                        callback: (arguments) async {
                          print(
                            'InAppWebViewCopyFuncCallback=========>${arguments}',
                          );
                          Clipboard.setData(ClipboardData(text: share_url));
                          await G.toast('已復制連結');
                          //                      print("InAppWebViewCopyFuncCallbackResult====>${result}");
                        },
                      );

                      webView?.addJavaScriptHandler(
                        handlerName:
                            "InAppWebViewHotArticleClickFuncFuncCallback",
                        callback: (arguments) async {
                          print(
                            'InAppWebViewHotArticleClickFuncFuncCallback=========>${arguments}',
                          );
                          // print(arguments[0] is String);
                          G.pushNamed(
                            '/article_detail',
                            arguments: {'id': int.parse(arguments[0])},
                          );
                        },
                      );

                      webView?.addJavaScriptHandler(
                        handlerName: "InAppWebViewMoreArticleFuncCallback",
                        callback: (arguments) async {
                          print(
                            'InAppWebViewMoreArticleFuncCallback=========>${arguments}',
                          );
                          G.pushNamed(
                            '/article_list',
                            arguments: {
                              'eland_id': article?.eland_id,
                              'ishot': true,
                            },
                          );
                        },
                      );

                      webView?.addJavaScriptHandler(
                        handlerName: "InAppWebViewFollowElandFuncCallback",
                        callback: (arguments) async {
                          print(
                            'InAppWebViewFollowElandFuncCallback=========>${arguments}',
                          );
                          _clickElandFollow(article);
                        },
                      );

                      webView?.addJavaScriptHandler(
                        handlerName: "InAppWebViewGoElandPageFuncCallback",
                        callback: (arguments) async {
                          print(
                            'InAppWebViewGoElandPageFuncCallback=========>${arguments}',
                          );
                          G.pushNamed(
                            '/eland_info',
                            arguments: {'id': article?.eland_id},
                          );
                        },
                      );

                      webView?.addJavaScriptHandler(
                        handlerName:
                            "InAppWebViewOpenImageByContentFuncCallback",
                        callback: (arguments) async {
                          print(
                            'InAppWebViewOpenImageByContentFuncCallback=========>${arguments}',
                          );
                          // print('arguments====>${arguments}');
                          if (arguments.length > 0 && arguments[0] != null) {
                            APhotoview.show(context, url: arguments[0]);
                          }
                        },
                      );

                      webView?.addJavaScriptHandler(
                        handlerName:
                            "InAppWebViewOpenHrefByContentFuncCallback",
                        callback: (arguments) async {
                          print(
                            'InAppWebViewOpenHrefByContentFuncCallback=========>${arguments}',
                          );
                          // print('arguments====>${arguments}');
                          if (arguments.length > 0 && arguments[0] != null) {
                            String hrefVal = arguments[0];
                            String extVal = hrefVal.substring(
                              hrefVal.lastIndexOf(".") + 1,
                              hrefVal.length,
                            );
                            if (extVal == 'pdf') {
                              APdfview.show(context, url: hrefVal);
                            } else {
                              List hrefValArr = hrefVal.split("/");
                              String pos = hrefValArr[hrefValArr.length - 2];
                              String val = hrefValArr[hrefValArr.length - 1];
                              print('pos====>${pos}');
                              print('val====>${val}');
                              if (pos == 'article') {
                                G.pushNamed(
                                  '/article_detail',
                                  arguments: {'id': int.parse(val)},
                                );
                              } else {
                                if (await canLaunchUrl(Uri.parse(hrefVal))) {
                                  await launchUrl(Uri.parse(hrefVal));
                                } else {
                                  AWebview.open(
                                    context,
                                    url: hrefVal,
                                    title: hrefVal,
                                  );
                                }
                              }
                            }
                          }
                        },
                      );
                    },
                    onLoadStop: (controller, url) {
                      print('onLoadStop=====>');
                      setState(() {
                        isloading = false;
                      });
                    },
                    onReceivedError: (controller, request, error) {
                      setState(() {
                        isloading = false; // Hide the progress indicator
                        print(
                          "WebView Error: code=${error}, description=${error.description}, request=${request.url}",
                        );
                      });
                    },
                    onProgressChanged:
                        (InAppWebViewController controller, int progress) {
                          print('progress====>${progress / 100}');
                          if ((progress / 100) > 0.90) {
                            print('progress2====>${progress}');
                            setState(() {
                              isloading = false;
                            });
                          }
                        },
                  ),
                ),
                (isloading == false)
                    ? Container()
                    : Positioned(
                        top: G.screenHeight() / 2 - 100,
                        left: G.screenWidth() / 2 - 20,
                        //            child: CircularProgressIndicator(
                        //              strokeWidth: 2.0,
                        //              backgroundColor: rgba(28, 141, 160, 1),
                        //            ),
                        child: new Opacity(
                          opacity: 1.0,
                          child: new CircularProgressIndicator(
                            backgroundColor: Color.fromARGB(255, 28, 141, 160),
                            valueColor: new AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      // Ian 20251107 : bug is originally 0xfffffff, missing 1 'f'
                      color: Color(0xffffffff),
                      border: new Border(
                        top: BorderSide(width: 2.0, color: Color(0xffcacbd1)),
                      ),
                    ),
                    padding: EdgeInsets.only(
                      left: 30.0,
                      right: 20.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    width: G.screenWidth(),
                    height: 75,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 5, bottom: 5.0),
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
                                        color: Color(0xff333333),
                                        fontSize: 15,
                                        height: 2,
                                        //                              letterSpacing: 10.0,
                                        decoration: TextDecoration.none,
                                      ),
                                      children: <TextSpan>[
                                        new TextSpan(text: "閱讀量："),
                                        new TextSpan(
                                          text: article?.read.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              (article?.ilike == true &&
                                      (article?.like ?? 0) > 0)
                                  ? AButton.icon(
                                      width: 70,
                                      height: 25,
                                      borderColor: Colors.pink,
                                      bgColor: Colors.pink,
                                      plain: true,
                                      textChild: Text(
                                        article!.like.toString(),
                                        style: TextStyle(
                                          //color: Color(0xfffffff),
                                          // Ian 20251111: wrong color
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                      icon: icon_favorite(
                                        size: 13,
                                        //color: Color(0xfffffff),
                                        // Ian 20251111: wrong color
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        _clickDoLike(article);
                                        //###Leo
                                        Map initMap = Provider.of<DoLikeMethod>(
                                          context,
                                          listen: false,
                                        ).pushLike;
                                        Map map = {
                                          "isLike": false,
                                          'id': initMap['id'],
                                          'num': (article?.like ?? 0) - 1,
                                        };
                                        Provider.of<DoLikeMethod>(
                                          context,
                                          listen: false,
                                        ).getPopIsLike(map);
                                      },
                                    )
                                  : AButton.icon(
                                      width: 70,
                                      height: 25,
                                      borderColor: Colors.pink,
                                      bgColor: Color(0xfffffff),
                                      plain: true,
                                      textChild: Text(
                                        article!.like.toString(),
                                        style: TextStyle(
                                          color: Colors.pink,
                                          fontSize: 13,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                      icon: icon_favorite_border(
                                        size: 13,
                                        color: Colors.pink,
                                      ),
                                      onPressed: () {
                                        //###Leo
                                        Map initMap = Provider.of<DoLikeMethod>(
                                          context,
                                          listen: false,
                                        ).pushLike;
                                        Map map = {
                                          "isLike": true,
                                          'id': initMap['id'],
                                          'num': (article?.like ?? 0) + 1,
                                        };
                                        Provider.of<DoLikeMethod>(
                                          context,
                                          listen: false,
                                        ).getPopIsLike(map);
                                        _clickDoLike(article);
                                      },
                                    ),
                              Container(width: 10.0),
                              AButton.icon(
                                width: 70,
                                height: 25,
                                borderColor: Color.fromARGB(255, 28, 141, 160),
                                bgColor: Color(0xffffffff),
                                plain: true,
                                textChild: (article!.comment_num == null)
                                    ? Text(
                                        '0',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            28,
                                            141,
                                            160,
                                          ),
                                          fontSize: 13,
                                        ),
                                      )
                                    : Text(
                                        article!.comment_num.toString(),
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            28,
                                            141,
                                            160,
                                          ),
                                          fontSize: 13,
                                        ),
                                      ),
                                borderRadius: BorderRadius.circular(40),
                                icon: icon_comment(
                                  size: 13,
                                  color: Color.fromARGB(255, 28, 141, 160),
                                ),
                                onPressed: () {
                                  G.pushNamed(
                                    '/comment_page',
                                    arguments: {'id': article!.id},
                                  );
                                },
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
