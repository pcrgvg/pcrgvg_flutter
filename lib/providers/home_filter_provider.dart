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

  List<UnitBoss> _bossList  = [];
  List<UnitBoss> get bossList  => _bossList;

  Future<void> init() async {
     await _initGvgTaskFilter();
     refresh();
  }

  Future<void> _initGvgTaskFilter() async {
    _gvgTaskFilter =
        MyHive.userConfBox.get(HiveDbKey.GvgTaskFilter) as GvgTaskFilterHive;
    final List<ClanPeriod> clanPeriodList =
        await PcrDb.getPeriods(_gvgTaskFilter.server);
    final ClanPeriod lastPeriod = clanPeriodList.last;
    if (_gvgTaskFilter.clanBattleId == 1 || _gvgTaskFilter.clanBattleId != lastPeriod.clanBattleId) {
      // 1的时候为第一次默认值
      final List<UnitBoss> bossList =  await PcrDb.getBoss(_gvgTaskFilter.server, lastPeriod.clanBattleId);
     _gvgTaskFilter.bossPrefabs = bossList.map((UnitBoss boss) => boss.prefabId).toList();
     _bossList = bossList;
     MyHive.userConfBox.put(HiveDbKey.GvgTaskFilter, _gvgTaskFilter);
    } 
  }

  Future<void> refresh() async {
    // _refreshController.refreshCompleted();
  }
}
