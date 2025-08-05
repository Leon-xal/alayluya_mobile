import 'package:cached_network_image/cached_network_image.dart';
//import 'package:color_dart/RgbaColor.dart';
import 'package:flutter/material.dart';

enum ImageType { network, assets, localFile }

class AcachedNetworkImage extends StatelessWidget {
  /// 图片URL
  final String path;

  /// 宽
  final double width;

  /// 高
  final double height;

  /// 填充效果
  final BoxFit fit;

  /// 圆角
  final BorderRadius borderRadius;

  AcachedNetworkImage(
    this.path, {
    Key key,
    this.width,
    this.height,
    this.fit = BoxFit.fill,
    this.borderRadius = const BorderRadius.all(Radius.circular(0.0)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        //          color: rgba(28, 141, 160, 1),
        imageUrl: path,
        height: height,
        width: width,
        fit: fit,
      ),
    );
  }
}
