import 'dart:async';
//import 'package:color_dart/HexColor.dart';
//import 'package:color_dart/RgbaColor.dart';

import 'package:flutter/services.dart';

import '../../utils/global.dart';
import 'package:flutter/material.dart';

// import './into_app.dart';

class NotNetwork extends StatefulWidget {
  NotNetwork({Key? key}) : super(key: key);

  @override
  createState() => _NotNetworkState();
}

class _NotNetworkState extends State<NotNetwork> {
  int clickNumOneOpenDev = 0;
  int clickNumTwoOpenDev = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: customAppbar(context: context,title: 'Alayluya'),
      // appBar: customAppbar(title: 'Alayluya'),
      // appBar: customAppbar(context: context,title:'Alayluya'),

      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   leading: InkWell(
      //     onTap: () {
      //       Navigator.pushNamedAndRemoveUntil(
      //           context, "/", (route) => true);
      //     },
      //     child: Icon(
      //       Icons.close,
      //       color: Colors.black,
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        centerTitle: false,
        title: Container(
          child: Text(
            'Alayluya',
            style: TextStyle(
              color: Color.fromARGB(255, 56, 56, 56),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          padding: EdgeInsets.only(left: 0),
        ),
        backgroundColor: Color(0xffffffff),
        elevation: 0,
        leading: InkWell(
          onTap: () {
            // Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(context, "/", (route) => true);
          },
          child: icon_left(color: Color.fromARGB(255, 0, 0, 0), size: 25),
        ),
        automaticallyImplyLeading: context == null ? false : true,

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(
            decoration: BoxDecoration(border: G.borderBottom(show: true)),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Expanded(child: Container()),
              Container(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (clickNumOneOpenDev >= 10 &&
                            clickNumTwoOpenDev == 0) {
                          G.isDev = false;
                          G.toast('debug mode stop');
                        }
                        if (clickNumOneOpenDev >= 10) {
                          print(
                            "aaa1=====>${clickNumOneOpenDev}/${clickNumTwoOpenDev}",
                          );
                          clickNumTwoOpenDev = 0;
                        } else {
                          clickNumOneOpenDev++;
                          print(
                            "aaa2=====>${clickNumOneOpenDev}/${clickNumTwoOpenDev}",
                          );
                        }
                      },
                      child: icon_wifi_off(
                        size: 100,
                        // color: hex('#333')
                        color: Color.fromARGB(133, 0, 0, 0),
                        // color: rgba(28, 141, 160, 1),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (clickNumOneOpenDev >= 10 &&
                            clickNumTwoOpenDev >= 10) {
                          print(
                            "aaa3=====>${clickNumOneOpenDev}/${clickNumTwoOpenDev}",
                          );
                          G.isDev = true;
                          G.toast('debug mode ready');
                          G.pushNamed('/setdomain');
                        } else {
                          if (clickNumOneOpenDev == 10) {
                            print(
                              "aaa4=====>${clickNumOneOpenDev}/${clickNumTwoOpenDev}",
                            );
                            clickNumTwoOpenDev++;
                          }
                        }
                      },
                      child: Text('網絡不在狀態'),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
