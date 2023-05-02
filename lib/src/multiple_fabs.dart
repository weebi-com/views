import 'package:flutter/material.dart';

class MultipleFABs extends StatelessWidget {
  final Widget FABCenter;
  final Widget FABRight;

  const MultipleFABs(
    this.FABCenter,
    this.FABRight,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 31),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FABCenter,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 31),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FABRight,
          ),
        )
      ],
    );
  }
}
