import 'dart:io';
import '../../provider/do_like_method.dart';
import 'package:provider/provider.dart';
//import 'package:color_dart/HexColor.dart';
//import 'package:color_dart/RgbaColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:social_share_plugin/social_share_plugin.dart';
import '../../components/custom_navbar/index.dart';
import '../../components/a_cached_network_image/index.dart';
import '../../model/user_model/data.dart';
import '../../model/eland_detail_model/data.dart';
import '../../components/a_button/index.dart';
import '../../components/a_pdfview/index.dart';
import '../../components/a_audioview/index.dart';
import '../../components/a_article_list/index.dart';
import '../../components/a_eland_prayers_list/index.dart';
import '../../components/a_web_view/index.dart';
import '../../utils/global.dart';

class ElandInfo extends StatefulWidget {
  final Map args;

  ElandInfo({Key? key, required this.args}) : super(key: key);

  @override
  createState() => _ElandInfoState();
}

class _ElandInfoState extends State<ElandInfo> {
  static Map? args;
  String? eland_header_title;
  int eland_id = 0;
  int userid = 0;
  ElandDetailModel? eland_info;
  double headerHeight = 200;
  ElandDetailData? eland;
  ScrollController scrollController = ScrollController();

  //double? _lat;
  //double? _lng;
  String? _lat;
  String? _lng;

