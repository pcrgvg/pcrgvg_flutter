import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pcrgvg_flutter/apis/pcrgvg_api.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/global/app_update.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/isolate/filter_task.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';
import 'base_provider.dart';

class HomeProvider extends BaseListProvider {
  HomeProvider() {
    init();
    // checkAppVersion();
    //  PcrDb.checkUpdate();
  }
  List<GvgTask> _gvgTaskListCache = [];
  List<GvgTask> _gvgTaskList = [];
  List<GvgTask> get gvgTaskList => _gvgTaskList;

  late GvgTaskFilterHive _gvgTaskFilter;
  GvgTaskFilterHive get gvgTaskFilter => _gvgTaskFilter;

  PcrDbVersion? pcrDbVersion;

  Future<void> init() async {
    _gvgTaskFilter =
        (MyHive.userConfBox.get(HiveDbKey.GvgTaskFilter) as GvgTaskFilterHive).copy();
  }

  @override
  Future<void> refresh() async {
    // await (this + init());
    final List<GvgTask> arr = await PcrGvgApi.getGvgTaskList(
        stage: _gvgTaskFilter.stage,
        server: _gvgTaskFilter.server,
        clanBattleId: _gvgTaskFilter.clanBattleId);
    dealGvgTask(arr);
    controller.refreshCompleted();
    '加载完成'.toast();
    notifyListeners();
  }

  /// 比对条件是否需要进行网络查询 /
  Future<void> changeFilter(GvgTaskFilterHive filter) async {
    MyHive.userConfBox.put(HiveDbKey.GvgTaskFilter, filter);
    if (filter.clanBattleId != gvgTaskFilter.clanBattleId ||
        filter.stage != gvgTaskFilter.stage ||
        filter.server != gvgTaskFilter.server) {
      _gvgTaskFilter = filter;
      controller.requestRefresh();
      // refresh();
    } else {
      _gvgTaskFilter = filter;
      fiterGvgTask();
      notifyListeners();
    }
  }

  /// 按照伤害排序 /
  void dealGvgTask(List<GvgTask> arr) {
    // ignore: avoid_function_literals_in_foreach_calls
    arr.forEach((GvgTask g) {
      g.tasks.sort((Task a, Task b) => b.damage - a.damage);
      // ignore: avoid_function_literals_in_foreach_calls
      g.tasks.forEach((Task t) {
        t.charas
            .sort((Chara c, Chara d) => d.searchAreaWidth - c.searchAreaWidth);
      });
    });
    _gvgTaskListCache = arr;
    fiterGvgTask();
  }

  void fiterGvgTask() {
    final List<GvgTask> cacheList =
        _gvgTaskListCache.map((e) => e.clone()).toList();
    final List<GvgTask> tempList = [];
    for (int i = 0; i < cacheList.length; i++) {
      final GvgTask gvgTask = cacheList[i];
      if (_gvgTaskFilter.bossNumber.contains(i + 1)) {
        gvgTask.tasks.retainWhere((Task task) {
          bool b = false;
          switch (_gvgTaskFilter.usedOrRemoved) {
            case TaskType.used:
              b = MyHive.usedBox.values
                  .any((int element) => element == task.id);
              break;
            case TaskType.removed:
              b = MyHive.removedBox.values
                  .any((int element) => element == task.id);
              break;
            case TaskType.tail:
              b = task.type == 1;
              break;
            case TaskType.all:
            default:
              b = true;
          }
          if (b) {
            for (final int canAuto in task.canAuto) {
              final bool isHaved = _gvgTaskFilter.methods.contains(canAuto);
              if (isHaved) {
                return true;
              }
            }
          }

          return false;
        });
        tempList.add(gvgTask);
      }
    }
    _gvgTaskList = tempList;
  }

  @override
  Future<void> loadMore() async {}

  Future<List<ResultBoss>> filterIsolate() async {
    final List<int> removedList = MyHive.removedBox.values.toList();
    final List<int> usedList = MyHive.usedBox.values.toList();
    final Box<Chara> charaBox = MyHive.getServerCharaBox(_gvgTaskFilter.server);
    final List<int> unHaveCharaList =
        charaBox.values.map((Chara e) => e.prefabId).toList();
    final List<ResultBoss> bossList = [];
    final List<GvgTask> taskList = [];
    for (final GvgTask item in _gvgTaskList) {
      final GvgTask gvgTask = item.clone();
      for (final Task task in gvgTask.tasks) {
        task.damage = typeDamage(task);
      }
      taskList.add(gvgTask);
      bossList.add(ResultBoss(prefabId: gvgTask.prefabId, id: gvgTask.id));
    }
    if (taskList.isEmpty) {
      '至少选择一个boss'.toast();
      return [];
    }
    final List<List<TaskFilterResult>> res = await isolateFilter(
        FilterIsolateConfig(
            removeList: removedList,
            usedList: usedList,
            taskList: _gvgTaskList,
            unHaveCharaList: unHaveCharaList));
    MyStore.filterResList = res;
    return bossList;
  }

  // 如果包含手动，则使用damage， 如果不包含且有自动刀的伤害显示自动刀的伤害
  int typeDamage(Task task) {
    if (_gvgTaskFilter.methods.contains(AutoType.manual)) {
      return task.damage;
    }
    return task.autoDamage ?? task.damage;
  }


}
