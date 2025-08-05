//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import '../../components/custom_navbar/index.dart';
import '../../utils/global.dart';

class SettingPage extends StatefulWidget {
  //  static _SettingPageState _settingPageState;
  //
  //  SettingPage() {
  //    _settingPageState = _SettingPageState();
  //  }
  //  getAppBar() => _settingPageState.createAppBar();
  //  _SettingPageState createState() => _SettingPageState();

  SettingPage({Key key}) : super(key: key);

  @override
  createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  //  AppBar createAppBar() {
  //    return customAppbar(title: 'setting');
  //  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppbar(
        context: context,
        title: 'Setting',
        textcenter: false,
        default_actions: true,
      ),
      //      body: Text('setting'),
      body: Container(color: hex('#fff'), child: Text('setting')),
      bottomNavigationBar: CustomNavbar(
        onTap: (index) {
          G.pushNamed(G.toobarRouteNameList[index]);
          //        context=null;
          //        Navigator.of(context).pushReplacementNamed(G.toobarRouteNameList[index]);
          //        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
          //            return SearchPage();
          //        }),(route) => route == null);
        },
      ),
    );
  }
}
