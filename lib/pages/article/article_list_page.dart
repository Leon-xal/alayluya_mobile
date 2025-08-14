import 'package:flutter/material.dart';
import '../../components/custom_navbar/index.dart';
import '../../components/a_article_list/index.dart';
import '../../model/user_model/data.dart';
import '../../utils/global.dart';

class ArticleListPage extends StatefulWidget {
  final Map args;
  ArticleListPage({Key? key, required this.args}) : super(key: key);
  @override
  createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  static Map? args;
  int userid = 0;
  int _eland_id = 0;
  bool _ishot = false;
  @override
  void initState() {
    super.initState();
    UserDataModel userData = G.user.data!;
    userid = userData.id ?? 0;
    args = widget.args;
    _eland_id = args?['eland_id'];
    _ishot = args?['ishot'];
    print('_ishot===>${_ishot}');
    //    Future.delayed(Duration.zero, () async {
    //      print('ssss===>${userid}');
    //    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppbar(context: context, title: 'AA文章'),

      body: (userid > 0)
          ? AArticleList(
              uid: userid,
              eland_id: _eland_id,
              isreload: true,
              isShowDesc: true,
              isShowCenterload: true,
              isShowPrayerBtn: false,
              ishot: _ishot,
            )
          : Container(),

      bottomNavigationBar: CustomNavbar(
        onTap: (index) {
          G.pushNamed(G.toobarRouteNameList[index]);
        },
      ),
    );
  }
}
