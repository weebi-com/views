// Flutter imports:
import 'package:models_weebi/utils.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/src/providers/amount_provider.dart';
import 'package:views_weebi/src/platform_info.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QtFromNumPad extends StatelessWidget {
  final FocusNode focusNode;
  const QtFromNumPad(this.focusNode, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qtProvider = Provider.of<AmountProvider>(context, listen: true);
    final val = TextEditingValue(
      text: qtProvider.textEditVal.text,
      selection:
          TextSelection.collapsed(offset: qtProvider.textEditVal.text.length),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Expanded(
          child: RawKeyboardListener(
            focusNode: focusNode,
            onKey: (event) {
              // * not sure about this, might lead to STRANGE RESULTS ON MACOS
              // if (PlatformInfo().isMobile()) {
              //   return;
              // }
              // if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
              //   Navigator.of(context).pop((double.tryParse(val.text) ?? 0.0));
              // } else {
              //   return;
              // }
            },
            child: TextField(
                decoration: InputDecoration(prefix: const Text('Quantité')),
                controller: TextEditingController.fromValue(val),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExpWeebi.regExpDecimal)
                ],
                autofocus: true,
                onChanged: (v) => qtProvider.setAmount(val.copyWith(
                      text: v,
                      selection: TextSelection(
                          baseOffset: v.length, extentOffset: v.length),
                      composing: TextRange.empty,
                    )),
                keyboardType: PlatformInfo().isMobile()
                    ? TextInputType.none
                    : const TextInputType.numberWithOptions(decimal: false),
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 20)),
          ),
        ),
      ]),
    );
  }
}
