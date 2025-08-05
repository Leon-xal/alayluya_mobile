import '../../model/user_model/data.dart';
import '../../main.dart';
import '../../provider/do_like_method.dart';
import 'package:provider/provider.dart';
//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import '../../utils/Icon.dart';
import '../../utils/global.dart';
import '../../components/a_button/index.dart';
import '../../model/eland_list_model/data.dart';

class AElandList extends StatefulWidget {
  //  final ValueChanged<int> onTap;
  int uid; //用戶id
  String search_by_name;
  bool isShowCenterload; //是否顯示加載數據的中間loading圖標
  bool isloadmore; //是否支持下拉刷新數,前提是有開啟isSmartRefresher
  int pagelimit; //顯示文章數量
  bool isreload; //開啟AutomaticKeepAliveClientMixin支持，tab效果支持會有緩存效果
  final Widget topchild; //上節點插糟
  final Widget bottomchild; //下節點插糟
  bool isSmartRefresher;
  int cateid; //eland分類id
  String type;

  AElandList({
    Key key,
    this.uid = 0,
    this.search_by_name = '',
    this.isShowCenterload = true,
    this.isloadmore = true,
    this.pagelimit = 10,
    this.isreload = true,
    this.topchild = null,
    this.bottomchild = null,
    this.isSmartRefresher = true,
    this.cateid = 0,
    this.type = 'all',
    //    this.onTap,
  }) : super(key: key);

  @override
  _AElandListState createState() => new _AElandListState();
}

//with AutomaticKeepAliveClientMixin
class _AElandListState extends State<AElandList> with RouteAware {
  List<dynamic> dataItems = [];
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  int page_id = 1;
  bool isloadcomplete = false;

  //  @override
  //  bool get wantKeepAlive => widget.isreload; ///see AutomaticKeepAliveClientMixin

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      //      print('aaa===>${widget.isShowcenterload}');
      _loadListData(
        context,
        isshowloading: widget.isShowCenterload,
        limit: widget.pagelimit,
        pageid: page_id,
        uid: widget.uid,
        search_by_name: widget.search_by_name,
        cateid: widget.cateid,
      );
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    MyApp.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
    Map popMap = Provider.of<DoLikeMethod>(context, listen: false).popIsLike;
    Map pushMap = Provider.of<DoLikeMethod>(context, listen: false).pushLike;
    print("進入詳情2======$pushMap}");
    print("再次返回頁面2======$popMap}");

