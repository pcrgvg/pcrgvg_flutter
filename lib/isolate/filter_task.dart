import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';

Future<List<List<TaskFilterResult>>> isolateFilter(
    FilterIsolateConfig _isolateConfig) async {
  'isolate filter start'.debug();
  return await compute<FilterIsolateConfig, List<List<TaskFilterResult>>>(
      filterTask, _isolateConfig);
}

/// 顶层函数在打包时候就初始化,此时main run里面的初始化均未执行
FutureOr<List<List<TaskFilterResult>>> filterTask(
    FilterIsolateConfig _isolateConfig) async {
  final int startTime = DateTime.now().millisecondsSinceEpoch;
  final List<TaskFilterResult> flatTaskList =
      flatTask(_isolateConfig.taskList, _isolateConfig.removeList);
  List<List<TaskFilterResult>> result = combineAndFilter(
      flatTaskList, 3, _isolateConfig.unHaveCharaList, _isolateConfig.usedList);

  if (result.isEmpty) {
    result = combineAndFilter(flatTaskList, 2, _isolateConfig.unHaveCharaList,
        _isolateConfig.usedList);
  }
  if (result.isEmpty) {
    result = combineAndFilter(flatTaskList, 1, _isolateConfig.unHaveCharaList,
        _isolateConfig.usedList);
  }

  final int endTime = DateTime.now().millisecondsSinceEpoch;
  ((endTime - startTime) / 1000).debug();
  'isolate filter end'.debug();
  return result;
}

void filterResult(
    {required List<TaskFilterResult> taskList,
    required List<int> unHaveCharas,
    required List<int> usedList,
    required List<List<List<TaskFilterResult>>> tempArr}) {
  final Set<int> set = <int>{};
  // 重复的角色
  final List<int> repeartCharaIdList = [];
  // 当前组合使用的角色
  final List<Chara> charaList = [];
  // 获取重复角色
  for (final TaskFilterResult task in taskList) {
    for (final Chara chara in task.task.charas) {
      charaList.addAll(task.task.charas);
      final int size = set.length;
      set.add(chara.prefabId);
      // 长度不变代表重复
      if (size == set.length) {
        repeartCharaIdList.add(chara.prefabId);
      }
    }
  }
  // 未拥有角色算作重复
  final List<int> unHaveList = filterUnHaveCharas(charaList, unHaveCharas);

  final List<TaskFilterResult> arr = repeatCondition(
      repeatCharas: repeartCharaIdList,
      unHaveCharas: unHaveList,
      taskList: taskList);
  if (arr.isNotEmpty) {
    final int usedCount = countUsed(arr, usedList);
    tempArr[usedCount].add(arr);
  }
}

// 排序
List<List<TaskFilterResult>> sortByScore(List<List<TaskFilterResult>> arr) {
  final List<List<TaskFilterResult>> result =
      List<List<TaskFilterResult>>.from(arr);
  const Map<int, Map<int, double>> scoreFactor = {
    1: {
      1: 1.2,
      2: 1.2,
      3: 1.3,
      4: 1.4,
      5: 1.5,
    },
    2: {
      1: 1.6,
      2: 1.6,
      3: 1.8,
      4: 1.9,
      5: 2,
    },
    3: {
      1: 2,
      2: 2,
      3: 2.4,
      4: 2.4,
      5: 2.6,
    },
    4: {
      1: 3.5,
      2: 3.5,
      3: 3.7,
      4: 3.8,
      5: 4.0,
    },
    5: {
      1: 3.5,
      2: 3.5,
      3: 3.7,
      4: 3.8,
      5: 4.0,
    },
    6: {
      1: 3.5,
      2: 3.5,
      3: 3.7,
      4: 3.8,
      5: 4.0,
    },
  };
  result.sort((a, b) {
    final double aScore = a.fold(
        0,
        (double previousValue, TaskFilterResult el) =>
            previousValue +
            el.task.damage! * scoreFactor[el.task.stage]![el.index]!);
    final double bScore = b.fold(
        0,
        (double previousValue, TaskFilterResult el) =>
            previousValue +
            el.task.damage! * scoreFactor[el.task.stage]![el.index]!);
    return bScore.compareTo(aScore);
  });
  return result;
}

/// 统计有多少已使用的
int countUsed(List<TaskFilterResult> list, List<int> usedList) {
  return list.fold(0, (int prev, TaskFilterResult el) {
    if (usedList.contains(el.task.id)) {
      return prev + 1;
    }
    return prev;
  });
}

