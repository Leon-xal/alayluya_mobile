//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../utils/Icon.dart';
import '../../utils/global.dart';
import '../../components/a_button/index.dart';
import '../../model/eland_prayers_list_model/data.dart';

class AElandPrayersList extends StatefulWidget {
  //  final ValueChanged<int> onTap;
  String search_by_title;
  bool isShowCenterload; //是否顯示加載數據的中間loading圖標
  bool isloadmore; //是否支持下拉刷新數,前提是有開啟isSmartRefresher
  int pagelimit; //顯示文章數量
  int cateid; //文章分類
  bool isreload; //開啟AutomaticKeepAliveClientMixin支持，tab效果支持會有緩存效果
  final Widget topchild; //上節點插糟
  final Widget bottomchild; //下節點插糟
  bool isSmartRefresher;
  bool isShowDesc;
  bool isShowTag;
  bool isShowLikeBtn;
  bool isShowPrayerBtn;
  bool isShowElandName;
  int user_id;
  int eland_id;
  AElandPrayersList({
    Key key,
    this.search_by_title = '',
    this.isShowCenterload = true,
    this.isloadmore = true,
    this.pagelimit = 10,
    this.cateid = 0,
    this.isreload = true,
    this.topchild = null,
    this.bottomchild = null,
    this.isSmartRefresher = true,
    this.isShowDesc = true,
    this.isShowTag = true,
    this.isShowLikeBtn = true,
    this.isShowPrayerBtn = true,
    this.isShowElandName = true,
    this.user_id = 0,
    this.eland_id = 0,
    //    this.onTap,
  }) : super(key: key);

  @override
  _AElandPrayersListState createState() => new _AElandPrayersListState();
}

//with AutomaticKeepAliveClientMixin
class _AElandPrayersListState extends State<AElandPrayersList> {
  List<dynamic> articleItems = [];
  List<dynamic> articleTagsItems = [];
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
        cateid: widget.cateid,
        search_by_title: widget.search_by_title,
        user_id: widget.user_id,
        eland_id: widget.eland_id,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _clickPrayer(item) {
    //    print('sss===>${item.eland_name}');

    int uid = G.user.data.id;
    int itemid = item.id;
    //    print('aaa===>${uid}/${itemid}/${item.key}');
    try {
      Future.delayed(Duration.zero, () async {
        var res = await G.req.eland.doprayer(id: itemid, userid: uid);
        Map result = res.data;
        if (result['code'] == 200) {
          setState(() {
            if (item.iprayer == true && item.prayer > 0) {
              articleItems[item.key].prayer = item.prayer - 1;
              articleItems[item.key].iprayer = false;
            } else {
              articleItems[item.key].prayer = item.prayer + 1;
              articleItems[item.key].iprayer = true;
            }
          });
        }
      });
    } catch (e) {
      print('articledocollect===>${e}');
    }
  }

  _clickDoLike(item) {
    //    print('sss===>${item.eland_name}');

    int uid = G.user.data.id;
    int articleid = item.id;
    //    print('aaa===>${uid}/${itemid}/${item.key}');
    try {
      Future.delayed(Duration.zero, () async {
        //        var res = await G.req.article.doprayer(articleid: itemid, userid: uid);
        var res = await G.req.article.dolike(articleid: articleid, userid: uid);
        Map result = res.data;
        if (result['code'] == 200) {
          setState(() {
            if (item.ilike == true && item.like > 0) {
              articleItems[item.key].like = item.like - 1;
              articleItems[item.key].ilike = false;
            } else {
              articleItems[item.key].like = item.like + 1;
              articleItems[item.key].ilike = true;
            }
          });
        }
      });
    } catch (e) {
      print('articledocollect===>${e}');
    }
  }