    if (pushMap['isLike'] != popMap['isLike']) {
      setState(() {
        for (var i = 0; i < dataItems.length; i++) {
          if (dataItems[i].eland_id == popMap['id']) {
            dataItems[i].ifollow = popMap['isLike'];
            if (popMap['isLike'] == true) {
              dataItems[i].follow++;
            } else {
              dataItems[i].follow--;
            }
          }
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _clickFollow(item) {
    //    print('sss===>${item.eland_name}');

    int uid = G.user.data.id;
    int itemid = item.eland_id;
    //    print('aaa===>${uid}/${itemid}/${item.key}');
    try {
      Future.delayed(Duration.zero, () async {
        var res = await G.req.eland.dofollow(eland_id: itemid, userid: uid);
        Map result = res.data;
        if (result['code'] == 200) {
          setState(() {
            if (item.ifollow == true && item.follow > 0) {
              dataItems[item.key].follow = item.follow - 1;
              dataItems[item.key].ifollow = false;
            } else {
              dataItems[item.key].follow = item.follow + 1;
              dataItems[item.key].ifollow = true;
            }
          });
        }
      });
    } catch (e) {
      print('_clickFollow===>${e}');
    }
  }

  Widget buildContent(item) {
    return new Container(
      alignment: Alignment.topLeft,
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new BorderDirectional(
          bottom: new BorderSide(color: Colors.black12, width: 1.0),
        ),
      ),
      child: new FlatButton(
        padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
        onPressed: () {
          //            print('blockclick====>${item.eland_id}');
          Map map = {"isLike": item.ifollow, "id": item.eland_id};
          Provider.of<DoLikeMethod>(context, listen: false).getPushIsLike(map);
          G.pushNamed('/eland_info', arguments: {'id': item.eland_id});
        },
        child: new Container(
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(right: 15.0),
                child: new CircleAvatar(
                  backgroundColor: rgba(28, 141, 160, 1),
                  backgroundImage: new NetworkImage(item.eland_pic),
                  radius: 11.0,
                ),
              ),
              new Expanded(
                flex: 6,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: new Text(
                        item.eland_name,
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          height: 1.1,
                          color: Colors.black,
                        ),
                      ),
                      padding: const EdgeInsets.only(bottom: 10.0, right: 4.0),
                      alignment: Alignment.topLeft,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Text(
                                item.follow.toString() + '用戶',
                                style: TextStyle(
                                  color: hex('#333'),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              '關注',
                              style: TextStyle(
                                color: hex('#333'),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: (item.ifollow == true && item.follow > 0)
                              ? AButton.icon(
                                  width: 70,
                                  height: 25,
                                  borderColor: rgba(28, 141, 160, 1),
                                  bgColor: rgba(28, 141, 160, 1),
                                  plain: true,
                                  textChild: Text(
                                    '已關注',
                                    style: TextStyle(
                                      color: hex('#fff'),
                                      fontSize: 13,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                  icon: icon_star(size: 13, color: hex('#fff')),
                                  onPressed: () {
                                    _clickFollow(item);
                                  },
                                )
                              : AButton.icon(
                                  width: 70,
                                  height: 25,
                                  borderColor: rgba(28, 141, 160, 1),
                                  bgColor: hex('#fff'),
                                  plain: true,
                                  textChild: Text(
                                    '關注',
                                    style: TextStyle(
                                      color: hex('#333'),
                                      fontSize: 13,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                  icon: icon_star_border(
                                    size: 13,
                                    color: hex('#333'),
                                  ),
                                  onPressed: () {
                                    _clickFollow(item);
                                  },
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onRefresh() async {
    print('onRefresh===>');
    // await Future.delayed(Duration(milliseconds: 1000));
    Future.delayed(Duration.zero, () async {
      if (mounted) {
        page_id = 1;
        dataItems = [];
        await _loadListData(
          context,
          isshowloading: false,
          limit: widget.pagelimit,
          pageid: page_id,
          cateid: widget.cateid,
          search_by_name: widget.search_by_name,
          uid: widget.uid,
        );
      }
      _refreshController.refreshCompleted();
    });
  }

  void _onLoading() async {
    print('onloading1===>');
    // await Future.delayed(Duration(milliseconds: 1000));
    Future.delayed(Duration.zero, () {
      if (mounted) {
        print('onloading2===>${page_id}');
        _loadListData(
          context,
          isshowloading: false,
          limit: widget.pagelimit,
          pageid: ++page_id,
          uid: widget.uid,
          search_by_name: widget.search_by_name,
          cateid: widget.cateid,
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
    uid = 0,
    search_by_name = '',
    cateid = 0,
  }) async {
    if (isshowloading == true) G.loading.show(context);
    // UserDataModel userDataModel = G.user.data;
    // print('Leo user id ===== ${userDataModel.id}');
    // print('Leo user id =====> ${uid}');
    // print('Leo cateid =====> ${cateid}');
    try {
      var res = null;
      if (widget.type == 'all') {
        res = await G.req.eland.list(
          userid: uid,
          // userid: userDataModel.id,
          pageid: pageid,
          limit: limit,
          search_by_name: search_by_name,
          cateid: cateid,
        );
      } else {
        res = await G.req.eland.my_follow_list(
          userid: uid,
          // userid: userDataModel.id,
          pageid: pageid,
          limit: limit,
          search_by_name: search_by_name,
          cateid: cateid,
        );
      }

      print('Leo======${res}');
      Map result = res.data;
      // print("result====>${result}");
      ElandListModel tempList = ElandListModel.fromJson(result);

      if (mounted) {
        setState(() {
          isloadcomplete = true;
          dataItems.addAll(tempList.list);
          if (tempList.list.length == 0) {
            _refreshController.loadNoData();
          }
        });
      }
      if (isshowloading == true) G.loading.hide(context);
    } catch (e) {
      print('articleCatch===>${e}');
      if (isshowloading == true) G.loading.hide(context);
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

  @override
  Widget build(BuildContext context) {
    Widget top_contents = widget.topchild;
    Widget bottom_contents = widget.bottomchild;

    //    super.build(context);

    if (widget.isSmartRefresher == true) {
      if (isloadcomplete == true) {
        return (dataItems.length == 0)
            ? Container(
                child: Center(
                  child: new Image.asset(
                    "lib/assets/images/empty_img.png",
                    fit: BoxFit.fill,
                  ),
                ),
              )
            : SmartRefresher(
                enablePullDown: true,
                enablePullUp: (widget.isloadmore == true) ? true : false,
                //        header:G.pullToRefresh.header(),
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
                footer: G.pullToRefresh.footer(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: SingleChildScrollView(
                  child: new Container(
                    child: new Column(
                      children: <Widget>[
                        top_contents,
                        new Column(
                          children: dataItems.asMap().keys.map((f) {
                            dataItems[f].key = f;
                            return buildContent(dataItems[f]);
                          }).toList(),
                        ),
                        bottom_contents,
                      ],
                    ),
                  ),
                ),
              );
      } else {
        return _cardListSkeleton();
      }
    } else {
      return (dataItems.length == 0)
          ? Container()
          : SingleChildScrollView(
              child: new Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    top_contents,
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: dataItems.asMap().keys.map((f) {
                        dataItems[f].key = f;
                        return buildContent(dataItems[f]);
                      }).toList(),
                    ),
                    bottom_contents,
                  ],
                ),
              ),
            );
    }
  }
}
