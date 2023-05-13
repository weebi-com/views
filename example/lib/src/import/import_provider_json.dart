import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:mixins_weebi/stores.dart' show ArticlesStore;
import 'package:models_weebi/weebi_models.dart';

import 'dart:convert';

import 'package:mixins_weebi/mobx_store_ticket.dart';
import 'package:models_weebi/extensions.dart';

// !  temporary hack this comes from weebi_app and is not yet modularized
abstract class ImportProviderAbstract extends ChangeNotifier {
  StringBuffer sb = StringBuffer();
  bool get isImportReady => _data.isNotEmpty;
  List<dynamic> _data = []; //  might be dups, we take the latest, keep List

  // ignore: unused_element
  void _writeInSb(String message) {
    sb.writeln(message);
    notifyListeners();
  }

  void _clearSbAndData() {
    sb.clear();
    _data = [];
    notifyListeners();
  }

  void _setDataToBeImported(dynamic filteredData) {
    if (filteredData.isEmpty) {
      return;
    } else {
      _writeInSb(sb.toString());
      _data = filteredData;
    }
    notifyListeners();
  }

  Future<bool> decodeFilterSetDataToBeImportedAndCheckAllDataFit<T>(
      T objectDummy, File file);
  // nextId and uniqueId not needed for json
  Future<int> addAllOnlyIfNoDup<T>(T store,
      {@required int nextId, @required String uniqueId});
  // nextId and uniqueId not needed for json
  Future<int> updateAllOnly<T>(T store, {@required String uniqueId});
}

class ImportProviderJson extends ImportProviderAbstract {
  @override
  Future<bool> decodeFilterSetDataToBeImportedAndCheckAllDataFit<T>(
      T objectDummy, File file) async {
    if (file.path.isEmpty) {
      return false;
    }
    final loadedJsonFile = await file.readAsString();
    final decoded = jsonDecode(loadedJsonFile);

    if (decoded.isEmpty) {
      _writeInSb('le fichier est vide');
      return false;
    }

    if (objectDummy.runtimeType.hashCode ==
        ArticleLine.dummy.runtimeType.hashCode) {
      final deserialisedJson = <ArticleLine>[];
      deserialisedJson.addAll(List<ArticleLine>.from(decoded
          .cast<Map>()
          .cast<Map<String, dynamic>>()
          .map((e) => ArticleLine.fromMap(e))));
      _setDataToBeImported(deserialisedJson);
    } else if (objectDummy.runtimeType.hashCode ==
        Herder.dummy.runtimeType.hashCode) {
      final deserialisedJson = <Herder>[];
      deserialisedJson.addAll(List<Herder>.from(decoded
          .cast<Map>()
          .cast<Map<String, dynamic>>()
          .map((e) => Herder.fromMap(e))));
      _setDataToBeImported(deserialisedJson);
    } else if (objectDummy.runtimeType == TicketWeebi) {
      final deserialisedJson = <TicketWeebi>[];
      deserialisedJson.addAll(List<TicketWeebi>.from(decoded
          .cast<Map>()
          .cast<Map<String, dynamic>>()
          .map((e) => TicketWeebi.fromMap(e))));
      _setDataToBeImported(deserialisedJson);
    } else {
      throw ('objectDummy.runtimeType found no match');
    }
    return true;
  }

  @override
  Future<int> addAllOnlyIfNoDup<T>(T store,
      {@required int nextId, @required String uniqueId}) async {
    if (isImportReady) {
      var count = 0;
      switch (store.runtimeType) {
        case ArticlesStore:
          final twoLists =
              (store as ArticlesStore).lines.findDupsById(newList: _data);
          if (twoLists.noDups.isNotEmpty) {
            count = await (store as ArticlesStore)
                .addAllArticleLine(twoLists.noDups);
          }
          _clearSbAndData();
          return count;
          break;
        // case HerdersStore:
        //   final twoLists =
        //       (store as HerdersStore).herders.findDupsById(newList: _data);
        //   if (twoLists.noDups.isNotEmpty) {
        //     count =
        //         await (store as HerdersStore).addAllHerders(twoLists.noDups);
        //   }
        //   _clearSbAndData();
        //   return count;
        //   break;
        case TicketsStore:
          final twoLists =
              (store as TicketsStore).tickets.filterById(newList: _data);
          var setTickets = <TicketWeebi>{};
          if (twoLists.noDups.isNotEmpty) {
            setTickets = await (store as TicketsStore)
                .addAllTickets(twoLists.noDups.toSet());
          }
          _clearSbAndData();
          return setTickets.length;
          break;
        default:
          print('no match');
      }
    }
    _clearSbAndData();
    return 0;
  }

  Future<int> upsertAll<T>(T store, {int nextId, String uniqueId}) async {
    if (isImportReady == false) {
      return 0;
    }
    var count = 0;
    switch (store.runtimeType) {
      case ArticlesStore:
        if (_data.isNotEmpty) {
          count = await (store as ArticlesStore).upsertAllBasedOnId(_data);
        }
        _clearSbAndData();
        return count;
        break;
      // case HerdersStore:
      //   if (_data.isNotEmpty) {
      //     count = await (store as HerdersStore).upsertAllBasedOnId(_data);
      //   }
      //   _clearSbAndData();
      //   return count;
      //   break;
      case TicketsStore:
        throw 'never update a ticket';
        break;
      default:
        print('no match');
        _clearSbAndData();
        return 0;
    }
  }

  @override
  Future<int> updateAllOnly<T>(T store, {@required String uniqueId}) async {
    if (isImportReady == false) {
      return 0;
    }
    var count = 0;
    switch (store.runtimeType) {
      case ArticlesStore:
        final twoLists =
            (store as ArticlesStore).lines.findDupsById(newList: _data);
        if (twoLists.dups.isNotEmpty) {
          for (var i = 0; i < twoLists.dups.length; i++) {
            await (store as ArticlesStore).updateLineArticle(twoLists.dups[i]);
            count += 1;
          }
        }
        _clearSbAndData();
        return count;
        break;
      // case HerdersStore:
      //   final twoLists =
      //       (store as HerdersStore).herders.findDupsById(newList: _data);
      //   if (twoLists.dups.isNotEmpty) {
      //     for (var i = 0; i < twoLists.dups.length; i++) {
      //       await (store as HerdersStore).updateHerder(twoLists.dups[i]);
      //       count += 1;
      //     }
      //   }
      //   _clearSbAndData();
      //   return count;
      //   break;
      case TicketsStore:
        throw 'never update a ticket';
        break;
      default:
        print('no match');
        _clearSbAndData();
        return 0;
    }
  }
}
