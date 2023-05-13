import 'package:flutter/material.dart';
import 'package:models_weebi/base.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:provider/provider.dart';

import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:mixins_weebi/stores.dart';

class StoresLoader extends StatelessWidget {
  final Widget child;
  final List<ArticleLine<ArticleAbstract>> articlesInitData;
  const StoresLoader(this.child, this.articlesInitData, {Key key})
      : super(key: key);

  Future<bool> loadIt(ArticlesStore articlesStore, TicketsStore ticketsStore,
      ClosingsStore closingsStore) async {
    // * do not want to add mobx depency here, so await
    // await asyncWhen((_) => appStore.initialLoading == false);
    await closingsStore.init();
    await ticketsStore.init();
    final isStillLoading = await articlesStore.init(data: articlesInitData);
    return isStillLoading;
  }

  @override
  Widget build(BuildContext context) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final ticketsStore = Provider.of<TicketsStore>(context, listen: false);
    final closingsStore = Provider.of<ClosingsStore>(context, listen: false);
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
              return child;
            } else {
              return const ColoredBox(
                  color: Color.fromRGBO(171, 71, 188, 1),
                  child: Center(child: Text('loadStoreUnfinished')));
            }
          }
        });
  }
}
