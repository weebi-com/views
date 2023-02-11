//credits to Flutter Animation Gallery

import 'package:flutter/material.dart';
import 'package:mixins_weebi/stock/abstracts/line_stock_abstract.dart';
import 'package:models_weebi/base.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:views_weebi/routes.dart';

import 'package:views_weebi/styles.dart' show WeebiColors;
import 'package:views_weebi/views_article.dart';

class ArticleACardSlide<A extends ArticleAbstract> extends StatelessWidget {
  final LineOfArticles line;
  final A article;
  final TicketsInvoker ticketsInvoker;
  final ClosingStockShopsInvoker closingStockShopsInvoker;
  const ArticleACardSlide(this.line, this.article, this.ticketsInvoker,
      this.closingStockShopsInvoker,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(ArticleDetailRoute.generateRoute(
              '${article.lineId}', '${article.id}'));
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
                  Text('#${line.id}.${article.id}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis),
                  Text(article.fullName,
                      style: TextStyle(
                          decoration: article.status == false
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis),
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: article.photo == null || article.photo!.isEmpty
                        ? Image.asset('assets/icons/product_detail.png',
                            color: WeebiColors.greyLight)
                        : Hero(
                            tag: article.photo!,
                            child: Image.asset('assets/photos/${article.photo}',
                                fit: BoxFit.scaleDown,
                                errorBuilder: (_, o, stack) => Image.asset(
                                    'assets/icons/product_detail.png',
                                    color: WeebiColors.greyLight)),
                          ),
                  ),
                  ArticleWFrameView(
                    article as Article,
                    false,
                    ticketsInvoker,
                    closingStockShopsInvoker,
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
