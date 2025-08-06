import '../../main.dart';
import '../../provider/do_like_method.dart';
//import 'package:color_dart/HexColor.dart';
//import 'package:color_dart/RgbaColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package
import '../../utils/Icon.dart';
import '../../utils/global.dart';
import '../../components/a_button/index.dart';
import '../../components/a_cached_network_image/index.dart';
import '../../model/eland_dynamic_model/data.dart';

class AElandDynamic extends StatefulWidget {
  bool isshowcenterload;
  bool isloadmore;
  int pagelimit;
  bool isreload;
  final Widget topchild;
  final Widget bottomchild;
  int uid;
  AElandDynamic({
    Key key,
    this.isshowcenterload = true,
    this.isloadmore = true,
    this.pagelimit = 10,
    this.isreload = true,
    this.topchild = null,
    this.bottomchild = null,
    this.uid = 0,
    //    this.onTap,
  }) : super(key: key);

  @override
  _ElandDynamicState createState() => new _ElandDynamicState();
}

//with AutomaticKeepAliveClientMixin  //###Leo
class _ElandDynamicState extends State<AElandDynamic> with RouteAware {
  List<dynamic> elandItems = [];
  List<dynamic> elandTagsItems = [];
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  int page_id = 1;
  bool isloadcomplete = false;

  bool _submit_i = false;

