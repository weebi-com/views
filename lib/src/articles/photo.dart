import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:models_weebi/base.dart';
import 'package:models_weebi/common.dart';
import 'package:models_weebi/dummies.dart';
import 'package:models_weebi/weebi_models.dart';

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

class PhotoWidget<A extends ArticleAbstract> extends StatelessWidget {
  final A article;
  PhotoWidget(this.article);
  final Uint8List blankBytes = Uint8List.fromList([
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

  Image get getImage {
    if ((article.photoSource == PhotoSource.unknown ||
        article.photo.isEmpty ||
        article.photo == 'photo')) {
      return Image.memory(blankBytes, height: 1);
    }
    //TODO remove below "as" once PhotoSource is embedded into ArticleAbstract
    switch ((article as ArticleRetail).photoSource) {
      case PhotoSource.asset:
        return Image.asset(
          'photos/${article.photo}',
          fit: BoxFit.scaleDown,
          errorBuilder: (_, o, stack) => Loader.productIcon,
        );
      case PhotoSource.file:
        return Image.memory(
          base64Decode(article.photo),
          fit: BoxFit.scaleDown,
          frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
            return child;
            //if (wasSynchronouslyLoaded) return child;
            //return Loader.animatedSwitcher(child, frame);
          }),
          errorBuilder: (_, o, stack) => Loader.productIcon,
        );
      case PhotoSource.network:
        return Image.network(article.photo,
            fit: BoxFit.scaleDown,
            frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
              return child;
            }),
            errorBuilder: (_, o, stack) => Loader.productIcon);
      case PhotoSource.unknown:
        return Image.memory(blankBytes, height: 1);
      default:
        return Image.memory(blankBytes, height: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
/*     print('photoSource ${article.photoSource}'); */
    return getImage;
  }
}
