import 'dart:async';
//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
//import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:shimmer/shimmer.dart';
//import '../../components/a_button/index.dart';
//import '../../model/user_model/data.dart';
import '../../utils/global.dart';
import '../../model/comment_list_model/data.dart';

class CommentPage extends StatefulWidget {
  final Map args;
  const CommentPage({Key? key, required this.args}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late int articleId; // More descriptive name
  late int userId;
  int pageId = 1;
  final List<dynamic> comments = []; // Typed list
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  bool isLoading = false; // Indicate loading state

  @override
  void initState() {
    super.initState();
    final userData = G.user.data;
    userId = userData!.id ?? 0; // Ensure userId is initialized
    articleId = widget.args['id'];
    _loadData(articleId: articleId, limit: 25, pageId: pageId, userId: userId);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    pageId = 1;
    comments.clear();
    await _loadData(
      articleId: articleId,
      limit: 25,
      pageId: pageId,
      userId: userId,
    );
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    await _loadData(
      articleId: articleId,
      limit: 25,
      pageId: ++pageId,
      userId: userId,
    );
    _refreshController.loadComplete();
  }

  Future<void> _loadData({
    required int articleId,
    required int userId,
    required int pageId,
    required int limit,
  }) async {
    setState(() => isLoading = true); // Indicate loading

    try {
      final res = await G.req.article.comment(
        articleid: articleId,
        userid: userId,
        pageid: pageId,
        limit: limit,
      );
      final result = res.data;
      final commentList = CommentModel.fromJson(result);
      setState(() {
        comments.addAll(commentList.list!);
        isLoading = false;
      });
      if (commentList.list!.isEmpty) {
        _refreshController.loadNoData();
      }
    } catch (e) {
      print('_loadData===>${e}');
      // Show error message to the user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error loading comments')));
      setState(() => isLoading = false); // Update loading state even on error
    }
  }

  Future<void> _clickDoLike(item) async {
    try {
      final res = await G.req.article.do_like_comment(
        articleid: articleId,
        userid: userId,
        comment_id: item.commentId,
        to_userid: item.userId,
      );
      final result = res.data;
      if (result['code'] == 200) {
        setState(() {
          item.likeNum += item.ilike ? -1 : 1;
          item.ilike = !item.ilike;
        });
      }
    } catch (e) {
      print('_clickDoLike===>${e}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error updating like')));
    }
  }

  Widget _buildCommentItem(item, int index) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(top: 10.0, bottom: 0.0),
          padding: const EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: BorderDirectional(
              bottom: BorderSide(color: Colors.black12, width: 1.0),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 28, 141, 160),
                        backgroundImage: NetworkImage(item.avatar),
                        radius: 11.0,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: G.screenWidth() * 0.73333,
                          child: Text(
                            item.userName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: SizedBox(
                            width: G.screenWidth() * 0.73333,
                            child: Text(
                              item.commentContent,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            icon_query_builder(size: 13, color: Colors.black54),
                            const SizedBox(width: 5.0),
                            Text(
                              item.commentTime,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => _clickDoLike(item),
                                child: Text(
                                  '${item.likeNum} 點贊',
                                  style: TextStyle(
                                    color: item.ilike
                                        ? Color.fromARGB(255, 28, 141, 160)
                                        : Colors.black54,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              InkWell(
                                onTap: () {
                                  G.pushNamed(
                                    '/reply_comment',
                                    arguments: {
                                      'articleid': articleId,
                                      'commentid': item.commentId,
                                      'to_userid': item.userId,
                                    },
                                  );
                                },
                                child: Text(
                                  '${item.replyNum} 回復',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                            ],
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
      ],
    );
  }

  Widget _buildShimmerCommentItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 20, color: Colors.grey[300]),
                    const SizedBox(height: 5),
                    Container(height: 40, color: Colors.grey[300]),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 10,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 30,
                          height: 10,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 30,
                          height: 10,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '評論'),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) =>
                          _buildShimmerCommentItem(),
                    )
                  : SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: false,
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
                        complete: const Text('√ 加載完成'),
                      ),
                      footer: G.pullToRefresh.footer(),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) =>
                            _buildCommentItem(comments[index], index),
                      ),
                    ),
            ),
            const SizedBox(height: 15.0),
            Container(
              height: 50.0,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: const Color(0xfff7f7f7),
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 0.2),
                  bottom: BorderSide(color: Colors.grey, width: 0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 7.0,
                        bottom: 7.0,
                        left: 8.0,
                        right: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        maxLines: null,
                        cursorColor: Color(0xff014d7b),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(5.0),
                        ),
                        style: const TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          fontSize: 14.0,
                          color: Color(0xff181818),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (_textController.text.trim().isEmpty) {
                        return G.toast('你還未填寫內容？');
                      }
                      final commentStr = _textController.text.trim();
                      try {
                        final res = await G.req.article.add_comment(
                          articleid: articleId,
                          userid: userId,
                          textStr: commentStr,
                        );
                        final data = res.data;
                        if (data != null && data['code'] == 200) {
                          _textController.clear();
                          G.toast('提交成功');
                          _onRefresh();
                        } else {
                          G.toast('提交失敗，請重試');
                        }
                      } catch (e) {
                        print('add_comment===>${e}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error adding comment')),
                        );
                      }
                    },
                    child: icon_send(size: 35, color: Color(0xff333333)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
