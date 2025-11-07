import 'package:cached_network_image/cached_network_image.dart';
//import 'package:color_dart/RgbaColor.dart';
import 'package:flutter/material.dart';

enum ImageType { network, assets, localFile }

class AcachedNetworkImage extends StatelessWidget {
  /// 图片URL
  final String path;

  /// 宽
  // Ian 20251108 - not initialized to zero but allow null of width & height
  final double? width;

  /// 高
  // Ian 20251108 - not initialized to zero but allow null of width & height
  final double? height;

  /// 填充效果
  final BoxFit fit;

  /// 圆角
  final BorderRadius borderRadius;

  AcachedNetworkImage(
    this.path, {
    Key? key,
    // Ian 20251108 - not initialized to zero but allow null of width & height
    this.width,
    this.height,
    this.fit = BoxFit.fill,
    this.borderRadius = const BorderRadius.all(Radius.circular(0.0)),
  });

  @override
  Widget build(BuildContext context) {
    print("AcachedNetworkImage path ${path}, ${height} ${width}");
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        //          color: rgba(28, 141, 160, 1),
        imageUrl: path,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      ),
    );
  }
}