  Widget buildContent(item) {
    //    print('bbb===>${key},${item}');
    setState(() {
      articleTagsItems = item.tags;
    });

    return new Container(
      alignment: Alignment.topLeft,
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new BorderDirectional(
          bottom: new BorderSide(color: Colors.black12, width: 1.0),
        ),
      ),
      child: new FlatButton(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
        onPressed: () {
          G.pushNamed('/prayers_detail', arguments: {'id': item.id});
        },
        child: new Container(
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                flex: 3,
                child: new Container(
                  //                      color:rgba(0,0,0,1),
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  //                      child: new AspectRatio(
                  //                          aspectRatio: 3.0 / 2.0,
                  //                          child: Image.network(item.pic),
                  //                      )
                  //                      child: Image.network(item.pic),
                  child: new AspectRatio(
                    aspectRatio: 3.0 / 2.0,
                    child: new Container(
                      alignment: Alignment.topLeft,
                      foregroundDecoration: new BoxDecoration(
                        image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: new NetworkImage(item.pic),
                          //                                  centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                        ),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(6.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              new Expanded(
                flex: 6,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: new Text(
                        item.title.replaceAll('\n', ''),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                    // Text('${item.desc}'),
                    (widget.isShowDesc == true && item.desc != '')
                        ? Container(
                            child: new Text(
                              item.desc,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15.0,
                                height: 1.1,
                                color: Colors.black,
                              ),
                            ),
                            padding: const EdgeInsets.only(
                              bottom: 10.0,
                              right: 4.0,
                            ),
                            alignment: Alignment.topLeft,
                          )
                        : Container(),
                    (widget.isShowTag == true)
                        ? Container(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              spacing: 5, // 主轴(水平)方向间距
                              runSpacing: 0, // 纵轴（垂直）方向间距
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start, //沿主轴方向居中
                              runAlignment: WrapAlignment.start,
                              children: articleTagsItems
                                  .map(buildTagsContent)
                                  .toList(),
                            ),
                          )
                        : Container(),
                    (widget.isShowPrayerBtn == true)
                        ? Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            //                          padding: EdgeInsets.only(left: 0.0,right: 0.0,top: 0.0,bottom: 0.0),
                            child: (item.iprayer == true && item.prayer > 0)
                                ? AButton.icon(
                                    width: 70,
                                    height: 25,
                                    borderColor: rgba(28, 141, 160, 1),
                                    bgColor: rgba(28, 141, 160, 1),
                                    plain: true,
                                    textChild: Text(
                                      item.prayer.toString(),
                                      style: TextStyle(
                                        color: hex('#fff'),
                                        fontSize: 13,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(40),
                                    icon: icon_prayer(
                                      size: 13,
                                      color: hex('#fff'),
                                    ),
                                    onPressed: () {
                                      _clickPrayer(item);
                                    },
                                  )
                                : AButton.icon(
                                    width: 70,
                                    height: 25,
                                    borderColor: rgba(28, 141, 160, 1),
                                    bgColor: hex('#fff'),
                                    plain: true,
                                    textChild: Text(
                                      item.prayer.toString(),
                                      style: TextStyle(
                                        color: hex('#333'),
                                        fontSize: 13,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(40),
                                    icon: icon_prayer(
                                      size: 13,
                                      color: hex('#333'),
                                    ),
                                    onPressed: () {
                                      _clickPrayer(item);
                                    },
                                  ),
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        (widget.isShowElandName == true)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: icon_author(
                                      size: 18,
                                      color: hex('#737373'),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                      bottom: 10.0,
                                      top: 6.0,
                                    ),
                                    //                                    margin: const EdgeInsets.only(top: 5.0,bottom:10.0,left:4.0,right:4.0),
                                    width: G.screenWidth() * 0.3,
                                    child: Text(
                                      item.author,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: hex('#333'),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),

                        //                            (widget.isShowLikeBtn == true)? Row(
                        //                                children: <Widget>[
                        //                                  IconButton(
                        //                                      alignment: Alignment.centerRight,
                        //                                      padding: EdgeInsets.only(right: 5.0),
                        //                                      icon: (item.ilike == true && item.like > 0)? icon_favorite(size: 18, color: Colors.red) : icon_favorite_border(size: 18, color: Colors.black),
                        //                                      onPressed: () {
                        //                                        int uid = G.user.data.id;
                        //                                        int articleid = item.id;
                        ////                                        print('aaa===>${uid}/${articleid}');
                        //                                        try {
                        //                                          Future.delayed(Duration.zero, () async{
                        //                                            var res = await G.req.article.dolike(articleid: articleid, userid: uid);
                        //                                            Map result = res.data;
                        //                                            if(result['code'] == 200){
                        //                                              setState(() {
                        //                                                if(item.ilike == true && item.like > 0){
                        //                                                  articleItems[item.key].like = item.like-1;
                        //                                                  articleItems[item.key].ilike = false;
                        //                                                }else{
                        //                                                  articleItems[item.key].like = item.like+1;
                        //                                                  articleItems[item.key].ilike = true;
                        //                                                }
                        //                                              });
                        ////                                              print('likeclick====>${articleItems[0].like}');
                        //                                            }
                        //                                          });
                        //                                        }catch(e){
                        //                                          print('articledolike===>${e}');
                        //                                        }
                        //                                      }
                        //                                  ),
                        //                                  Text(item.like.toString(),style: TextStyle(
                        //                                    color: Colors.grey[500],
                        //                                    fontSize: 15,
                        //                                  )
                        //                                  ),
                        //                                ]
                        //                            ):Container(),
                        (widget.isShowLikeBtn == true)
                            ? Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: (item.ilike == true && item.like > 0)
                                    ? AButton.icon(
                                        width: 70,
                                        height: 25,
                                        borderColor: rgba(28, 141, 160, 1),
                                        bgColor: rgba(28, 141, 160, 1),
                                        plain: true,
                                        textChild: Text(
                                          item.like.toString(),
                                          style: TextStyle(
                                            color: hex('#fff'),
                                            fontSize: 13,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(40),
                                        icon: icon_favorite(
                                          size: 13,
                                          color: hex('#fff'),
                                        ),
                                        onPressed: () {
                                          _clickDoLike(item);
                                        },
                                      )
                                    : AButton.icon(
                                        width: 70,
                                        height: 25,
                                        borderColor: rgba(28, 141, 160, 1),
                                        bgColor: hex('#fff'),
                                        plain: true,
                                        textChild: Text(
                                          item.like.toString(),
                                          style: TextStyle(
                                            color: hex('#333'),
                                            fontSize: 13,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(40),
                                        icon: icon_favorite_border(
                                          size: 13,
                                          color: hex('#333'),
                                        ),
                                        onPressed: () {
                                          _clickDoLike(item);
                                        },
                                      ),
                              )
                            : Container(),
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

  Widget buildTagsContent(item) {
    return new InkWell(
      child: new Chip(label: new Text(item.name)),
      onTap: () {
        //          print('clickTagname====>${item.name},value====>${item.value}');
        G.pushNamed('/search_result', arguments: {'result': item.value});
      },
    );
  }

  void _onRefresh() async {
    //    print('onRefresh===>');
    //     await Future.delayed(Duration(milliseconds: 1000));
    Future.delayed(Duration.zero, () {
      if (mounted) {
        _refreshController.loadComplete();
      }
      // if failed,use refreshFailed()
      return _refreshController.refreshCompleted();
    });
  }

  void _onLoading() async {
    //    print('onloading1===>');
    //     await Future.delayed(Duration(milliseconds: 1000));
    Future.delayed(Duration.zero, () {
      if (mounted) {
        //      print('onloading2===>${page_id}');
        _loadListData(
          context,
          isshowloading: false,
          limit: widget.pagelimit,
          pageid: ++page_id,
          cateid: widget.cateid,
          search_by_title: widget.search_by_title,
          user_id: widget.user_id,
          eland_id: widget.eland_id,
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
    cateid = 0,
    search_by_title = '',
    user_id = 0,
    eland_id = 0,
  }) async {
    if (isshowloading == true) G.loading.show(context);
    //    print('articlereault====>${search_by_title}');
    try {
      var res = await G.req.eland.prayers_list(
        cateid: cateid,
        pageid: pageid,
        limit: limit,
        search_by_title: search_by_title,
        userid: user_id,
        eland_id: eland_id,
      );
      Map result = res.data;
      // print('result===>${result}');
      ElandPrayersListModel tempArticleLikeList =
          ElandPrayersListModel.fromJson(result);
      if (mounted) {
        setState(() {
          articleItems.addAll(tempArticleLikeList.list);
          //        print('_loadListData===>${tempArticleList.list.length}');
          if (tempArticleLikeList.list.length == 0) {
            isloadcomplete = true;
            _refreshController.loadNoData();
            //          print('_loadListData===>${articleList.list.length}');
          }
        });
      }

      //      List list = data['list'];
      //      print('sss===>${articleList.list[0].tags[0].name}');
      if (isshowloading == true) G.loading.hide(context);
    } catch (e) {
      print('articleCatch===>${e}');
      if (isshowloading == true) G.loading.hide(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget top_contents = widget.topchild;
    Widget bottom_contents = widget.bottomchild;

    //    super.build(context);
    //    return SingleChildScrollView(
    //        child: new Container(
    //          child: new Column(
    ////              children: articleItems.map(buildContent).toList()
    //              children: articleItems.asMap().keys.map((f){
    //                articleItems[f].key = f;
    //                return buildContent(articleItems[f]);
    //              }).toList()
    //          ),
    //        )
    //    );
    if (widget.isSmartRefresher == true) {
      return SmartRefresher(
        enablePullDown: false,
        enablePullUp: (widget.isloadmore == true) ? true : false,
        //        header:G.pullToRefresh.header(),
        footer: G.pullToRefresh.footer(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: SingleChildScrollView(
          child: new Container(
            child: new Column(
              //              children: articleItems.map(buildContent).toList()
              //              children: articleItems.asMap().keys.map((f){
              //                articleItems[f].key = f;
              //                return buildContent(articleItems[f]);
              //              }).toList()
              children: <Widget>[
                top_contents,
                new Column(
                  children: articleItems.asMap().keys.map((f) {
                    articleItems[f].key = f;
                    return buildContent(articleItems[f]);
                  }).toList(),
                ),
                bottom_contents,
              ],
            ),
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              top_contents,
              new Column(
                children: articleItems.asMap().keys.map((f) {
                  articleItems[f].key = f;
                  return buildContent(articleItems[f]);
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
