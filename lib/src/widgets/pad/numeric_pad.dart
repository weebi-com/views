import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/src/providers/amount_provider.dart';
import 'package:views_weebi/buttons.dart';

class WeebiNumericPad extends StatelessWidget {
  final bool isDecimal;
  const WeebiNumericPad({this.isDecimal = false, Key? key}) : super(key: key);

  void onPressed(AmountProvider amountProvider, String numString) {
    String text = amountProvider.textEditVal.text;
    if (text == '' || text == '0' || text == '.' || text == '0.') {
      if (text == '0' && numString == '0') {
        return; // on n'ajoute pas des 000
      }
      if (text == '0.' && numString == '.' || text == '.' && numString == '.') {
        return; // on n'ajoute pas des ....
      }
    }
    final temp = amountProvider.textEditVal.copyWith(
      text: text + numString,
      selection:
          TextSelection(baseOffset: text.length, extentOffset: text.length),
      composing: TextRange.empty,
    );
    amountProvider.setAmount(temp);
  }

  void onPressedClear(AmountProvider amountProvider) {
    final temp = amountProvider.textEditVal.copyWith(
      text: '',
      selection: TextSelection(
          baseOffset: amountProvider.textEditVal.text.length,
          extentOffset: amountProvider.textEditVal.text.length),
      composing: TextRange.empty,
    );

    amountProvider.setAmount(temp);
  }

  @override
  Widget build(BuildContext context) {
    final _amountProvider = Provider.of<AmountProvider>(context, listen: true);

    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 2, 0, 22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  WeebiNumPadButton(
                      tooltip: '7',
                      string: '7',
                      onPressed: () => onPressed(_amountProvider, '7')),
                  WeebiNumPadButton(
                      tooltip: '8',
                      string: '8',
                      onPressed: () => onPressed(_amountProvider, '8')),
                  WeebiNumPadButton(
                      tooltip: '9',
                      string: '9',
                      onPressed: () => onPressed(_amountProvider, '9')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  WeebiNumPadButton(
                      tooltip: '4',
                      string: '4',
                      onPressed: () => onPressed(_amountProvider, '4')),
                  WeebiNumPadButton(
                      tooltip: '5',
                      string: '5',
                      onPressed: () => onPressed(_amountProvider, '5')),
                  WeebiNumPadButton(
                      tooltip: '6',
                      string: '6',
                      onPressed: () => onPressed(_amountProvider, '6')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  WeebiNumPadButton(
                      tooltip: '1',
                      string: '1',
                      onPressed: () => onPressed(_amountProvider, '1')),
                  WeebiNumPadButton(
                      tooltip: '2',
                      string: '2',
                      onPressed: () => onPressed(_amountProvider, '2')),
                  WeebiNumPadButton(
                      tooltip: '3',
                      string: '3',
                      onPressed: () => onPressed(_amountProvider, '3')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  WeebiNumPadButton(
                      tooltip: '0',
                      string: '0',
                      onPressed: () => onPressed(_amountProvider, '0')),
                  isDecimal
                      ? WeebiNumPadButton(
                          tooltip: '.',
                          string: '.',
                          onPressed: () => onPressed(_amountProvider, '.'))
                      : WeebiNumPadButton(
                          tooltip: '00',
                          string: '00',
                          onPressed: () => onPressed(_amountProvider, '00')),
                  WeebiNumPadButton(
                      tooltip: 'Clear',
                      string: 'C',
                      backColor: MaterialStateProperty.all<Color>(Colors.red),
                      fontColor: Colors.white,
                      onPressed: () => onPressedClear(_amountProvider)),
                ],
              ),
            )
          ],
        ));
  }
}
