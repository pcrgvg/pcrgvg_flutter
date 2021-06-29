import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'base_provider.dart';

class HomeFilterProvider extends CancelableBaseModel {
  HomeFilterProvider() {
    init();
  }
  final RefreshController _refreshController = RefreshController();
  RefreshController get refreshController => _refreshController;
  late GvgTaskFilterHive _gvgTaskFilter;
  GvgTaskFilterHive get gvgTaskFilter => _gvgTaskFilter;

  List<UnitBoss> _bossList = [];
  List<UnitBoss> get bossList => _bossList;

  List<ClanPeriod> _clanPeriodList = [];
  List<ClanPeriod> get clanPeriodList => _clanPeriodList;

  Future<void> init() async { 
    await _initGvgTaskFilter();
    refresh();
    notifyListeners();
  }

  Future<void> _initGvgTaskFilter() async {
    _gvgTaskFilter =
        MyHive.userConfBox.get(HiveDbKey.GvgTaskFilter) as GvgTaskFilterHive;
    await getPeriods();
    final ClanPeriod lastPeriod = clanPeriodList.last;
    if (_gvgTaskFilter.clanBattleId == 1 ||
        _gvgTaskFilter.clanBattleId != lastPeriod.clanBattleId) {
      // 1的时候为第一次默认值
      _gvgTaskFilter.clanBattleId = lastPeriod.clanBattleId;
      await getBoss();
      _gvgTaskFilter.bossPrefabs =
          _bossList.map((UnitBoss boss) => boss.prefabId).toList();
      MyHive.userConfBox.put(HiveDbKey.GvgTaskFilter, _gvgTaskFilter);
    }
  }

  Future<void> getPeriods() async {
    final List<ClanPeriod> periods =
        await PcrDb.getPeriods(_gvgTaskFilter.server);
    _clanPeriodList = periods.map((ClanPeriod period) {
      final String startTime = period.startTime
          .replaceAll('/', '-')
          .replaceAll(RegExp(r'\s\S*'), '');
      period.startTime = startTime;
      return period;
    }).toList();
  }

  Future<void> getBoss() async {
    _bossList =
        await PcrDb.getBoss(_gvgTaskFilter.server, _gvgTaskFilter.clanBattleId);
  }

  Future<void> refresh() async {
    _refreshController.refreshCompleted();
  }

  Future<void> setServer(String server) async {
    if (_gvgTaskFilter.server == server) {
      return;
    }
    _gvgTaskFilter.server = server;
    await getPeriods();
    notifyListeners();
  }

  Future<void> setClanPeriod(ClanPeriod clanPeriod) async {
    _gvgTaskFilter.clanBattleId = clanPeriod.clanBattleId;
    _gvgTaskFilter.startTime = clanPeriod.startTime;
    await getBoss();
    notifyListeners();
  }

  Future<void> setBoss(int prefabId) async {
    final List<int> bossPrefabs = List.from(_gvgTaskFilter.bossPrefabs);
    if (bossPrefabs.contains(prefabId)) {
      bossPrefabs.remove(prefabId);
    } else {
      bossPrefabs.add(prefabId);
    }
    _gvgTaskFilter.bossPrefabs = bossPrefabs;
    notifyListeners();
  }
}
