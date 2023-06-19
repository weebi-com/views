import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_article.dart';
import 'package:models_weebi/base.dart';
import 'package:models_weebi/common.dart';
import 'package:models_weebi/dummies.dart';
import 'package:models_weebi/weebi_models.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/src/extensions/article.dart';
import 'package:views_weebi/styles.dart';

class ArticlePhotoGlimpseWidget<A extends ArticleAbstract>
    extends StatelessWidget {
  final A article;
  final Widget childIfNoPhoto;
  const ArticlePhotoGlimpseWidget(this.article,
      {required this.childIfNoPhoto, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    if (articlesStore.photos
        .any((e) => e.calibreId == article.calibreId && e.id == article.id)) {
      final photo = articlesStore.photos.firstWhere(
          (e) => e.calibreId == article.calibreId && e.id == article.id);
      // print('photo ${photo.toMap()}');
      if (photo.path.isNotEmpty && photo.source != PhotoSource.unknown) {
        return SizedBox(width: 24, height: 24, child: PhotoWidget(photo));
      }
    }
    return childIfNoPhoto;
  }
}

class ArticleCartingWidget<A extends ArticleAbstract> extends StatelessWidget {
  final A article;
  final Widget childIfNoPhoto;
  const ArticleCartingWidget(this.article,
      {required this.childIfNoPhoto, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    if (articlesStore.photos
        .any((e) => e.calibreId == article.calibreId && e.id == article.id)) {
      final photo = articlesStore.photos.firstWhere(
          (e) => e.calibreId == article.calibreId && e.id == article.id);
      // print('photo ${photo.toMap()}');
      if (photo.path.isNotEmpty && photo.source != PhotoSource.unknown) {
        return PhotoWidget(photo);
      }
    }
    return childIfNoPhoto;
  }
}

class ArticlePhotoWidget<A extends ArticleAbstract> extends StatelessWidget {
  final A article;
  const ArticlePhotoWidget(this.article, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    if (articlesStore.photos
        .any((e) => e.calibreId == article.calibreId && e.id == article.id)) {
      final photo = articlesStore.photos.firstWhere(
          (e) => e.calibreId == article.calibreId && e.id == article.id);
      // print('photo ${photo.toMap()}');
      if (photo.path.isNotEmpty && photo.source != PhotoSource.unknown) {
        return PhotoWidget(photo);
      } else {
        if (article is ArticleBasket) {
          return const Icon(Icons.shopping_basket, color: WeebiColors.grey);
        } else {
          return Icon((article as ArticleRetail).getIcon.icon,
              color: Colors.grey);
        }
      }
    } else {
      return Image.memory(_blankBytes, height: 1);
    }
  }
}

class PhotoWidget<P extends PhotoAbstract> extends StatelessWidget {
  final P articlePhoto;
  PhotoWidget(this.articlePhoto);

  Image get getImage {
    if ((articlePhoto.source == PhotoSource.unknown ||
        articlePhoto.path.isEmpty ||
        articlePhoto.path == 'photo')) {
      return Image.memory(_blankBytes, height: 1);
    }
    switch (articlePhoto.source) {
      case PhotoSource.asset:
        if (kIsWeb) {
          return Image.asset(
            'photos/${articlePhoto.path}',
            fit: BoxFit.scaleDown,
            errorBuilder: (_, o, stack) => Loader.productIcon,
          );
        } else {
          return Image.asset(
            'assets/photos/${articlePhoto.path}',
            fit: BoxFit.scaleDown,
            errorBuilder: (_, o, stack) => Loader.productIcon,
          );
        }
      case PhotoSource.file:
        return Image.file(
          File(articlePhoto.path),
          fit: BoxFit.scaleDown,
          frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
            return child;
            //if (wasSynchronouslyLoaded) return child;
            //return Loader.animatedSwitcher(child, frame);
          }),
          errorBuilder: (_, o, stack) => Loader.productIcon,
        );
      case PhotoSource.network:
        return Image.network(articlePhoto.path,
            fit: BoxFit.scaleDown,
            frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
              return child;
            }),
            errorBuilder: (_, o, stack) => Loader.productIcon);
      case PhotoSource.memory:
        return Image.memory(base64Decode(articlePhoto.path),
            color: Colors.black, fit: BoxFit.scaleDown,
            frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
          // if (wasSynchronouslyLoaded)
          return child;
          // return Loader.animatedSwitcher(child, frame);
        }));
      case PhotoSource.unknown:
        return Image.memory(_blankBytes, height: 1);
      default:
        return Image.memory(_blankBytes, height: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return getImage;
  }
}

abstract class Loader {
  // * bad look
  // static animatedSwitcher(child, frame) => AnimatedSwitcher(
  //       duration: const Duration(milliseconds: 200),
  //       child: frame != null
  //           ? child
  //           : const SizedBox(
  //               height: 42,
  //               width: 42,
  //               child: CircularProgressIndicator(
  //                   strokeWidth: 6, color: WeebiColors.grey),
  //             ),
  //     );
  static Image get productIcon =>
      Image.memory(base64Decode(Base64DummyProduct.productBase64),
          color: Colors.black, fit: BoxFit.scaleDown,
          frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
        // if (wasSynchronouslyLoaded)
        return child;
        // return Loader.animatedSwitcher(child, frame);
      }));
}

final Uint8List _blankBytes = Uint8List.fromList([
  71,
  73,
  70,
  56,
  57,
  97,
  1,
  0,
  1,
  0,
  128,
  0,
  0,
  0,
  0,
  0,
  255,
  255,
  255,
  33,
  249,
  4,
  1,
  0,
  0,
  0,
  0,
  44,
  0,
  0,
  0,
  0,
  1,
  0,
  1,
  0,
  0,
  2,
  1,
  68,
  0,
  59
]);
