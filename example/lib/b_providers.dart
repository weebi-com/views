import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mixins_weebi/instantiate_stores/tickets.dart';
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:mixins_weebi/stores.dart';

class ZeProviders extends StatelessWidget {
  final Widget child;
  const ZeProviders(
    this.child, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TicketsStore>(
            create: (_) => TicketsStoreInstantiater.noPersistence),
        Provider<ClosingsStore>(
            create: (_) => ClosingsStoreInstantiater.noPersistence),
        Provider<ArticlesStore>(
            create: (_) => ArticlesStoreInstantiater.noPersistence),
      ],
      child: child,
    );
  }
}
