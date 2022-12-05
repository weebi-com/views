// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:models_weebi/common.dart' show PaiementType, TicketType;
import 'package:views_weebi/src/styles/colors.dart';

extension GetTicketTypeIcon on TicketType {
  Widget get getTicketTypeIcon {
    final color = getTicketTypeIconColor;
    Widget posIcon = SizedBox(
        width: 24,
        height: 24,
        child: Icon(FontAwesomeIcons.cashRegister, color: color));
    if (this == TicketType.sell) {
      return posIcon;
    } else if (this == TicketType.sellDeferred) {
      return Icon(Icons.record_voice_over, color: color);
    } else if (this == TicketType.sellCovered) {
      return Icon(Icons.playlist_add_check, color: color);
    } else if (this == TicketType.spend) {
      return Icon(Icons.shopping_cart, color: color);
    } else if (this == TicketType.spendDeferred) {
      return Icon(Icons.local_drink, color: color);
    } else if (this == TicketType.spendCovered) {
      return Icon(Icons.healing, color: color);
    } else if (this == TicketType.stockIn) {
      return Icon(Icons.layers, color: color);
    } else if (this == TicketType.stockOut) {
      return Icon(Icons.layers, color: color);
    } else if (this == TicketType.wage) {
      return Icon(Icons.attach_money, color: color);
    } else {
      return const Icon(Icons.device_unknown);
    }
  }

  Color get getTicketTypeIconColor {
    if (this == TicketType.sell) {
      return Colors.teal;
    } else if (this == TicketType.sellDeferred) {
      return Colors.blueGrey;
    } else if (this == TicketType.sellCovered) {
      return Colors.teal;
    } else if (this == TicketType.spend) {
      return WeebiColors.orange;
    } else if (this == TicketType.spendDeferred) {
      return Colors.orange;
    } else if (this == TicketType.spendCovered) {
      return WeebiColors.orange;
    } else if (this == TicketType.stockIn) {
      return const Color(0xFFAD1457); // Colors.pink[800]
    } else if (this == TicketType.stockOut) {
      return const Color(0xFFF06292); // Colors.pink[300]
    } else if (this == TicketType.wage) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  Icon get getTicketContactIcon {
    if (this == TicketType.sell) {
      return const Icon(Icons.person);
    } else if (this == TicketType.sellDeferred) {
      return const Icon(Icons.face);
    } else if (this == TicketType.sellCovered) {
      return const Icon(Icons.face);
    } else if (this == TicketType.spend) {
      return const Icon(Icons.person);
    } else if (this == TicketType.spendDeferred) {
      return const Icon(Icons.face);
    } else if (this == TicketType.spendCovered) {
      return const Icon(Icons.face);
    } else {
      return const Icon(Icons.device_unknown);
    }
  }
}

Widget getTicketPaiementTypeIcon(
    PaiementType thisPaiementType, TicketType ticketType) {
  final color = ticketType.getTicketTypeIconColor;
  Widget cashIcon = SizedBox(
      width: 24,
      height: 24,
      child: Icon(FontAwesomeIcons.moneyBill1Wave, size: 18, color: color));
  if (thisPaiementType == PaiementType.cash) {
    return cashIcon;
  } else if (thisPaiementType == PaiementType.yup) {
    return Icon(Icons.phone_android, color: color);
  } else if (thisPaiementType == PaiementType.goods) {
    return Icon(Icons.local_shipping, color: color);
  } else if (thisPaiementType == PaiementType.cheque) {
    return Icon(Icons.note, color: color);
  } else if (thisPaiementType == PaiementType.cb) {
    return Icon(Icons.payment, color: color);
  } else if (thisPaiementType == PaiementType.nope) {
    return Icon(Icons.record_voice_over, color: color);
  } else {
    return Icon(Icons.device_unknown, color: color);
  }
}

// * below is not used, seemed useless

Color getTicketIconsColor(bool ticketStatus) {
  if (ticketStatus == true) {
    return Colors.black;
  } else {
    return Colors.grey;
  }
}
