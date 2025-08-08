import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

/// 下拉刷新样式
class APullToRefresh {
  /// 顶部样式
  Widget header() {
    // Changed return type to Widget
    return CustomHeader(
      builder: (context, mode) {
        return Container(
          height: 44.0,
          child: Center(child: CupertinoActivityIndicator()),
        );
      },
    );
  }

  /// 底部样式
  Widget footer() {
    // Changed return type to Widget
    return CustomFooter(
      builder: (context, mode) {
        Widget body;
        if (mode == LoadStatus.noMore) {
          body = Text(
            '--- 沒有更多了哦~ ---',
            style: TextStyle(
              color: const Color.fromARGB(255, 28, 141, 160),
            ), //Added const
          );
        } else if (mode == LoadStatus.loading) {
          //Explicitly handle loading state
          body = const CupertinoActivityIndicator(); //Added const
        } else {
          body =
              const SizedBox.shrink(); //Added to handle other LoadStatus cases
        }
        return SizedBox(
          height: 44.0,
          child: Center(child: body),
        ); //Using SizedBox for better layout
      },
    );
  }
}