/// 重复几次代表要借几次, 借完符合
/// [bool, List<TaskFilterResult>];
List<TaskFilterResult> repeatCondition(
    {required List<int> repeatCharas,
    required List<int> unHaveCharas,
    required List<TaskFilterResult> taskList}) {
  // 统计重复次数
  final Map<int, int> map = {};
  for (final int prefabId in [...unHaveCharas, ...repeatCharas]) {
    final int charaCount = map[prefabId] ?? 0;
    map[prefabId] = charaCount + 1;
  }
  // 优先处理fixed和未拥有

  for (final TaskFilterResult filterResult in taskList) {
    Chara? unHaveChara;
    // 若包含未拥有角色，该作业必定要借该角色
    for (final int item in unHaveCharas) {
      final int index = filterResult.task.charas
          .indexWhere((Chara chara) => chara.prefabId == item);
      if (index > -1) {
        unHaveChara = filterResult.task.charas[index];
        break;
      }
    }
    final Chara? fixedBorrowChara = filterResult.fixedBorrowChara;
    // 两者冲突
    if (fixedBorrowChara != null &&
        unHaveChara != null &&
        fixedBorrowChara.prefabId != unHaveChara.prefabId) {
      return [];
    }

    if (unHaveChara != null) {
      final int charaCount = map[unHaveChara.prefabId] ?? 0;
      if (charaCount > 0 && filterResult.borrowChara == null) {
        filterResult.borrowChara = unHaveChara;
        map[unHaveChara.prefabId] = charaCount - 1;
        continue;
      }
    }

    // 强制借人
    if (fixedBorrowChara != null) {
      filterResult.borrowChara = fixedBorrowChara;
      final int charaCount = map[fixedBorrowChara.prefabId] ?? 0;
      // 如果强制借用角色包含在重复角色中且在该使用角色合集里,重复-1;
      if (charaCount > 0) {
        for (final Chara chara in filterResult.task.charas) {
          if (repeatCharas.contains(chara.prefabId) &&
              chara.prefabId == fixedBorrowChara.prefabId) {
            map[fixedBorrowChara.prefabId] = charaCount - 1;
            break;
          }
        }
      }
    }
  }

  // 处理虽然有2个重复，但是另一个重复被fixed占用
  for (final TaskFilterResult filterResult in taskList) {
    if (filterResult.borrowChara != null) {
      continue;
    }
    Chara? repeateChara;
    int count = 0;
    for (final Chara chara in filterResult.task.charas) {
      final int charaCount = map[chara.prefabId] ?? 0;
      if (charaCount > 0) {
        repeateChara = chara;
        count++;
      }
    }
    if (count == 1) {
      filterResult.borrowChara = repeateChara;
      final int charaCount = map[repeateChara!.prefabId] ?? 0;
      map[repeateChara.prefabId] = charaCount - 1;
    }
  }
 // 借重复的角色
  for (final TaskFilterResult filterResult in taskList) {
   
    Chara? repeatChara;
    for (final int prefabId in repeatCharas) {
      final int index = filterResult.task.charas
          .indexWhere((Chara chara) => chara.prefabId == prefabId);
      if (index > -1) {
        repeatChara = filterResult.task.charas[index];
        final int charaCount = map[prefabId] ?? 0;
        if (charaCount > 0 && filterResult.borrowChara == null) {
          filterResult.borrowChara = repeatChara;
          map[prefabId] = charaCount - 1;
          break;
        }
      }
    }
  }

  final List<int> values = map.values.toList();
  if (values.every((int v) => v == 0)) {
    return taskList;
  }
  return [];
}

List<int> filterUnHaveCharas(List<Chara> charas, List<int> unHaveChras) {
  final List<int> result = [];
  for (final int prefabId in unHaveChras) {
    if (charas.indexWhere((Chara e) => e.prefabId == prefabId) > -1) {
      result.add(prefabId);
    }
  }
  return result;
}

/// 将List<TaskFilterResult> 转为以k个为一组的List<List<TaskFilterResult>>,同时过滤不符合条件的组合
List<List<TaskFilterResult>> combineAndFilter(List<TaskFilterResult> taskList,
    int k, List<int> unHaveCharas, List<int> usedList) {
  final List<TaskFilterResult> subResult = [];
  final List<List<List<TaskFilterResult>>> tempArr = [[], [], [], []];
  void combineSub(
    int start,
  ) {
    if (subResult.length == k) {
      // 长度符合时候,符合条件则放进tempArr
      filterResult(
          taskList: subResult.map((e) => e.copy()).toList(),
          unHaveCharas: unHaveCharas,
          tempArr: tempArr,
          usedList: usedList);
      return;
    }
    final int len = subResult.length;
    // 还需要多少个元素才能符合条件，若taskList剩余的长度不够，则不符合继续循环
    final int conditionLen = taskList.length - (k - len) + 1;
    for (int i = start; i < conditionLen; i++) {
      subResult.add(taskList[i]);
      combineSub(i + 1);
      subResult.removeLast();
    }
  }

  combineSub(0);
  final List<List<TaskFilterResult>> result = tempArr
      .map((e) => sortByScore(e))
      .toList()
      .reversed
      .fold([], (List<List<TaskFilterResult>> previousValue,
          List<List<TaskFilterResult>> element) {
    previousValue.addAll(element);
    return previousValue;
  });
  return result;
}

/// 转换为TaskFilterResult类型
List<TaskFilterResult> flatTask(List<GvgTask> taskList, List<int> removeList) {
  final List<TaskFilterResult> result = [];
  for (final GvgTask gvgTask in taskList) {
    for (final Task task in gvgTask.tasks) {
      // 1为尾刀不计入
      if (!removeList.contains(task.id) && task.type != 1) {
        result.add(TaskFilterResult(
            bossId: gvgTask.id,
            prefabId: gvgTask.prefabId,
            task: task,
            fixedBorrowChara: task.fixedBorrowChara,
            index: gvgTask.index));
      }
    }
  }

  return result;
}

class FilterIsolateConfig {
  FilterIsolateConfig(
      {required this.removeList,
      required this.taskList,
      required this.usedList,
      required this.unHaveCharaList});

  List<GvgTask> taskList;
  List<int> removeList;
  List<int> usedList;
  List<int> unHaveCharaList;
}
