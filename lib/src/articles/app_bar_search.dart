import 'package:flutter/material.dart';
import 'package:mixins_weebi/mobx_store_article.dart';
import 'package:provider/provider.dart';
import 'package:views_weebi/styles.dart';

class TopBarSearchArticles extends StatefulWidget {
  final void Function() onPressedCloseIconButton;
  const TopBarSearchArticles({this.onPressedCloseIconButton, Key key})
      : super(key: key);

  @override
  State<TopBarSearchArticles> createState() => _TopBarSearchArticlesState();
}

class _TopBarSearchArticlesState extends State<TopBarSearchArticles> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      final String text = textController.text;
      textController.value = textController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
      final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
      articlesStore.setQueryString(textController.value.text);
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);

    return AppBar(
      backgroundColor: weebiTheme.scaffoldBackgroundColor,
      leading: const Icon(Icons.search, color: WeebiColors.grey),
      title: TextField(
        autofocus: true,
        style: const TextStyle(color: Colors.black),
        keyboardType: TextInputType.text,
        controller: textController,
        decoration: const InputDecoration(
          hintText: "Nom ou #",
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.close),
            color: Colors.black,
            onPressed: widget.onPressedCloseIconButton ??
                () {
                  articlesStore.clearSearch();
                }),
      ],
    );
  }
}
