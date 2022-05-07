import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/global/collection.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';

import 'base_provider.dart';

class ResultProvider extends BaseListProvider {
  ResultProvider(this.resultBossList) : super(initialRefresh: false) {
    init();
  }

  late final String serverType;
  late final List<List<TaskFilterResult>> _resultListTemp;
  List<int> usedList = <int>[];
  List<List<TaskFilterResult>> resultList = <List<TaskFilterResult>>[];
  List<ResultBoss> resultBossList = <ResultBoss>[];
  List<int> _bossSet = <int>[];
  List<int> get bossSet => _bossSet;
  List<List<TaskFilterResult>> collectionTask = [];

  void init() {
    serverType =
        (MyHive.userConfBox.get(HiveDbKey.GvgTaskFilter) as GvgTaskFilterHive)
            .server;
    _resultListTemp = MyStore.filterResList;
    usedList = MyHive.usedBox.values.toList();
    collectionTask = Collection.getCollection(serverType);
    filterByBoss();
  }

  void filterByBoss() {
    resultList = _resultListTemp;
    notifyListeners();
  }

  void changeBossSet(int prefabId) {
    final List<int> arr = <int>[..._bossSet];
    final int index = arr.indexOf(prefabId);
    if (index > -1) {
      arr.removeAt(index);
    } else {
      arr.add(prefabId);
    }
    _bossSet = arr;
    notifyListeners();
  }

  void changeBossCount(int count, ResultBoss boss) {
    if (count != boss.count) {
      final List<ResultBoss> arr =
          resultBossList.map((ResultBoss e) => e.copy()).toList();
      final int index =
          arr.indexWhere((ResultBoss a) => a.prefabId == boss.prefabId);
      arr[index].count = count;
      resultBossList = arr;
      notifyListeners();
    }
  }

  bool filterTask() {
    final List<ResultBoss> temp = resultBossList
        .where((ResultBoss a) => _bossSet.contains(a.prefabId))
        .toList();
    final int total = temp.fold(
        0, (int previousValue, ResultBoss a) => a.count + previousValue);
    if (total > 3) {
      '选中总数大于3'.toast();
      return false;
    }

    if (_bossSet.isNotEmpty) {
      final List<List<TaskFilterResult>> arr = [];
      for (final List<TaskFilterResult> itemList in _resultListTemp) {
        final Map<int, int> map = <int, int>{};
        for (final ResultBoss boss in temp) {
          map[boss.prefabId] = boss.count;
        }
        for (final TaskFilterResult item in itemList) {
          if (map.containsKey(item.prefabId)) {
            final int count = map[item.prefabId] ?? 0;
            map[item.prefabId] = count - 1;
          }
        }
        if (map.values.every((int element) => element == 0)) {
          arr.add(itemList);
        }
      }
      resultList = arr;
    } else {
      resultList = _resultListTemp;
    }
    notifyListeners();
    return true;
  }

  bool changeCollect(List<TaskFilterResult> item) {
    final List<List<TaskFilterResult>> arr = <List<TaskFilterResult>>[...collectionTask];
    final int index = Collection.indexOfCollection(item, arr);
    if (index > -1) {
      arr.removeAt(index);
    } else {
      '收藏成功'.toast();
      arr.add(item);
    }
    MyHive.collectBox.put(serverType, arr);
    collectionTask = arr;
    return false;
  }

  @override
  Future<void> refresh() async {}

  @override
  Future<void> loadMore() async {}

  @override
  void dispose() {
    MyStore.filterResList = [];
    super.dispose();
  }
}
