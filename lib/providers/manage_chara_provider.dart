import 'package:hive/hive.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';

import 'base_provider.dart';

class ManageCharaProvider extends BaseListProvider {
  ManageCharaProvider() {
    init();
  }

  int showType = 1; // 1 全部，2已选中 3 未选中

  late GvgTaskFilterHive _gvgTaskFilter;
  GvgTaskFilterHive get gvgTaskFilter => _gvgTaskFilter;
  List<Chara> _charaList = [];
  late String _serverType;
  String get serverType => _serverType;
  set serverType(String value) {
    _serverType = value;
    final Box<Chara> box = getCharaBox(value);
     hiveCharaList = box.values.toList();
    getCharaList();
  }

  List<Chara> hiveCharaList = [];

  List<Chara> get front {
    return _charaList
        .where((Chara chara) => chara.searchAreaWidth < 300)
        .toList();
  }

  List<Chara> get middle {
    return _charaList
        .where((Chara chara) =>
            chara.searchAreaWidth > 300 && chara.searchAreaWidth < 600)
        .toList();
  }

  List<Chara> get back {
    return _charaList
        .where((Chara chara) => chara.searchAreaWidth > 600)
        .toList();
  }

  void init() {
    serverType =
        (MyHive.userConfBox.get(HiveDbKey.GvgTaskFilter) as GvgTaskFilterHive)
            .server;
  }

  Box<Chara> getCharaBox(String serverType) {
    if (serverType == ServerType.cn) {
      return MyHive.cnCharaBox;
    } else if (serverType == ServerType.jp) {
      return MyHive.jpCharaBox;
    } else {
      return MyHive.twCharaBox;
    }
  }

  void getCharaList() {
    PcrDb.charaList(serverType).then((List<Chara> value) {
      _charaList = value;
      notifyListeners();
    });
  }

  void addChara(Chara chara) {
    final box = getCharaBox(serverType);
    final int index = hiveCharaList
        .indexWhere((Chara element) => element.prefabId == chara.prefabId);
    if (index > -1) {
      hiveCharaList.removeAt(index);
      box.deleteAt(index);
    } else {
      hiveCharaList.add(chara);
      box.add(chara);
    }
  
    notifyListeners();
  }

  @override
  Future<void> refresh() async {}

  @override
  Future<void> loadMore() async {}
}
