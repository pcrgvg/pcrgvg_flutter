import 'dart:io';

import 'package:hive/hive.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';

class MyHive {
  const MyHive._();
  static const int PcrDbId = 1;
  static const int GvgTaskFilterId = PcrDbId + 1;
  static const int TaskId = GvgTaskFilterId + 1;
  static const int CharaId = TaskId + 1;

  static late Box<PcrDbVersion> pcrDbVersionBox;
  static late Box<dynamic> userConfBox; 
  static late Box<int> removedBox;
  static late Box<int> usedBox;
  static late Box<Chara> jpCharaBox;
  static late Box<Chara> twCharaBox;
  static late Box<Chara> cnCharaBox;

  static Future<void> init() async {
    Hive.init('${MyStore.appSurDir.path}${Platform.pathSeparator}hivedb');
    Hive
      ..registerAdapter(PcrDbVersionAdapter())
      ..registerAdapter(GvgTaskFilterHiveAdapter())
      ..registerAdapter(CharaAdapter());
    pcrDbVersionBox = await Hive.openBox(HiveBoxKey.PcrDbVersion);
    userConfBox = await Hive.openBox<dynamic>('userConfBox');
    removedBox = await Hive.openBox(HiveBoxKey.removedBox);
    usedBox = await Hive.openBox(HiveBoxKey.usedBox);
    jpCharaBox = await Hive.openBox(HiveBoxKey.jpCharaBox);
    twCharaBox = await Hive.openBox(HiveBoxKey.twCharaBox);
    cnCharaBox = await Hive.openBox(HiveBoxKey.cnCharaBox);
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
  static const String cnCharaBox = 'cnCharaBox';
  static const String twCharaBox = 'twCharaBox';
  static const String jpCharaBox = 'jpCharaBox';
}
