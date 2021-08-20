import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pcrgvg_flutter/apis/pcr_db_api.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';
import 'package:sqflite/sqflite.dart';
import 'package:brotli/brotli.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';



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

  static Future<void> checkUpdate() async {
    final List<PcrDbVersion?> jpVersion = await checkUpdatedbJp();
    final List<PcrDbVersion?> cnVersion = await checkUpdatedbCn();
    final bool jp =
        jpVersion.first?.truthVersion != jpVersion.last?.truthVersion;
    final bool cn =
        cnVersion.first?.truthVersion != cnVersion.last?.truthVersion;
    if (jp || cn) {
      final Map<String, PcrDbVersion?> serverDbversion = {
        'jp': jp ? jpVersion.last : null,
        "cn": cn ? cnVersion.last : null
      };
      updateModal(serverDbversion);
    }
  }

  static void updateModal(Map<String, PcrDbVersion?> serverDbversion) {
    showToastWidget(Builder(builder: (BuildContext context) {
      final Color bgc = Theme.of(context).accentColor;
      final TextStyle textStyle = TextStyle(
        color: bgc.computeLuminance() < 0.5 ? Colors.white : Colors.black,
      );
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: HexColor.fromHex('#f94800'),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.024),
              offset: const Offset(0, 1),
              blurRadius: 3.0,
              spreadRadius: 3.0,
            ),
          ],
        ),
        width: Screens.width * 0.7,
        height: Screens.width / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              '数据库有更新,是否更新?',
              style: textStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    dismissAllToast();
                  },
                  child: Text(
                    '取消',
                    style: textStyle,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    dismissAllToast();
                    final PcrDbVersion? jpVersion = serverDbversion['jp'];
                    final PcrDbVersion? cnVersion = serverDbversion['cn'];
                    '数据库更新中'.toast();
                    if (jpVersion != null) {
                      await downloadDbJp(jpVersion);
                    }
                    if (cnVersion != null) {
                      await downloadDbCn(cnVersion);
                    }

                    '数据库更新完毕'.toast();
                  },
                  child: Text(
                    '确定',
                    style: textStyle,
                  ),
                )
              ],
            )
          ],
        ),
      );
    }),
        position: ToastPosition.center,
        handleTouch: true,
        duration: const Duration(hours: 24));
  }

  static Future<Database> getDb(String server) async {
    final String dbName = server == ServerType.cn ? cnDbName : jpDbName;
    return await openDatabase('$dbDirPath${Platform.pathSeparator}$dbName');
  }

  static Future<List<PcrDbVersion?>> checkUpdatedbCn() async {
    final PcrDbVersion? pcrDbVersion = MyHive.pcrDbVersionBox.get(HiveDbKey.Cn);
    final PcrDbVersion lastPcrDbVersion = await PcrDbApi.dbVersionCn();
    return [pcrDbVersion, lastPcrDbVersion];
  }

  static Future<List<PcrDbVersion?>> checkUpdatedbJp() async {
    final PcrDbVersion? pcrDbVersion = MyHive.pcrDbVersionBox.get(HiveDbKey.Jp);
    final PcrDbVersion lastPcrDbVersion = await PcrDbApi.dbVersionJp();
    return [pcrDbVersion, lastPcrDbVersion];
  }

  static Future<void> downloadDbJp(PcrDbVersion dbVersion) async {
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
    MyHive.pcrDbVersionBox.put(HiveDbKey.Jp, dbVersion);
    '$dbPath dowload end'.debug();
  }

  static Future<void> downloadDbCn(PcrDbVersion dbVersion) async {
    final String dbPath = '$dbDirPath${Platform.pathSeparator}$cnDbName';
    await PcrDbApi.downloadDbCn('$dbPath.br');
    final List<int> dbString =
        brotli.decode(File('$dbPath.br').readAsBytesSync());
    final File db = File(dbPath);
    if (!db.existsSync()) {
      db.createSync();
    }
    db.writeAsBytesSync(dbString);
    MyHive.pcrDbVersionBox.put(HiveDbKey.Cn, dbVersion);
    '$dbPath dowload end'.debug();
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

  // 前中后

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
          clan_battle_period.clan_battle_id >= ${server == ServerType.cn ? 1015 : 1033}
        ORDER BY
          clan_battle_period.clan_battle_id DESC
     ''');
    await db.close();
    final List<ClanPeriod> periodsList = queryRes
        .map<ClanPeriod>(
            (Map<String, Object?> period) => ClanPeriod.fromJson(period))
        .toList();
    // 台服会战期次少于日服5次
    if (server == ServerType.tw) {
      periodsList.forEach((ClanPeriod period) {
        period.clanBattleId -= 5;
      });
    }
    return periodsList;
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

    return queryRes
        .map<UnitBoss>((Map<String, Object?> query) => UnitBoss.fromJson(query))
        .toList();
  }
}
