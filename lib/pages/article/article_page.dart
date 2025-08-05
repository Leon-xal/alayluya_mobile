import 'package:flutter/material.dart';
import '../../components/a_article_list/index.dart';
import '../../model/user_model/data.dart';
import '../../utils/global.dart';

class ArticlePage extends StatefulWidget {

  static _ArticlePageState _articlePageState;

  ArticlePage() {
    _articlePageState = _ArticlePageState();
  }

  getAppBar() => _articlePageState.createAppBar();

  _ArticlePageState createState() => _ArticlePageState();
}

// class _ArticlePageState extends State<ArticlePage> {
class _ArticlePageState extends State<ArticlePage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; ///see AutomaticKeepAliveClientMixin

  String _search_key = '';

  int userid = 0;

  @override
  void initState() {
    super.initState();
    // print('article======>');
    UserDataModel userData = G.user.data;
    if(userData != null){
      userid = userData.id;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
  AppBar createAppBar() {
    return customAppbar(title: 'AA文章',default_actions: true,);
  }
  @override
  Widget build(BuildContext context) {
//    return Text('qwe');

    dynamic arg = ModalRoute.of(context).settings.arguments;
    if (arg != null) {
      _search_key = arg["search_key"];
    }
//    return Text('456');
    return AArticleList(
      isShowDesc: true,
      isShowPrayerBtn: false,
      isreload: true,
      search_by_title: _search_key,
      uid: userid,
    );

  }


}
