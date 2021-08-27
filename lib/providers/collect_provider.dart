import 'package:hive/hive.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/global/collection.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/isolate/filter_task.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';

import 'base_provider.dart';

class CollectProvider extends BaseListProvider {
  CollectProvider() {
    init();
  }
  late final String serverType;
  List<List<TaskFilterResult>> collectionList = <List<TaskFilterResult>>[];
   List<int> usedList = <int>[];

  void init() {
    serverType =
        (MyHive.userConfBox.get(HiveDbKey.GvgTaskFilter) as GvgTaskFilterHive)
            .server;
         
   
  }

  @override
  Future<void> refresh() async {
     collectionList = Collection.getCollection(serverType);
       usedList = MyHive.usedBox.values.toList();
    Future<void>.delayed(const Duration(milliseconds: 500))
        .then((_) => controller.refreshCompleted());
  }

   bool changeCollect(List<TaskFilterResult> item) {
    final List<List<TaskFilterResult>> arr = [...collectionList];
    final int index =  Collection.indexOfCollection(item, arr);
    if (index > -1) {
      arr.removeAt(index);
    } else {
      arr.add(item);
    }
    MyHive.collectBox.put(serverType, arr);
    collectionList = arr;
    return false;
  }


  @override
  Future<void> loadMore() async {}
}
