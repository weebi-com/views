import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mixins_weebi/stores.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:provider/provider.dart';
import 'package:rc_router2/rc_router2.dart';
import 'package:views_weebi/src/articles/line/line_update.dart';
import 'package:views_weebi/src/providers.dart';
import 'package:views_weebi/src/routes/articles/line_detail.dart';

void main() {
  testWidgets('article line update widget test', (tester) async {
    final rcRoutes = RcRoutes(routes: [ArticleLineRetailDetailRoute()]);

    await tester.pumpWidget(
      ZeProviders(
        MaterialApp(
          onGenerateRoute: rcRoutes.onGeneratedRoute,
          home: ArticleLineUpdateView(ArticleLine.dummy),
        ),
      ),
    );
    await tester.pump();

    final actionButton = find.byType(FloatingActionButton);
    final BuildContext context = tester.element(actionButton);
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    final lineCreated =
        await articlesStore.createLineArticle(ArticleLine.dummy);
    expect(lineCreated, ArticleLine.dummy);
    final name = find.byKey(ArticleLineUpdateView.nameKey);

    expect(find.byIcon(Icons.short_text), findsOneWidget);
    expect(find.byIcon(Icons.filter_frames), findsOneWidget); // stockUnit
    await tester.enterText(name, 'jet prive');
    await tester.pump();
    await tester.tap(actionButton);
    await tester.pump();
    expect(articlesStore.lines.first.nameLine, 'jet prive');
  });
}
