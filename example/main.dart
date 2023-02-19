import 'package:mixins_weebi/instantiate_stores/tickets.dart';
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:mixins_weebi/stores.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rc_router/rc_router.dart';

import 'package:views_weebi/routes.dart';
import 'package:weebi_website/data/articles_dummy.dart';
import 'package:weebi_website/theme/colors.dart';
import 'package:weebi_website/utils/scroll.dart';
import 'package:weebi_website/views/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider<TicketsStore>(
          create: (_) => TicketsStoreInstantiater.noPersistence),
      Provider<ClosingsStore>(
          create: (_) => ClosingsStoreInstantiater.noPersistence),
      Provider<ArticlesStore>(
          create: (_) =>
              ArticlesStoreInstantiater.instArticlesStoreNoPersistenceTest),
    ],
    child: const StoreLoader(),
  ));
  ;
}

class StoreLoader extends StatelessWidget {
  const StoreLoader({Key? key}) : super(key: key);

  Future<bool> loadIt(ArticlesStore articlesStore, TicketsStore ticketsStore,
      ClosingsStore closingsStore) async {
    // * do not want to add mobx depency here, so await
    // await asyncWhen((_) => appStore.initialLoading == false);
    await closingsStore.init();
    await ticketsStore.init();
    final isStillLoading =
        await articlesStore.init(data: DummyData.articlesPopulate);
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
            return ColoredBoxWeebi.blackColoredBox;
          } else if (snap.connectionState != ConnectionState.waiting &&
              !snap.hasData)
            return ColoredBox(
              color: Colors.black38,
              child: Center(child: CircularProgressIndicator()),
            );
          if (snap.hasError) {
            print('${snap.error}');
            return ColoredBox(
                color: Color.fromRGBO(171, 71, 188, 1),
                child: Center(child: Text('loadStoreError ${snap.error}')));
          } else {
            if (snap.data == false) {
              return const WeebiSiteApp();
            } else {
              return ColoredBox(
                  color: Color.fromRGBO(171, 71, 188, 1),
                  child: Center(child: const Text('loadStoreUnfinished')));
            }
          }
        });
    //await asyncWhen((_) => appStore.initialLoading == false);
  }
}

class WeebiSiteApp extends StatefulWidget {
  const WeebiSiteApp({Key? key}) : super(key: key);

  @override
  State<WeebiSiteApp> createState() => _WeebiSiteAppState();
}

class _WeebiSiteAppState extends State<WeebiSiteApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  RcRoutes rcRoutes = RcRoutes(routes: []);

  @override
  void initState() {
    super.initState();
    rcRoutes.routes.addAll([
      // ArticleLinesRoute(navigatorKey),
      // ArticleBasketCreateRoute(),
      // ArticleLineCreateRoute(),
      LineOfArticlesDetailRoute(),
      // LineOfArticleUpdateRoute(),
      // ArticleCreateRoute(),
      ArticleDetailRoute(),
      // ArticleUpdateRoute(),
      // PrinterSettingsRoute(),
      // PromoCreateRoute(),
      ProxyADetailRoute(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: globals.appNavigator,
      onGenerateRoute: rcRoutes.onGeneratedRoute,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(backgroundColor: Colors.white70),
      home: HomeView(navigatorKey),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        // etc.
      };
}
