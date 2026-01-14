//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import '../../components/custom_navbar/index.dart';
import '../../model/user_model/data.dart';
import '../../components/a_eland_list/index.dart';
import '../../utils/global.dart';

class MyElandList extends StatefulWidget {
  final Map args;
  MyElandList({Key? key, required this.args}) : super(key: key);
  @override
  _MyElandListState createState() => _MyElandListState();
}

class _MyElandListState extends State<MyElandList>
    with TickerProviderStateMixin {
  static Map? args;
  String header_title = '我關注的ELand';
  String search_key = '';
  int userid = 0;

  // static TabController _tabController;

  // static ElandCateModel elandCate;
  //
  // static int curelandCateId = 0;

  @override
  void initState() {
    UserDataModel userData = G.user.data!;
    userid = userData.id ?? 0;
    if (args != null) {
      args = widget.args;
      search_key = args?['search_key'];
    } else {
      search_key = '';
    }
    print('search_key===>${args}');
    try {
      Future.delayed(Duration.zero, () async {});
    } catch (e) {
      print('_clickelandcate===>${e}');
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildTabBarView() {
    int cateid = 0;
    userid = G.user.data!.id ?? 0;
    // print('userid====>${userid}');
    return AElandList(
      uid: userid,
      searchByName: search_key,
      cateId: cateid,
      type: 'follow',
    );

    //     if(elandCate != null && elandCate.list.length > 0){
    //       return TabBarView(
    // //        physics: new NeverScrollableScrollPhysics(),
    //         controller: _tabController,
    //         children: elandCate.list.asMap().keys.map((f){
    //           var elandCateList = elandCate.list[f];
    //           cateid = elandCateList.cateid;
    // //          print('cateid11=====>${cateid}');
    //           return AElandList(uid:userid,search_by_name:search_key,cateid:cateid);
    //
    //         }).toList(),
    //       );
    //     }
  }

  @override
  Widget build(BuildContext context) {
    //print('articleCate===>${articleCate}');
    //print('articleCate.list===>${articleCate.list}');
    print('my_eland_list ${header_title}');
    return Scaffold(
      backgroundColor: Colors.white,

      //      appBar: customAppbar(context: context,title: header_title),
      appBar: customAppbar(context: context, title: '${header_title}'),

      //      body: AElandList(uid:userid,search_by_name:search_key),
      body: Container(
        color: Color(0xffffffff),
        child: buildTabBarView(),
        //      child: Text('123'),
      ),

      bottomNavigationBar: CustomNavbar(
        onTap: (index) {
          G.pushNamed(G.toobarRouteNameList[index]);
        },
      ),
    );
  }
}
