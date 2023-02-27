import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:views_weebi/views.dart' show LinesFrameW;
import 'package:views_weebi_example/example.dart';

void main() {
  testWidgets('check articles search by title', (tester) async {
    await tester.pumpWidget(const ZeProviders(StoresLoader(ExampleApp())));
    // pumps ChassisTutoProducts and also ArticlesLinesViewWIP
    await tester.pump();
    expect(find.text('Articles'), findsWidgets);

    final searchArticleFound = find.byTooltip("Chercher un article");
    expect(searchArticleFound, findsOneWidget);
    await tester.tap(searchArticleFound);
    await tester.pump();

    final searchBar = find.byType(TextField);
    expect(searchBar, findsOneWidget);
    await tester.enterText(searchBar, 'ba');
    await tester.pump();
    int itemsLength =
        tester.widgetList<LinesFrameW>(find.byType(LinesFrameW)).length;
    expect(itemsLength, 1);

    LinesFrameW item =
        tester.widgetList<LinesFrameW>(find.byType(LinesFrameW)).elementAt(0);
    expect('Babibel', item.line.title);
    expect(2, item.line.id);

    // verify that close icon is there and works
    final closeIcon = find.byIcon(Icons.cancel);
    expect(closeIcon, findsOneWidget);
    await tester.tap(closeIcon);
    await tester.pump();

    expect(searchBar, findsNothing);
    final linesSearchClose =
        tester.widgetList<LinesFrameW>(find.byType(LinesFrameW));
    final colaSearchClose = linesSearchClose.elementAt(0);
    expect(linesSearchClose, 2);
    expect('Noix de cola', colaSearchClose.line.title);
    expect(1, colaSearchClose.line.id);
  });
}
