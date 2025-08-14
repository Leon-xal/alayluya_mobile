import '../../main.dart';
import '../../provider/do_like_method.dart';
//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
//import '../../utils/Icon.dart';
import '../../utils/global.dart';
import '../../components/a_button/index.dart';
import '../../model/article_list_model/data.dart';

class AArticleList extends StatefulWidget {
  //  final ValueChanged<int> onTap;
  final String search_by_title;
  final bool isShowCenterload; //是否顯示加載數據的中間loading圖標
  final bool isloadmore; //是否支持下拉刷新數,前提是有開啟isSmartRefresher
  final int pagelimit; //顯示文章數量
  final int cateid; //文章分類
  final bool isreload; //開啟AutomaticKeepAliveClientMixin支持，tab效果支持會有緩存效果
  final Widget topchild; //上節點插糟
  final Widget bottomchild; //下節點插糟
  final bool isSmartRefresher;
  final bool isShowDesc;
  final bool isShowTag;
  final bool isShowLikeBtn;
  final bool isShowPrayerBtn;
  final bool isShowElandName;
  final int uid;
  final int eland_id;
  final bool ishot;
  AArticleList({
    Key? key,
    this.search_by_title = '',
    this.isShowCenterload = true,
    this.isloadmore = true,
    this.pagelimit = 10,
    this.cateid = 0,
    this.isreload = true,
    this.topchild = const SizedBox(),
    this.bottomchild = const SizedBox(),
    this.isSmartRefresher = true,
    this.isShowDesc = true,
    this.isShowTag = true,
    this.isShowLikeBtn = true,
    this.isShowPrayerBtn = true,
    this.isShowElandName = true,
    this.uid = 0,
    this.eland_id = 0,
    this.ishot = false,
    //    this.onTap,
  }) : super(key: key);

  @override
  _AArticleListState createState() => new _AArticleListState();
}

//with AutomaticKeepAliveClientMixin
//###Leo
class _AArticleListState extends State<AArticleList> with RouteAware {
  List<dynamic> articleItems = [];
  List<dynamic> articleTagsItems = [];
  //List<Article> articleItems = []; // Use Article type for better type safety
  //List<Tag> articleTagsItems = []; // Use Tag type for better type safety
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  int page_id = 1;
  bool isloadcomplete = false;
  bool isLoading = false; // Add isLoading flag

  //  @override
  //  bool get wantKeepAlive => widget.isreload; ///see AutomaticKeepAliveClientMixin

