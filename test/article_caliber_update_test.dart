import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mixins_weebi/mobx_store_closing.dart';
import 'package:mixins_weebi/mobx_store_ticket.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';
import 'package:views_weebi/src/articles/calibre/update_calibre.dart';
import 'package:views_weebi/src/routes/articles/calibre_detail.dart';

void main() {
  testWidgets('article calibre update widget test', (tester) async {
    final rcRoutes = RcRoutes(routes: [ArticleCalibreRetailDetailRoute()]);

    await tester.pumpWidget(MultiProvider(
      providers: [
        Provider<TicketsStore>(
            create: (_) => TicketsStoreInstantiater.noPersistence),
        Provider<ClosingsStore>(
            create: (_) => ClosingsStoreInstantiater.noPersistence),
        Provider<ArticlesStore>(
            create: (_) => ArticlesStoreInstantiater.noPersistence),
      ],
      child: MaterialApp(
        onGenerateRoute: rcRoutes.onGeneratedRoute,
        home: ArticleCalibreUpdateView(ArticleCalibre.dummyRetail),
      ),
    ));
    await tester.pump();
    // set-up
    final actionButton = find.byType(FloatingActionButton);
    final BuildContext context = tester.element(actionButton);
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final calibreCreated = await articlesStore
        .createAndCalibrateArticle(ArticleCalibre.dummyRetail);
    expect(calibreCreated, ArticleCalibre.dummyRetail);

    // we are already in ArticleCalibreUpdateView
    final name = find.byKey(ArticleCalibreUpdateView.nameKey);
    expect(find.byIcon(Icons.short_text), findsOneWidget);
    expect(find.byIcon(Icons.filter_frames), findsOneWidget); // stockUnit
    await tester.enterText(name, 'jet prive');
    await tester.pump();
    await tester.tap(actionButton);
    await tester.pump();
    expect(articlesStore.calibres.first.nameLine, 'jet prive');
  });
}
