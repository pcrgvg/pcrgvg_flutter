part of 'models.dart';

@HiveType(typeId: MyHive.FilterResultId)
class TaskFilterResult extends HiveObject {
  TaskFilterResult(
      {required this.bossId,
      required this.prefabId,
      required this.index,
      required this.task,
      this.borrowChara});
  @HiveField(0)
  int bossId;
  @HiveField(1)
  int prefabId;
  @HiveField(2)
  Chara? borrowChara;
  @HiveField(3)
  int index;
  @HiveField(4)
  Task task;
  Map<String, dynamic> toJson() => <String, dynamic>{
        "bossId": bossId,
        "prefabId": prefabId,
        "borrowChara": borrowChara,
        "index": index,
        "task": task
      };

  TaskFilterResult copy() => TaskFilterResult(
      bossId: bossId,
      index: index,
      prefabId: prefabId,
      task: task,
      borrowChara: borrowChara);
}

class ResultBoss {
  ResultBoss({required this.prefabId, required this.id, this.count = 1});

  int count;
  final int prefabId;
  final int id;

  ResultBoss copy() => ResultBoss(id: id, prefabId: prefabId, count: count);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultBoss &&
          count == other.count &&
          id == other.id &&
          prefabId == other.prefabId;
  @override
  int get hashCode => id.hashCode ^ count.hashCode ^ prefabId.hashCode;
}
