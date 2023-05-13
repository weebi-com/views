import 'dart:convert';

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
  const PhotoWidget(
    this.article,
  );

  Widget get getImage {
    if ((article.photo == null || article.photo.isEmpty)) {
      return const SizedBox();
    }
    //TODO remove below "as" once PhotoSource is embedded into ArticleAbstract
    switch ((article as ArticleRetail).photoSource) {
      case PhotoSource.asset:
        return Image.asset(
          'assets/photos/${article.photo}',
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
        return const SizedBox();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('photoSource ${article.photoSource}');
    return getImage;
  }
}
