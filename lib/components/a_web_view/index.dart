import 'dart:async';
//import 'package:color_dart/HexColor.dart';
//import 'package:color_dart/RgbaColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import '../../components/custom_navbar/index.dart';
import '../../utils/global.dart';

class AWebview {
  final BuildContext context;

  /// 图片URL
  final String url;
  final String title;
  AWebview.open(this.context, {required this.url, this.title = ""}) {
    //    print('sss===>${title}');
    String mytitle = '';
    if (title == '') {
      mytitle = url;
    } else {
      mytitle = title;
    }

    Widget webview = new AWebViewPage(url, mytitle);
    final route = new CupertinoPageRoute(
      builder: (BuildContext context) => webview,
      settings: new RouteSettings(
        name: webview.toStringShort(),
        //        isInitialRoute: false,
      ),
    );

    G.getCurrentState().push(route);
  }
}

class AWebViewPage extends StatefulWidget {
  final String url;
  final String title;

  AWebViewPage(this.url, this.title);

  @override
  State<StatefulWidget> createState() => new AWebViewState();
}

class AWebViewState extends State<AWebViewPage> {
  final Completer<WebViewController> _controller =
      new Completer<WebViewController>();

  bool isloading = true;

  JavascriptChannel Function(BuildContext) _toasterJavascriptChannel =
      (BuildContext context) {
        return new JavascriptChannel(
          name: 'Toaster',
          onMessageReceived: (JavascriptMessage message) {
            print('message=====>${message.message}');
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(new SnackBar(content: Text(message.message)));
          },
        );
      };

  Widget body() {
    return new Builder(
      builder: (BuildContext context) {
        print('widget.url======>${widget.url}');
        return Stack(
          children: [
            new WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet(),
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith(
                  'https://github.com/fluttercandies/wechat_flutter',
                )) {
                  print('blocking=====> navigation to $request}');
                  return NavigationDecision.prevent;
                }
                print('allowing=====> navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageFinished: (String url) {
                print('Page=====> finished loading: $url');
                setState(() {
                  isloading = false;
                });
              },
            ),
            (isloading == false)
                ? Container()
                : Positioned(
                    top: G.screenHeight() / 2 - 100,
                    left: G.screenWidth() / 2 - 20,
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppbar(context: context, title: '${widget.title}'),
      body: body(),
    );
  }
}
