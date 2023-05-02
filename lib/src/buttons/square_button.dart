import 'package:flutter/material.dart';

class WeebiNumPadButton extends StatelessWidget {
  final void Function() onPressed;
  final String string;
  final String tooltip;
  final MaterialStateProperty<Color> backColor;
  final Color fontColor;
  const WeebiNumPadButton(
      {@required this.onPressed,
      @required this.string,
      @required this.tooltip,
      this.backColor,
      this.fontColor = Colors.black,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 55,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Tooltip(
        message: tooltip,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                backColor ?? MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: onPressed,
          child: Text(string,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: fontColor,
              )),
        ),
      ),
    );
  }
}
