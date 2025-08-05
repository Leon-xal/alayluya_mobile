import 'dart:async';
import 'dart:io';

//import 'package:flui/widgets/toast.dart';
// import 'package:flui/flui.dart';
import '../../components/a_button/index.dart';
import 'package:color_dart/HexColor.dart';
import 'package:color_dart/RgbaColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import '../../model/user_model/data.dart';
import '../../utils/global.dart';
import '../../model/reply_list_model/data.dart';

class ReplyComment extends StatefulWidget {
  final Map args;
  ReplyComment({
    Key key,
    this.args,
  }) : super(key: key);

  @override
  _ReplyCommentState createState() => _ReplyCommentState();

}


class _ReplyCommentState extends State<ReplyComment> {
  static Map args;
  TextEditingController _textController = TextEditingController();
  FocusNode _focusNode = new FocusNode();
  int articleid = 0;
  int commentid = 0;
  int userid = 0;
  int to_userid=0;
  int page_id = 1;
  List<dynamic> items = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  bool isloadcomplete = false;

  @override
  void initState() {
    super.initState();
    UserDataModel userData = G.user.data;
    userid = userData.id;
    args = widget.args;
    if(args != null){
      articleid = args['articleid'];
      commentid = args['commentid'];
      to_userid = args['to_userid'];
      Future.delayed(Duration.zero, () async{
        _loadData(articleid: articleid,commentid: commentid,uid: userid,limit:25,pageid: page_id);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onRefresh() async{
//    print('onRefresh1===>');
//     await Future.delayed(Duration(milliseconds: 1000));
    Future.delayed(Duration.zero,()async{
      if(mounted) {
        page_id = 1;
        items = [];
        _loadData(articleid: articleid,commentid: commentid,uid:userid,limit:25,pageid:page_id);
      }
      _refreshController.refreshCompleted();
    });

  }

  void _onLoading() async{
    // await Future.delayed(Duration(milliseconds: 1000));
    Future.delayed(Duration.zero,() {
      if (mounted) {
        int page_id2 = ++page_id;
        _loadData(articleid: articleid,
            commentid: commentid,
            uid: userid,
            limit: 25,
            pageid: page_id2);
      }
      _refreshController.loadComplete();
    });
  }

  _loadData({int articleid=0,int commentid=0,int uid=0, int pageid=1, int limit=25,}) async {
    try {
//      print('_loaddata====>${id},${uid},${pageid},${limit}');
      var res = await G.req.article.reply_comment_list(
        articleid: articleid,
        comment_id: commentid,
        userid: uid,
        pageid:pageid,
        limit:limit,
      );
      print('reply===>${res}');
      Map result = res.data;
      ReplyModel tempList = ReplyModel.fromJson(result);
      if (mounted) {
        setState(() {
          items.addAll(tempList.list);
          isloadcomplete = true;

        });
        if (tempList.list.length == 0) {
          _refreshController.loadNoData();
        }
      }
    }catch(e) {
      print('_loadData===>${e}');
    }
  }

  Widget editWidget(context, size) {
    // 计算当前的文本需要占用的行数
    return TextField(
      controller: _textController,
      focusNode: _focusNode,
      maxLines: 100,
      cursorColor: hex('#014d7b'),
      decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(top:3.0,left:5.0,right:5.0,bottom:5.0)
      ),
//      onTap: () => setState(() {}),
//      onChanged: (v) => setState(() {}),
      style: TextStyle(
          textBaseline: TextBaseline.alphabetic,
          fontSize: 14.0,
          color: const Color(0xff181818)
      ),
    );
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
//    print('aaa=====>${userid},${item.user_id}');
    return Stack(
      children: [
        new Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(top: 10.0, bottom: 0.0),
          padding: const EdgeInsets.only(bottom: 10.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            border: new BorderDirectional(
                bottom: new BorderSide(color: Colors.black12, width: 1.0)
            ),
          ),
          child: new Column(
            children: <Widget>[
              new Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 10.0),

                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      width: 45,
                      height: 45,
                      margin: const EdgeInsets.only(left:10.0,right: 15.0),
                      child: new CircleAvatar(
                          backgroundColor: rgba(28, 141, 160, 1),
                          backgroundImage: new NetworkImage(item.avatar),
                          radius: 11.0
                      ),
                    ),
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          width: G.screenWidth() * 0.73333,
                          child: new Text(
                              item.user_name,
                              maxLines:2,
                              overflow:TextOverflow.ellipsis,
                              style: new TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 16.0,)
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(top: 5.0,bottom:5.0),
                          width: G.screenWidth() * 0.73333,
                          child: new Text(
                              item.reply_content,
                              style: new TextStyle(color: Colors.black,fontSize: 15.0,)
                          ),
                        ),
                        Row(
                          children: [
                            icon_query_builder(size: 13,color: Colors.black54),
                            Container(
                              width:5.0,
                            ),
                            (item.reply_time.toString() == '') ? Container(): new Text(item.reply_time.toString(), style: new TextStyle(color: Colors.black54,fontSize: 13.0,)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

              ),
            ],
          ),
        ),
      ],
    );

  }


  @override
  Widget build(BuildContext context) {
    var body = [
      new Expanded(
        child:(items.length > 0 && isloadcomplete == true) ?
        SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: WaterDropHeader(
            refresh:SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(rgba(28, 141, 160, 1)),
              ),
            ),
            complete:Text('√ 加載完成'),
          ),
          footer: G.pullToRefresh.footer(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,

          child: ListView.builder(
            itemBuilder: (c, f){
              //          print('fff====>${f},${elandItems.length}');
              items[f].key = f;
              return new Container(
                child: new Column(
                  children: <Widget>[
                    buildContent(items[f]),
                  ],
                ),
              );
            },
            itemCount: items.length,
          ),
        ) : ((items.length == 0 && isloadcomplete == true)? Container() : _cardListSkeleton()),
      ),
      new Container(
        height: 15.0,
      ),
//      new Spacer(),
      new Container(
        height: 50.0,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Color(0xfff7f7f7),
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.2),
            bottom: BorderSide(color: Colors.grey, width: 0.2),
          ),
        ),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: new Container(
                margin: const EdgeInsets.only(top: 7.0, bottom: 7.0, left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                child: new LayoutBuilder(builder: editWidget),
              ),
            ),
            new InkWell(
              child: icon_send(
                  size: 35,
                  color: hex('#333')
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                if(_textController.text == null || _textController.text.trim() == '') {
                  return G.toast('你還未填寫內容？');
                }
                String replyStr = _textController.text.trim();
                print('bbb====>${userid},${articleid},${commentid},${to_userid},${replyStr}');

                try {
                  var res = await G.req.article.reply_comment(
                    articleid: articleid,
                    userid: userid,
                    comment_id: commentid,
                    to_userid: to_userid,
                    textStr: replyStr,
                  );
                  var data = res.data;

                  if(data == null) return;

                  if(data['code'] == 200){
                    _textController.clear();
                    G.toast('提交成功');
                    _onRefresh();
                  }else{
                    G.toast('提交失敗，請重試');
                  }

                  print('reply===>${res}');

                }catch(e) {
                  print('add_reply===>${e}');
                }

              },
            ),
          ],
        ),
      ),

    ];
    return Scaffold(
        appBar: customAppbar(context: context,title: '回復'),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: new Column(children: body),
        )
    );

  }

}