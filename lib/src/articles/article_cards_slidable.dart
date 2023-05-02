//credits to Flutter Animation Gallery

import 'package:flutter/material.dart';
import 'package:mixins_weebi/stock.dart';
import 'package:models_weebi/base.dart';
import 'package:models_weebi/weebi_models.dart';

import 'package:views_weebi/extensions.dart';
import 'dart:math';

import 'package:views_weebi/src/articles/article_card_slide.dart';

class SlidableCardsV2<A extends ArticleAbstract> extends StatefulWidget {
  final ArticleLines line;
  final int articleId;
  final TicketsInvoker ticketsInvoker;
  final ClosingStockShopsInvoker closingStockShopsInvoker;

  const SlidableCardsV2(
      this.line, this.ticketsInvoker, this.closingStockShopsInvoker,
      {this.articleId = 1});
  @override
  SlidableCardsV2State createState() => SlidableCardsV2State();
}

class SlidableCardsV2State extends State<SlidableCardsV2> {
  PageController pageController;
  var currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
        viewportFraction: 0.5, initialPage: (widget.articleId - 1));
    currentPageValue = (widget.articleId - 1).toDouble();
    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page;
      });
    });
  }

  @override
  void dispose() {
    pageController.keepPage;
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: context.screenHeight * 0.83,
        child: PageView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: pageController,
            itemCount: widget.line.articles.length,
            itemBuilder: (context, position) {
              if (position == currentPageValue) {
                return Transform.scale(
                  scale: 1,
                  child: SizedBox(
                    width: 200,
                    child: ArticleACardSlide(
                        widget.line,
                        widget.line.articles[position],
                        widget.ticketsInvoker,
                        widget.closingStockShopsInvoker),
                  ),
                );
              } else if (position < currentPageValue) {
                return Transform.scale(
                  scale: max(1 - (currentPageValue - position), 0.5),
                  child: ArticleACardSlide(
                      widget.line,
                      widget.line.articles[position],
                      widget.ticketsInvoker,
                      widget.closingStockShopsInvoker),
                );
              } else {
                return Transform.scale(
                  scale: max(1 - (position - currentPageValue), 0.5),
                  child: ArticleACardSlide(
                      widget.line,
                      widget.line.articles[position],
                      widget.ticketsInvoker,
                      widget.closingStockShopsInvoker),
                );
              }
            }),
      ),
    );
  }
}
