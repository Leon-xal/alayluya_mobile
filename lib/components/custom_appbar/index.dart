//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
//import '../../model/user_model/data.dart';
//import '../../utils/Icon.dart';
import '../../utils/global.dart';

/// 通用appbar
///
/// ```
/// @param {BuildContext} - context 如果context存在：左边有返回按钮，反之没有
/// @param {String} title - 标题
/// @param {bool} borderBottom - 是否显示底部border
/// ```
AppBar customAppbar({
  BuildContext? context,
  String? title,
  bool textcenter = false,
  bool borderBottom = true,
  bool default_actions = false,
  bool is_search = false,
  List? actions,
  Theme? TabContainer,
  Function? onGoBackPressed = null,
}) {
  //  print('aaaaaaa:${context}');
  //  context = null;
  //  print('aaaaaab:${context}');

  if (is_search == true) {
    _doSearch(String str) async {
      try {
        //UserDataModel userData = G.user.data;
        //int userid = userData.id!;
        //var res = await G.req.search.dosearch(search_key: str, uid: userid);
        //Map result = res.data;
        //        print('dosearch====>${result}');
      } catch (e) {
        print('dosearchCatch===>${e}');
      }
    }

    return new AppBar(
      //brightness: Brightness.light,
      title: Container(
        child: new Row(
          children: <Widget>[
            new Container(
              child: new ElevatedButton.icon(
                onPressed: () {
                  //                  Navigator.of(context).pop();
                  if (context == null) {
                    G.toast('參數有誤');
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: new Icon(Icons.arrow_back, color: Colors.black54),
                label: new Text(""),
              ),
              width: 60.0,
            ),
            new Expanded(
              child: new TextField(
                autofocus: true,
                decoration: new InputDecoration.collapsed(
                  hintText: title,
                  hintStyle: new TextStyle(color: Colors.black54),
                ),
                onSubmitted: (result) {
                  ///這裏需要調起一個網絡請求，記錄搜索結果
                  //                  print('onSubmitted:${result}');
                  //                  G.pushNamed('/search_result');
                  _doSearch(result);
                  //FocusScope.of(context).requestFocus(FocusNode());
                  if (context != null) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.of(context).pushReplacementNamed(
                      '/search_result',
                      arguments: {'result': result},
                    );
                  }
                },
              ),
            ),
          ],
        ),
        decoration: new BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
          color: new Color(0xFFEBEBEB),
        ),
      ),
      backgroundColor: Color(0xffffffff),
      elevation: 0,
      leading: null,
      automaticallyImplyLeading: false,

      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Container(
          decoration: BoxDecoration(border: G.borderBottom(show: borderBottom)),
        ),
      ),
    );
  } else {
    if (title == null || title.isEmpty) {
      title = 'Alayluya';
    }
    return AppBar(
      //brightness: Brightness.light,
      centerTitle: textcenter,
      title: Container(
        child: Text(
          title,
          style: TextStyle(
            color: Color.fromARGB(255, 56, 56, 56),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        padding: EdgeInsets.only(left: 0),
      ),
      backgroundColor: Color(0xffffffff),
      //    backgroundColor: rgba(255, 255, 255, 1),
      elevation: 0,
      leading: context == null
          ? null
          : InkWell(
              child: icon_left(color: Color.fromARGB(255, 0, 0, 0), size: 25),
              onTap: () {
                onGoBackPressed!();
              },
            ),
      automaticallyImplyLeading: context == null ? false : true,

      bottom: PreferredSize(
        preferredSize: Size.fromHeight((TabContainer == null) ? 0 : 60),
        //        child: (TabContainer == null)? Container(
        //          decoration: BoxDecoration(
        //              border: G.borderBottom(show: borderBottom)
        //          ),
        //        ) : TabContainer,

        //        child: Container(
        //          decoration: BoxDecoration(
        //              border: G.borderBottom(show: borderBottom)
        //          ),
        //          child: (TabContainer == null)? null : TabContainer,
        //        ),
        child: (TabContainer == null)
            ? Container(
                decoration: BoxDecoration(
                  border: G.borderBottom(show: borderBottom),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  border: G.borderTop(show: borderBottom),
                ),
                child: TabContainer,
              ),
      ),

      actions: (actions == null && default_actions == true)
          ? <Widget>[
              Container(
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(right: 0),
                      child: InkWell(
                        child: CircleAvatar(
                          radius: 20.0,
                          child: icon_search(
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 20,
                          ),
                          backgroundColor: Color.fromARGB(255, 229, 229, 229),
                        ),
                        onTap: () {
                          //                      print('icontest1 click<<<<<<===============');
                          G.pushNamed('/search');
                          //                    Navigator.of(context).pushReplacementNamed('/search');
                        },
                      ),
                    ),
                    //              new Container(
                    //                margin: EdgeInsets.only(right: 10),
                    //                child: InkWell(
                    //                    child: CircleAvatar(
                    //                      radius: 20.0,
                    //                      child: icon_setting(color: rgba(0, 0, 0, 1), size: 20),
                    //                      backgroundColor: rgba(229, 229, 229, 1),
                    //                    ),
                    //                    onTap: (){
                    ////                        print('icontest2 click<<<<<<===============');
                    //                      G.pushNamed('/setting');
                    ////                    Navigator.of(context).pushReplacementNamed('/search_result');
                    //
                    //                    }
                    //                ),
                    //              ),
                  ],
                ),
              ),
            ]
          : actions as List<Widget>,
    );
  }
}
