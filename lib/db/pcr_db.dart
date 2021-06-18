import 'dart:io';

import 'package:pcrgvg_flutter/apis/pcr_db_api.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';
import 'package:sqflite/sqflite.dart';
import 'package:brotli/brotli.dart';

class PcrDb {
  const PcrDb._();

  static String dbDirPath =
      '${MyStore.appSurDir.path}${Platform.pathSeparator}sqfliteDb';

  static const String cnDbName = 'redive_cn.db';
  static const String jpDbName = 'redive_jp.db';

  static Future<void> init() async {
    final Directory dbDir = Directory(dbDirPath);
    if (!dbDir.existsSync()) {
      dbDir.createSync();
    }
  }
  // TODO(KURUMI): 更新数据库
  static Future<List<bool>> checkDb() async {
    return Future.wait([checkUpdatedbCn(), checkUpdatedbJp()]);
  }

  static Future<bool> checkUpdatedbCn() async {
    final PcrDbVersion? pcrDbVersion = MyHive.pcrDbBox.get('cn');
    final PcrDbVersion lastPcrDbVersion = await PcrDbApi.dbVersionCn();
    return pcrDbVersion?.truthVersion != lastPcrDbVersion.truthVersion;
  }

  static Future<bool> checkUpdatedbJp() async {
    final PcrDbVersion? pcrDbVersion = MyHive.pcrDbBox.get('jp');
    final PcrDbVersion lastPcrDbVersion = await PcrDbApi.dbVersionJp();
    return pcrDbVersion?.truthVersion != lastPcrDbVersion.truthVersion;
  }

  static Future<void> downloadDbJp() async {
    final String dbPath = '$dbDirPath${Platform.pathSeparator}$jpDbName';
    await PcrDbApi.downloadDbCn('$dbPath.br');
    final List<int> dbString =
        brotli.decode(File('$dbPath.br').readAsBytesSync());
    final File db = File(dbPath);
    if (!db.existsSync()) {
      db.createSync();
    }
    db.writeAsBytesSync(dbString);
  }
  
  static Future<void> downloadDbCn() async {
    final String dbPath = '$dbDirPath${Platform.pathSeparator}$cnDbName';
    await PcrDbApi.downloadDbCn('$dbPath.br');
    final List<int> dbString =
        brotli.decode(File('$dbPath.br').readAsBytesSync());
    final File db = File(dbPath);
    if (!db.existsSync()) {
      db.createSync();
    }
    db.writeAsBytesSync(dbString);
  }

  static Future<void> charaList(String server) async {
    final String dbName = server == 'jp' ? jpDbName : cnDbName;
    final Database db =
        await openDatabase('$dbDirPath${Platform.pathSeparator}$dbName');
    final List<Map<String, Object?>> rankList = await db.rawQuery(
        'SELECT promotion_level as promotionLevel FROM unit_promotion GROUP BY promotion_level');
    db.close();
    // return rankList.map<int>((Map<String, Object?> rank) {
    //   return rank['promotionLevel'] as Int;
    // }).toList();
  }
}
