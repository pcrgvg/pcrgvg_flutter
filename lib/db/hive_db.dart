import 'dart:io';

import 'package:hive/hive.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';

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
  static late Box<dynamic> userConfBox;
  static late Box<GvgTask> collectionBox;
  static late Box<int> removedBox;

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
    pcrDbVersionBox.put(
        HiveDbKey.Cn, PcrDbVersion(truthVersion: 'truthVersion', hash: 'hash'));
    userConfBox.put(
        HiveDbKey.GvgTaskFilter,
        GvgTaskFilterHive(
          server: ServerType.jp,
          bossPrefabs: <int>[],
          stage: 1,
          methods: <int>[AutoType.unAuto, AutoType.harfAuto, AutoType.auto],
          clanBattleId: 1,
          startTime: ''
        ));
  }
}

abstract class HiveDbKey {
  static const String Cn = 'Cn';
  static const String Jp = 'Jp';
  static const String GvgTaskFilter = 'GvgTaskFilter';
}

abstract class HiveBoxKey {
   static const String removedBox = 'removedBox';
   static const String PcrDbVersion = 'PcrDbVersion';
}
