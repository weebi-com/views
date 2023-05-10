import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

toastSuccessArticle(context,
        {String message = '',
        StyledToastPosition position = StyledToastPosition.bottom}) =>
    showToastWidget(IconToastWidget.successProduct(msg: message),
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
    showToastWidget(IconToastWidget.failProduct(msg: message),
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
    showToastWidget(IconToastWidget.successContact(msg: message),
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
    showToastWidget(IconToastWidget.failContact(msg: 'erreur ' + message),
        context: context,
        position: position,
        animation: StyledToastAnimation.size,
        reverseAnimation: StyledToastAnimation.sizeFade,
        duration: Duration(seconds: 4),
        animDuration: Duration(seconds: 1),
        curve: Curves.decelerate,
        reverseCurve: Curves.linear);

toastWarningUser(context, {String message = ''}) => showToastWidget(
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

class IconToastWidget extends StatelessWidget {
  final Key key;
  final Color backgroundColor;
  final String message;
  final Widget textWidget;
  final double height;
  final double width;
  final String assetName;
  final EdgeInsetsGeometry padding;
  final Icon icon;

  IconToastWidget({
    this.key,
    this.backgroundColor,
    this.textWidget,
    this.message,
    this.height,
    this.width,
    this.icon,
    @required this.assetName,
    this.padding,
  }) : super(key: key);

  factory IconToastWidget.successProduct({String msg}) => IconToastWidget(
      message: msg,
      assetName: 'assets/icons/product_detail.png',
      icon: const Icon(Icons.done, color: Colors.green));

  factory IconToastWidget.failProduct({String msg}) => IconToastWidget(
      message: msg,
      assetName: 'assets/icons/product_detail.png',
      icon: const Icon(Icons.error, color: Colors.red));

  factory IconToastWidget.successContact({String msg}) => IconToastWidget(
      message: msg,
      assetName: 'assets/icons/contact_detail.png',
      icon: const Icon(Icons.done, color: Colors.green));
  factory IconToastWidget.failContact({String msg}) => IconToastWidget(
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
                      message ?? '',
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
  final Key key;
  final Color backgroundColor;
  final String message;
  final Widget textWidget;
  final double offset;
  final double height;
  final double width;

  BannerToastWidget(
      {this.key,
      this.backgroundColor,
      this.textWidget,
      this.message,
      this.height,
      this.width,
      Offset offset})
      : this.offset = offset == null ? 10.0 : offset,
        super(key: key);

  factory BannerToastWidget.success(
          {String msg, Widget text, BuildContext context}) =>
      BannerToastWidget(
        backgroundColor: context != null
            ? Theme.of(context).toggleableActiveColor
            : Colors.green,
        message: msg,
        textWidget: text,
      );

  factory BannerToastWidget.fail(
          {String msg, Widget text, BuildContext context}) =>
      BannerToastWidget(
        backgroundColor: context != null
            ? Theme.of(context).errorColor
            : const Color(0xEFCC2E2E),
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
      color: backgroundColor ?? Theme.of(context).backgroundColor,
      child: textWidget ??
          Text(
            message ?? '',
            style: TextStyle(
                //fontSize: Theme.of(context).textTheme.title.fontSize,
                color: Colors.white),
          ),
    );

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
    this.text,
    this.textWidget,
    this.actionWidget,
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
        children: [
          textWidget ??
              Text(
                text ?? '',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
          actionWidget ??
              IconButton(
                onPressed: () {
                  ToastManager().dismissAll(showAnim: true);
                  //Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //  return SecondPage();
                  //}));
                },
                icon: Icon(
                  Icons.add_circle_outline_outlined,
                  color: Colors.white,
                ),
              ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
