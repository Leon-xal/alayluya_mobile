//import 'package:color_dart/RgbaColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
//import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/article_cate_model/data.dart';
import '../../utils/global.dart';

class ASwiper extends StatelessWidget {
  // final List<String> images;
  final List<ArticleCatePic> images;
  final int index;
  final double height;

  /// 轮播图
  /// ```
  /// @param {List<String>} images - 轮播图地址
  /// @param {int} index - 初始下标位置
  /// @param {double} height - 容器高度
  /// ```
  ASwiper(this.images, {this.index = 0, this.height = 288});

  void toDetails(int type, var val) {
    if (type == 1) {
      launchUrl(val);
    } else if (type == 2) {
      G.pushNamed('/article_detail', arguments: {'id': val});
    } else if (type == 5) {
      G.pushNamed('/prayers_detail', arguments: {'id': val});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Swiper(
        index: index,
        itemBuilder: (BuildContext context, int index) {
          // if(G.is_http(images[index])){
          //   return Image.network(
          //     images[index],
          //     fit: BoxFit.cover,);
          // }else{
          //   return Image.asset(images[index], fit: BoxFit.cover);
          // }
          if (G.is_http(images[index].pic!)) {
            return GestureDetector(
              onTap: () {
                toDetails(images[index].type!, images[index].type_val);
              },
              child: Image.network(images[index].pic!, fit: BoxFit.cover),
            );
          } else {
            return GestureDetector(
              onTap: () {
                toDetails(images[index].type!, images[index].type_val);
              },
              child: Image.asset(images[index].pic!, fit: BoxFit.cover),
            );
          }
        },
        itemCount: images.length,
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            size: 8,
            activeSize: 8,
            color: Colors.white,
            activeColor: Color.fromARGB(255, 28, 141, 160),
          ),
        ),
        autoplay: true,
        duration: 500,
        autoplayDelay: 5000,
      ),
    );
  }
}
