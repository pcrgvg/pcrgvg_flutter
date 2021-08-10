part of 'models.dart';

abstract class AutoType {
  static const int manual = 10;
  static const int auto = 20;
  static const int harfAuto = 40;
}

String getTypeText(int type) {
    switch (type) {
      case AutoType.auto:
        return '自动';
      case AutoType.harfAuto:
        return '半自动';
      case AutoType.manual:
      default:
        return '手动';
    }
  }


// 会战期次
class ClanPeriod {
  ClanPeriod({
    required this.clanBattleId,
    required this.startTime,
  });

  factory ClanPeriod.fromJson(Map<String, dynamic> jsonRes) => ClanPeriod(
        clanBattleId: asT<int>(jsonRes['clanBattleId'])!,
        startTime: asT<String>(jsonRes['startTime'])!,
      );

  int clanBattleId;
  String startTime;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'clanBattleId': clanBattleId,
        'startTime': startTime,
      };

  ClanPeriod clone() => ClanPeriod.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}

// boss
class UnitBoss {
  UnitBoss({
    required this.prefabId,
    required this.unitName,
  });

  factory UnitBoss.fromJson(Map<String, dynamic> jsonRes) => UnitBoss(
        prefabId: asT<int>(jsonRes['prefabId'])!,
        unitName: asT<String>(jsonRes['unitName'])!,
      );

  int prefabId;
  String unitName;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'prefabId': prefabId,
        'unitName': unitName,
      };

  UnitBoss clone() => UnitBoss.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