  //###Leo
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      MyApp.routeObserver.subscribe(this, route);
    }
  }

  //###Leo
  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        Map popMap = Provider.of<DoLikeMethod>(
          context,
          listen: false,
        ).popIsLike;
        Map pushMap = Provider.of<DoLikeMethod>(
          context,
          listen: false,
        ).pushLike;
        print("進入詳情======$pushMap}");
        print("再次返回頁面======$popMap}");

        if (pushMap['isLike'] != popMap['isLike']) {
          setState(() {
            for (var i = 0; i < articleItems.length; i++) {
              if (articleItems[i].id == popMap['id']) {
                articleItems[i].ilike = popMap['isLike'];
                if (popMap['isLike'] == true) {
                  articleItems[i].like++;
                } else {
                  articleItems[i].like--;
                }
              }
            }
          });
        }
      }
    });
  }

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
        userid: widget.uid,
        eland_id: widget.eland_id,
        ishot: widget.ishot,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _clickPrayer(item) {
    //    print('sss===>${item.eland_name}');

    int uid = G.user.data!.id!;
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

    int uid = G.user.data!.id!;
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

  Widget _shimmerListItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: AspectRatio(
                    aspectRatio: 3.0 / 2.0,
                    child: Container(
                      alignment: Alignment.topLeft,
                      color: Colors.grey[300], // Shimmer for image
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: 200,
                      color: Colors.grey[300],
                    ), // Shimmer for title
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, right: 4.0),
                    ),
                    Container(
                      height: 30,
                      width: 250,
                      color: Colors.grey[300],
                    ), // Shimmer for description
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, right: 4.0),
                    ),
                    if (widget.isShowTag)
                      Wrap(
                        spacing: 5,
                        runSpacing: 0,
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        children: List.generate(
                          3,
                          (index) => Container(
                            height: 20,
                            width: 50,
                            color: Colors.grey[300],
                          ),
                        ), // Shimmer for tags
                      ),
                    if (widget.isShowPrayerBtn)
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          height: 25,
                          width: 70,
                          color: Colors.grey[300],
                        ), // Shimmer for prayer button
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.isShowElandName)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Container(
                                  height: 18,
                                  width: 18,
                                  color: Colors.grey[300],
                                ), // Shimmer for author icon
                              ),
                              Container(
                                height: 14,
                                width: 150,
                                color: Colors.grey[300],
                              ), // Shimmer for author name
                            ],
                          ),
                        if (widget.isShowLikeBtn)
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: Container(
                              height: 25,
                              width: 70,
                              color: Colors.grey[300],
                            ), // Shimmer for like button
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildContent(item) {
    //    setState(() {
    articleTagsItems = item.tags;
    //    });

    return new Container(
      alignment: Alignment.topLeft,
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new BorderDirectional(
          bottom: new BorderSide(color: Colors.black12, width: 1.0),
        ),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
          backgroundColor: Colors.transparent,
        ),
        onPressed: () {
          //###Leo
          Future.delayed(Duration.zero, () async {
            Map map = {"isLike": item.ilike, "id": item.id};
            Provider.of<DoLikeMethod>(
              context,
              listen: false,
            ).getPushIsLike(map);
          });
          G.pushNamed('/article_detail', arguments: {'id': item.id});
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
                        item.title,
                        maxLines: 1,
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
                    (widget.isShowDesc == true)
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
                                    borderColor: Color.fromARGB(
                                      255,
                                      28,
                                      141,
                                      160,
                                    ),
                                    bgColor: Color.fromARGB(255, 28, 141, 160),
                                    plain: true,
                                    textChild: Text(
                                      item.prayer.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(40),
                                    icon: icon_prayer(
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _clickPrayer(item);
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
                                    ), // Replaced rgba
                                    bgColor:
                                        Colors.white, // Replaced hex('#fff')
                                    plain: true,
                                    textChild: Text(
                                      item.prayer.toString(),
                                      style: TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          51,
                                          51,
                                          51,
                                        ), // Replaced hex('#333')
                                        fontSize: 13,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(40),
                                    icon: icon_prayer(
                                      size: 13,
                                      color: Color.fromARGB(
                                        255,
                                        51,
                                        51,
                                        51,
                                      ), // Replaced hex('#333')
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
                                    margin: EdgeInsets.only(
                                      bottom: 10.0,
                                      top: 0.0,
                                    ),
                                    child: icon_author(
                                      size: 18,
                                      color: Color.fromARGB(
                                        255,
                                        73,
                                        73,
                                        73,
                                      ), // Replaced hex('#333')
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                      bottom: 10.0,
                                      top: 0.0,
                                    ),
                                    //                                    margin: const EdgeInsets.only(top: 5.0,bottom:10.0,left:4.0,right:4.0),
                                    width: G.screenWidth() * 0.3,
                                    child: InkWell(
                                      onTap: () {
                                        //                                      print('fffuuukkkkkk=====>${item.eland_id.toString()}');
                                        if (item.eland_id > 0) {
                                          G.pushNamed(
                                            '/eland_info',
                                            arguments: {'id': item.eland_id},
                                          );
                                        }
                                      },
                                      child: Text(
                                        item.author,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            73,
                                            73,
                                            73,
                                          ), // Replaced hex('#333')
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),

                        (widget.isShowLikeBtn == true)
                            ? Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: (item.ilike == true && item.like > 0)
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
                                          item.like.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(40),
                                        icon: icon_favorite(
                                          size: 13,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          _clickDoLike(item);
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
                                        bgColor: Colors.white,
                                        plain: true,
                                        textChild: Text(
                                          item.like.toString(),
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              51,
                                              51,
                                              51,
                                            ),
                                            fontSize: 13,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(40),
                                        icon: icon_favorite_border(
                                          size: 13,
                                          color: Color.fromARGB(
                                            255,
                                            51,
                                            51,
                                            51,
                                          ),
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
        G.pushNamed('/search_result', arguments: {'result': item.value});
        //          print('clickTagname====>${item.name},value====>${item.value}');
      },
    );
  }

  void _onRefresh() async {
    // await Future.delayed(Duration(milliseconds: 1000));
    Future.delayed(Duration.zero, () async {
      if (mounted) {
        page_id = 1;
        articleItems = [];
        articleTagsItems = [];
        await _loadListData(
          context,
          isshowloading: false,
          limit: widget.pagelimit,
          pageid: page_id,
          cateid: widget.cateid,
          search_by_title: widget.search_by_title,
          userid: widget.uid,
          eland_id: widget.eland_id,
          ishot: widget.ishot,
        );
      }
      _refreshController.refreshCompleted();
    });
  }

  void _onLoading() async {
    //    print('onloading1===>');
    //     await Future.delayed(Duration(milliseconds: 1000));
    Future.delayed(Duration.zero, () async {
      if (mounted) {
        _loadListData(
          context,
          isshowloading: false,
          limit: widget.pagelimit,
          pageid: ++page_id,
          cateid: widget.cateid,
          search_by_title: widget.search_by_title,
          userid: widget.uid,
          eland_id: widget.eland_id,
          ishot: widget.ishot,
        );
      }
      _refreshController.loadComplete();
    });
  }

  Future<void> _loadListData(
    BuildContext context, {
    bool isshowloading = true,
    int pageid = 1,
    int limit = 5,
    int cateid = 0,
    String search_by_title = '',
    int userid = 0,
    int eland_id = 0,
    bool ishot = false,
  }) async {
    if (isLoading) return; // Prevent multiple simultaneous loads
    isLoading = true;
    if (isshowloading) G.loading.show(context);
    try {
      var res = await G.req.article.list(
        cateid: cateid,
        pageid: pageid,
        limit: limit,
        search_by_title: search_by_title,
        userid: userid,
        eland_id: eland_id,
        ishot: ishot,
      );
      Map result = res.data;
      ArticleListModel tempArticleList = ArticleListModel.fromJson(
        Map<String, dynamic>.from(result),
      );
      if (mounted) {
        setState(() {
          articleItems.addAll(tempArticleList.list!);
          if (tempArticleList.list?.isEmpty ?? true) {
            isloadcomplete = true;
            _refreshController.loadNoData();
          }
          isLoading = false; // Set loading flag to false after data is loaded
        });
      }
    } catch (e) {
      print('articleCatch===>${e}');
      setState(() {
        isLoading = false;
      });
    } finally {
      if (isshowloading) G.loading.hide(context);
    }
  }

  /* replace with the above Shimmer method
  _loadListData(BuildContext context, {bool isshowloading=true, int pageid=1, int limit=5,int cateid=0,String search_by_title='',int userid=0,int eland_id=0,bool ishot=false}) async {
    if(isshowloading == true) G.loading.show(context);
//    print('articlereault====>${search_by_title}');
    try {
      var res = await G.req.article.list(
          cateid: cateid,
          pageid:pageid,
          limit:limit,
          search_by_title:search_by_title,
          userid: userid,
          eland_id: eland_id,
          ishot:ishot
      );
      Map result = res.data;
      ArticleListModel tempArticleList = ArticleListModel.fromJson(result);
      if (mounted) {
        setState(() {
          articleItems.addAll(tempArticleList.list);
//        print('_loadListData===>${tempArticleList.list.length}');
          if (tempArticleList.list.length == 0) {
            isloadcomplete = true;
            _refreshController.loadNoData();
//          print('_loadListData===>${articleList.list.length}');
          }
        });
      }

//      List list = data['list'];
//      print('sss===>${articleList.list[0].tags[0].name}');
      if(isshowloading == true) G.loading.hide(context);
    }catch(e) {
      print('articleCatch===>${e}');
      if(isshowloading == true) G.loading.hide(context);
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
  */

  /// Builds the main widget tree for the article list.
  /// Splits logic into smaller widgets for maintainability.
  @override
  Widget build(BuildContext context) {
    Widget top_contents = widget.topchild;
    Widget bottom_contents = widget.bottomchild;

    if (widget.isSmartRefresher) {
      return _buildSmartRefresher(top_contents, bottom_contents);
    } else {
      return _buildSimpleList(top_contents, bottom_contents);
    }
  }

  /// Builds the SmartRefresher branch with pull-to-refresh and loading logic.
  Widget _buildSmartRefresher(Widget top_contents, Widget bottom_contents) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: widget.isloadmore,
      header: WaterDropHeader(
        refresh: SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 28, 141, 160),
            ),
          ),
        ),
        complete: Text('√ 加載完成'),
      ),
      footer: G.pullToRefresh.footer(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: _buildListView(top_contents, bottom_contents),
    );
  }

  /// Builds the ListView for SmartRefresher, handling loading and empty states.
  Widget _buildListView(Widget top_contents, Widget bottom_contents) {
    if (isLoading) {
      // Show shimmer loading items
      return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => _shimmerListItem(),
      );
    } else if (articleItems.isEmpty) {
      // Show empty state
      return Center(
        child: Image.asset("lib/assets/images/empty_img.png", fit: BoxFit.fill),
      );
    } else {
      // Show article list
      return ListView.builder(
        itemCount: articleItems.length,
        itemBuilder: (c, i) {
          articleItems[i].key = i;
          return Column(
            children: [
              if (i == 0) top_contents,
              buildContent(articleItems[i]),
              if (i == articleItems.length - 1) bottom_contents,
            ],
          );
        },
      );
    }
  }

  /// Builds the simple scrollable list branch.
  Widget _buildSimpleList(Widget top_contents, Widget bottom_contents) {
    if (articleItems.isEmpty) {
      return Container();
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          top_contents,
          ...articleItems.map(buildContent),
          bottom_contents,
        ],
      ),
    );
  }
}
