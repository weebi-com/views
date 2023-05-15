import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:mixins_weebi/src/mobx_stores/tickets.dart';
import 'package:provider/provider.dart';

extension ProvideStores on BuildContext {
  TicketsStore get ticketsStore =>
      Provider.of<TicketsStore>(this, listen: false);
  ClosingsStore get closingsStore =>
      Provider.of<ClosingsStore>(this, listen: false);
}
