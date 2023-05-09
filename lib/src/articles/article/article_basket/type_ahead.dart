// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:models_weebi/weebi_models.dart';
// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:views_weebi/styles.dart' show WeebiColors;

class ArticlesInBasketTypeAhead extends StatefulWidget {
  const ArticlesInBasketTypeAhead({Key key}) : super(key: key);

  @override
  State<ArticlesInBasketTypeAhead> createState() =>
      _ArticlesInBasketTypeAheadState();
}

class _ArticlesInBasketTypeAheadState extends State<ArticlesInBasketTypeAhead> {
  FocusNode _focus;
  TextEditingController _articleNameCtr;
  TriState _areArticlesSelected;
  @override
  void initState() {
    super.initState();
    _focus = FocusNode();
    _focus.addListener(() {});
    _areArticlesSelected = TriState.unknown;
    _articleNameCtr = TextEditingController(text: '');
    _articleNameCtr.addListener(() {
      final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
      final String text = _articleNameCtr.text;
      _articleNameCtr.value = _articleNameCtr.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
      articlesStore.setQueryString(_articleNameCtr.text);
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    _articleNameCtr.dispose();
    super.dispose();
  }

  Future<void> onSelected(String suggestion) async {
    final articlesStore = Provider.of<ArticlesStore>(context, listen: false);
    // ToRuminate a way to use id instead of name
    final aWeebi = articlesStore.findSingleArticleBasedOnFullName(suggestion);
    if (aWeebi != ArticleWMinQt.dummy) {
      // prefer dummy other null
      articlesStore.addArticleWInSelected(aWeebi);
      this._articleNameCtr.text = '';
      setState(() {
        _areArticlesSelected = TriState.yes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      //key: ShopUpdateView.Key_ShopUpdateCountryEntry,
      hideOnEmpty: true,
      hideOnError: true,
      hideOnLoading: true,
      getImmediateSuggestions: false,
      keepSuggestionsOnSuggestionSelected: false,
      hideSuggestionsOnKeyboardHide: true,
      autoFlipDirection: false,
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: false,
        focusNode: _focus,
        controller: _articleNameCtr,
        onSubmitted: (val) {
          onSelected(val);
        },
        decoration: InputDecoration(
          labelText: "Articles*",
          errorText: _areArticlesSelected == TriState.no
              ? 'Choisir les articles'
              : null,
          icon: const Icon(Icons.widgets),
          suffixIcon: this._articleNameCtr.value.text.isEmpty
              ? const SizedBox()
              : IconButton(
                  icon: const Icon(Icons.close, color: WeebiColors.grey),
                  onPressed: () {
                    setState(() {
                      this._articleNameCtr.text = '';
                    });
                    _focus.unfocus();
                  },
                ),
          filled: false,
        ),
      ),
      suggestionsCallback: (pattern) {
        final articlesStore =
            Provider.of<ArticlesStore>(context, listen: false);
        return articlesStore.getSuggestions;
      },
      itemBuilder: (context, String suggestion) {
        if (kIsWeb) {
          return suggestion == null || suggestion.isEmpty
              ? const SizedBox()
              : GestureDetector(
                  onPanDown: (_) {
                    _articleNameCtr.text = suggestion;
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 2, 0, 2),
                    child: ListTile(title: Text(suggestion)),
                  ));
        } else {
          return suggestion == null || suggestion.isEmpty
              ? const ListTile(title: const Text('no match'))
              : Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                  child: ListTile(title: Text(suggestion)),
                );
        }
      },

      noItemsFoundBuilder: (context) {
        return const Text("Aucun article correspondant");
      },
      onSuggestionSelected: (String suggestion) async {
        onSelected(suggestion);
      },
      transitionBuilder: (context, suggestionBox, controller) {
        return suggestionBox;
      },
    );
  }
}
