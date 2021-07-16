import 'package:pcrgvg_flutter/apis/pcrgvg_api.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'base_provider.dart';

class HomeProvider extends CancelableBaseModel {
  HomeProvider() {
    init();
  }
  List<GvgTask> _gvgTaskListCache = [];
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
    final List<GvgTask> arr = await PcrGvgApi.getGvgTaskList(
        stage: _gvgTaskFilter.stage,
        server: _gvgTaskFilter.server,
        clanBattleId: _gvgTaskFilter.clanBattleId);
    dealGvgTask(arr);
    notifyListeners();
  }

  Future<void> refresh() async {
    // controller.requestRefresh();
    await (this + init());
    controller.refreshCompleted();
    '加载完成'.toast();
  }

  /// 比对条件是否需要进行网络查询 /
  Future<void> changeFilter(GvgTaskFilterHive filter) async {
    MyHive.userConfBox.put(HiveDbKey.GvgTaskFilter, filter);
    _gvgTaskFilter = filter;
    if (filter.clanBattleId != gvgTaskFilter.clanBattleId ||
        filter.stage != gvgTaskFilter.stage ||
        filter.server != gvgTaskFilter.server) {
      init();
    } else {
      fiterGvgTask();
    }
  }

  /// 按照伤害排序 /
  void dealGvgTask(List<GvgTask> arr) {
    // ignore: avoid_function_literals_in_foreach_calls
    arr.forEach((GvgTask g) {
      g.tasks.sort((Task a, Task b) => b.damage - a.damage);
      g.tasks.forEach((Task t) {
        t.charas
            .sort((Chara c, Chara d) => d.searchAreaWidth - c.searchAreaWidth);
      });
    });
    _gvgTaskListCache = arr;
    fiterGvgTask();
  }

  void fiterGvgTask() {
    final List<GvgTask> cacheList =
        _gvgTaskListCache.map((e) => e.clone()).toList();
    final List<GvgTask> tempList = [];
    for (int i = 0; i < cacheList.length; i++) {
      final GvgTask gvgTask = cacheList[i];
      if (_gvgTaskFilter.bossNumber.contains(i + 1)) {
        gvgTask.tasks.retainWhere((Task task) {
          bool b = false;
          switch (_gvgTaskFilter.usedOrRemoved) {
            case 'used':
              b = MyHive.usedBox.values.any((int element) => element == task.id);
              break;
            case 'removed':
              b = MyHive.removedBox.values.any((int element) => element == task.id);
              break;
            case 'all':
            default:
              b = true;
          }
          if (b) {
            for (final int canAuto in task.canAuto) {
              final bool isHaved = _gvgTaskFilter.methods.contains(canAuto);
              if (isHaved) {
                return true;
              }
            }
          }

          return false;
        });
        tempList.add(gvgTask);
      }
    }
    _gvgTaskList = tempList;
    notifyListeners();
  }
}
