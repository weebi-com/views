//credits to Flutter Animation Gallery

import 'package:flutter/material.dart';
import 'package:mixins_weebi/invokers.dart';

import 'package:mixins_weebi/stock.dart';
import 'package:models_weebi/base.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:views_weebi/routes.dart';
import 'package:views_weebi/src/articles/photo.dart';

import 'package:views_weebi/styles.dart' show WeebiColors;
import 'package:views_weebi/views_article.dart';

class ArticleACardSlide<A extends ArticleAbstract> extends StatelessWidget {
  final ArticleCalibre calibre;
  final A article;
  final TicketsInvoker ticketsInvoker;
  final ClosingStockShopsInvoker closingStockShopsInvoker;
  const ArticleACardSlide(
    this.calibre,
    this.article,
    this.ticketsInvoker,
    this.closingStockShopsInvoker,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
              '${article.calibreId}', '${article.id}'));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: WeebiColors.grey.withOpacity(.10), blurRadius: 5)
            ],
          ),
          child: Card(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            color: Colors.white,
            elevation: 10.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('#${calibre.id}.${article.id}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis),
                  Text(article.fullName,
                      style: TextStyle(
                          decoration: (article.status) == false
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis),
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: Hero(
                      tag: '${article.calibreId}.${article.id}',
                      child: PhotoWidget(article),
                    ),
                  ),
                  ArticleRetailFrameView(
                    ArticleRetailStockNow(
                      article: article as ArticleRetail,
                      ticketsInvoker: ticketsInvoker,
                      closingStockShopsInvoker: closingStockShopsInvoker,
                    ),
                    false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
