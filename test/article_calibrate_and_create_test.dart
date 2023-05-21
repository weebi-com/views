import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/src/articles/calibre/retail/calibrate_create_retail.dart';

void main() {
  testWidgets('article calibre create widget test', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      Provider<ArticlesStore>(
        create: (_) => ArticlesStoreInstantiater.noPersistence,
        child: MaterialApp(
          home: const ArticleRetailCalibrateAndCreateView(),
        ),
      ),
    );

    await tester.pump();

    expect(find.byIcon(Icons.short_text), findsOneWidget); // lineName
    expect(find.byIcon(Icons.local_offer), findsWidgets); // price & cost
    expect(find.byIcon(Icons.filter_frames), findsOneWidget); // stockUnit
    expect(find.byIcon(Icons.style), findsOneWidget); // units per piece
    expect(find.byIcon(Icons.speaker_phone), findsOneWidget); // barcode

    final name = find.byKey(ArticleRetailCalibrateAndCreateView.nameKey);
    await tester.enterText(name, ArticleCalibre.dummyRetail.title);
    await tester.pump();

    final price = find.byKey(ArticleRetailCalibrateAndCreateView.priceKey);
    await tester.enterText(
        price, ArticleCalibre.dummyRetail.articles.first.price.toString());
    await tester.pump();

    final cost = find.byKey(ArticleRetailCalibrateAndCreateView.costKey);
    await tester.enterText(
        cost, ArticleCalibre.dummyRetail.articles.first.cost.toString());
    await tester.pump();

    final actionButton = find.byType(FloatingActionButton);
    final BuildContext context = tester.element(actionButton);
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);

    expect(articlesStore.calibres.length, 0);
    await tester.tap(actionButton);
    await tester.pump();
    await tester.pump();
    await tester.pump();
    expect(articlesStore.calibres.length, 1);
  });
}
