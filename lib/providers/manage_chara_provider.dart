import 'package:hive/hive.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';

import 'base_provider.dart';

class ManageCharaProvider extends BaseListProvider {
  ManageCharaProvider() : super(initialRefresh: true) {
    init();
  }

  int _showType = 1; // 1 全部，2已选中 3 未选中
  int get showType => _showType;
  set showType(int value) {
    if (value != _showType) {
      _showType = value;
      notifyListeners();
    }
  }

  late GvgTaskFilterHive _gvgTaskFilter;
  GvgTaskFilterHive get gvgTaskFilter => _gvgTaskFilter;
  List<Chara> charaList = [];
  String _serverType = '';
  String get serverType => _serverType;
  set serverType(String value) {
    if (_serverType != value) {
      _serverType = value;
      final Box<Chara> box = getCharaBox(value);
      hiveCharaList = box.values.toList();
      getCharaList();
      notifyListeners();
    }
  }

  List<Chara> hiveCharaList = [];

  void init() {
    serverType =
        (MyHive.userConfBox.get(HiveDbKey.GvgTaskFilter) as GvgTaskFilterHive)
            .server;
  }

  Box<Chara> getCharaBox(String serverType) {
    return MyHive.getServerCharaBox(serverType);
  }

  void getCharaList() {
    PcrDb.charaList(serverType).then((List<Chara> value) {
      charaList = value;
      notifyListeners();
      Future<void>.delayed(const Duration(milliseconds: 800)).then((_) => controller.refreshCompleted());
    });
  }

  void addChara(Chara chara) {
    final Box<Chara> box = getCharaBox(serverType);
    final int index = hiveCharaList
        .indexWhere((Chara element) => element.prefabId == chara.prefabId);
    final List<Chara> list = [...hiveCharaList];
    if (index > -1) {
      list.removeAt(index);
      box.deleteAt(index);
    } else {
      list.add(chara);
      box.add(chara);
    }
    hiveCharaList = list;
    notifyListeners();
  }

  @override
  Future<void> refresh() async {
    init();
  }

  @override
  Future<void> loadMore() async {}
}
