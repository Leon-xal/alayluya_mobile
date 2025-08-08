//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';

class ARow extends StatelessWidget {
  final double height;
  final Widget leftChild;
  final Widget centerChild;
  final Widget rightChild;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final Border border;
  final Color color;
  final VoidCallback? onPressed;

  /// ARow 行
  ///
  /// ```
  /// @param {double} height 高度
  /// @param {Widget} leftChild 左侧内容
  /// @param {Widget} centerChild 中间内容
  /// @param {Widget} rightChild 右侧内容
  /// @param {EdgeInsets} padding 内边距
  /// @param {EdgeInsets} margin 外边距
  /// @param {Border} border
  /// @param {Color} color
  /// @param {Function} onPressed 点击回调
  /// ```

  const ARow({
    Key? key,
    required this.height,
    required this.leftChild,
    required this.centerChild,
    required this.rightChild,
    this.padding = const EdgeInsets.all(0),
    this.margin,
    this.border = const Border(
      bottom: BorderSide(width: 1, color: Color(0xFFF2F2F2)),
    ),
    this.color = const Color(0xFFFFFFFF),
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: onPressed == null ? Colors.transparent : null,
      splashColor: onPressed == null ? Colors.transparent : null,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color == null ? Color(0xffffffff) : color,
          border: border == null
              ? Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Color.fromARGB(255, 242, 242, 242),
                  ),
                )
              : border,
        ),
        padding: padding == null
            ? EdgeInsets.symmetric(horizontal: 15)
            : padding,
        margin: margin == null ? EdgeInsets.all(0) : margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // left
            leftChild == null ? Container() : leftChild,

            // center
            Expanded(child: centerChild == null ? Container() : centerChild),

            // right
            rightChild == null ? Container() : rightChild,
          ],
        ),
      ),
      onTap: () => onPressed == null ? () {} : onPressed!(),
    );
  }
}
