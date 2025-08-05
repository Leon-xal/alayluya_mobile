import 'dart:async';
import 'dart:io';
//import 'package:color_dart/RgbaColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:flutter_full_pdf_viewer_null_safe/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import '../../utils/global.dart';

class APdfview {
  final BuildContext context;
  /// 图片URL
  final String url;
  APdfview.show(this.context,{
    @required this.url,
  }) {

//    String reurl = "http://192.168.4.45/plugins/icon/awana/assets/images/test.pdf";

    Widget pdfview = new APdfviewScreen(
        url: url,
    );
//    Widget photoview = new PDFScreen(pathPDF);
    final route = new CupertinoPageRoute(
      builder: (BuildContext context) => pdfview,
      settings: new RouteSettings(
        name: pdfview.toStringShort(),
//        isInitialRoute: false,
      ),
    );

    G.getCurrentState().push(route);

  }
}


class APdfviewScreen extends StatefulWidget {
  String url;
  APdfviewScreen({
    Key key,
    this.url='',
  }) : super(key: key);
  @override
  createState() => _APdfviewScreenState();
}

class _APdfviewScreenState extends State<APdfviewScreen> {

  String pathPDF = "";

  @override
  void initState() {
    super.initState();
//    G.loading.show(context);
    createFileOfPdfUrl(widget.url).then((f) {
      setState(() {
        pathPDF = f.path;
        print('pathPDF==================>${pathPDF}');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<File> createFileOfPdfUrl(String url) async {
//    final url = "http://africau.edu/images/default/sample.pdf";
//    final url = "http://192.168.4.45/plugins/icon/awana/assets/images/test.pdf";

    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: 1.0,
          child: new CircularProgressIndicator(
            backgroundColor: rgba(28, 141, 160, 1),
//            value: 0.3,
            valueColor: new AlwaysStoppedAnimation<Color>(rgba(255, 255, 255, 1)),
          ),
//          child: Text('loading'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return (pathPDF == '')? Scaffold(
        appBar: customAppbar(context: context,title: 'Pdf'),
        body: _buildProgressIndicator()
    ): PDFViewerScaffold(
        appBar: customAppbar(context: context,title: 'Pdf'),
        path: pathPDF
    );


    return Scaffold(
        appBar: customAppbar(context: context,title: 'Pdf'),
        body: Text('loading')
    );

  }

}
