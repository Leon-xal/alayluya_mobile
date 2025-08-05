import 'package:flutter/material.dart';
import '../../components/custom_navbar/index.dart';
import '../../components/a_eland_prayers_list/index.dart';
import '../../model/user_model/data.dart';
import '../../utils/global.dart';

class ElandPrayersListPage extends StatefulWidget {
  final Map args;
  ElandPrayersListPage({Key key, this.args}) : super(key: key);
  @override
  createState() => _ElandPrayersListPageState();
}

class _ElandPrayersListPageState extends State<ElandPrayersListPage> {
  static Map args;
  int userid = 0;
  int _eland_id = 0;
  @override
  void initState() {
    super.initState();
    UserDataModel userData = G.user.data;
    userid = userData.id;
    args = widget.args;
    _eland_id = args['eland_id'];
    //      print('_eland_id===>${_eland_id}');
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
      appBar: customAppbar(context: context, title: '祈祷'),

      body: (userid > 0)
          ? AElandPrayersList(
              user_id: userid,
              eland_id: _eland_id,
              isreload: true,
              isShowCenterload: true,
              isShowTag: false,
              isShowElandName: false,
              isShowLikeBtn: false,
              isShowDesc: true,
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
