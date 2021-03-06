part of 'models.dart';

@HiveType(typeId: MyHive.GvgTaskFilterId)
class GvgTaskFilterHive extends HiveObject {
  GvgTaskFilterHive(
      {required this.server,
      required this.bossNumber,
      required this.methods,
      required this.clanBattleId,
      required this.startTime,
      required this.stage,
      this.taskTypes = const ['all']});
  @HiveField(0)
  String server;
  @HiveField(1)
  List<int> bossNumber;
  @HiveField(2)
  List<int> methods;
  @HiveField(3)
  int clanBattleId;
  @HiveField(4)
  int stage;
  @HiveField(5)
  String startTime;

  /// all used removed tail
  @HiveField(7, defaultValue: ['all'])
  List<String> taskTypes;
  /// HIVE内存存取，同一个引用
  GvgTaskFilterHive copy() => GvgTaskFilterHive(
      bossNumber: bossNumber,
      clanBattleId: clanBattleId,
      methods: [...methods],
      server: server,
      stage: stage,
      taskTypes: taskTypes,
      startTime: startTime);
}
