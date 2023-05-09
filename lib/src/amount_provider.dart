import 'package:flutter/material.dart';

class AmountProvider extends ChangeNotifier {
  AmountProvider(this._textEditVal);
  TextEditingValue _textEditVal;
  TextEditingValue get textEditVal => _textEditVal ?? '';
  void setAmount(TextEditingValue val) {
    _textEditVal = val;
    notifyListeners();
  }
}
