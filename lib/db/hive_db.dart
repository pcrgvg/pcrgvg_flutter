import 'dart:io';

import 'package:hive/hive.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';

class MyHive {
  const MyHive._();
  static const int PcrDbId = 1;
  static const int GvgTaskId = PcrDbId + 1;
  static const int GvgTaskFilterId = GvgTaskId + 1;
  static const int TaskId = GvgTaskFilterId + 1;
  static const int CharaId = TaskId + 1;
  static const int LinkId = CharaId + 1;

  static late Box<PcrDbVersion> pcrDbVersionBox;
  static late Box<GvgTask> gvgTaskBox;
  /// GvgTaskFilter: GvgTaskFilterHive 
  static late Box<dynamic> userConfBox; 
  static late Box<GvgTask> collectionBox; // 用于
  static late Box<int> removedBox;
  static late Box<int> usedBox;

  static Future<void> init() async {
    Hive.init('${MyStore.appSurDir.path}${Platform.pathSeparator}hivedb');
    Hive
      ..registerAdapter(PcrDbVersionAdapter())
      ..registerAdapter(GvgTaskFilterHiveAdapter())
      ..registerAdapter(CharaAdapter())
      ..registerAdapter(GvgTaskAdapter())
      ..registerAdapter(TaskAdapter())
      ..registerAdapter(LinkAdapter());
    pcrDbVersionBox = await Hive.openBox(HiveBoxKey.PcrDbVersion);
    gvgTaskBox = await Hive.openBox('gvgTaskBox');
    userConfBox = await Hive.openBox<dynamic>('userConfBox');
    removedBox = await Hive.openBox(HiveBoxKey.removedBox);
    usedBox = await Hive.openBox(HiveBoxKey.usedBox);
    collectionBox = await Hive.openBox(HiveBoxKey.collectionBox);
    await initPcrDbversion();
  }

  static Future<void> initPcrDbversion() async {
    if (userConfBox.get(HiveDbKey.GvgTaskFilter) == null) {
      userConfBox.put(
        HiveDbKey.GvgTaskFilter,
        GvgTaskFilterHive(
            server: ServerType.jp,
            bossNumber: <int>[1,2,3,4,5],
            usedOrRemoved: 'all',
            stage: 1,
            methods: <int>[AutoType.manual, AutoType.harfAuto, AutoType.auto],
            clanBattleId: 1,
            startTime: ''),
      );
    }
  }
}

abstract class HiveDbKey {
  static const String Cn = 'Cn';
  static const String Jp = 'Jp';
  static const String GvgTaskFilter = 'GvgTaskFilter';
  static const String collection = 'collection';
  static const String removed = 'removed';
}

abstract class HiveBoxKey {
  static const String removedBox = 'removedBox';
  static const String usedBox = 'usedBox';
  static const String PcrDbVersion = 'PcrDbVersion';
  static const String collectionBox = 'collectionBox';
}
