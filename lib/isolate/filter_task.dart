import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';

Future<List<List<TaskFilterResult>>> isolateFilter(
    FilterIsolateConfig _isolateConfig) async {
  return await compute<FilterIsolateConfig, List<List<TaskFilterResult>>>(
      filterTask, _isolateConfig);
}

/// 顶层函数在打包时候就初始化,此时main run里面的初始化均未执行
FutureOr<List<List<TaskFilterResult>>> filterTask(
    FilterIsolateConfig _isolateConfig) async {
  final List<TaskFilterResult> flatTaskList =
      flatTask(_isolateConfig.taskList, _isolateConfig.removeList);
  final List<List<TaskFilterResult>> combineResult = combine(flatTaskList, 3);
   List<List<TaskFilterResult>> result = filterResult(
    taskList: combineResult,
    unHaveCharas: _isolateConfig.unHaveCharaList,
    usedList: _isolateConfig.usedList,
  );
  if (result.isEmpty) {
    final List<List<TaskFilterResult>> combineResult = combine(flatTaskList, 2);
    List<List<TaskFilterResult>> result = filterResult(
      taskList: combineResult,
      unHaveCharas: _isolateConfig.unHaveCharaList,
      usedList: _isolateConfig.usedList,
    );
  }
  if (result.isEmpty) {
    final List<List<TaskFilterResult>> combineResult = combine(flatTaskList, 1);
    List<List<TaskFilterResult>> result = filterResult(
      taskList: combineResult,
      unHaveCharas: _isolateConfig.unHaveCharaList,
      usedList: _isolateConfig.usedList,
    );
  }
  return result;
}

List<List<TaskFilterResult>> filterResult(
    {required List<List<TaskFilterResult>> taskList,
    required List<Chara> unHaveCharas,
    required List<int> usedList}) {
  // 依次为包含0/1/2/3个已使用作业组
  final List<List<List<TaskFilterResult>>> tempArr = [[], [], [], []];
  for (final List<TaskFilterResult> tasks in taskList) {
    final Set<int> set = <int>{};
    // 重复的角色
    final List<int> repeartCharaIdList = [];
    // 当前组合使用的角色
    final List<Chara> charaList = [];
    // 获取重复角色
    for (final TaskFilterResult task in tasks) {
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
        taskList: tasks);
    if (arr.isNotEmpty) {
      final int usedCount = countUsed(arr, usedList);
      tempArr[usedCount].add(arr);
    }
  }
  // 感觉有问题
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
            el.task.damage * scoreFactor[el.task.stage]![el.index]!);
    final double bScore = b.fold(
        0,
        (double previousValue, TaskFilterResult el) =>
            previousValue +
            el.task.damage * scoreFactor[el.task.stage]![el.index]!);
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

  final List<TaskFilterResult> tempList = taskList.map((TaskFilterResult task) {
    final dynamic json = jsonDecode(jsonEncode(task));
    return TaskFilterResult(
        bossId: json['bossId'] as int,
        index: json['index'] as int,
        prefabId: json['prefabId'] as int,
        task: Task.fromJson(json['task'] as Map<String, dynamic>));
  }).toList();

  for (final TaskFilterResult filterResult in tempList) {
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
    if (unHaveChara != null) {
      final int charaCount = map[unHaveChara.prefabId] ?? 0;
      if (charaCount > 0 && filterResult.borrowChara == null) {
        filterResult.borrowChara = unHaveChara;
        map[unHaveChara.prefabId] = charaCount - 1;
        continue;
      }
    }
    // 借重复的角色
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
    return tempList;
  }
  return [];
}

List<int> filterUnHaveCharas(List<Chara> charas, List<Chara> unHaveChras) {
  final List<int> result = [];
  for (final Chara chara in unHaveChras) {
    if (charas.indexWhere((e) => e.prefabId == chara.prefabId) > -1) {
      result.add(chara.prefabId);
    }
  }
  return result;
}

/// 将List<TaskFilterResult> 转为以k个为一组的List<List<TaskFilterResult>>
List<List<TaskFilterResult>> combine(List<TaskFilterResult> taskList, int k) {
  final List<List<TaskFilterResult>> result = [];
  final List<TaskFilterResult> subResult = [];
  void combineSub(int start, List<TaskFilterResult> subResult) {
    if (subResult.length == k) {
      result.add(List<TaskFilterResult>.from(subResult));
      return;
    }
    final int len = subResult.length;
    // 还需要多少个元素才能符合条件，若taskList剩余的长度不够，则不符合继续循环
    final int conditionLen = taskList.length - (k - len) + 1;
    for (int i = 0; i < conditionLen; i++) {
      subResult.add(taskList[i]);
      combineSub(i + 1, subResult);
      subResult.removeLast();
    }
  }

  combineSub(0, subResult);
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
            index: gvgTask.index));
      }
    }
  }

  return result;
}

class TaskFilterResult {
  TaskFilterResult(
      {required this.bossId,
      required this.prefabId,
      required this.index,
      required this.task,
      this.borrowChara});
  int bossId;
  int prefabId;
  Chara? borrowChara;
  int index;
  Task task;
  Map<String, dynamic> toJson() => <String, dynamic>{ 
    "bossId": bossId,
    "prefabId": prefabId,
    "borrowChara": borrowChara,
    "index":index,
    "task": task
  };
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
  List<Chara> unHaveCharaList;
}
