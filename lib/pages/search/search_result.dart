//import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/a_article_list/index.dart';
import '../../components/a_eland_list/index.dart';
import '../../components/custom_navbar/index.dart';
import '../../components/a_button/index.dart';
import '../../model/user_model/data.dart';
import '../../utils/global.dart';

class SearchResult extends StatefulWidget {
  final Map args;

  SearchResult({Key key, this.args}) : super(key: key);

  @override
  createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  static Map args;
  int userid = 0;
  String _result = '';
  String _showresult = '';
  @override
  void initState() {
    super.initState();
    UserDataModel userData = G.user.data;
    userid = userData.id;
    //    dynamic arg = ModalRoute.of(context).settings.arguments;
    //    if (arg != null) {
    //      _result = arg["result"];
    //      _showresult = (_result.length > 10)?_result.substring(0,10)+'...':_result;
    //    }
    args = widget.args;
    _result = args['result'];
    _showresult = (_result.length > 10)
        ? _result.substring(0, 10) + '...'
        : _result;

    //    print('aaaaa====>${_result}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget barSearch() {
    return new Container(
      color: rgba(51, 51, 51, 0.3),
      padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      //        child: Text('123')
      child: new FlatButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/search');
        },
        child: new Row(
          children: <Widget>[
            new Container(
              child: new Icon(Icons.search, size: 18.0, color: Colors.black),
              margin: const EdgeInsets.only(right: 20),
              //                  width: 50.0,
            ),
            new Expanded(
              child: new Container(
                child: new Text(
                  _showresult,
                  style: new TextStyle(color: Colors.black),
                ),
              ),
            ),
            new Container(
              child: new FlatButton(
                child: new Icon(Icons.cancel, size: 18.0, color: Colors.black),
              ),
              width: 40.0,
            ),
          ],
        ),
      ),

      //        decoration: new BoxDecoration(
      //            borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
      //          color: rgba(51,51,51,0.3),
      //        )
    );
  }

  @override
  Widget build(BuildContext context) {
    //    dynamic arg = ModalRoute.of(context).settings.arguments;
    ////    print("sssb:${arg}");
    //    if (arg != null) {
    //      _result = arg["result"];
    ////      print("sssb:${_title}");
    //      _showresult = (_result.length > 10)?_result.substring(0,10)+'...':_result;
    ////      print('aaa:${_result.length}');
    //    }
    //    return Text('search result');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppbar(context: context, title: '搜索結果'),
      //        body: barSearch(),
      body: new SingleChildScrollView(
        child: new Container(
          child: new Column(
            children: <Widget>[
              barSearch(),

              (userid > 0)
                  ? AArticleList(
                      uid: userid,
                      isSmartRefresher: false,
                      search_by_title: _result,
                      pagelimit: 3,
                      isShowDesc: true,
                      isShowPrayerBtn: false,
                      topchild: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: new Border(
                            bottom: BorderSide(
                              width: 2.0,
                              color: hex('#cacbd1'),
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                        margin: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 10.0,
                          bottom: 10,
                        ),

                        child: Text(
                          "文章",
                          style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      bottomchild: Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 10,
                          right: 10,
                        ),
                        child: AButton.normal(
                          width: MediaQuery.of(context).size.width,
                          child: Text('更多'),
                          bgColor: rgba(229, 229, 229, 1.0),
                          color: hex('#000'),
                          borderColor: rgba(229, 229, 229, 1.0),
                          plain: true,
                          borderRadius: BorderRadius.circular(5),
                          onPressed: () {
                            G.pushNamed(
                              '/article',
                              arguments: {'search_key': _result},
                            );
                          },
                        ),
                      ),
                    )
                  : Container(),

              (userid > 0)
                  ? AElandList(
                      uid: userid,
                      isSmartRefresher: false,
                      isShowCenterload: false,
                      pagelimit: 3,
                      search_by_name: _result,
                      topchild: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: new Border(
                            bottom: BorderSide(
                              width: 2.0,
                              color: hex('#cacbd1'),
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                        margin: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 10.0,
                          bottom: 10,
                        ),

                        child: Text(
                          "Eland",
                          style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      bottomchild: Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 10,
                          right: 10,
                        ),
                        child: AButton.normal(
                          width: MediaQuery.of(context).size.width,
                          child: Text('更多'),
                          bgColor: rgba(229, 229, 229, 1.0),
                          color: hex('#000'),
                          borderColor: rgba(229, 229, 229, 1.0),
                          plain: true,
                          borderRadius: BorderRadius.circular(5),
                          onPressed: () {
                            G.pushNamed(
                              '/eland_list',
                              arguments: {'search_key': _result},
                            );
                          },
                        ),
                      ),
                    )
                  : Container(),
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
