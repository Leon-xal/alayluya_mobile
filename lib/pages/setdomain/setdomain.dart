import 'dart:async';

//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/a_button/index.dart';
import '../../utils/global.dart';


class SetDomain extends StatefulWidget {
  SetDomain({Key key}) : super(key: key);

  @override
  _SetDomainState createState() => _SetDomainState();

}


class _SetDomainState extends State<SetDomain> {

//  static Map server_address = {
//    "value": null,
//    "verify": true
//  };

  String domain = '';
  bool isTextInput = false;

  TextEditingController serveraddressController = TextEditingController();

  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async{

      // if(G.isLogin == true) G.pop();

      prefs = await SharedPreferences.getInstance();
      setState(() {
        domain = prefs.getString('domain');
        if(domain == null || domain == ''){
          domain = '';
        }
        if(isTextInput == true){
          serveraddressController.text = domain;
        }
      });

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 登录
  _submit() async{

    FocusScope.of(context).requestFocus(FocusNode());

    if((serveraddressController.text == null || serveraddressController.text.trim() == '') && isTextInput == true) {
      return G.toast('Please enter the Server address');
    }
    if((domain == null || domain == '') && isTextInput == false) {
      return G.toast('Please select the Server address');
    }

    try {
      String doMainStr = '';
      if(isTextInput == true){
        doMainStr = serveraddressController.text.trim();
      }else{
        doMainStr = domain;
      }

      print('doMainStr2=====>${doMainStr}');
      G.setDomain(doMainStr,onCallback:(result){
        if(result == true){
          if(G.isLogin == true) {
            setState(() {
              G.isDev = true;
              G.baseurl = doMainStr;
              print('G.baseurl2======>${G.baseurl}');
              print('G.isDev2======>${G.isDev}');
              print('G.isLogin2======>${G.isLogin}');

              G.prdapi = G.baseurl+'/api';
              G.toast('設置成功');
              G.pushNamed('/');
            });
          }else{
            G.pop();
          }
        }else{
          G.toast('The format is wrong');
        }
      });

    } catch(e) {
      print("set domain fail==========>,${e}");
      G.toast('Submission failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hex('#fff'),
      appBar: customAppbar(context: context,title: '設置域名'),
      // body: Text('asd'),
      body: SingleChildScrollView(
        child: Container(
          height: G.screenHeight()-100,
          padding: EdgeInsets.only(left: 30, right: 30, top: 30),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 30),
                        child: Text('Server address', style: TextStyle(
                            color: rgba(28, 141, 160, 1),
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                      Container(
                        child: Column(
                          children: [
//                              Container(
//                                alignment: Alignment.topLeft,
//                                child: Text('Phone Number/Account', style: TextStyle(
//                                  color: hex('#014d7b'),
//                                  fontSize: 15,
//                                )),
//                              ),
//                           Text('${domain}'),
                            (isTextInput == true) ?
                            TextField(
                              controller: serveraddressController,
                              keyboardType: TextInputType.url,
                              cursorColor: hex('#014d7b'),
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: (){
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      isTextInput = false;
                                    });
                                  },
                                  child: Icon(
                                      Icons.cancel,
                                    color: rgba(28, 141, 160, 1),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: hex('#014d7b')),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: hex('#ccc')),
                                ),
                                hintText: "http://",
                                hintStyle: TextStyle(fontSize: 15.0, color: hex('#ccc')),//设置提示文字样式
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                            ) :
                            DropdownButton(
                              isExpanded: true,
                            // underline: Container(height: 10, color: Colors.green.withOpacity(0.7)),
                              isDense:true,
                              value: (domain == '' || domain == null)?'':domain,
                            // itemHeight:10,
                              icon: Icon(Icons.arrow_right), iconSize: 40, iconEnabledColor: rgba(28, 141, 160, 1),
                              hint: Text('請選擇地址'),
                              items: [
                                DropdownMenuItem(child: Text('Select Domain'), value: ''),
                                if(domain != 'http://testapi2.alayluya.com' && domain != 'https://api11.alayluya.info' && domain != '') DropdownMenuItem(child: Text('Cur：${domain}'), value: '${domain}'),
                                DropdownMenuItem(child: Text('http://testapi2.alayluya.com'), value: 'http://testapi2.alayluya.com'),
                                DropdownMenuItem(child: Text('https://testapi2.alayluya.com'), value: 'https://testapi2.alayluya.com'),
                                DropdownMenuItem(child: Text('https://api1.alayluya.info'), value: 'https://api1.alayluya.info'),
                                DropdownMenuItem(child: Text('https://api11.alayluya.info'), value: 'https://api11.alayluya.info'),
                                DropdownMenuItem(child: Text('Other...'), value: 'other'),
                              ], onChanged: (value) {
                                print('value=====>${value}');
                                if(value == 'other'){
                                  setState(() {
                                    isTextInput = true;
                                    serveraddressController.text = domain;
                                  });
                                }else {
                                  setState(() {
                                    domain = value;
                                  });
                                }
                              }
                            ),

                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        child: AButton.normal(
                            width: G.screenWidth(),
                            child: Text('SUBMIT'),
//                            rgba(169, 211, 218, 1)
                            bgColor: rgba(28, 141, 160, 1),
                            color: hex('#fff'),
                            borderColor: rgba(28, 141, 160, 1),
                            plain: true,
                            borderRadius: BorderRadius.circular(5),
                            onPressed: () => _submit()
                        ),
                      ),
                    ],
                  ),
                ),
              ],),
          ),

        ),
      ),

    );
  }

}