  @override
  void initState() {
    super.initState();
    args = widget.args;
    eland_id = args?['id'];
    Future.delayed(Duration.zero, () {
      UserDataModel userData = G.user.data;
      userid = userData.id ?? 0;
      _loadElandData(elandid: eland_id, uid: userid);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _loadElandData({int elandid = 0, int uid = 0}) async {
    try {
      var res = await G.req.eland.detail(userid: uid, eland_id: elandid);
      if (res.data != null) {
        Map result = res.data;
        print('result=====>${result}');
        if (res.data != null) {
          if (res.data is Map<String, dynamic>) {
            Map<String, dynamic> result = res.data;
            // ... your existing code ...
            setState(() {
              eland_info = ElandDetailModel.fromJson(result);
              eland_header_title = eland_info?.data?.name;
              eland = eland_info?.data;
              //_lat = double.parse(eland.map.lat);
              //_lng = double.parse(eland.map.lng);
              _lat = eland?.map?.lat;
              _lng = eland?.map?.lng;
              //            _lat = -33.852;
              //            _lng = 151.211;
              print('location===>${_lat}/${_lng}');
            });
          } else {
            // Handle the case where res.data is not a Map<String, dynamic>
            print('Error: res.data is not a Map<String, dynamic>');
          }
        }
      }
    } catch (e) {
      print('dataElandInfoCatch===>${e}');
    }
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        /*forceSafariVC: false,
        forceWebView: false,*/
        mode: LaunchMode.externalApplication,
        //        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  _clickFollow(item) {
    int uid = G.user.data.id ?? 0;
    int itemid = item.id;
    try {
      Future.delayed(Duration.zero, () async {
        var res = await G.req.eland.dofollow(eland_id: itemid, userid: uid);
        Map result = res.data;
        if (result['code'] == 200) {
          setState(() {
            if (item.ifollow == true && item.follow > 0) {
              eland?.follow = item.follow - 1;
              eland?.ifollow = false;
            } else {
              eland?.follow = item.follow + 1;
              eland?.ifollow = true;
            }
          });
        }
      });
    } catch (e) {
      print('articledocollect===>${e}');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final brochureList = eland?.brochure;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppbar(context: context, title: eland_header_title),
      body: (eland == null)
          ? _buildProgressIndicator()
          : Stack(
              children: <Widget>[
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          //                  (eland.name == '')?Text(''):Text(eland.name),
                          Container(
                            child: AcachedNetworkImage(
                              eland?.cover ?? '',
                              fit: BoxFit.cover,
                              height: headerHeight,
                              width: MediaQuery.of(context).size.width,
                            ),
                            margin: EdgeInsets.only(bottom: 30.0),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                AcachedNetworkImage(
                                  eland?.avatar ?? '',
                                  height: 70,
                                  width: 70,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(right: 10),
                          ),
                        ],
                      ),

                      SizedBox(height: 5),

                      Container(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          bottom: 10.0,
                        ),
                        decoration: BoxDecoration(
                          border: new Border(
                            bottom: BorderSide(
                              width: 10.0,
                              color: Color(0xffcacbd1),
                            ),
                          ),
                        ),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.only(right: 10.0),
                                  child: AcachedNetworkImage(
                                    eland?.type_pic ?? '',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                new Container(
                                  width: G.screenWidth() * 0.6,
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        eland?.name ?? '',
                                        style: new TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      new Text(
                                        eland?.type ?? '',
                                        style: new TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            new Column(
                              children: <Widget>[
                                new Text(
                                  eland?.follow?.toString() ?? '0',
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                new Text(
                                  '用戶關注',
                                  style: new TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13.0,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  child:
                                      ((eland?.ifollow ?? '0') == true &&
                                          (eland?.follow ?? 0) > 0)
                                      ? AButton.icon(
                                          width: 70,
                                          height: 25,
                                          borderColor: Color.fromARGB(
                                            255,
                                            28,
                                            141,
                                            160,
                                          ),
                                          bgColor: Color.fromARGB(
                                            255,
                                            28,
                                            141,
                                            160,
                                          ),
                                          plain: true,
                                          textChild: Text(
                                            '已關注',
                                            style: TextStyle(
                                              color: Color(0xffffffff),
                                              fontSize: 13,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            40,
                                          ),
                                          icon: icon_check(
                                            size: 13,
                                            color: Color(0xffffffff),
                                          ),
                                          onPressed: () {
                                            _clickFollow(eland);
                                            Map initMap =
                                                Provider.of<DoLikeMethod>(
                                                  context,
                                                  listen: false,
                                                ).pushLike;
                                            Map map = {
                                              "isLike":
                                                  !(eland?.ifollow ?? false),
                                              'id': initMap['id'],
                                              'num': (eland?.follow ?? 0),
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
                                          borderColor: Color.fromARGB(
                                            255,
                                            28,
                                            141,
                                            160,
                                          ),
                                          bgColor: Color(0xffffffff),
                                          plain: true,
                                          textChild: Text(
                                            '關注',
                                            style: TextStyle(
                                              color: Color(0xff333333),
                                              fontSize: 13,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            40,
                                          ),
                                          icon: icon_puls(
                                            size: 13,
                                            color: Color(0xff333333),
                                          ),
                                          onPressed: () {
                                            Map initMap =
                                                Provider.of<DoLikeMethod>(
                                                  context,
                                                  listen: false,
                                                ).pushLike;
                                            Map map = {
                                              "isLike":
                                                  !(eland?.ifollow ?? false),
                                              'id': initMap['id'],
                                              'num': eland?.follow ?? 0,
                                            };
                                            Provider.of<DoLikeMethod>(
                                              context,
                                              listen: false,
                                            ).getPopIsLike(map);
                                            _clickFollow(eland);
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          border: new Border(
                            bottom: BorderSide(
                              width: 10.0,
                              color: Color(0xffcacbd1),
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              "分享",
                              style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              // decoration: BoxDecoration(
                              //   border: new Border(bottom: BorderSide(width: 1.0, color: hex('#cacbd1'))),
                              // ),
                              padding: const EdgeInsets.only(bottom: 0),
                              margin: const EdgeInsets.only(top: 5),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new InkWell(
                                    child: SvgPicture.string(
                                      '''<svg t="1589530069365" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="3731" width="48" height="48"><path d="M512.262115 959.556658c247.175132 0 447.569968-200.366167 447.569968-447.556658 0-247.16387-200.394836-447.556658-447.569968-447.556658-247.17718 0-447.556658 200.392788-447.556658 447.556658-0.001024 247.190491 200.378454 447.556658 447.556658 447.556658" fill="#537BBC" p-id="3732"></path><path d="M404.292383 436.216104h46.269378v-44.969044c0-19.828563 0.499656-50.408946 14.904699-69.347753 15.172957-20.05689 36.000832-33.690947 71.826579-33.690946 58.371702 0 82.952117 8.326235 82.952118 8.326235l-11.564785 68.550147s-19.285904-5.576079-37.275569-5.57608c-17.99888 0-34.111763 6.449454-34.111764 24.438095v52.269346h73.791416l-5.152191 66.958004h-68.639225v232.604221h-86.731278V503.174108h-46.269378v-66.958004z" fill="#FFFFFF" p-id="3733"></path></svg>''',
                                      width: 50,
                                      height: 50,
                                    ),
                                    onTap: () async {
                                      print(
                                        'eland.MobileAppViewUrl=======>${eland?.MobileAppViewUrl}',
                                      );
                                      // final result = await SocialSharePlugin.shareToFeedFacebookLink(
                                      //   quote: eland.desc,
                                      //   url: eland.MobileAppViewUrl,
                                      //   // url: 'http://baidu.com',
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
                                      var response = FlutterShareMe()
                                          .shareToFacebook(
                                            url: '${eland?.MobileAppViewUrl}',
                                            msg: '${eland?.desc}',
                                          );
                                      print(
                                        'shareToFacebook======>${response}',
                                      );
                                    },
                                  ),
                                  new InkWell(
                                    child: SvgPicture.string(
                                      '''<svg t="1589529900245" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2712" width="48" height="48"><path d="M512.274401 959.556658c247.17718 0 447.556658-200.366167 447.556658-447.556658 0-247.16387-200.379477-447.556658-447.556658-447.556658-247.188443 0-447.569968 200.392788-447.569968 447.556658 0 247.190491 200.382549 447.556658 447.569968 447.556658" fill="#78CBEF" p-id="2713"></path><path d="M736.810405 394.754891c-16.48353 7.310541-34.227463 12.256931-52.82122 14.478763 19.004336-11.383557 33.588558-29.396772 40.435279-50.868671-17.780793 10.536804-37.440415 18.183179-58.42392 22.294079-16.741549-17.872942-40.666677-29.038412-67.134113-29.038412-50.766282 0-91.948998 41.192954-91.948998 91.972548 0 7.220439 0.784296 14.222791 2.366199 20.943574-76.439183-3.841618-144.191723-40.421969-189.587726-96.109044-7.915657 13.630985-12.452493 29.422369-12.452493 46.282688 0 31.877646 16.241893 60.042683 40.924696 76.552835-15.072616-0.460748-29.26981-4.637177-41.682371-11.485946v1.131393c0 44.585086 31.698466 81.757243 73.804725 90.185867-7.723167 2.160398-15.841554 3.239573-24.246628 3.239574a91.24866 91.24866 0 0 1-17.294447-1.63105c11.691747 36.527109 45.654023 63.139936 85.90705 63.845394-31.477307 24.682804-71.144672 39.382725-114.227718 39.382725-7.42624 0-14.762379-0.410578-21.946982-1.270642 40.706609 26.070168 89.057546 41.308653 140.992081 41.308653 169.209337 0 261.697922-140.132017 261.697922-261.695874 0-3.997248-0.078839-7.979138-0.244709-11.899595a186.466924 186.466924 0 0 0 45.883373-47.618859" fill="#FFFFFF" p-id="2714"></path></svg>''',
                                      width: 50,
                                      height: 50,
                                    ),
                                    onTap: () async {
                                      // final result = await SocialSharePlugin.shareToTwitterLink(
                                      //     text: eland.desc,
                                      //     url: eland.MobileAppViewUrl,
                                      //     onSuccess: (_) {
                                      //       print('TWITTER SUCCESS=====>${_}');
                                      //       return;
                                      //     },
                                      //     onCancel: () {
                                      //       print('TWITTER CANCELLED=====>');
                                      //       return;
                                      //     }
                                      // );
                                      // print("InAppWebViewTwitterFuncCallbackResult====>${result}");
                                      var response = FlutterShareMe()
                                          .shareToTwitter(
                                            url: '${eland?.MobileAppViewUrl}',
                                            msg: '${eland?.desc}',
                                          );
                                      print('shareToTwitter======>${response}');
                                    },
                                  ),
                                  new InkWell(
                                    child: SvgPicture.string(
                                      '''<svg t="1594284620020" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2357" width="48" height="48"><path d="M544.059897 959.266898h-64.949141c-228.633593 0-415.697442-187.063849-415.697442-415.697442v-64.949141c0-228.633593 187.063849-415.697442 415.697442-415.697442h64.949141c228.633593 0 415.697442 187.063849 415.697442 415.697442v64.949141C959.756315 772.203049 772.692466 959.266898 544.059897 959.266898z" fill="#4DC247" p-id="2358"></path><path d="M576.882589 541.680388c-8.480842 0-24.804646 31.690275-34.608348 31.690274-2.554594-0.107508-5.03342-0.893852-7.181531-2.280192-18.284544-9.164798-34.288896-18.626522-49.313389-32.989585-12.424848-11.764442-26.127506-29.410082-33.286512-44.754028-0.988049-1.452893-1.563473-3.147423-1.663814-4.901339 0-7.523509 22.570528-21.544595 22.570528-33.970467 0-3.260051-16.643256-47.649575-18.968499-53.23487-3.260051-8.480842-4.878814-11.103012-13.679108-11.103012-4.263458 0-8.207465-0.979858-12.082871-0.979859-6.885629 0-12.082871 2.62217-17.007759 7.181532-15.685923 14.705041-23.527861 30.048987-24.166765 51.616107v2.598621c-0.341978 22.570528 10.761035 45.072456 23.185883 63.380549 28.042171 41.493977 57.133825 77.743613 103.825043 98.94623 14.043611 6.543651 46.395316 20.245285 62.05769 20.245285 18.626522 0 49.017486-11.740893 56.49492-30.048987 2.964148-7.523509 5.562769-16.643256 5.562769-24.804645 0-1.321836 0-3.282576-0.683955-4.90134C635.656678 569.449182 582.445358 541.680388 576.882589 541.680388zM510.583967 714.790727c-39.829139 0-79.338826-12.082871-112.671413-33.970467l-79.042923 25.124098 25.808053-76.078775c-25.459932-34.906298-39.189211-76.990033-39.213784-120.194922 0-112.967316 92.106676-205.073992 205.119043-205.073992s205.142592 92.084151 205.142592 205.051466C715.725535 622.684051 623.619883 714.790727 510.583967 714.790727zM510.583967 263.423169c-135.879821 0-246.225991 110.39122-246.225991 246.22599 0 44.776553 12.082871 88.869151 35.246228 127.079527l-44.41205 132.277793 136.199274-43.773145c119.12701 65.765178 269.012559 22.506023 334.776713-96.62201 20.106036-36.419601 30.662294-77.338154 30.685843-118.939639 0-135.834771-110.39122-246.225991-246.271041-246.225991L510.583967 263.423169z" fill="#FFFFFF" p-id="2359"></path></svg>''',
                                      width: 50,
                                      height: 50,
                                    ),
                                    onTap: () async {
                                      String? response;
                                      final url = eland?.MobileAppViewUrl;
                                      if (Platform.isAndroid) {
                                        response = await FlutterShareMe()
                                            .shareToWhatsApp(msg: url ?? '');
                                        if (response == 'false' ||
                                            response == false) {
                                          await G.toast('請安裝WhatsApp');
                                        }
                                      } else {
                                        String share_url2 = Uri.encodeComponent(
                                          url ?? '',
                                        );
                                        try {
                                          Future<bool>
                                          canToWhatsApp = canLaunchUrl(
                                            Uri.parse(
                                              "whatsapp://send?text=${share_url2}",
                                            ),
                                          );
                                          canToWhatsApp.then((
                                            isCanToWhatsApp,
                                          ) async {
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
                                          print(
                                            'eeeeeeeeee2======================>${e}',
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  new InkWell(
                                    child: SvgPicture.string(
                                      '''<svg t="1589531921476" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="13300" width="48" height="48"><path d="M689.38 369.87H334.5L512.13 547.5z" fill="#717071" p-id="13301"></path><path d="M504.7 569.52L320.15 385.1v269.03h383.58V385.1L519.3 569.52c-3.96 3.96-10.64 3.96-14.6 0z" fill="#717071" p-id="13302"></path><path d="M512 64C264.58 64 64 264.58 64 512s200.58 448 448 448 448-200.58 448-448S759.42 64 512 64z m226.72 288.93v318.51c0 9.89-7.92 17.57-17.56 17.57H302.59c-9.4 0-17.31-7.68-17.31-17.57V352.43c0-9.52 7.92-17.44 17.31-17.44h418.57c9.64 0 17.56 7.92 17.56 17.44v0.5z" fill="#717071" p-id="13303"></path></svg>''',
                                      width: 50,
                                      height: 50,
                                    ),
                                    onTap: () {
                                      final desc = eland?.desc ?? '';
                                      final url = eland?.MobileAppViewUrl ?? '';
                                      String share_text2 = Uri.encodeComponent(
                                        desc,
                                      );
                                      String share_url2 = Uri.encodeComponent(
                                        url,
                                      );
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
                                        print(
                                          'eeeeeeeeee2======================>${e}',
                                        );
                                      }
                                    },
                                  ),
                                  new InkWell(
                                    child: SvgPicture.string(
                                      '''<svg t="1594285438889" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="11488" width="48" height="48"><path d="M512.3 66.2c-246.9 0-447.1 200.2-447.1 447s200.2 447 447.1 447 447-200.1 447-447-200.1-447-447-447z m184.8 715.7c0 9.6-7.9 17.5-17.5 17.5H284.9c-9.7 0-17.5-7.9-17.5-17.5V307c0-9.6 7.9-17.5 17.5-17.5h394.7c9.6 0 17.5 7.9 17.5 17.5v474.9z m60.8-50.7c0 5.3-4.3 9.6-9.6 9.6h-1c-5.3 0-9.6-4.3-9.6-9.6V244.7H337.5c-5.7 0-10.4-4.7-10.4-10.4V231c0-5.7 4.7-10.4 10.4-10.4h410c5.6 0 10.2 4.5 10.3 10v500.6zM626 675.1H337.2c-5.5 0-10 4.5-10 10v1.8c0 5.5 4.5 10 10 10H626c5.5 0 10-4.5 10-10v-1.8c0-5.4-4.5-10-10-10z m0-51.4H337.2c-5.5 0-10 4.5-10 10v1.8c0 5.5 4.5 10 10 10H626c5.5 0 10-4.5 10-10v-1.8c0-5.5-4.5-10-10-10z m0-51.5H337.2c-5.5 0-10 4.5-10 10v1.8c0 5.5 4.5 10 10 10H626c5.5 0 10-4.5 10-10v-1.8c0-5.5-4.5-10-10-10z m0-51.5H337.2c-5.5 0-10 4.5-10 10v1.8c0 5.5 4.5 10 10 10H626c5.5 0 10-4.5 10-10v-1.8c0-5.5-4.5-10-10-10z m0-51.5H337.2c-5.5 0-10 4.5-10 10v1.8c0 5.5 4.5 10 10 10H626c5.5 0 10-4.5 10-10v-1.8c0-5.4-4.5-10-10-10z m0-51.4H337.2c-5.5 0-10 4.5-10 10v1.8c0 5.5 4.5 10 10 10H626c5.5 0 10-4.5 10-10v-1.8c0-5.5-4.5-10-10-10z m0-51.5H337.2c-5.5 0-10 4.5-10 10v1.8c0 5.5 4.5 10 10 10H626c5.5 0 10-4.5 10-10v-1.8c0-5.5-4.5-10-10-10z" fill="#29ABE2" p-id="11489"></path><path d="M636 376.3v1.8c0 5.5-4.5 10-10 10H337.2c-5.5 0-10-4.5-10-10v-1.8c0-5.5 4.5-10 10-10H626c5.5 0 10 4.5 10 10zM636 427.8v1.8c0 5.5-4.5 10-10 10H337.2c-5.5 0-10-4.5-10-10v-1.8c0-5.5 4.5-10 10-10H626c5.5 0 10 4.5 10 10zM636 479.3v1.8c0 5.5-4.5 10-10 10H337.2c-5.5 0-10-4.5-10-10v-1.8c0-5.5 4.5-10 10-10H626c5.5-0.1 10 4.5 10 10zM636 530.8v1.8c0 5.5-4.5 10-10 10H337.2c-5.5 0-10-4.5-10-10v-1.8c0-5.5 4.5-10 10-10H626c5.5-0.1 10 4.4 10 10zM636 582.2v1.8c0 5.5-4.5 10-10 10H337.2c-5.5 0-10-4.5-10-10v-1.8c0-5.5 4.5-10 10-10H626c5.5 0 10 4.5 10 10zM636 633.7v1.8c0 5.5-4.5 10-10 10H337.2c-5.5 0-10-4.5-10-10v-1.8c0-5.5 4.5-10 10-10H626c5.5 0 10 4.5 10 10zM636 685.2v1.8c0 5.5-4.5 10-10 10H337.2c-5.5 0-10-4.5-10-10v-1.8c0-5.5 4.5-10 10-10H626c5.5-0.1 10 4.5 10 10z" fill="#FFFFFF" p-id="11490"></path><path d="M636 376.3v1.8c0 5.5-4.5 10-10 10H337.2c-5.5 0-10-4.5-10-10v-1.8c0-5.5 4.5-10 10-10H626c5.5 0 10 4.5 10 10zM636 427.8v1.8c0 5.5-4.5 10-10 10H337.2c-5.5 0-10-4.5-10-10v-1.8c0-5.5 4.5-10 10-10H626c5.5 0 10 4.5 10 10zM636 479.3v1.8c0 5.5-4.5 10-10 10H337.2c-5.5 0-10-4.5-10-10v-1.8c0-5.5 4.5-10 10-10H626c5.5-0.1 10 4.5 10 10zM636 530.8v1.8c0 5.5-4.5 10-10 10H337.2c-5.5 0-10-4.5-10-10v-1.8c0-5.5 4.5-10 10-10H626c5.5-0.1 10 4.4 10 10zM636 582.2v1.8c0 5.5-4.5 10-10 10H337.2c-5.5 0-10-4.5-10-10v-1.8c0-5.5 4.5-10 10-10H626c5.5 0 10 4.5 10 10zM636 633.7v1.8c0 5.5-4.5 10-10 10H337.2c-5.5 0-10-4.5-10-10v-1.8c0-5.5 4.5-10 10-10H626c5.5 0 10 4.5 10 10zM636 685.2v1.8c0 5.5-4.5 10-10 10H337.2c-5.5 0-10-4.5-10-10v-1.8c0-5.5 4.5-10 10-10H626c5.5-0.1 10 4.5 10 10z" fill="#29ABE2" p-id="11491"></path></svg>''',
                                      width: 50,
                                      height: 50,
                                    ),
                                    onTap: () async {
                                      print(
                                        'content_app_link====>${eland?.MobileAppViewUrl}',
                                      );
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: eland?.MobileAppViewUrl ?? '',
                                        ),
                                      );
                                      await G.toast('已復制連結');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          border: new Border(
                            bottom: BorderSide(
                              width: 10.0,
                              color: Color(0xffcacbd1),
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              "簡介",
                              style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            new Text(
                              eland?.desc ?? '',
                              style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          border: new Border(
                            bottom: BorderSide(
                              width: 10.0,
                              color: Color(0xffcacbd1),
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              "相冊",
                              style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              //                      padding: const EdgeInsets.only(left: 0.0,right:0.0,bottom:10.0),
                              child: InkWell(
                                onTap: () {
                                  _launchURL(eland?.album_url ?? '');
                                },
                                child: new Text(
                                  eland?.album_url ?? '',
                                  style: new TextStyle(
                                    color: Color.fromARGB(255, 28, 141, 160),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              //                      child: new SingleChildScrollView(
                              //                        scrollDirection: Axis.horizontal,
                              //                        child: new Row(
                              //                          crossAxisAlignment: CrossAxisAlignment.start,
                              //                          children: eland.album.map((item){
                              //                            return GestureDetector(
                              //                              onTap: () {
                              //                                APhotoview.show(context,url: item.img);
                              //                              },
                              //                              child: Container(
                              //                                width: MediaQuery.of(context).size.width / 3.33,
                              //                                margin: const EdgeInsets.only(top: 6.0, bottom: 6.0,right: 10.0),
                              //                                child: Column(
                              //                                  children: <Widget>[
                              //                                    AspectRatio(
                              //                                      aspectRatio: 4.0 / 3.0,
                              //                                      child: new Container(
                              //                                        foregroundDecoration:new BoxDecoration(
                              //                                          image: new DecorationImage(
                              //                                            image: new NetworkImage(item.img),
                              //                                            centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                              //                                          ),
                              //                                          borderRadius: const BorderRadius.all(const Radius.circular(6.0)),
                              ////                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0),topRight: Radius.circular(6.0)),
                              //                                        ),
                              //                                      ),
                              //                                    ),
                              //                                    Container(
                              //                                      margin: const EdgeInsets.only(top: 5.0,bottom:10.0,left:4.0,right:4.0),
                              //                                      child: Text(
                              //                                        item.desc,
                              //                                        maxLines: 1,
                              //                                        overflow: TextOverflow.ellipsis,
                              //                                      ),
                              //                                    ),
                              //
                              //                                  ],
                              //                                ),
                              //                              ),
                              //                            );
                              //                          }).toList(),
                              //                        ),
                              //                      ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          border: new Border(
                            bottom: BorderSide(
                              width: 10.0,
                              color: Color(0xffcacbd1),
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              "本周刊物",
                              style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: new SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: brochureList != null
                                      ? brochureList.map((item) {
                                          return GestureDetector(
                                            onTap: () {
                                              if (item.type == 1) {
                                                //pdf
                                                APdfview.show(
                                                  context,
                                                  url: item.source ?? '',
                                                );
                                                print('pdf====>${item.source}');
                                              } else if (item.type == 2) {
                                                //mp3
                                                AAudioView.show(
                                                  context,
                                                  url: item.source ?? '',
                                                );
                                                print('mp3====>${item.source}');
                                              }
                                            },
                                            child: Container(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width /
                                                  3.33,
                                              margin: const EdgeInsets.only(
                                                top: 6.0,
                                                bottom: 6.0,
                                                right: 10.0,
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  AspectRatio(
                                                    aspectRatio: 4.0 / 3.0,
                                                    child: (item.img == '')
                                                        ? Image.asset(
                                                            'lib/assets/images/logo.jpg',
                                                            width: 55,
                                                            height: 55,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : new Container(
                                                            foregroundDecoration: new BoxDecoration(
                                                              image: new DecorationImage(
                                                                image:
                                                                    new NetworkImage(
                                                                      item.img ??
                                                                          '',
                                                                    ),
                                                                centerSlice:
                                                                    new Rect.fromLTRB(
                                                                      270.0,
                                                                      180.0,
                                                                      1360.0,
                                                                      730.0,
                                                                    ),
                                                              ),
                                                              borderRadius:
                                                                  const BorderRadius.all(
                                                                    const Radius.circular(
                                                                      6.0,
                                                                    ),
                                                                  ),
                                                            ),
                                                          ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                          top: 5.0,
                                                          bottom: 10.0,
                                                          left: 4.0,
                                                          right: 4.0,
                                                        ),
                                                    child: Text(
                                                      item.desc ?? '',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList()
                                      : [],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          border: new Border(
                            bottom: BorderSide(
                              width: 10.0,
                              color: Color(0xffcacbd1),
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "聯絡我們",
                              style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text.rich(
                              new TextSpan(
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  height: 2,
                                  //                              letterSpacing: 10.0,
                                  decoration: TextDecoration.none,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(text: "地址："),
                                  new TextSpan(text: eland?.address),
                                ],
                              ),
                            ),
                            Text.rich(
                              new TextSpan(
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  height: 2,
                                  decoration: TextDecoration.none,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(text: "電話："),
                                  new TextSpan(text: eland?.phone),
                                ],
                              ),
                            ),
                            Text.rich(
                              new TextSpan(
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  height: 2,
                                  decoration: TextDecoration.none,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(text: "傳真："),
                                  new TextSpan(text: eland?.fax),
                                ],
                              ),
                            ),
                            Text.rich(
                              new TextSpan(
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  height: 2,
                                  decoration: TextDecoration.none,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(text: "電郵："),
                                  new TextSpan(text: eland?.email),
                                ],
                              ),
                            ),
                            Text.rich(
                              new TextSpan(
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  height: 2,
                                  decoration: TextDecoration.none,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(text: "網站："),
                                  (eland?.link1 == '')
                                      ? new TextSpan()
                                      : new TextSpan(
                                          text: eland?.link1,
                                          style: new TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              57,
                                              139,
                                              161,
                                            ),
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              //                                print('clicklink');
                                              AWebview.open(
                                                context,
                                                url: eland?.link1 ?? '',
                                                title: eland?.link1 ?? '',
                                              );
                                            },
                                        ),
                                  (eland?.link2 == '')
                                      ? new TextSpan()
                                      : new TextSpan(
                                          text: "\n" + (eland?.link2 ?? ''),
                                          style: new TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              57,
                                              139,
                                              161,
                                            ),
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              //                                print('clicklink');
                                              AWebview.open(
                                                context,
                                                url: eland?.link2 ?? '',
                                                title: eland?.link2 ?? '',
                                              );
                                            },
                                        ),
                                  (eland?.link3 == '')
                                      ? new TextSpan()
                                      : new TextSpan(
                                          text: "\n" + (eland?.link3 ?? ''),
                                          style: new TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              57,
                                              139,
                                              161,
                                            ),
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              //                                print('clicklink');
                                              AWebview.open(
                                                context,
                                                url: eland?.link3 ?? '',
                                                title: eland?.link3 ?? '',
                                              );
                                            },
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            //                    AGoogleMap(
                            //                        lat: _lat,
                            //                        lng: _lng
                            //                    ),
                          ],
                        ),
                      ),

                      Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          border: new Border(
                            bottom: BorderSide(
                              width: 10.0,
                              color: Color(0xffcacbd1),
                            ),
                          ),
                        ),
                        child: AArticleList(
                          uid: userid,
                          eland_id: eland_id,
                          topchild: Container(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                              top: 10.0,
                            ),
                            child: Text(
                              "文章",
                              style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          pagelimit: 3,
                          isreload: true,
                          isShowDesc: true,
                          isShowCenterload: false,
                          isSmartRefresher: false,
                          isShowTag: false,
                          isShowPrayerBtn: false,
                          isShowElandName: true,
                          isShowLikeBtn: true,
                          bottomchild: Container(
                            margin: EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                              left: 10,
                              right: 10,
                            ),
                            child: AButton.normal(
                              width: MediaQuery.of(context).size.width,
                              child: Text('更多'),
                              bgColor: Color.fromARGB(255, 229, 229, 229),
                              color: Color(0xff000000),
                              borderColor: Color.fromARGB(255, 229, 229, 229),
                              plain: true,
                              borderRadius: BorderRadius.circular(5),
                              onPressed: () {
                                G.pushNamed(
                                  '/article_list',
                                  arguments: {'eland_id': eland_id},
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          border: new Border(
                            bottom: BorderSide(
                              width: 10.0,
                              color: Color(0xffcacbd1),
                            ),
                          ),
                        ),
                        child: AElandPrayersList(
                          user_id: userid,
                          eland_id: eland_id,
                          topchild: Container(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                              top: 10.0,
                            ),
                            child: Text(
                              "祈禱",
                              style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          pagelimit: 3,
                          isreload: true,
                          isShowCenterload: false,
                          isSmartRefresher: false,
                          isShowTag: false,
                          isShowElandName: false,
                          isShowLikeBtn: false,
                          isShowDesc: true,
                          bottomchild: Container(
                            margin: EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                              left: 10,
                              right: 10,
                            ),
                            child: AButton.normal(
                              width: MediaQuery.of(context).size.width,
                              child: Text('更多'),
                              bgColor: Color.fromARGB(255, 229, 229, 229),
                              color: Color(0xff000000),
                              borderColor: Color.fromARGB(255, 229, 229, 229),
                              plain: true,
                              borderRadius: BorderRadius.circular(5),
                              onPressed: () {
                                G.pushNamed(
                                  '/eland_prayers',
                                  arguments: {'eland_id': eland_id},
                                );
                                //                              print('點擊更多');
                                //                            AWebview.open(context, url: 'http://baidu.com');
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: CustomNavbar(
        onTap: (index) {
          G.pushNamed(G.toobarRouteNameList[index]);
        },
      ),
    );
  }
}
