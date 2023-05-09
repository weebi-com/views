import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DiscountAmountChangedNotif extends Notification {
  final int val;
  DiscountAmountChangedNotif(this.val);
}

class DiscountAmountWidget extends StatefulWidget {
  final int totalPrice;
  final int oldDiscountAmount;
  const DiscountAmountWidget(this.totalPrice,
      {this.oldDiscountAmount = 0, Key key})
      : super(key: key);

  @override
  State<DiscountAmountWidget> createState() => _DiscountAmountWidgetState();
}

class _DiscountAmountWidgetState extends State<DiscountAmountWidget> {
  String discountAmountString;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    discountAmountString = '${widget.oldDiscountAmount}';
  }

  String discountAmountValidator() {
    if (discountAmountString.isEmpty) {
      return null;
    } else {
      if (int.tryParse(discountAmountString) == null) {
        return 'Montant incorrect';
      } else {
        if (int.parse(discountAmountString) > widget.totalPrice) {
          return 'le montant de la réduction ne peut être supérieur au total du panier';
        } else {
          return null;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Expanded(
          child: TextField(
              decoration: InputDecoration(
                labelText: 'Réduction',
                icon: const Icon(Icons.redeem),
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                //FilteringTextInputFormatter.allow(RegExpWeebi.regExpDecimal)
              ],
              autofocus: true,
              onChanged: (val) {
                setState(() {
                  discountAmountString = val;
                });
                if (discountAmountValidator() == null) {
                  DiscountAmountChangedNotif(int.parse(val.isEmpty ? '0' : val))
                      .dispatch(context);
                }
              },
              keyboardType: TextInputType.number,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 20)),
        ),
      ]),
    );
  }
}