  //  @override
  //  bool get wantKeepAlive => widget.isreload; ///see AutomaticKeepAliveClientMixin

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      //      print('aaa===>${widget.isshowcenterload}');
      _loadListData(
        context,
        isshowloading: widget.isshowcenterload,
        limit: widget.pagelimit,
        pageid: page_id,
        userid: widget.uid,
      );
    });
  }

  //###Leo
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    MyApp.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  //###Leo
  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
    Map popMap = Provider.of<DoLikeMethod>(context, listen: false).popIsLike;
    Map pushMap = Provider.of<DoLikeMethod>(context, listen: false).pushLike;
    print("進入詳情======$pushMap}");
    print("再次返回頁面======$popMap}");

    if (pushMap['isLike'] != popMap['isLike']) {
      setState(() {
        for (var i = 0; i < elandItems.length; i++) {
          if (elandItems[i].id == popMap['id']) {
            elandItems[i].icollect = popMap['isLike'];
            elandItems[i].collect = popMap['num'];
          }
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Shimmer Loading Widget
  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10, // Adjust the number of shimmer items as needed
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 45,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 8),
                Container(width: 100, height: 20, color: Colors.grey[300]),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onRefresh() async {
    //    print('onRefresh1===>');
    //     await Future.delayed(Duration(milliseconds: 1000));

    Future.delayed(Duration.zero, () async {
      if (mounted) {
        page_id = 1;
        elandItems = [];
        elandTagsItems = [];
        //      print('onRefresh2===>');
        await _loadListData(
          context,
          isshowloading: false,
          limit: widget.pagelimit,
          pageid: page_id,
          userid: widget.uid,
        );
      }
      _refreshController.refreshCompleted();
    });
  }

  void _onLoading() async {
    // await Future.delayed(Duration(milliseconds: 1000));
    Future.delayed(Duration.zero, () async {
      if (mounted) {
        int page_id2 = ++page_id;
        _loadListData(
          context,
          isshowloading: false,
          limit: widget.pagelimit,
          pageid: page_id2,
          userid: widget.uid,
        );
      }
      _refreshController.loadComplete();
    });
  }

  _loadListData(
    BuildContext context, {
    bool isshowloading = true,
    int pageid = 1,
    int limit = 5,
    int userid = 0,
  }) async {
    if (isshowloading == true) G.loading.show(context);

    try {
      var res = await G.req.eland.dynamic(
        pageid: pageid,
        limit: limit,
        search_by_content: '',
        userid: userid,
      );
      Map result = res.data;
      //      print('_result===>${result}');
      //###Leo
      Future.delayed(Duration.zero, () {
        ElandDynamicModel tempElandList = ElandDynamicModel.fromJson(result);
        if (mounted) {
          setState(() {
            elandItems.addAll(tempElandList.list);
            // print("aaa===>${pageid},${elandItems.length}");
            //          print("bbb===>${elandItems}");
            isloadcomplete = true;
          });
          if (tempElandList.list.length == 0) {
            _refreshController.loadNoData();
          }
        }
      });
      if (isshowloading == true) G.loading.hide(context);
    } catch (e) {
      print('articleCatch2===>${e}');
      if (isshowloading == true) G.loading.hide(context);
    }
  }

  _clickCollect(item) {
    int uid = G.user.data.id;
    int itemid = item.id;
    try {
      Future.delayed(Duration.zero, () async {
        if (_submit_i == true) return;
        _submit_i = true;
        var res = await G.req.eland.docollect(
          id: itemid,
          userid: uid,
          type: item.type,
        );
        Map result = res.data;
        _submit_i = false;
        if (result['code'] == 200) {
          setState(() {
            if (item.icollect == true && item.collect > 0) {
              elandItems[item.key].collect = item.collect - 1;
              elandItems[item.key].icollect = false;
            } else {
              elandItems[item.key].collect = item.collect + 1;
              elandItems[item.key].icollect = true;
            }
          });
        }
      });
    } catch (e) {
      print('articledocollect===>${e}');
    }
  }

  Widget _cardListSkeleton() {
    return Container(
      child: CardListSkeleton(
        style: SkeletonStyle(
          theme: SkeletonTheme.Light,
          isShowAvatar: true,
          isCircleAvatar: true,
          barCount: 2,
        ),
      ),
    );
  }

  Widget buildContent(item) {
    int imageSize = item.pics.length;
    double imageWidth =
        G.screenWidth() /
        ((imageSize == 3 || imageSize > 4)
            ? 3.0
            : (imageSize == 2 || imageSize == 4)
            ? 2.0
            : 1);
    elandTagsItems = item.tags;
    //    return Text('hello=====>${item.content}');

    return Stack(
      children: [
        new Column(
          children: <Widget>[
            new Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
              padding: const EdgeInsets.only(bottom: 20.0),
              decoration: new BoxDecoration(
                color: Colors.white,
                border: new BorderDirectional(
                  bottom: new BorderSide(color: Colors.black12, width: 1.0),
                ),
              ),
              child: new FlatButton(
                onPressed: () {
                  if (item.type == 2) {
                    //###Leo
                    Map map = {"isLike": item.icollect, "id": item.id};
                    Provider.of<DoLikeMethod>(
                      context,
                      listen: false,
                    ).getPushIsLike(map);
                    G.pushNamed('/article_detail', arguments: {'id': item.id});
                  } else if (item.type == 5) {
                    //###Leo
                    Map map = {"isLike": item.icollect, "id": item.id};
                    Provider.of<DoLikeMethod>(
                      context,
                      listen: false,
                    ).getPushIsLike(map);
                    G.pushNamed('/prayers_detail', arguments: {'id': item.id});
                  }
                },
                child: new Column(
                  children: <Widget>[
                    new Container(
                      alignment: Alignment.centerLeft,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if (item.eland_id != null) {
                                G.pushNamed(
                                  '/eland_info',
                                  arguments: {'id': item.eland_id},
                                );
                              }
                            },
                            child: new Row(
                              children: <Widget>[
                                new Container(
                                  width: 45,
                                  height: 45,
                                  margin: const EdgeInsets.only(right: 15.0),
                                  child: new CircleAvatar(
                                    backgroundColor: rgba(28, 141, 160, 1),
                                    backgroundImage: new NetworkImage(
                                      item.eland_pic,
                                    ),
                                    radius: 11.0,
                                  ),
                                ),
                                new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      //                                    margin: const EdgeInsets.only(top: 5.0,bottom:10.0,left:4.0,right:4.0),
                                      width: G.screenWidth() * 0.48,
                                      child: new Text(
                                        item.eland_name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: new TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    (item.time == '')
                                        ? Container()
                                        : new Text(
                                            item.time,
                                            style: new TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          (item.icollect == true && item.collect > 0)
                              ? AButton.icon(
                                  width: 70,
                                  height: 25,
                                  borderColor: rgba(28, 141, 160, 1),
                                  bgColor: rgba(28, 141, 160, 1),
                                  plain: true,
                                  textChild: Text(
                                    item.collect.toString(),
                                    style: TextStyle(
                                      color: hex('#fff'),
                                      fontSize: 13,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                  icon: (item.type == 5)
                                      ? icon_prayer(
                                          size: 13,
                                          color: hex('#fff'),
                                        )
                                      : icon_favorite(
                                          size: 13,
                                          color: hex('#fff'),
                                        ),
                                  onPressed: () {
                                    _clickCollect(item);
                                  },
                                )
                              : AButton.icon(
                                  width: 70,
                                  height: 25,
                                  borderColor: rgba(28, 141, 160, 1),
                                  bgColor: hex('#fff'),
                                  plain: true,
                                  textChild: Text(
                                    item.collect.toString(),
                                    style: TextStyle(
                                      color: hex('#333'),
                                      fontSize: 13,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                  icon: (item.type == 5)
                                      ? icon_prayer(
                                          size: 13,
                                          color: hex('#333'),
                                        )
                                      : icon_favorite_border(
                                          size: 13,
                                          color: hex('#333'),
                                        ),
                                  onPressed: () {
                                    _clickCollect(item);
                                  },
                                ),
                        ],
                      ),
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    (item.title == '' || item.title == null)
                        ? new Container()
                        : new Container(
                            child: new Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                                height: 1.3,
                                color: Colors.black,
                              ),
                            ),
                            margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                            alignment: Alignment.topLeft,
                          ),
                    (item.content == '' || item.content == null)
                        ? new Container()
                        : new Container(
                            child: new Text(
                              item.content,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                                height: 1.3,
                                color: Colors.black,
                              ),
                            ),
                            margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                            alignment: Alignment.topLeft,
                          ),
                    new Container(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 5, // 主轴(水平)方向间距
                        runSpacing: 0, // 纵轴（垂直）方向间距
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start, //沿主轴方向居中
                        runAlignment: WrapAlignment.start,
                        children: elandTagsItems.map((itemtag) {
                          return new InkWell(
                            child: new Chip(
                              label: new Text(itemtag.name),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onTap: () {
                              G.pushNamed(
                                '/search_result',
                                arguments: {'result': itemtag.value},
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    new Offstage(
                      offstage: imageSize == 0,
                      child: imageSize > 1
                          ? GridView.builder(
                              padding: EdgeInsets.only(top: 8.0),
                              itemCount: imageSize,
                              shrinkWrap: true,
                              primary: false,
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: imageWidth,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 1,
                                  ),
                              itemBuilder: (context, index) {
                                Widget buildItem = null;
                                if (index == (imageSize - 1)) {
                                  buildItem = Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      AcachedNetworkImage(
                                        item.pics[index],
                                        fit: BoxFit.cover,
                                        width: imageWidth,
                                        height: imageWidth,
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Container(
                                          width: imageWidth,
                                          height: imageWidth,
                                          alignment: Alignment.center,
                                          color: rgba(0, 0, 0, 0.5),
                                          child: Text(
                                            'more...',
                                            style: new TextStyle(
                                              color: hex('#fff'),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  buildItem = AcachedNetworkImage(
                                    item.pics[index],
                                    fit: BoxFit.cover,
                                    width: imageWidth,
                                    height: imageWidth,
                                  );
                                }
                                return GestureDetector(
                                  onTap: () {
                                    //                            APhotoview.show(context,url: item.pics[index]);
                                    if (item.type == 2) {
                                      //###Leo
                                      Map map = {
                                        "isLike": item.icollect,
                                        "id": item.id,
                                      };
                                      Provider.of<DoLikeMethod>(
                                        context,
                                        listen: false,
                                      ).getPushIsLike(map);
                                      G.pushNamed(
                                        '/article_detail',
                                        arguments: {'id': item.id},
                                      );
                                    } else if (item.type == 5) {
                                      Map map = {
                                        //###Leo
                                        "isLike": item.icollect,
                                        "id": item.id,
                                      };
                                      Provider.of<DoLikeMethod>(
                                        context,
                                        listen: false,
                                      ).getPushIsLike(map);
                                      G.pushNamed(
                                        '/prayers_detail',
                                        arguments: {'id': item.id},
                                      );
                                    }
                                  },
                                  child: buildItem,
                                );
                              },
                            )
                          : imageSize == 1
                          ? Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  //                            APhotoview.show(context,url: item.pics[0]);
                                  if (item.type == 2) {
                                    //###Leo
                                    Map map = {
                                      "isLike": item.icollect,
                                      "id": item.id,
                                    };
                                    Provider.of<DoLikeMethod>(
                                      context,
                                      listen: false,
                                    ).getPushIsLike(map);
                                    G.pushNamed(
                                      '/article_detail',
                                      arguments: {'id': item.id},
                                    );
                                  } else if (item.type == 5) {
                                    //###Leo
                                    Map map = {
                                      "isLike": item.icollect,
                                      "id": item.id,
                                    };
                                    Provider.of<DoLikeMethod>(
                                      context,
                                      listen: false,
                                    ).getPushIsLike(map);
                                    G.pushNamed(
                                      '/prayers_detail',
                                      arguments: {'id': item.id},
                                    );
                                  }
                                },
                                child: AcachedNetworkImage(
                                  item.pics[0],
                                  width: imageWidth,
                                  //                            height: imageWidth,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        (item.IsFeatured == true)
            ? Positioned(
                top: 0,
                left: 0,
                child: Container(
                  // child: icon_turned_in(
                  //     size: 20,
                  //     color: hex('#f34343')
                  // ),
                  child: Image.asset(
                    'lib/assets/images/recommended.png',
                    width: 35,
                    // height: 20,
                    //                            fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget top_contents = widget.topchild;
    Widget bottom_contents = widget.bottomchild;

    //    super.build(context);
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: (widget.isloadmore == true) ? true : false,
      header: WaterDropHeader(
        refresh: SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 28, 141, 160),
            ),
          ),
        ),
        complete: const Text('√ 加載完成'),
      ),
      footer: G.pullToRefresh.footer(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (elandItems.isEmpty)
          ? _shimmerLoading() // Use shimmer loading widget
          : ListView.builder(
              shrinkWrap: true,
              itemCount: elandItems.length,
              itemBuilder: (c, f) {
                elandItems[f].key = f;
                return Column(
                  children: [
                    (f == 0) ? widget.topchild ?? Container() : Container(),
                    buildContent(elandItems[f]),
                    (f == elandItems.length - 1)
                        ? widget.bottomchild ?? Container()
                        : Container(),
                  ],
                );
              },
            ),
    );

    /*return (elandItems.length == 0)
        ? _cardListSkeleton()
        : SmartRefresher(
            enablePullDown: true,
            enablePullUp: (widget.isloadmore == true) ? true : false,
            header: WaterDropHeader(
              refresh: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    rgba(28, 141, 160, 1),
                  ),
                ),
              ),
              complete: Text('√ 加載完成'),
            ),
            //      header: MaterialClassicHeader(),
            //      header: G.pullToRefresh.header(),
            footer: G.pullToRefresh.footer(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            //Leo
            // onOffsetChange: (up,height){
            //   print('$up=========$height');
            // },
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: elandItems.length,
              itemBuilder: (c, f) {
                elandItems[f].key = f;
                return new Container(
                  child: new Column(
                    children: <Widget>[
                      (f == 0) ? top_contents : Container(),
                      buildContent(elandItems[f]),
                      (f == elandItems.length - 1)
                          ? bottom_contents
                          : Container(),
                    ],
                  ),
                );
              },
            ),
          );*/
  }
}
