import 'package:flutter/material.dart';

class WeebiButtonRect extends StatelessWidget {
  final void Function() onPressed;
  final String string;
  final String tooltip;
  final MaterialStateProperty<Color>? backColor;
  final Color fontColor;
  const WeebiButtonRect(
      {required this.onPressed,
      required this.string,
      required this.tooltip,
      this.backColor,
      this.fontColor = Colors.black,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: 88,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Tooltip(
          message: tooltip ?? '',
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  backColor ?? MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: onPressed,
            child: Text(string,
                style: TextStyle(color: fontColor ?? Colors.black)),
          ),
        ),
      ),
    );
  }
}
