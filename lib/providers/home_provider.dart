import 'package:pcrgvg_flutter/apis/pcrgvg_api.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'base_provider.dart';

class HomeProvider extends CancelableBaseModel {
  HomeProvider() {
    init();
  }
  int _page = 0;
  List<Chara> _charList = [];
  List<Chara> get charList => _charList;

  List<GvgTask> _gvgTaskList = [];
  List<GvgTask> get gvgTaskList => _gvgTaskList;
  final RefreshController _controller = RefreshController();
  RefreshController get controller => _controller;
  bool _hasScrolled = true;
  bool get hasScrolled => _hasScrolled;
  set hasScrolled(bool value) {
    if (value != _hasScrolled) {
      _hasScrolled = value;
      notifyListeners();
    }
  }

  late GvgTaskFilterHive _gvgTaskFilter;
  GvgTaskFilterHive get gvgTaskFilter => _gvgTaskFilter;

  Future<void> init() async {
    _gvgTaskFilter =
        MyHive.userConfBox.get(HiveDbKey.GvgTaskFilter) as GvgTaskFilterHive;
    _gvgTaskList = await PcrGvgApi.getGvgTaskList(
        stage: 1, server: 'jp', clanBattleId: 1040);
     notifyListeners();
  }

  Future<void> refresh() async {
    _page = 0;
    await (this + _loadList());
    controller.refreshCompleted();
    '加载完成'.toast();
  }

  Future<void> loadMore() async {
    _page++;
    await (this + _loadList());
    controller.loadComplete();
  }

  Future<void> _loadList() async {
    _charList = await PcrDb.charaList(ServerType.jp);

    notifyListeners();
  }
}
