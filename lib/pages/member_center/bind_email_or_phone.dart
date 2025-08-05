import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../login/components/region_code.dart';
import '../../components/a_button/index.dart';
//import 'package:color_dart/HexColor.dart';
//import 'package:color_dart/RgbaColor.dart';
import '../../utils/global.dart';
import '../../components/custom_appbar/index.dart';
import 'package:flutter/material.dart';

class BindEmailOrPhone extends StatefulWidget {
  final Map type;
  const BindEmailOrPhone({Key key, this.type}) : super(key: key);
  @override
  _BindEmailOrPhoneState createState() => _BindEmailOrPhoneState();
}

class _BindEmailOrPhoneState extends State<BindEmailOrPhone> {

  Map email = {
    'value':null,
    'verify':true,
  };
  Map phone = {
    'value':null,
    'verify':true,
  };
  Map phoneCode = {
    'value':null,
    'verify':true,
  };


  var code = regionCode[0]['code'];
  bool canClick = true;
  Timer timer;
  int index;
  int countDown = 60;

  void getCode(){
    if(!canClick) return;
    setState(() {
      canClick = false;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(countDown>0){
        setState(() {
          countDown -- ;
        });
      }else{
        timer?.cancel();
        setState(() {
          countDown = 60;
          canClick = true;
        });
      }
    });
  }

  Future clickAreaCode(BuildContext context){
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: 380,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                )
            ),
            child: Column(
                children: [
                  Expanded(
                    child: Container(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        onSelectedItemChanged: (value){
                          setState(() {
                            index = value;
                          });
                        },
                        children: regionCode.map((areaCode){
                          return Container(
                            alignment: Alignment.center,
                            child: Text('${areaCode['zh']} +' + '${areaCode['code']}'),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        code = regionCode[index]['code'];
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border(top: BorderSide(width: 1,color: Colors.grey))
                      ),
                      child: Text('確認',style: TextStyle(fontSize: 20,color: rgba(28, 141, 160, 0.7))),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>Navigator.pop(context),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border(top: BorderSide(width: 1,color: Colors.grey))
                      ),
                      child: Text('取消',style: TextStyle(fontSize: 20,color: Colors.black)),
                    ),
                  )
                ]
            ),
          );
        }
    );
  }

  Widget input(Map registerInfoKey, String hitText, {bool obscureText = false,bool hasBorder = true}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(border:hasBorder ? G.borderBottom() : null),
      child: TextField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            counterText: "",
            border: InputBorder.none,
            hintText: '$hitText',
            hintStyle: TextStyle(
              fontSize: 14,
            )),
        obscureText: obscureText,
        onChanged: (e) {
          setState(() {
            registerInfoKey['value'] = e;
            registerInfoKey['verify'] = (e == null || e == '') ? false : true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context,title: '綁定${widget.type['type']}',textcenter: true),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: G.screenHeight()-100,
          color: hex('#fff'),
          padding: EdgeInsets.only(left: 35, right: 35, top: 35),
          child:widget.type['type'] == '郵箱'
          ? Column(
            children: [
              input(email, '郵箱地址'),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: AButton.normal(
                    width: 250,
                    child: Text('綁定'),
                    bgColor: rgba(28, 141, 160, 1),
                    color: hex('#fff'),
                    borderColor: rgba(28, 141, 160, 1),
                    plain: true,
                    borderRadius: BorderRadius.circular(40),
                    onPressed: (){

                    }
                ),
              ),
            ],
          )
          : Column(
            children: [
              Container(
                  height: 48,
                  decoration: BoxDecoration(border: G.borderBottom()),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: ()=>clickAreaCode(context),
                        child: Container(
                            width: 80,
                            decoration: BoxDecoration(color: rgba(28, 141, 160, 1),),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10,bottom: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$code',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.keyboard_arrow_down,color: Colors.white,size: 16,)
                              ],
                            )
                        ),
                      ),
                      Container(width: 10),
                      Expanded(
                        child:  input(phone, '手機號碼',hasBorder: false),
                      ),
                    ],
                  )),
              SizedBox(height: 20),
              Container(
                  height: 48,
                  decoration: BoxDecoration(border: G.borderBottom()),
                  child: Row(
                    children: [
                      Expanded(
                        child: input(phoneCode, '驗證碼',hasBorder: false),
                      ),
                      GestureDetector(
                        onTap: ()=>getCode(),
                        child: Container(
                          width: 120,
                          alignment: Alignment.center,
                          height: double.infinity,
                          color: canClick ? rgba(28, 141, 160, 1) : Colors.grey,
                          margin: EdgeInsets.only(top: 10,bottom: 0),
                          child: Text(
                            canClick ? '發送' : '${countDown}s',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: AButton.normal(
                    width: 250,
                    child: Text('綁定'),
                    bgColor: rgba(28, 141, 160, 1),
                    color: hex('#fff'),
                    borderColor: rgba(28, 141, 160, 1),
                    plain: true,
                    borderRadius: BorderRadius.circular(40),
                    onPressed: (){

                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }
}
