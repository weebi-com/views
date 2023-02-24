import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_article.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/routes.dart';
import 'package:rc_router/rc_router.dart';
import 'package:views_weebi/views.dart';
import 'package:views_weebi/views_tutos.dart';

class ExampleApp extends StatefulWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  final mainNavigator = GlobalKey<NavigatorState>();
  RcRoutes rcRoutes = RcRoutes(routes: []);

  @override
  void initState() {
    super.initState();
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final chassisArticles = ChassisTutoProducts.buildChassisForArticles(
        mainNavigator, articlesStore);
    rcRoutes.routes.addAll([
      // this allows us to use different types of chassis in home while maintaining lower views untouched
      // I can reduce bottombar to x2 activities in my tutorial without changing anything else
      ArticleLinesFrameRoute(mainNavigator, chassisArticles),
      // ArticleBasketCreateRoute(),
      // ArticleLineCreateRoute(),
      LineOfArticlesDetailRoute(),
      // LineOfArticleUpdateRoute(),
      // ArticleCreateRoute(),
      ArticleDetailRoute(),
      ArticleUpdateRouteUnfinished(), // unfinished here
      // PrinterSettingsRoute(),
      // PromoCreateRoute(),
      ProxyADetailRoute(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final chassisArticles = ChassisTutoProducts.buildChassisForArticles(
        mainNavigator, articlesStore);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: mainNavigator,
      onGenerateRoute: rcRoutes.onGeneratedRoute,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(backgroundColor: Colors.white70),
      home: HomeView<ChassisTutoProducts>(chassisArticles,
          mainNavigator: mainNavigator),
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
