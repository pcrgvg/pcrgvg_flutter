import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'base_provider.dart';

class HomeFilterProvider extends BaseListProvider {
  HomeFilterProvider() {
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
        MyHive.userConfBox.get(HiveDbKey.GvgTaskFilter) as GvgTaskFilterHive;
    
    await getPeriods();
    final ClanPeriod lastPeriod = clanPeriodList.first;
    if (_gvgTaskFilter.clanBattleId == 1 ||
        _gvgTaskFilter.clanBattleId != lastPeriod.clanBattleId) {
      // 1的时候为第一次默认值
      _gvgTaskFilter.clanBattleId = lastPeriod.clanBattleId;
      _gvgTaskFilter.startTime = lastPeriod.startTime;
      MyHive.userConfBox.put(HiveDbKey.GvgTaskFilter, _gvgTaskFilter);
    }
    setStageOption(_gvgTaskFilter.clanBattleId);
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


  @override
  Future<void> refresh() async {
    await _initGvgTaskFilter();
    Future<void>.delayed(const Duration(seconds: 1))
        .then((_) => controller.refreshCompleted());
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
    setStageOption(_gvgTaskFilter.clanBattleId);
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
  //  日服在1037期后将4 5阶段合并
  void setStageOption(int clanId) {
    if (clanId > 1037) {
      _stageOption = [
        LvPair(label: "1", value: 1),
        LvPair(label: "2", value: 2),
        LvPair(label: "3", value: 3),
        LvPair(label: "4+5", value: 6),
      ];
    } else {
      _stageOption = [
        LvPair(label: "1", value: 1),
        LvPair(label: "2", value: 2),
        LvPair(label: "3", value: 3),
        LvPair(label: "4", value: 4),
        LvPair(label: "5", value: 5),
      ];
    }
  }

  // 
  void setUsedOrRemoved(String type) {
    _gvgTaskFilter.usedOrRemoved = type;
    notifyListeners();
  }

  @override
  Future<void> loadMore() {
    throw UnimplementedError();
  }
}
