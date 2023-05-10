// Flutter imports:
import 'package:views_weebi/src/providers/amount_provider.dart';
import 'package:views_weebi/src/widgets/pad/numeric_pad.dart';
import 'package:views_weebi/src/widgets/pad/numpad_qt.dart';
import 'package:views_weebi/src/widgets/pad/ok_padd_qt_double.dart.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';
// Project imports:

class AskMinimumQuantity extends StatefulWidget {
  const AskMinimumQuantity({Key key}) : super(key: key);
  @override
  _AskMinimumQuantityState createState() => _AskMinimumQuantityState();
}

class _AskMinimumQuantityState extends State<AskMinimumQuantity> {
  final _bigQtCtrler = TextEditingController(text: '');
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {});
    _bigQtCtrler.addListener(() {
      final String text = _bigQtCtrler.text;
      _bigQtCtrler.value = _bigQtCtrler.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    _bigQtCtrler.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AmountProvider(_bigQtCtrler.value),
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Quantité minimum dans x1 panier'),
              QtFromNumPad(focusNode),
              const WeebiNumericPad(isDecimal: true),
              const WeebiOkPaddedQtDouble(),
            ],
          ),
        ));
  }
}
