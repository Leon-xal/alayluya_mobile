//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import '../../components/a_button/index.dart';
import '../../utils/global.dart';

class ADialog {
  final BuildContext context;
  String title = "";
  String content = "";

  static Widget _title =
      const SizedBox.shrink(); // Provide a default empty widget;
  static Widget _content =
      const SizedBox.shrink(); // Provide a default empty widget;
  static Widget _bottom =
      const SizedBox.shrink(); // Provide a default empty widget;

  /// 提示弹窗
  ///
  /// ```
  /// @param {BuildContext} context
  /// @param {String} title - 标题（标题为null，表示不显示标题）
  /// @param {String} content - 内容
  /// @param {Function} confirmButtonPress - 点击确认回调
  /// @param {Text} confirmButtonText - 确认的文字
  /// ```
  ADialog.alert(
    this.context, {
    this.title = "",
    required this.content,
    Function? confirmButtonPress,
    Text? confirmButtonText,
  }) {
    _title = _initTitle();
    _content = _initContent();
    _bottom = _initBottom(
      confirmButtonPress: confirmButtonPress,
      confirmButtonText: confirmButtonText == null
          ? Text('確認')
          : confirmButtonText,
      confirmBorderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(4),
        bottomRight: Radius.circular(4),
      ),
    );
    _initDialog();
  }

  /// 确认弹窗
  ///
  /// ```
  /// @param {BuildContext} context
  /// @param {String} title - 标题 （标题为null，表示不显示标题）
  /// @param {String} content - 内容
  /// @param {Function} confirmButtonPress - 点击确认回调
  /// @param {Text} confirmButtonText - 确认的文字
  /// @param {Function} cancelButtonPress - 点击取消回调
  /// @param {Text} cancelButtonText - 取消的文字
  /// ```
  ADialog.confirm(
    this.context, {
    this.title = "",
    required this.content,
    Function? confirmButtonPress,
    Text confirmButtonText = const Text('確認'),
    Function? cancelButtonPress,
    Text cancelButtonText = const Text('取消'),
  }) {
    _title = _initTitle();
    _content = _initContent();
    _bottom = _initBottom(
      confirmButtonPress: confirmButtonPress,
      confirmButtonText: confirmButtonText,
      cancelButtonText: cancelButtonText,
      cancelButtonPress: cancelButtonPress,
      cancelBorderRadius: BorderRadius.only(bottomLeft: Radius.circular(4)),
      confirmBorderRadius: BorderRadius.only(bottomRight: Radius.circular(4)),
    );
    _initDialog();
  }

  ADialog.block(
    this.context, {
    //    this.title,
    //    @required this.content,
    required Widget contentChild,
    required Widget bottomChild,
    //    Function confirmButtonPress,
    //    Text confirmButtonText,
  }) {
    _title = Container(
      child: Stack(
        children: <Widget>[
          Align(
            //              child: Icon(Icons.search, size: 40, color: rgba(28, 141, 160, 1)),
            child: InkWell(
              child: icon_close(
                size: 30,
                color: Color.fromARGB(255, 28, 141, 160),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            alignment: Alignment.topRight,
          ),
        ],
      ),
    );
    _content = Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 5.0,
        bottom: 20.0,
      ),
      child: contentChild,
    );
    _bottom = bottomChild;
    //    _bottom = _initBottom(
    //        confirmButtonPress: confirmButtonPress,
    //        confirmButtonText: confirmButtonText == null ? Text('确认') : confirmButtonText,
    //        confirmBorderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4))
    //    );
    _initDialog();
  }

  // 标题部分
  Widget _initTitle() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 12),
      child: Text(
        title,
        style: TextStyle(
          color: Color.fromARGB(255, 56, 56, 56),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 内容部分
  Widget _initContent() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 15),
      child: Text(
        content,
        style: TextStyle(
          color: Color.fromARGB(255, 153, 153, 153),
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // 底部按钮 如果 confirmButtonText || cancelButtonText 为null 代表不显示改按钮
  Widget _initBottom({
    Text confirmButtonText = const Text('确认'),
    Text cancelButtonText = const Text('取消'),
    Function? confirmButtonPress,
    Function? cancelButtonPress,
    BorderRadius? cancelBorderRadius,
    BorderRadius? confirmBorderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color.fromARGB(255, 242, 242, 242)),
        ),
      ),
      child: Row(
        children: <Widget>[
          // 取消按钮
          Container(
            child: cancelButtonText == null
                ? null
                : Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Color.fromARGB(255, 242, 242, 242),
                          ),
                        ),
                      ),
                      child: AButton.normal(
                        child: cancelButtonText,
                        color: Color.fromARGB(255, 56, 56, 56),
                        borderRadius: cancelBorderRadius,
                        onPressed: () {
                          if (cancelButtonPress != null) {
                            cancelButtonPress();
                          }
                        },
                      ),
                    ),
                  ),
          ),
          // 确认按钮
          Container(
            child: confirmButtonText == null
                ? null
                : Expanded(
                    child: AButton.normal(
                      child: confirmButtonText,
                      borderRadius: confirmBorderRadius,
                      color: Color.fromARGB(255, 141, 160, 1),
                      onPressed: () {
                        Navigator.pop(context);
                        if (confirmButtonPress != null) {
                          confirmButtonPress();
                        }
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // 初始化dialog
  _initDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // print("state===>${setDialogState}");
            return Dialog(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[_title, _content, _bottom],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
