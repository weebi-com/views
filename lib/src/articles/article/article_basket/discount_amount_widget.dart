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
  String discountAmountValidator(String val) {
    if (val.isEmpty) {
      return null;
    } else {
      if (int.tryParse(val) == null) {
        return 'Montant incorrect';
      } else {
        if (int.parse(val) > widget.totalPrice) {
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
          child: TextFormField(
            initialValue: '${widget.oldDiscountAmount}' ?? '',
            decoration: InputDecoration(
              labelText: 'Réduction',
              icon: const Icon(Icons.redeem),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              //FilteringTextInputFormatter.allow(RegExpWeebi.regExpDecimal)
            ],
            autofocus: false,
            validator: (val) => discountAmountValidator(val),
            onChanged: (val) {
              DiscountAmountChangedNotif(int.parse(val.isEmpty ? '0' : val))
                  .dispatch(context);
              setState(() {});
            },
            keyboardType: TextInputType.number,
            textAlign: TextAlign.start,
            // style: const TextStyle(fontSize: 20),
          ),
        ),
      ]),
    );
  }
}
