import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/cupertino.dart';
//import '../../utils/global.dart'; // Assuming this is your global utils file

class AWebview {
  final BuildContext context;
  final String url;
  final String title;

  AWebview.open(this.context, {required this.url, this.title = ""}) {
    String mytitle = title.isEmpty ? url : title;
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => AWebViewPage(url, mytitle)),
    );
  }
}

class AWebViewPage extends StatefulWidget {
  final String url;
  final String title;

  AWebViewPage(this.url, this.title);

  @override
  State<AWebViewPage> createState() => AWebViewState();
}

class AWebViewState extends State<AWebViewPage> {
  final Completer<InAppWebViewController> _controller =
      Completer<InAppWebViewController>(); // Changed to InAppWebViewController
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            onWebViewCreated: (InAppWebViewController controller) {
              _controller.complete(controller);
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                isLoading = progress < 100;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false;
              });
            },
            /*onLoadError: (controller, url, code, message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error loading page: $message')),
              );
              setState(() => isLoading = false);
            },*/
            onReceivedError: (controller, request, error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error loading page: ${error.description}'),
                ),
              );
              setState(() => isLoading = false);
            },
            // JavaScript handling (replace with your actual JavaScript interaction)
            onConsoleMessage: (controller, consoleMessage) {
              print("consoleMessage: ${consoleMessage.message}");
              // Handle console messages from the webpage here
            },
          ),
          if (isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
