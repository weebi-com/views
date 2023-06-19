// ignore_for_file: file_names

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_article.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/routes.dart';
import 'package:rc_router2/rc_router2.dart';
import 'package:views_weebi/views.dart';
import 'package:views_weebi/demo.dart';

class ArticlesDemoApp extends StatefulWidget {
  const ArticlesDemoApp({Key? key}) : super(key: key);

  @override
  State<ArticlesDemoApp> createState() => _ArticlesDemoAppState();
}

class _ArticlesDemoAppState extends State<ArticlesDemoApp> {
  final mainNavigator = GlobalKey<NavigatorState>();
  RcRoutes rcRoutes = RcRoutes(routes: []);

  @override
  void initState() {
    super.initState();
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);

    rcRoutes.routes.addAll([
      // this allows us to use different types of chassis in home while maintaining lower views untouched
      // I can reduce bottombar to x2 activities in my tutorial without changing anything else
      ArticlesCalibresAllFrameRoute(
        mainNavigator,
        ChassisDemoArticles.buildChassisForArticles(
            mainNavigator, articlesStore),
      ),

      ArticleCalibreBasketCreateRoute(),
      ArticleBasketUpdateRoute(),

      ArticleRetailCalibrationAndCreationRoute(),
      ArticleCalibreRetailDetailRoute(),
      ArticleCalibreUpdateRoute(),

      ArticleDetailRoute(),

      ArticleRetailCalibrationAndCreationRoute(),
      ArticleRetailCreateRoute(),
      ArticleRetailUpdateRoute(),

      InfoRoute(mainNavigator),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: mainNavigator,
      onGenerateRoute: rcRoutes.onGeneratedRoute,
      scrollBehavior: MyCustomScrollBehavior(),
      home: HomeViewChassisBuilder<ChassisDemoArticles>(
        ChassisDemoArticles.buildChassisForArticles(
            mainNavigator, articlesStore),
        mainNavigator: mainNavigator,
      ),
      // locale: const Locale('fr'),
      // supportedLocales: const [
      //   Locale('fr'),
      //   Locale('en'),
      //   Locale('es'), // spanish
      // ],
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => const Scaffold(
              body: Center(child: Text('Not Found example views'))),
        );
      },
      // routes: {
      //   InfoView.routePath: (context) => InfoView(mainNavigator),
      // },
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
      };
}
