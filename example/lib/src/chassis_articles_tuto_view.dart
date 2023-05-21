// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
// Package imports:
import 'package:mixins_weebi/stores.dart';
import 'package:views_weebi/routes.dart';
// Project imports:
import 'package:views_weebi/styles.dart' show WeebiColors;
import 'package:views_weebi/views.dart';
import 'package:views_weebi/widgets.dart';
import 'package:views_weebi/chassis.dart' show ChassisAbstract;
import 'info_route.dart';

class ChassisTutoProducts extends ChassisAbstract {
  static const Key? keyAppBarTitle = Key("AppBar");

  static ChassisTutoProducts buildChassisForArticles(
          GlobalKey<NavigatorState> mainNavigator,
          ArticlesStore articlesStore) =>
      ChassisTutoProducts(
        selectedIndex: 0,
        actions: <Widget>[
          Tooltip(
            message: 'Trier par code',
            child: Observer(
              builder: (context) => IconButton(
                icon: articlesStore.sortedBy.value == SortedBy.id
                    ? const Icon(Icons.keyboard_arrow_down)
                    : const Icon(Icons.keyboard_arrow_up),
                onPressed: () {
                  if (articlesStore.sortedBy.value == SortedBy.id) {
                    articlesStore.sortBy(SortedBy.idReversed);
                  } else {
                    articlesStore.sortBy(SortedBy.id);
                  }
                },
              ),
            ),
          ),
          Tooltip(
            message: 'Trier par nom',
            child: IconButton(
              icon: const Icon(Icons.sort_by_alpha),
              onPressed: () {
                if (articlesStore.sortedBy.value == SortedBy.title) {
                  articlesStore.sortBy(SortedBy.titleReversed);
                } else {
                  articlesStore.sortBy(SortedBy.title);
                }
              },
            ),
          ),
        ],
        mainNavigatorKey: mainNavigator,
        body: ArticlesCalibresOverviewWebOnly(mainNavigator: mainNavigator),
      );

  const ChassisTutoProducts({
    key,
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

// * *consider adding pathes, selectedColor and titles into the class as params
// then consider making a dedicated constructor instead of extending an abstract class
// should give more flexibility
class _ViewsFrameState extends State<ChassisTutoProducts> {
  List<String> paths = [
    ArticlesCalibresAllFrameRoute.routePath,
    InfoRoute.routePath,
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
          onWillPop: () async => AskDialog.areYouSureQuitApp(context),
          child: widget.body),
      floatingActionButton: widget.floatingButton,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: selectedColor[widget.selectedIndex],
        unselectedItemColor: Colors.white,
        backgroundColor: const Color(0xFF20272B),
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.selectedIndex,
        onTap: (newIndex) {
          // print(widget.mainNavigatorKey);
          // print(paths[newIndex]);
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
