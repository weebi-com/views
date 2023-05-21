// Flutter imports:
import 'package:models_weebi/extensions.dart';
import 'package:views_weebi/src/providers/amount_provider.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:views_weebi/src/widgets/pad/numeric_pad.dart';
import 'package:views_weebi/src/widgets/pad/numpad_qt.dart';
import 'package:views_weebi/src/widgets/pad/ok_padd_qt_double.dart.dart';

class AskBigQuantity extends StatefulWidget {
  final bool isStockOutput;
  final double articleStockNow;
  final double? articleQtInCart;
  final bool isBasket;
  const AskBigQuantity(this.isStockOutput,
      {required this.articleStockNow,
      this.articleQtInCart,
      this.isBasket = false,
      Key? key})
      : super(key: key);
  @override
  _AskBigQuantityState createState() => _AskBigQuantityState();
}

class _AskBigQuantityState extends State<AskBigQuantity> {
  final _bigQtCtrler = TextEditingController(text: '');
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
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
              widget
                      .isBasket // basket has no stock, only a potential based on all articles in backet stocklevels
                  ? const SizedBox()
                  : widget.articleQtInCart == null
                      ? Text(
                          'qt stock : ${widget.articleStockNow.roundTwoDecimals}')
                      : Text(widget.isStockOutput
                          ? 'qt stock : ${widget.articleStockNow.roundTwoDecimals} - qt panier : ${widget.articleQtInCart?.roundTwoDecimals}'
                          : 'qt stock : ${widget.articleStockNow.roundTwoDecimals} + qt panier : ${widget.articleQtInCart?.roundTwoDecimals}'),
              QtFromNumPad(focusNode),
              const WeebiNumericPad(isDecimal: true),
              const WeebiOkPaddedQtDouble(),
            ],
          ),
        ));
  }
}
