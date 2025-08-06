import 'package:flutter/material.dart';

enum ButtonType { warning, danger, info, primary, defaultType }

class CustomButton extends StatelessWidget {
  final ButtonType type;
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final double? width;
  final double? height;
  final bool plain;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Widget child;

  static final Map<ButtonType, Map<String, Color>> _buttonTypeConfig = {
    ButtonType.warning: {
      'color': const Color(0xFFFFFFFF),
      'bgColor': const Color(0xFFff976a),
      'borderColor': const Color(0xFFff976a),
    },
    ButtonType.danger: {
      'color': const Color(0xFFFFFFFF),
      'bgColor': const Color(0xFFf44),
      'borderColor': const Color(0xFFf44),
    },
    ButtonType.info: {
      'color': const Color(0xFFFFFFFF),
      'bgColor': const Color(0xFF1989fa),
      'borderColor': const Color(0xFF1989fa),
    },
    ButtonType.primary: {
      'color': const Color(0xFFFFFFFF),
      'bgColor': const Color(0xFF07c160),
      'borderColor': const Color(0xFF07c160),
    },
    ButtonType.defaultType: {
      'color': const Color(0xFF323233),
      'bgColor': const Color(0xFFFFFFFF),
      'borderColor': const Color(0xFFebedf0),
    },
  };

  CustomButton._internal({
    Key? key,
    required this.type,
    required this.color,
    required this.bgColor,
    required this.borderColor,
    this.width,
    this.height,
    this.plain = false,
    this.onPressed,
    this.padding,
    this.borderRadius,
    required this.child,
  }) : super(key: key);

  factory CustomButton.normal({
    Key? key,
    ButtonType type = ButtonType.defaultType,
    Color? color,
    Color? bgColor,
    Color? borderColor,
    double? width,
    double? height,
    bool plain = false,
    VoidCallback? onPressed,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    required Widget child,
  }) {
    final buttonConfig = _buttonTypeConfig[type]!;
    return CustomButton._internal(
      key: key,
      type: type,
      color: color ?? buttonConfig['color']!,
      bgColor: bgColor ?? buttonConfig['bgColor']!,
      borderColor: borderColor ?? buttonConfig['borderColor']!,
      width: width,
      height: height,
      plain: plain,
      onPressed: onPressed,
      padding: padding,
      borderRadius: borderRadius,
      child: child,
    );
  }

  factory CustomButton.icon({
    Key? key,
    ButtonType type = ButtonType.defaultType,
    Color? color,
    Color? bgColor,
    Color? borderColor,
    double? width,
    double? height,
    bool plain = false,
    VoidCallback? onPressed,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    required Widget textChild,
    required Widget icon,
  }) {
    final buttonConfig = _buttonTypeConfig[type]!;
    return CustomButton._internal(
      key: key,
      type: type,
      color: color ?? buttonConfig['color']!,
      bgColor: bgColor ?? buttonConfig['bgColor']!,
      borderColor: borderColor ?? buttonConfig['borderColor']!,
      width: width,
      height: height,
      plain: plain,
      onPressed: onPressed,
      padding: padding,
      borderRadius: borderRadius,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[icon, SizedBox(width: 5), textChild],
      ),
    );
  }

  factory CustomButton.loading({
    Key? key,
    ButtonType type = ButtonType.defaultType,
    Color? color,
    Color? bgColor,
    Color? borderColor,
    double? width,
    double? height,
    bool plain = false,
    VoidCallback? onPressed,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    required Widget textChild,
  }) {
    final buttonConfig = _buttonTypeConfig[type]!;
    return CustomButton._internal(
      key: key,
      type: type,
      color: color ?? buttonConfig['color']!,
      bgColor: bgColor ?? buttonConfig['bgColor']!,
      borderColor: borderColor ?? buttonConfig['borderColor']!,
      width: width,
      height: height,
      plain: plain,
      onPressed: onPressed,
      padding: padding,
      borderRadius: borderRadius,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Transform.scale(
            scale: 0.7,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(
                color ?? buttonConfig['color']!,
              ),
            ),
          ),
          SizedBox(width: 5),
          textChild,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: padding ?? EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(4),
            side: BorderSide(
              width: 1,
              color: plain ? borderColor : Colors.transparent,
            ),
          ),
          backgroundColor: bgColor,
          foregroundColor: color,
        ),
        onPressed: onPressed ?? () {},
        child: child,
      ),
    );
  }
}
