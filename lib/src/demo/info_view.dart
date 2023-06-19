// Flutter imports:
import 'package:flutter/material.dart';
import 'chassis_articles_demo_view.dart';
import 'import/import_articles_json.dart';

class InfoView extends StatelessWidget {
  final GlobalKey<NavigatorState> mainNavigator;
  const InfoView(this.mainNavigator, {Key? key}) : super(key: key);
  // static const routePath = '/info_view';
  @override
  Widget build(BuildContext context) {
    return ChassisDemoArticles(
      selectedIndex: 1,
      mainNavigatorKey: mainNavigator,
      body: const ImportArticleCalibreJsonView(),
    );
  }
}
