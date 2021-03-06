import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/model/models.dart';

class Collection {
  static List<List<TaskFilterResult>> getCollection(String server) {
    final List<dynamic> arr = MyHive.collectBox.get(server) ?? <dynamic>[];
    final List<List<TaskFilterResult>> result = [];
    for (final item in arr) {
      if (item is List) {
        result.add(item.map((dynamic a) => a as TaskFilterResult).toList());
      }
    }
    return result;
  }

  static int indexOfCollection(List<TaskFilterResult> collection,
      List<List<TaskFilterResult>> collectionList) {
    final List<int> ids = collection.map((e) => e.task.id).toList()
      ..sort();
    for (int i = 0; i < collectionList.length; i++) {
       final List<int> ids1 = collectionList[i].map((e) => e.task.id).toList()..sort();
       if (ids.toString() == ids1.toString()) {
        return i;
      }
    }

    return -1;
  }
}
