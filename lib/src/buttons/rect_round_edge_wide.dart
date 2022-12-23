import 'package:flutter/material.dart';

class WeebiButtonOkRectWide extends StatelessWidget {
  final void Function() onPressed;
  final String string;
  final String tooltip;
  const WeebiButtonOkRectWide(
      {required this.onPressed,
      required this.string,
      required this.tooltip,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 64,
        width: 264,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Tooltip(
          message: tooltip,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: onPressed,
            child: Text(string,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
