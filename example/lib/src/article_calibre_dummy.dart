import 'package:models_weebi/common.dart';
import 'package:models_weebi/dummies.dart';
import 'package:models_weebi/utils.dart';
import 'package:models_weebi/weebi_models.dart'
    show ArticleCalibre, ArticleRetail;

final articleCalibresDummies = [
  ...DummyArticleData.cola,
  ...DummyArticleData.babibel,
  articleCalibreDummySugar
];

final articleCalibreDummySugar = ArticleCalibre(
  id: 3,
  title: 'Sucre',
  stockUnit: StockUnit.gram,
  status: true,
  statusUpdateDate: WeebiDates.defaultDate,
  creationDate: WeebiDates.defaultDate,
  updateDate: WeebiDates.defaultDate,
  articles: [
    ArticleRetail(
      calibreId: 3,
      id: 1,
      fullName: 'Sucre g',
      photo: '',
      photoSource: PhotoSource.unknown,
      weight: 1.0,
      price: 10,
      cost: 5,
      articleCode: 31,
      creationDate: WeebiDates.defaultDate,
      updateDate: WeebiDates.defaultDate,
    )
  ],
);
