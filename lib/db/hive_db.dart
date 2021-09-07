import 'dart:io';

import 'package:hive/hive.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';

class MyHive {
  const MyHive._();
  static const int PcrDbId = 1;
  static const int GvgTaskFilterId = PcrDbId + 1;
  static const int CharaId = GvgTaskFilterId + 1;
  static const int FilterResultId = CharaId + 1;
  static const int TaskId = FilterResultId + 1;
  static const int LinkId = TaskId + 1;
  static const int UserId = LinkId + 1;

  static late Box<PcrDbVersion> pcrDbVersionBox;
  static late Box<dynamic> userConfBox;
  static late Box<int> removedBox;
  static late Box<int> usedBox;
  static late Box<Chara> _jpCharaBox;
  static late Box<Chara> _twCharaBox;
  static late Box<Chara> _cnCharaBox;
  static late Box<Chara> charaBox;
  static late Box<List<dynamic>> collectBox;

  static Future<void> init() async {
    Hive.init('${MyStore.appSurDir.path}${Platform.pathSeparator}hivedb');
    Hive
      ..registerAdapter(PcrDbVersionAdapter())
      ..registerAdapter(GvgTaskFilterHiveAdapter())
      ..registerAdapter(TaskFilterResultAdapter())
      ..registerAdapter(TaskAdapter())
      ..registerAdapter(LinkAdapter())
      ..registerAdapter(UserConfigAdapter())
      ..registerAdapter(CharaAdapter());
    pcrDbVersionBox = await Hive.openBox(HiveBoxKey.PcrDbVersion);
    userConfBox = await Hive.openBox<dynamic>('userConfBox');
    removedBox = await Hive.openBox(HiveBoxKey.removedBox);
    usedBox = await Hive.openBox(HiveBoxKey.usedBox);
    _jpCharaBox = await Hive.openBox(HiveBoxKey.jpCharaBox);
    _twCharaBox = await Hive.openBox(HiveBoxKey.twCharaBox);
    _cnCharaBox = await Hive.openBox(HiveBoxKey.cnCharaBox);
    collectBox = await Hive.openBox(HiveBoxKey.collectBox);
    initUserConfig();
    initPcrDbversion();
  }

  static Box<Chara> getServerCharaBox(String server) {
    if (server == ServerType.cn) {
      return _cnCharaBox;
    } else if (server == ServerType.tw) {
      return _twCharaBox;
    } else {
      return _jpCharaBox;
    }
  }

  static void initPcrDbversion() {
    if (userConfBox.get(HiveDbKey.GvgTaskFilter) == null) {
      userConfBox.put(
        HiveDbKey.GvgTaskFilter,
        GvgTaskFilterHive(
            server: ServerType.jp,
            bossNumber: <int>[1, 2, 3, 4, 5],
            usedOrRemoved: TaskType.all,
            stage: 1,
            methods: <int>[AutoType.manual, AutoType.harfAuto, AutoType.auto],
            clanBattleId: 1,
            startTime: ''),
      );
    }
  }

  static void initUserConfig() {
    userConfBox.delete(HiveDbKey.UserConfig);
    final dynamic userConfig = userConfBox.get(HiveDbKey.UserConfig);
    if (userConfig == null) {
      userConfBox.put(
          HiveDbKey.UserConfig, UserConfig());
    }
  }
}

abstract class HiveDbKey {
  static const String Cn = 'Cn';
  static const String Jp = 'Jp';
  static const String Tw = 'Tw';
  static const String GvgTaskFilter = 'GvgTaskFilter';
  static const String UserConfig = 'userConfig';
}

abstract class HiveBoxKey {
  static const String removedBox = 'removedBox';
  static const String usedBox = 'usedBox';
  static const String PcrDbVersion = 'PcrDbVersion';
  static const String collectionBox = 'collectionBox';
  static const String cnCharaBox = 'cnCharaBox';
  static const String twCharaBox = 'twCharaBox';
  static const String jpCharaBox = 'jpCharaBox';
  static const String collectBox = 'collectBox';
}
