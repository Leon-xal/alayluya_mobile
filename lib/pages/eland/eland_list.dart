//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import '../../components/custom_navbar/index.dart';
import '../../model/user_model/data.dart';
import '../../model/eland_cate_model/data.dart';
import '../../components/a_eland_list/index.dart';
import '../../utils/global.dart';

class ElandList extends StatefulWidget {
  final Map args;
  ElandList({Key key, this.args}) : super(key: key);
  @override
  createState() => _ElandListState();
}

class _ElandListState extends State<ElandList> with TickerProviderStateMixin {
  static Map args;
  String header_title = 'ELand';
  String search_key = '';
  int userid = 0;

  static TabController _tabController;

  static ElandCateModel elandCate;

  static int curelandCateId = 0;

  @override
  void initState() {
    UserDataModel userData = G.user.data;
    userid = userData.id;
    args = widget.args;
    search_key = args['search_key'];
    print('search_key===>${args}');
    try {
      Future.delayed(Duration.zero, () async {
        var res = await G.req.eland.cate();
        Map result = res.data;
        if (mounted) {
          setState(() {
            elandCate = ElandCateModel.fromJson(result);
            curelandCateId = elandCate.list[0].cateid;

            _tabController = TabController(
              vsync: this,
              length: elandCate.list.length,
            );
            _tabController.addListener(() {
              if (_tabController.index == _tabController.animation.value) {
                curelandCateId = elandCate.list[_tabController.index].cateid;
                //                print('curelandCateId====>${curelandCateId}');
              }
            });
          });
        }
      });
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
    if (elandCate.list.length > 0) {
      return TabBarView(
        //        physics: new NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: elandCate.list.asMap().keys.map((f) {
          var elandCateList = elandCate.list[f];
          cateid = elandCateList.cateid;
          //          print('cateid11=====>${cateid}');
          return AElandList(
            uid: userid,
            search_by_name: search_key,
            cateid: cateid,
          );
        }).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //    print('articleCate===>${articleCate}');
    //    print('articleCate.list===>${articleCate.list}');
    return Scaffold(
      backgroundColor: Colors.white,

      //      appBar: customAppbar(context: context,title: header_title),
      appBar: (elandCate != null)
          ? customAppbar(
              title: header_title,
              default_actions: true,
              borderBottom: true,
              TabContainer: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: (elandCate.list.length > 0)
                      ? elandCate.list.asMap().keys.map((f) {
                          return Text(elandCate.list[f].catename);
                        }).toList()
                      : Text('全部'),
                  indicatorColor: rgba(28, 141, 160, 1),
                  //            indicatorSize: TabBarIndicatorSize.tab,
                  //          labelPadding: EdgeInsets.only(top: 20,bottom:20,left:20,right:20),
                  labelPadding: (elandCate.list.length > 4)
                      ? EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                          left: 20,
                          right: 20,
                        )
                      : EdgeInsets.only(top: 20, bottom: 20),
                  indicatorPadding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 20,
                    right: 20,
                  ),
                  //          indicator: new ShapeDecoration(shape: new Border.all(color: Colors.redAccent, width: 1.0)),
                  labelColor: rgba(28, 141, 160, 1),
                  //          indicatorWeight: 15.0,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: rgba(28, 141, 160, 1),
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 15,
                    color: hex('#333'),
                  ),
                  unselectedLabelColor: hex('#333'),
                  isScrollable: (elandCate.list.length > 4) ? true : false,
                ),
              ),
            )
          : null,

      //      body: AElandList(uid:userid,search_by_name:search_key),
      body: Container(
        color: hex('#fff'),
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
