import 'package:color_dart/HexColor.dart';
import 'package:color_dart/RgbaColor.dart';
import 'package:flutter/material.dart';
import '../../utils/global.dart';
//import '../../components/a_button/index.dart';
import '../../model/eland_list_model/data.dart';
import '../../components/a_cached_network_image/index.dart';

class AElandCard extends StatefulWidget {
  int uid;
  AElandCard({
    Key key,
    this.uid = 0,
  }) : super(key: key);

  @override
  _ElandCardState createState() => new _ElandCardState();

}

class _ElandCardState extends State<AElandCard> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true; ///see AutomaticKeepAliveClientMixin

  List<dynamic> elandItem = [];
  int eland_page_id = 1;

  ScrollController _elandScrollController = new ScrollController();

  @override
  void initState() {
    _loadElandListData( pageid:eland_page_id );
    Future.delayed(Duration.zero, () {
      _elandScrollController.addListener(() {
        if (_elandScrollController.position.pixels == _elandScrollController.position.maxScrollExtent) {
//          print('拉到底222===>');
//          _loadElandListData( pageid: ++eland_page_id );
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _elandScrollController.dispose();
  }

  _loadElandListData({int pageid=1, int limit=15}) async {
    try {
      print('dataElandCard==================>');
      var res = await G.req.eland.list(
        userid: widget.uid,
        pageid: pageid,
        limit: limit,
      );
      Map result = res.data;
      Map<String, dynamic> json = {'eland_name': 'last_plus_button123456'};
      result['list'].add(json);
      ElandListModel eland_list = ElandListModel.fromJson(result);

      if (mounted) {
        setState(() {
          elandItem.addAll(eland_list.list);
        });
      }
    }catch(e) {
      print('dataElandCardCatch===>${e}');
    }
  }

  Widget eLandCard() {
    return (elandItem.length == 0) ? new Container() : new Container(
//      color: Colors.white,
        alignment: Alignment.topLeft,
//        margin: const EdgeInsets.only(left: 12.0),
        child: new Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
//              margin: const EdgeInsets.only(left: 6.0),
              padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0,bottom: 0.0,),
              child: new SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _elandScrollController,
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  elandItem.map((item){
                    if(item.eland_name == 'last_plus_button123456'){
                      return InkWell(
                          onTap: () {
    //                        print('eland_info===>${item.eland_id}');
//                            G.pushNamed('/eland_info', arguments: {'id': item.eland_id});
                            G.pushNamed('/eland_list');
                          },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 4.0,
                          height: 135,
                          margin: const EdgeInsets.only(top: 6.0, bottom: 6.0,left:5.0,right: 5.0),
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0,left:10.0,right: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.0),
                              boxShadow: [
                                BoxShadow(
                                    color: rgba(0,0,0,0.3),
                                    offset: Offset(1.0, 1.0), //阴影xy轴偏移量
                                    blurRadius: 1.0, //阴影模糊程度
                                    spreadRadius: 0.5 //阴影扩散程度
                                )
                              ]
                            //                          shape: BoxShape.circle,
                          ),
                          child: icon_pending(
                              size: 50,
                              // color: hex('#333')
                              color: rgba(0, 0, 0, 0.69),
                              // color: rgba(28, 141, 160, 1),
                          ),
//                           child: Image.asset(
//                             'lib/assets/images/Plus.png',
// //                            width: 20,
// //                            height: 20,
// //                            fit: BoxFit.cover,
//                           ),
                        ),
                      );
                    }else{
                      return InkWell(
                        onTap: () {
//                        print('eland_info===>${item.eland_id}');
                          G.pushNamed('/eland_info', arguments: {'id': item.eland_id});
                        },
                        child: Stack(
//                    alignment:Alignment.center , //指定未定位或部分定位widget的对齐方式
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 4.0,
                              height: 135,
                              margin: const EdgeInsets.only(top: 6.0, bottom: 6.0,left:5.0,right: 5.0),
                              decoration: BoxDecoration(

                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: rgba(0,0,0,0.3),
                                        offset: Offset(1.0, 1.0), //阴影xy轴偏移量
                                        blurRadius: 1.0, //阴影模糊程度
                                        spreadRadius: 0.5 //阴影扩散程度
                                    )
                                  ]
                                //                          shape: BoxShape.circle,
                              ),
                              child: Column(
                                children: <Widget>[
                                  AspectRatio(
                                    aspectRatio: 4.0 / 3.0,
//                              child: Image.network(
//                                item.eland_pic,
//                                fit: BoxFit.cover,),
                                    child: new Container(
//                                    foregroundDecoration:new BoxDecoration(
//                                      image: new DecorationImage(
//                                        image: new NetworkImage(item.eland_pic),
//                                        centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
//                                      ),
////                                    borderRadius: const BorderRadius.all(const Radius.circular(6.0)),
//                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0),topRight: Radius.circular(6.0)),
//                                    ),
                                      child: AcachedNetworkImage(
                                        item.eland_pic,
                                        fit: BoxFit.cover,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0),topRight: Radius.circular(6.0)),
//                                      width: imageWidth,
//                                      height: imageWidth,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5.0,bottom:10.0,left:4.0,right:4.0),
                                    child: Text(
                                      item.eland_name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            (item.eland_has_news == true)?
                            Positioned(
                              right: 0.0,
                              top: 0.0,
                              child: ClipOval(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: rgba(28, 141, 160, 1),
                                  ),
                                  constraints: BoxConstraints(
                                      minWidth:15,
                                      minHeight:15
                                  ),
                                ),
                              ),
                            ):Text(''),

                          ],
                        ),
                      );
                    }

                  }).toList(),

                ),
              ),
            ),
//            Container(
//              margin: EdgeInsets.only(left: 16,right: 16),
//              child: AButton.normal(
//                  width: MediaQuery.of(context).size.width,
//                  child: Text('更多'),
//                  bgColor: rgba(229, 229, 229, 1.0),
//                  color: hex('#000'),
//                  borderColor: rgba(229, 229, 229, 1.0),
//                  plain: true,
//                  borderRadius: BorderRadius.circular(5),
//                  onPressed: (){
////                    print('點擊更多');
//                    G.pushNamed('/eland_list');
//                  }
//              ),
//            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: new Border(bottom: BorderSide(width: 10.0, color: hex('#cacbd1'))),
                //              color: hex('#cacbd1'),
                //                          shape: BoxShape.circle,
              ),
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
//    print('bbbb===>');
//    return Text('aaaa====>');
    return eLandCard();
  }
}