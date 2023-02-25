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
    ''
    //HerdersRoute.routePath,
    //SellRoute.routePath,
    //SpendRoute.routePath,
    //TicketsRoute.routePath,
  ];

  List<Color> selectedColor = const [
    WeebiColors.orange,
    WeebiColors.blue,
    // WeebiColors.blue,
    // Colors.teal,
    // WeebiColors.red,
    // WeebiColors.grey,
  ];

  List<String> titles = const [
    'Articles', 'vide'
    //'Contacts',
    //'Vente',
    //'Achat',
    //'Tickets',
  ];

  @override
  Widget build(BuildContext context) {
    Widget posIcon = const SizedBox(
        width: 24,
        height: 24,
        child: Icon(FontAwesomeIcons.cashRegister, color: Colors.white));
    Widget posIconActive = const SizedBox(
        width: 24,
        height: 24,
        child: Icon(FontAwesomeIcons.cashRegister, color: Colors.teal));

    // final shopStore = Provider.of<ShopStore>(context, listen: false);
    // final cartStore = Provider.of<CartStore>(context, listen: false);
    // print('about to request environment');
    // final top = Provider.of<TopProvider>(context, listen: false);
    // final environment = top.environment ?? 'null';

    // print('environment $environment');
    return Scaffold(
      appBar: AppBar(
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
      drawer: const SizedBox(), //DrawerWeebi(),
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
          // if ((environment == EnvironmentWeebi.ldb ||
          //         shopStore.shop.first.isLocked) &&
          //     paths[newIndex] == SpendRoute.routePath) {
          //   widget.mainNavigatorKey.currentState
          //       .pushReplacementNamed(SyncLdbRoute.routePath);
          // } else if (!shopStore.shop.first.isLocked &&
          //     cartStore.items.isNotEmpty &&
          //     widget.selectedIndex == 2 &&
          //     paths[newIndex] == SpendRoute.routePath) {
          //   showDialogWeebi(
          //       'Vider le panier vente avant de faire un achat', context);
          // } else if (!shopStore.shop.first.isLocked &&
          //     cartStore.items.isNotEmpty &&
          //     widget.selectedIndex == 3 &&
          //     paths[newIndex] == SellRoute.routePath) {
          //   showDialogWeebi(
          //       'Vider le panier achat avant de faire une vente', context);
          // } else if (paths[newIndex] != null) {
          //   widget.mainNavigatorKey.currentState
          //       .pushReplacementNamed(paths[newIndex]);
          // }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Articles'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'vide'),
          // BottomNavigationBarItem(
          //     icon: const Icon(Icons.contacts),
          //     label: environment == EnvironmentWeebi.ldb ||
          //             shopStore.shop.first.isLocked
          //         ? 'Eleveurs'
          //         : 'Contacts'),
          // BottomNavigationBarItem(
          //     icon: posIcon, activeIcon: posIconActive, label: 'Vente'),
          // environment == EnvironmentWeebi.ldb || shopStore.shop.first.isLocked
          //     ? BottomNavigationBarItem(
          //         icon: const Icon(Icons.cloud), label: 'Sync')
          //     : BottomNavigationBarItem(
          //         icon: const Icon(Icons.shopping_cart), label: 'Achat'),
          // BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Tickets'),
        ],
      ),
    );
  }
}
