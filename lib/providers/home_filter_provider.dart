import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/global/redive.dart';
import 'package:pcrgvg_flutter/model/models.dart';

import 'base_provider.dart';

class HomeFilterProvider extends BaseListProvider {
  HomeFilterProvider():super(initialRefresh: false) {
   init();
  }
  late GvgTaskFilterHive _gvgTaskFilter;
  GvgTaskFilterHive get gvgTaskFilter => _gvgTaskFilter;

  List<ClanPeriod> _clanPeriodList = [];
  List<ClanPeriod> get clanPeriodList => _clanPeriodList;

  List<LvPair> _stageOption = [];
  List<LvPair> get stageOption => _stageOption;

  Future<void> init() async {
    await _initGvgTaskFilter();
    notifyListeners();
  }

  

  Future<void> _initGvgTaskFilter() async {
    _gvgTaskFilter =
        (MyHive.userConfBox.get(HiveDbKey.GvgTaskFilter) as GvgTaskFilterHive).copy();
    await getPeriods();
    final ClanPeriod lastPeriod = clanPeriodList.first;
    if (_gvgTaskFilter.clanBattleId == 1) {
      // 1的时候为第一次默认值
      _gvgTaskFilter.clanBattleId = lastPeriod.clanBattleId;
      _gvgTaskFilter.startTime = lastPeriod.startTime;
      MyHive.userConfBox.put(HiveDbKey.GvgTaskFilter, _gvgTaskFilter);
    }
   _stageOption = setStageOption(_gvgTaskFilter.clanBattleId, _gvgTaskFilter.server);
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
    // if(periods.indexWhere((ClanPeriod a) => a.clanBattleId == _gvgTaskFilter.clanBattleId) == -1)  {
    //   _gvgTaskFilter.clanBattleId = periods.first.clanBattleId;
    // }
  }


  @override
  Future<void> refresh() async {
  }

  Future<void> setServer(String server) async {
    if (_gvgTaskFilter.server == server) {
      return;
    }
    _gvgTaskFilter.server = server;
    await getPeriods();
    setClanPeriod(clanPeriodList.first);
    notifyListeners();
  }

  Future<void> setClanPeriod(ClanPeriod clanPeriod) async {
    _gvgTaskFilter.clanBattleId = clanPeriod.clanBattleId;
    _gvgTaskFilter.startTime = clanPeriod.startTime;
    _stageOption = setStageOption(_gvgTaskFilter.clanBattleId, _gvgTaskFilter.server);
    setStage(_stageOption.first.value as int);
    notifyListeners();
  }

  Future<void> setBoss(int number) async {
    final List<int> bossNumberList = List<int>.from(gvgTaskFilter.bossNumber);
    if (bossNumberList.contains(number)) {
      bossNumberList.remove(number);
    } else {
      bossNumberList.add(number);
    }
    _gvgTaskFilter.bossNumber = bossNumberList;
    notifyListeners();
  }

  Future<void> setStage(int stage) async {
    _gvgTaskFilter.stage = stage;
    notifyListeners();
  }

  Future<void> setMethods(int type) async {
    final List<int> methodList = List<int>.from(_gvgTaskFilter.methods);
    if (methodList.contains(type)) {
      methodList.remove(type);
    } else {
      methodList.add(type);
    }
    _gvgTaskFilter.methods = methodList;
    notifyListeners();
  }


  // 
  void setTaskTypes(String type) {
    final list = [..._gvgTaskFilter.taskTypes]; 
    if (list.contains(type)) {
      list.remove(type);
    } else {
      list.add(type);
    }
    _gvgTaskFilter.taskTypes = list;
    notifyListeners();
  }

  @override
  Future<void> loadMore() {
    throw UnimplementedError();
  }
}
