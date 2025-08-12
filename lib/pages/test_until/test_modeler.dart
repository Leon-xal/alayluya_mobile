// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
// import 'package:social_share_plugin/social_share_plugin.dart';
import '../../utils/global.dart';

class TestModeler extends StatefulWidget {
  final Map? args;
  TestModeler({Key? key, this.args}) : super(key: key);
  @override
  createState() => _TestModelerState();
}

class _TestModelerState extends State<TestModeler> {
  //static Map? args;
  // InAppWebViewController webView;
  bool isloading = true;

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
      backgroundColor: Color(0xffcccccc),
      appBar: customAppbar(
        context: context,
        title: 'TestModeler',
        default_actions: true,
        onGoBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: <Widget>[
          // Text(article.content_app_link.toString()),
          Container(
            margin: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              top: 10.0,
              bottom: 10.0,
            ),
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            color: Color(0xffffffff),
            width: G.screenWidth(),
            height: G.screenHeight(),

            //             child: InAppWebView(
            //              initialUrl: 'http://v2.sharebim.co/apk/html/index.html',
            //               initialHeaders: {},
            //               initialOptions: InAppWebViewWidgetOptions(
            //                 crossPlatform: InAppWebViewOptions(
            //                   debuggingEnabled: false,
            //                   javaScriptEnabled: true,
            // //                  useShouldOverrideUrlLoading: true,
            // //                  useOnLoadResource: true,
            //                   cacheEnabled: true,
            //                   disableVerticalScroll: false,
            //                   disableHorizontalScroll: false,
            //                   verticalScrollBarEnabled: false,
            //                   horizontalScrollBarEnabled:false,
            //                 ),
            //                 ios: IOSInAppWebViewOptions(
            //                   isPagingEnabled: true,
            //                 ),
            //                 android: AndroidInAppWebViewOptions(
            //
            //                 ),
            //               ),
            //
            //               onWebViewCreated: (InAppWebViewController controller) {
            //                 webView = controller;
            //
            //
            //
            //
            //               },
            //               onLoadStop: (InAppWebViewController controller, String url) async {
            //                 print('onLoadStop=====>');
            //                 setState(() {
            //                   isloading = false;
            //                 });
            //               },
            //               onProgressChanged: (InAppWebViewController controller, int progress) {
            // //                print('progress====>${progress/100}');
            //                 if((progress/100)>0.90){
            // //                  print('progress2====>${progress}');
            //                   setState(() {
            //                     isloading = false;
            //                   });
            //                 }
            //               },
            //             ),
          ),
          (isloading == false)
              ? Container()
              : Positioned(
                  top: G.screenHeight() / 2 - 100,
                  left: G.screenWidth() / 2 - 20,
                  //            child: CircularProgressIndicator(
                  //              strokeWidth: 2.0,
                  //              backgroundColor: rgba(28, 141, 160, 1),
                  //            ),
                  child: new Opacity(
                    opacity: 1.0,
                    child: new CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(255, 28, 141, 160),
                      valueColor: new AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
        ],
      ),
      //      bottomNavigationBar: CustomNavbar(onTap:(index) {
      //        G.pushNamed(G.toobarRouteNameList[index]);
      //      }),
    );
  }
}
