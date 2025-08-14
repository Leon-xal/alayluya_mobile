import 'package:flutter/material.dart';
import '../../model/user_model/data.dart';
import '../../components/custom_navbar/index.dart';
import '../../utils/global.dart';
import '../../model/search_model/data.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);
  @override
  createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> suggestedItem = [];
  List<dynamic> historyItem = [];
  String searchText = '搜索';
  int userid = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      //      print('aaa===>${widget.isshowcenterload}');
      _loadListData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _doSearch(String str) async {
    try {
      UserDataModel? userData = G.user.data;
      userid = userData!.id ?? 0;
      //      print('_doSearch====>${userid}');
      var res = await G.req.search.dosearch(search_key: str, uid: userid);
      //      Map result = res.data;
      //      print('dosearch====>${result}');
    } catch (e) {
      print('dosearchCatch===>${e}');
    }
  }

  _loadListData() async {
    try {
      UserDataModel userData = G.user.data!;
      userid = userData.id!;
      var res = await G.req.search.index(uid: userid);
      Map result = res.data;
      SearchModel searchResult = SearchModel.fromJson(
        result as Map<String, dynamic>,
      );
      //      print('aasd1===>${searchResult.data.suggested[0].title}');
      //      print('aasd2===>${searchResult.data.history[0].title}');
      if (mounted) {
        setState(() {
          suggestedItem = searchResult.data!.suggested!;
          historyItem = searchResult.data!.history!;
        });
      }
    } catch (e) {
      print('searchCatch===>${e}');
    }
  }

  clickTag(String str) async {
    FocusScope.of(context).requestFocus(FocusNode());

    _doSearch(str);

    setState(() {
      searchText = str;
    });
    await G.sleep(milliseconds: 1000);
    Navigator.of(
      context,
    ).pushReplacementNamed('/search_result', arguments: {'result': searchText});
    //    print('sss===>${str}');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppbar(
        context: context,
        title: searchText,
        is_search: true,
      ),
      body: new SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: new Column(
            children: <Widget>[
              new Container(
                child: new Text(
                  "熱搜榜",
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                margin: const EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                  bottom: 16.0,
                ),
                alignment: Alignment.topLeft,
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 10.0,
                ),
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 5, // 主轴(水平)方向间距
                  runSpacing: 0, // 纵轴（垂直）方向间距
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.start, //沿主轴方向居中
                  runAlignment: WrapAlignment.start,
                  children: suggestedItem.map((item) {
                    return new InkWell(
                      child: new Chip(label: new Text(item.title)),
                      onTap: () {
                        //                        print('clickTagtitle====>${item.title}}');
                        clickTag(item.title);
                      },
                    );
                  }).toList(),
                ),
              ),
              new Container(
                child: new Text(
                  "搜索記錄",
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                margin: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                alignment: Alignment.topLeft,
              ),
              new Column(
                children: historyItem.map((item) {
                  //                return Text('${item.title}');
                  return new Container(
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          child: new Icon(
                            Icons.access_time,
                            color: Colors.black54,
                            size: 16.0,
                          ),
                          margin: const EdgeInsets.only(right: 12.0),
                        ),
                        new Expanded(
                          child: new Container(
                            child: new InkWell(
                              child: new Text(
                                item.title,
                                style: new TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14.0,
                                ),
                              ),
                              onTap: () {
                                clickTag(item.title);
                                //                                print('clickTagtitle2====>${item.title}}');
                              },
                            ),
                            //                          child: new Text(item.title, style: new TextStyle( color: Colors.black54, fontSize: 14.0),),
                          ),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 10.0,
                    ),
                    padding: const EdgeInsets.only(bottom: 10.0),
                    decoration: new BoxDecoration(
                      border: new BorderDirectional(
                        bottom: new BorderSide(color: Colors.black12),
                      ),
                    ),
                  );
                }).toList(),
              ),
              //
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavbar(
        onTap: (index) {
          G.pushNamed(G.toobarRouteNameList[index]);
        },
      ),
    );
  }
}
