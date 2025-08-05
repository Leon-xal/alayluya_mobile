import 'package:flutter/material.dart';
import '../../components/custom_navbar/index.dart';
import '../../components/a_article_like_list/index.dart';
import '../../model/user_model/data.dart';
import '../../utils/global.dart';

class ArticleLikePage extends StatefulWidget {
  ArticleLikePage({Key key}) : super(key: key);
  @override
  createState() => _ArticleLikePageState();
}

class _ArticleLikePageState extends State<ArticleLikePage> {
  int userid = 0;

  @override
  void initState() {
    super.initState();

    UserDataModel userData = G.user.data;
    userid = userData.id;
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
      appBar: customAppbar(context: context, title: '點贊文章'),

      body: (userid > 0)
          ? AArticleLikeList(
              isShowDesc: true,
              isShowPrayerBtn: false,
              isreload: true,
              user_id: userid,
            )
          : Container(),

      bottomNavigationBar: CustomNavbar(
        onTap: (index) {
          // print('currentIndex2=====>${index}');
          G.pushNamed(G.toobarRouteNameList[index]);

          // if(index == 1){
          //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
          // }else if(index == 2){
          //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TodayPage()));
          // }else if(index == 3){
          //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ArticlePage()));
          // }else if(index == 4){
          //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MemberCenter()));
          // }else{
          //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
          // }

          // G.pushNamed('/index',arguments: {'index': index});
          // G.pushNamed('/index');
          // Navigator.of(context).pushReplacementNamed(G.toobarRouteNameList[index]);
          // Navigator.of(context).pushNamed(G.toobarRouteNameList[index]);

          // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
          //   if(index == 1){
          //     return HomePage();
          //   }else if(index == 2){
          //     return TodayPage();
          //   }else if(index == 3){
          //     return ArticlePage();
          //   }else if(index == 4){
          //     return MemberCenter();
          //   }else{
          //     return HomePage();
          //   }
          // }),(route) => route == null);
        },
      ),
    );
  }
}
