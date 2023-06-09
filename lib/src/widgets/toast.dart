import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

mixin ToastWeebi {
  toastSuccessArticle(context,
          {String message = '',
          StyledToastPosition position = StyledToastPosition.bottom}) =>
      kIsWeb == false && Platform.environment.containsKey('FLUTTER_TEST')
          ? {}
          : showToastWidget(IconToastWidget.successProduct(msg: message),
              context: context,
              animation: StyledToastAnimation.size,
              reverseAnimation: StyledToastAnimation.sizeFade,
              position: position,
              duration: Duration(seconds: 4),
              animDuration: Duration(seconds: 1),
              curve: Curves.decelerate,
              reverseCurve: Curves.decelerate);
  toastFailProduct(context,
          {String message = '',
          StyledToastPosition position = StyledToastPosition.bottom}) =>
      kIsWeb == false && Platform.environment.containsKey('FLUTTER_TEST')
          ? {}
          : showToastWidget(IconToastWidget.failProduct(msg: message),
              context: context,
              animation: StyledToastAnimation.size,
              reverseAnimation: StyledToastAnimation.sizeFade,
              duration: Duration(seconds: 4),
              animDuration: Duration(seconds: 1),
              curve: Curves.decelerate,
              position: position,
              reverseCurve: Curves.linear);
  toastSuccessContact(context,
          {String message = '',
          StyledToastPosition position = StyledToastPosition.bottom}) =>
      kIsWeb == false && Platform.environment.containsKey('FLUTTER_TEST')
          ? {}
          : showToastWidget(IconToastWidget.successContact(msg: message),
              context: context,
              animation: StyledToastAnimation.size,
              reverseAnimation: StyledToastAnimation.sizeFade,
              duration: Duration(seconds: 4),
              animDuration: Duration(seconds: 1),
              curve: Curves.decelerate,
              position: position,
              reverseCurve: Curves.linear);
  toastFailContact(context,
          {String message = '',
          StyledToastPosition position = StyledToastPosition.bottom}) =>
      kIsWeb == false && Platform.environment.containsKey('FLUTTER_TEST')
          ? {}
          : showToastWidget(IconToastWidget.successContact(msg: message),
              context: context,
              animation: StyledToastAnimation.size,
              reverseAnimation: StyledToastAnimation.sizeFade,
              duration: Duration(seconds: 4),
              animDuration: Duration(seconds: 1),
              curve: Curves.decelerate,
              position: position,
              reverseCurve: Curves.linear);

  toastWarningUser(context, {String message = ''}) => kIsWeb == false &&
          Platform.environment.containsKey('FLUTTER_TEST')
      ? {}
      : showToastWidget(
          IconToastWidget.failContact(
              msg: 'Attention ' +
                  message +
                  '\nEn cas de besoin n\'hésitez pas à contacter l\'assistance'),
          context: context,
          position: StyledToastPosition.center,
          animation: StyledToastAnimation.size,
          reverseAnimation: StyledToastAnimation.sizeFade,
          duration: Duration(seconds: 10),
          animDuration: Duration(seconds: 1),
          curve: Curves.decelerate,
          reverseCurve: Curves.linear);
}

class IconToastWidget extends StatelessWidget {
  final Key? key;
  final Color? backgroundColor;
  final String message;
  final Widget? textWidget;
  final double? height;
  final double? width;
  final String assetName;
  final EdgeInsetsGeometry? padding;
  final Icon icon;

  IconToastWidget({
    this.key,
    this.backgroundColor,
    this.textWidget,
    this.message = '',
    this.height,
    this.width,
    required this.icon,
    required this.assetName,
    this.padding,
  }) : super(key: key);

  factory IconToastWidget.successProduct({String msg = ''}) => IconToastWidget(
      message: msg,
      assetName: 'assets/icons/product_detail.png',
      icon: const Icon(Icons.done, color: Colors.green));

  factory IconToastWidget.failProduct({String msg = ''}) => IconToastWidget(
      message: msg,
      assetName: 'assets/icons/product_detail.png',
      icon: const Icon(Icons.error, color: Colors.red));

  factory IconToastWidget.successContact({String msg = ''}) => IconToastWidget(
      message: msg,
      assetName: 'assets/icons/contact_detail.png',
      icon: const Icon(Icons.done, color: Colors.green));
  factory IconToastWidget.failContact({String msg = ''}) => IconToastWidget(
      message: msg,
      assetName: 'assets/icons/contact_detail.png',
      icon: const Icon(Icons.error, color: Colors.red));

  @override
  Widget build(BuildContext context) {
    Widget content = Material(
      color: Colors.transparent,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50.0),
          padding:
              padding ?? EdgeInsets.symmetric(vertical: 20.0, horizontal: 17.0),
          decoration: ShapeDecoration(
            color: backgroundColor ?? const Color(0x9F000000),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.asset(
                  assetName,
                  fit: BoxFit.fill,
                  width: 30,
                  height: 30,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: textWidget ??
                    Text(
                      message,
                      style: const TextStyle(
                          //fontSize: Theme.of(context).textTheme.title.fontSize,
                          color: Colors.white),
                      softWrap: true,
                      maxLines: 200,
                    ),
              ),
            ],
          )),
    );

    return content;
  }
}

///
///created time: 2019-06-17 16:22
///author linzhiliang
///version 1.5.0
///since
///file name: styled_toast.dart
///description: Banner type toast widget, example of custom toast content widget when you use [showToastWidget]
///
class BannerToastWidget extends StatelessWidget {
  final Key? key;
  final Color? backgroundColor;
  final String message;
  final Widget textWidget;

  final double? height;
  final double? width;

  BannerToastWidget(
      {this.key,
      this.backgroundColor,
      required this.textWidget,
      this.message = '',
      this.height,
      this.width})
      : super(key: key);

  factory BannerToastWidget.success(
          {String msg = '',
          required Widget text,
          required BuildContext context}) =>
      BannerToastWidget(
        backgroundColor: Theme.of(context).toggleableActiveColor,
        message: msg,
        textWidget: text,
      );

  factory BannerToastWidget.fail(
          {String msg = '',
          required Widget text,
          required BuildContext context}) =>
      BannerToastWidget(
        backgroundColor: Theme.of(context).colorScheme.error,
        message: msg,
        textWidget: text,
      );

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(17.0),
        height: 60.0,
        alignment: Alignment.center,
        color: backgroundColor ?? Theme.of(context).colorScheme.background,
        child: textWidget);

    return content;
  }
}

///Toast with action widget
class ActionToastWidget extends StatelessWidget {
  ///Text
  final String text;

  ///Text widget
  final Widget textWidget;

  ///Action widget
  final Widget actionWidget;

  ActionToastWidget({
    required this.text,
    required this.textWidget,
    required this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      margin: EdgeInsets.symmetric(horizontal: 50.0),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Colors.green[600],
          shadows: [
            const BoxShadow(
              offset: Offset.zero,
              spreadRadius: 10,
              blurRadius: 10,
              color: const Color(0x040D0229),
            ),
          ]),
      child: Row(
        children: [textWidget, actionWidget],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
