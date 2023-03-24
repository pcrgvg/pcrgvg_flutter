import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pcrgvg_flutter/apis/pcrgvg_api.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/global/app_update.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/global/redive.dart';
import 'package:pcrgvg_flutter/isolate/filter_task.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';
import 'base_provider.dart';

class HomeProvider extends BaseListProvider {
  HomeProvider() {
    init();

    PcrDb.checkUpdate();
    checkAppVersion();
  }
  List<GvgTask> _gvgTaskListCache = [];
  List<GvgTask> _gvgTaskList = [];
  List<GvgTask> get gvgTaskList => _gvgTaskList;

  late GvgTaskFilterHive _gvgTaskFilter;
  GvgTaskFilterHive get gvgTaskFilter => _gvgTaskFilter;
  String stageLabel = '1';
  bool _showRightControll = false;
  bool get showRightControll => _showRightControll;
  set showRightControll(bool value) {
    if (value != _showRightControll) {
      _showRightControll = value;
      notifyListeners();
    }
  }

  final List<GlobalKey> _keyList = <GlobalKey>[];
  List<GlobalKey> get keyList => _keyList;

  PcrDbVersion? pcrDbVersion;
  final ScrollController scrollController = ScrollController();

  Future<void> init() async {
    _gvgTaskFilter =
        (MyHive.userConfBox.get(HiveDbKey.GvgTaskFilter) as GvgTaskFilterHive)
            .copy();
    createKeyList();
  }

  @override
  Future<void> refresh() async {
    final List<GvgTask> arr = await PcrGvgApi.getGvgTaskList(
        stage: _gvgTaskFilter.stage,
        server: _gvgTaskFilter.server,
        clanBattleId: _gvgTaskFilter.clanBattleId);
    dealGvgTask(arr);
    controller.refreshCompleted();
    setStageString();
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
      setStageString();
      notifyListeners();
    }
  }

  /// 按照伤害排序 /
  void dealGvgTask(List<GvgTask> arr) {
    // ignore: avoid_function_literals_in_foreach_calls
    arr.forEach((GvgTask g) {
      g.tasks.sort((Task a, Task b) => typeDamage(b) - typeDamage(a));
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
        gvgTask.tasks.retainWhere((task) {
          for (final int canAuto in task.canAuto) {
            final bool isHaved = _gvgTaskFilter.methods.contains(canAuto);
            if (isHaved) {
              return true;
            }
          }
          return false;
        });
        filterTaskType(gvgTask.tasks);
        tempList.add(gvgTask);
      }
    }
    _gvgTaskList = tempList;
  }

  void filterTaskType(List<Task> result) {
    if (!_gvgTaskFilter.taskTypes.contains(TaskType.tail)) {
      result.retainWhere((task) => task.type != 1);
    }
    if (!_gvgTaskFilter.taskTypes.contains(TaskType.removed)) {
      result.retainWhere((task) => !MyHive.removedBox.values.contains(task.id));
    }

    if (!_gvgTaskFilter.taskTypes.contains(TaskType.used)) {
      result.retainWhere((task) => !MyHive.usedBox.values.contains(task.id));
    }
    if (!_gvgTaskFilter.taskTypes.contains(TaskType.all)) {
      result.retainWhere((task) =>
          task.type == 1 ||
          MyHive.usedBox.values.contains(task.id) ||
          MyHive.removedBox.values.contains(task.id));
    }
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
            taskList: taskList,
            unHaveCharaList: unHaveCharaList));
    MyStore.filterResList = res;
    return bossList;
  }

  // 如果包含手动，则使用damage， 如果不包含且有自动刀的伤害显示自动刀的伤害
  int typeDamage(Task task) {
    int? damage;
    if (_gvgTaskFilter.methods.contains(AutoType.manual) &&
        task.canAuto.contains(AutoType.manual)) {
      damage = task.damage;
    }
    if (_gvgTaskFilter.methods.contains(AutoType.harfAuto) &&
        task.canAuto.contains(AutoType.harfAuto)) {
      damage = damage ?? task.halfAutoDamage;
    }
    if (_gvgTaskFilter.methods.contains(AutoType.easyManual) &&
        task.canAuto.contains(AutoType.easyManual)) {
      damage = damage ?? task.easyManualDamage;
    }
    return damage ?? task.autoDamage ?? 0;
  }

  void setStageString() {
    stageLabel =
        setStageOption(_gvgTaskFilter.clanBattleId, _gvgTaskFilter.server)
            .firstWhere((LvPair a) => a.value == _gvgTaskFilter.stage,
                orElse: () => LvPair(value: 1, label: '1'))
            .label;
  }

  void scrollTo(int index) {
    // keyList[index].currentContext?.findRenderObject()
    // scrollController.jumpTo(0);
    if (index == 0) {
      // 会错位。。待解决
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    } else {
      Scrollable.ensureVisible(keyList[index].currentContext!);
    }

    // scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  void createKeyList() {
    for (final int item in List<int>.filled(5, 1)) {
      _keyList.add(GlobalKey());
    }
  }

  void checkAppVersion() {
    final int nowDate = DateTime.now().millisecondsSinceEpoch;
    final int lastUpdateTime =
        MyHive.userConfBox.get(HiveDbKey.AppCheckDate, defaultValue: 0) as int;
    const int DayMs = 24 * 60 * 60 * 1000;
    if (nowDate - lastUpdateTime > DayMs) {
      AppUpgrade.checkAppVersion();
    }
  }
}
