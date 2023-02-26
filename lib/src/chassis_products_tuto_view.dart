// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:views_weebi/src/routes/articles/frame.dart';

// Project imports:
import 'package:views_weebi/styles.dart' show WeebiColors;
import 'package:views_weebi/views.dart';
import 'package:views_weebi/widgets.dart' show areYouSureQuitApp;
import 'package:views_weebi/src/chassis_abstract.dart';

class InfoView extends StatelessWidget {
  final GlobalKey<NavigatorState> mainNavigator;
  const InfoView(this.mainNavigator, {Key? key}) : super(key: key);
  static const routePath = '/info_view';
  @override
  Widget build(BuildContext context) {
    return ChassisTutoProducts(
      selectedIndex: 1,
      mainNavigatorKey: mainNavigator,
      body: const Center(child: Text('hey')),
    );
  }
}

class ChassisTutoProducts extends ChassisAbstract {
  static const Key keyAppBarTitle = Key("AppBar");

  static ChassisTutoProducts buildChassisForArticles(
          GlobalKey<NavigatorState> mainNavigator,
          ArticlesStore articlesStore) =>
      ChassisTutoProducts(
        selectedIndex: 0,
        actions: <Widget>[
          Observer(
            builder: (context) => IconButton(
              icon: articlesStore.sortedBy.value == SortedBy.idReversed
                  ? const Icon(Icons.keyboard_arrow_up)
                  : const Icon(Icons.keyboard_arrow_down),
              onPressed: () {
                if (articlesStore.sortedBy.value == SortedBy.id) {
                  articlesStore.sortBy(SortedBy.idReversed);
                } else {
                  articlesStore.sortBy(SortedBy.id);
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.sort_by_alpha),
            onPressed: () {
              if (articlesStore.sortedBy.value == SortedBy.title) {
                articlesStore.sortBy(SortedBy.titleReversed);
              } else {
                articlesStore.sortBy(SortedBy.title);
              }
            },
          ),
        ],
        mainNavigatorKey: mainNavigator,
        body: ArticlesLinesViewWIP(mainNavigator: mainNavigator),
      );

  const ChassisTutoProducts({
    super.key,
    required Widget body,
    required int selectedIndex,
    required GlobalKey<NavigatorState> mainNavigatorKey,
    Widget floatingButton = const SizedBox(),
    List<Widget> actions = const [],
  }) : super(
            body: body,
            selectedIndex: selectedIndex,
            mainNavigatorKey: mainNavigatorKey,
            floatingButton: floatingButton,
            actions: actions);

  @override
  _ViewsFrameState createState() => _ViewsFrameState();
}

class _ViewsFrameState extends State<ChassisTutoProducts> {
  List<String> paths = [
    ArticleLinesFrameRoute.routePath,
    InfoView.routePath,
  ];

  List<Color> selectedColor = const [
    WeebiColors.orange,
    WeebiColors.blue,
  ];

  List<String> titles = const ['Articles', 'Info'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: selectedColor[widget.selectedIndex],
          title: SelectableText.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: titles[widget.selectedIndex],
                  style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            key: ChassisTutoProducts.keyAppBarTitle,
          ),
          centerTitle: true,
          elevation: 3,
          actions: widget.actions),
      body: WillPopScope(
          onWillPop: () async => areYouSureQuitApp(context),
          child: widget.body),
      floatingActionButton: widget.floatingButton,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: selectedColor[widget.selectedIndex],
        unselectedItemColor: Colors.white,
        backgroundColor: const Color(0xFF20272B),
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.selectedIndex,
        onTap: (newIndex) {
          widget.mainNavigatorKey.currentState
              ?.pushReplacementNamed(paths[newIndex]);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Articles'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
        ],
      ),
    );
  }
}
