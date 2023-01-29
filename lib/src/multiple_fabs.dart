import 'package:flutter/material.dart';

class MultipleFABs extends StatelessWidget {
  final FloatingActionButton FABCenter;
  final FloatingActionButton FABRight;

  const MultipleFABs(this.FABCenter, this.FABRight, {super.key});

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
