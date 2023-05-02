import 'package:flutter/material.dart';
import 'package:views_weebi/styles.dart';

class FieldValueWidget extends StatelessWidget {
  final Icon icon;
  final Text fieldName;
  final SelectableText value;
  const FieldValueWidget(
    this.icon,
    this.fieldName,
    this.value,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingVerticalLine,
      child: Row(
        children: <Widget>[
          Flexible(flex: 1, fit: FlexFit.tight, child: icon),
          const SizedBox(width: 20),
          Flexible(flex: 4, fit: FlexFit.tight, child: fieldName),
          Flexible(flex: 5, fit: FlexFit.tight, child: value),
        ],
      ),
    );
  }
}
