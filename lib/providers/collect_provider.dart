import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/global/collection.dart';
import 'package:pcrgvg_flutter/model/models.dart';

import 'base_provider.dart';

class CollectProvider extends BaseListProvider {
  CollectProvider() {
    init();
  }
  late String serverType;
  List<List<TaskFilterResult>> collectionList = <List<TaskFilterResult>>[];

  void init() {
    serverType =
        (MyHive.userConfBox.get(HiveDbKey.GvgTaskFilter) as GvgTaskFilterHive)
            .server;
         
   
  }

  @override
  Future<void> refresh() async {
     collectionList = Collection.getCollection(serverType);
      notifyListeners();
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
    notifyListeners();
    return false;
  }

  void clearCollection() {
     MyHive.collectBox.put(serverType, []);
     collectionList = [];
     notifyListeners();
  }

  void changeServer(String server) {
    if (server != serverType) {
      serverType = server;
      refresh();
    }
  }

  @override
  Future<void> loadMore() async {}
}
