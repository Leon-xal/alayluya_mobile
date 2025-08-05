import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';
import '../../utils/global.dart';

class APhotoview {
  final BuildContext context;

  /// 图片URL
  final String url;

  APhotoview.show(this.context, {@required this.url}) {
    Widget photoview = new PhotoView(
      imageProvider: NetworkImage(url),
      onTapUp: (c, f, s) => Navigator.of(context).pop(),
      maxScale: 3.0,
      minScale: 0.0,
    );
    final route = new CupertinoPageRoute(
      builder: (BuildContext context) => photoview,
      settings: new RouteSettings(
        name: photoview.toStringShort(),
        //        isInitialRoute: false,
      ),
    );

    G.getCurrentState().push(route);
  }
}
