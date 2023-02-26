import 'material_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mixins_weebi/instantiate_stores/tickets.dart';
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:models_weebi/dummies.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider<TicketsStore>(
          create: (_) => TicketsStoreInstantiater.noPersistence),
      Provider<ClosingsStore>(
          create: (_) => ClosingsStoreInstantiater.noPersistence),
      Provider<ArticlesStore>(
          create: (_) => ArticlesStoreInstantiater.noPersistence),
    ],
    child: const StoreLoader(),
  ));
}

class StoreLoader extends StatelessWidget {
  const StoreLoader({Key? key}) : super(key: key);

  Future<bool> loadIt(ArticlesStore articlesStore, TicketsStore ticketsStore,
      ClosingsStore closingsStore) async {
    // * do not want to add mobx depency here, so await
    // await asyncWhen((_) => appStore.initialLoading == false);
    await closingsStore.init();
    await ticketsStore.init();
    final isStillLoading = await articlesStore
        .init(data: [...DummyArticleData.cola, ...DummyArticleData.babibel]);
    // JamfBM.jams
    return isStillLoading;
  }

  @override
  Widget build(BuildContext context) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);
    // print('closingsStore $closingsStore');
    return FutureBuilder<bool>(
        future: loadIt(articlesStore, ticketsStore, closingsStore),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const ColoredBox(
              color: Colors.grey,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snap.connectionState != ConnectionState.waiting &&
              !snap.hasData) {
            return const ColoredBox(
              color: Colors.black38,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snap.hasError) {
            // print('${snap.error}');
            return ColoredBox(
                color: const Color.fromRGBO(171, 71, 188, 1),
                child: Center(child: Text('loadStoreError ${snap.error}')));
          } else {
            if (snap.data == false) {
              return const ExampleApp();
            } else {
              return const ColoredBox(
                  color: Color.fromRGBO(171, 71, 188, 1),
                  child: Center(child: Text('loadStoreUnfinished')));
            }
          }
        });
    //await asyncWhen((_) => appStore.initialLoading == false);
  }
}
