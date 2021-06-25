import 'dart:io';
import 'package:pcrgvg_flutter/apis/pcr_db_api.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';
import 'package:sqflite/sqflite.dart';
import 'package:brotli/brotli.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';

abstract class ServerType {
  static const String cn = 'cn';
  static const String jp = 'jp';
}

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
    // TODO(KURUMI): check db and update
  }

  static Future<Database> getDb(String server) async {
    final String dbName = server == ServerType.jp ? jpDbName : cnDbName;
    return await openDatabase('$dbDirPath${Platform.pathSeparator}$dbName');
  }

  // TODO(KURUMI): 更新数据库
  static Future<List<bool>> checkDb() async {
    return Future.wait(<Future<bool>>[checkUpdatedbCn(), checkUpdatedbJp()]);
  }

  static Future<bool> checkUpdatedbCn() async {
    final PcrDbVersion? pcrDbVersion = MyHive.pcrDbBox.get(HiveDbKey.Cn);
    final PcrDbVersion lastPcrDbVersion = await PcrDbApi.dbVersionCn();
    return pcrDbVersion?.truthVersion != lastPcrDbVersion.truthVersion;
  }

  static Future<bool> checkUpdatedbJp() async {
    final PcrDbVersion? pcrDbVersion = MyHive.pcrDbBox.get(HiveDbKey.Jp);
    final PcrDbVersion lastPcrDbVersion = await PcrDbApi.dbVersionJp();
    return pcrDbVersion?.truthVersion != lastPcrDbVersion.truthVersion;
  }

  static Future<void> downloadDbJp() async {
    final String dbPath = '$dbDirPath${Platform.pathSeparator}$jpDbName';
    '$dbPath dowload start'.debug();
    await PcrDbApi.downloadDbJp('$dbPath.br');
    final List<int> dbString =
        brotli.decode(File('$dbPath.br').readAsBytesSync());
    final File db = File(dbPath);
    if (!db.existsSync()) {
      db.createSync();
    }
    db.writeAsBytesSync(dbString);
     '$dbPath dowload end'.debug();
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

  // 获取rank列表
  static Future<List<int>> rankList(String server) async {
    final Database db = await getDb(server);
    final List<Map<String, Object?>> queryRes = await db.rawQuery(
        'SELECT promotion_level as promotionLevel FROM unit_promotion GROUP BY promotion_level');
    await db.close();
    return queryRes.map<int>((Map<String, Object?> rank) {
      return int.parse('${rank['promotionLevel']}');
    }).toList();
  }

  // 获取所有角色
  static Future<List<Chara>> charaList(String server) async {
    final Database db = await getDb(server);
    final List<Map<String, Object?>> queryRes = await db.rawQuery('''
    SELECT
      a.prefab_id AS prefabId,
      a.unit_name AS unitName,
      a.search_area_width as searchAreaWidth,
      MAX( b.rarity ) AS rarity 
    FROM
      unit_data a
      JOIN unit_rarity  b ON a.unit_id = b.unit_id 
    WHERE
      a.COMMENT <> '' 
    GROUP BY
      a.prefab_id
    ORDER BY a.search_area_width
    ''');
    await db.close();
    return queryRes.map<Chara>((Map<String, Object?> charaJson) {
      return Chara.fromJson(charaJson);
    }).toList();
  }

  // 获取所有会战期次
  static Future<List<ClanPeriod>> getPeriods(String server) async {
    final Database db = await getDb(server);
    final List<Map<String, Object?>> queryRes = await db.rawQuery('''
        SELECT
          clan_battle_period.clan_battle_id as clanBattleId, 
          clan_battle_period.start_time as startTime
        FROM
          clan_battle_period
        WHERE
          clan_battle_period.clan_battle_id >= ${server == ServerType.cn ? 1009 : 1033}
        ORDER BY
          clan_battle_period.clan_battle_id DESC
     ''');
    await db.close();
    return queryRes
        .map<ClanPeriod>(
            (Map<String, Object?> period) => ClanPeriod.fromJson(period))
        .toList();
  }

  // 获取当期boss
  static Future<List<UnitBoss>> getBoss(String server, int clanBattleId) async {
    final Database db = await getDb(server);
    final List<Map<String, Object?>> waves = await db.rawQuery(
        'SELECT * FROM clan_battle_2_map_data WHERE clan_battle_id = $clanBattleId');
    final Map<String, Object?> wave = waves.first;
    final List<Map<String, Object?>> queryRes = await db.rawQuery('''
      SELECT
	      c.prefab_id as prefabId, 
	      c.unit_name as unitName
      FROM
	      wave_group_data AS a
	    LEFT JOIN
	      enemy_parameter AS b
	    ON 
	    	a.enemy_id_1 = b.enemy_id
	    LEFT JOIN
	      unit_enemy_data AS c
	    ON 
		    c.unit_id = b.unit_id
      WHERE
	      wave_group_id IN(${wave['wave_group_id_1']}, ${wave['wave_group_id_2']}, ${wave['wave_group_id_3']}, ${wave['wave_group_id_4']}, ${wave['wave_group_id_5']})
    ''');
    await db.close();

    return queryRes.map<UnitBoss>((Map<String, Object?> query) => UnitBoss.fromJson(query)).toList();
  }
}
