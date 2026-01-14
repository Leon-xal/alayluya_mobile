import 'dart:async';

import './region_code.dart';
//import 'package:color_dart/RgbaColor.dart';
import 'package:flutter/cupertino.dart';
import '../../../utils/global.dart';
import 'package:flutter/material.dart';

class PhoneForgot extends StatefulWidget {
  final Map? phone;
  final Map? phoneCode;
  final Map? phonePassword;
  final Function? callback;
  final int? code;
  final Function? returnSid;

  const PhoneForgot({
    Key? key,
    this.phone,
    this.phoneCode,
    this.phonePassword,
    this.callback,
    this.code,
    this.returnSid,
  }) : super(key: key);

  @override
  _PhoneForgotState createState() => _PhoneForgotState();
}

class _PhoneForgotState extends State<PhoneForgot> {
  var code = regionCode[0]['code'];
  bool canClick = true;
  Timer? timer;
  int? seconds;
  int countDown = 60;

  void getCode() async {
    if (widget.code == '') {
      await G.toast('請選擇號碼所在地');
      return;
    }
    if (widget.phone?['value'] == null || widget.phone?['value'] == '') {
      await G.toast('請輸入手機號碼');
      return;
    }
    if (widget.phone?['value'].length < 6) {
      await G.toast('手機號碼不正確');
      return;
    }

    final reg = RegExp(r'^-?[0-9]+');
    if (reg.hasMatch(widget.phone?['value']) == false) {
      await G.toast('手機號碼不正確');
      return;
    }
    if (!canClick) return;
    setState(() {
      canClick = false;
    });
    //ajax
    print('widget.code=====>${widget.code}');
    print('widget.phone1=====>${widget.phone}');
    print('widget.phone2=====>${widget.phone?['value']}');
    var res = await G.req.user.forgotmobileverify(
      phone: '+${widget.code}${widget.phone?['value']}',
    );
    var data = res.data;
    // if(data == null) return;
    // print('res====>${res.data}');
    if (data == null) {
      // print('res1====>${res}');
      setState(() {
        canClick = true;
      });
      return;
    } else {
      print('res2====>${data['data']['sid']}');
      widget.returnSid!(data['data']['sid']);

      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (countDown > 0) {
          setState(() {
            countDown--;
          });
        } else {
          timer.cancel();
          setState(() {
            countDown = 60;
            canClick = true;
          });
        }
      });
    }
  }

  Future clickAreaCode(BuildContext context) {
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
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        code = regionCode[value]['code'];
                      });
                    },
                    children: regionCode.map((areaCode) {
                      return Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${areaCode['zh']} +' + '${areaCode['code']}',
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.callback!(code);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1, color: Colors.grey),
                    ),
                  ),
                  child: Text(
                    '確認',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(179, 28, 141, 160),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1, color: Colors.grey),
                    ),
                  ),
                  child: Text(
                    '取消',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget input(
    Map registerInfoKey,
    String hitText, {
    bool obscureText = false,
    bool hasBorder = true,
  }) {
    return Container(
      height: 48,
      margin: EdgeInsets.only(top: 0),
      decoration: BoxDecoration(border: hasBorder ? G.borderBottom() : null),
      child: TextField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          counterText: "",
          border: InputBorder.none,
          hintText: '$hitText',
          hintStyle: TextStyle(fontSize: 14),
        ),
        obscureText: obscureText,
        onChanged: (e) {
          setState(() {
            registerInfoKey['value'] = e;
            registerInfoKey['verify'] = (e == '') ? false : true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(border: G.borderBottom()),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => clickAreaCode(context),
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 204, 204, 204),
                    ),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.code}',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(width: 10),
                Expanded(child: input(widget.phone!, '手機號碼', hasBorder: false)),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 48,
            decoration: BoxDecoration(border: G.borderBottom()),
            child: Row(
              children: [
                Expanded(
                  child: input(widget.phoneCode!, '驗證碼', hasBorder: false),
                ),
                GestureDetector(
                  onTap: () => getCode(),
                  child: Container(
                    width: 120,
                    alignment: Alignment.center,
                    height: double.infinity,
                    color: canClick
                        ? Color.fromARGB(179, 28, 141, 160)
                        : Colors.grey,
                    margin: EdgeInsets.only(top: 10, bottom: 0),
                    child: Text(
                      canClick ? '發送' : '${countDown}s',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          input(widget.phonePassword!, '新密碼', obscureText: true),
        ],
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
