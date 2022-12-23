import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final void Function() onPressed;
  final String string;
  final String tooltip;
  const RoundButton(
      {required this.onPressed,
      required this.string,
      this.tooltip = '',
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Tooltip(
          message: tooltip,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(), backgroundColor: Colors.blue),
            child: Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Text(string),
            ),
          ),
        ),
      );
}
