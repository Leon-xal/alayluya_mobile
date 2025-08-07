/*
 * @Author: meetqy
 * @since: 2019-09-02 10:52:36
 * @lastTime: 2019-11-18 17:29:02
 * @LastEditors: meetqy
 */
import 'package:flutter/material.dart';

import './custom_button.dart';

// Helper function to convert String to ButtonType
ButtonType _stringToButtonType(String typeString) {
  switch (typeString.toLowerCase()) {
    case 'warning':
      return ButtonType.warning;
    case 'danger':
      return ButtonType.danger;
    case 'info':
      return ButtonType.info;
    case 'primary':
      return ButtonType.primary;
    case 'defaultType': // Handle potential case mismatch
    case 'default':
      return ButtonType.defaultType;
    default:
      return ButtonType.defaultType; // Default to defaultType if invalid
  }
}

/// 暴露button 相当于工厂函数
class AButton {
  /// 按钮
  ///
  /// ```
  /// @param {double} width 宽度
  /// @param {double} height  高度
  /// @param {String} type  按钮类型：default，primary，info，danger，warning
  /// @param {Color} color  文字颜色
  /// @param {Color} bgColor  背景颜色
  /// @param {Color} borderColor  边框颜色
  /// @param {bool} plain 是否使用边框样式
  /// @param {VoidCallback} onPressed 点击回调 如果没有该参数表示不可点击状态
  /// @param {Widget} child 按钮内容
  /// @param {EdgeInsetsGeometry} padding 内边距
  /// @param {BorderRadius} borderRadius  圆角
  /// ```
  static Widget normal({
    double width = 0,
    double height = 44,
    String typeString = 'defaultType',
    Color? color,
    Color? bgColor,
    Color? borderColor,
    bool plain = false,
    VoidCallback? onPressed,
    Widget child = const SizedBox.shrink(), // <-- Default empty widget
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    final buttonType = _stringToButtonType(typeString); // Convert to ButtonType
    return CustomButton.normal(
      width: width,
      height: height,
      type: buttonType,
      color: color,
      bgColor: bgColor,
      borderColor: borderColor,
      plain: plain,
      onPressed: onPressed,
      child: child,
      padding: padding,
      borderRadius: borderRadius,
    );
  }

  /// 按钮
  ///
  /// ```
  /// @param {double} width 宽度
  /// @param {double} height  高度
  /// @param {String} type  按钮类型：default，primary，info，danger，warning
  /// @param {Color} color  文字颜色
  /// @param {Color} bgColor  背景颜色
  /// @param {Color} borderColor  边框颜色
  /// @param {bool} plain 是否使用边框样式
  /// @param {VoidCallback} onPressed 点击回调 如果没有该参数表示不可点击状态
  /// @param {Widget} textChild 按钮内容
  /// @param {Widget} icon icon
  /// @param {EdgeInsetsGeometry} padding 内边距
  /// @param {BorderRadius} borderRadius  圆角
  /// ```
  static Widget icon({
    double width = 0,
    double height = 44,
    String typeString = 'defaultType',
    Color? color,
    Color? bgColor,
    Color? borderColor,
    bool plain = false,
    VoidCallback? onPressed,
    Widget textChild = const SizedBox.shrink(), // <-- Default empty widget
    //Widget textChild,
    Widget icon = const SizedBox.shrink(), // Provide a default empty widget
    //Widget? icon,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    final buttonType = _stringToButtonType(typeString); // Convert to ButtonType
    return CustomButton.icon(
      width: width,
      height: height,
      type: buttonType,
      color: color,
      bgColor: bgColor,
      borderColor: borderColor,
      plain: plain,
      onPressed: onPressed,
      textChild: textChild,
      icon: icon,
      padding: padding,
      borderRadius: borderRadius,
    );
  }

  /// loading 按钮
  ///
  /// ```
  /// @param {double} width 宽度
  /// @param {double} height  高度
  /// @param {String} type  按钮类型：default，primary，info，danger，warning
  /// @param {Color} color  加载动画颜色颜色
  /// @param {Color} bgColor  背景颜色
  /// @param {Color} borderColor  边框颜色
  /// @param {bool} plain 是否使用边框样式
  /// @param {VoidCallback} onPressed 点击回调 如果没有该参数表示不可点击状态
  /// @param {Widget} loadingChild 按钮内容
  /// @param {EdgeInsetsGeometry} padding 内边距
  /// @param {BorderRadius} borderRadius  圆角
  /// ```
  static Widget loading({
    double width = 0,
    double height = 44,
    String typeString = 'defaultType',
    Color? color,
    Color? bgColor,
    Color? borderColor,
    bool plain = false,
    VoidCallback? onPressed,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    //Widget loadingChild,
    Widget loadingChild =
        const SizedBox.shrink(), // Provide a default empty widget
  }) {
    final buttonType = _stringToButtonType(typeString); // Convert to ButtonType
    return CustomButton.loading(
      width: width,
      height: height,
      type: buttonType,
      color: color,
      bgColor: bgColor,
      borderColor: borderColor,
      plain: plain,
      onPressed: onPressed,
      padding: padding,
      borderRadius: borderRadius,
      textChild: loadingChild,
    );
  }
}
