part of 'models.dart';

@HiveType(typeId: MyHive.GvgTaskId)
class GvgTask extends HiveObject {
  GvgTask({
    required this.id,
    required this.prefabId,
    required this.unitName,
    required this.server,
    required this.index,
    required this.tasks,
  });

  factory GvgTask.fromJson(Map<String, dynamic> jsonRes) {
    final List<Task>? tasks = jsonRes['tasks'] is List ? <Task>[] : null;
    if (tasks != null) {
      for (final dynamic item in jsonRes['tasks']!) {
        if (item != null) {
          tryCatch(() {
            tasks.add(Task.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return GvgTask(
      id: asT<int>(jsonRes['id'])!,
      prefabId: asT<int>(jsonRes['prefabId'])!,
      unitName: asT<String>(jsonRes['unitName'])!,
      server: asT<String>(jsonRes['server'])!,
      index: asT<int>(jsonRes['index'])!,
      tasks:  tasks!,
    );
  }
  @HiveField(0)
  int id;
  @HiveField(1)
  int prefabId;
  @HiveField(2)
  String unitName;
  @HiveField(3)
  String server;
  @HiveField(4)
  int index;
  @HiveField(5)
  List<Task> tasks;
  // HiveList<Task> tasks;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'prefabId': prefabId,
        'unitName': unitName,
        'server': server,
        'index': index,
        'tasks': tasks,
      };

  GvgTask clone() => GvgTask.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GvgTask &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          prefabId == other.prefabId &&
          unitName == other.unitName &&
          server == other.server &&
          index == other.index &&
          tasks.eq(other.tasks);
}

@HiveType(typeId: MyHive.TaskId)
class Task extends HiveObject {
  Task({
    required this.id,
    required this.canAuto,
    required this.stage,
    required this.damage,
    required this.charas,
    required this.remarks,
    required this.links,
  });

  factory Task.fromJson(Map<String, dynamic> jsonRes) {
    final List<int>? canAuto = jsonRes['canAuto'] is List ? <int>[] : null;
    if (canAuto != null) {
      for (final dynamic item in jsonRes['canAuto']!) {
        if (item != null) {
          tryCatch(() {
            canAuto.add(asT<int>(item)!);
          });
        }
      }
    }

    final List<Chara>? charas = jsonRes['charas'] is List ? <Chara>[] : null;
    if (charas != null) {
      for (final dynamic item in jsonRes['charas']!) {
        if (item != null) {
          tryCatch(() {
            charas.add(Chara.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }

    final List<Link>? links = jsonRes['links'] is List ? <Link>[] : null;
    if (links != null) {
      for (final dynamic item in jsonRes['links']!) {
        if (item != null) {
          tryCatch(() {
            links.add(Link.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return Task(
      id: asT<int>(jsonRes['id'])!,
      canAuto: canAuto!,
      stage: asT<int>(jsonRes['stage'])!,
      damage: asT<int>(jsonRes['damage'])!,
      charas: charas!,
      remarks: asT<String>(jsonRes['remarks'])!,
      links: links!,
    );
  }
  @HiveField(0)
  int id;
  @HiveField(1)
  List<int> canAuto;
  @HiveField(2)
  int stage;
  @HiveField(3)
  int damage;
  @HiveField(4)
  List<Chara> charas;
  @HiveField(5)
  String remarks;
  @HiveField(6)
  List<Link> links;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'canAuto': canAuto,
        'stage': stage,
        'damage': damage,
        'charas': charas,
        'remarks': remarks,
        'links': links,
      };

  Task clone() =>
      Task.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          canAuto == other.canAuto &&
          stage == other.stage &&
          damage == other.damage &&
          charas.eq(other.charas) &&
          links.eq(other.links);
}

@HiveType(typeId: MyHive.CharaId)
class Chara extends HiveObject {
  Chara({
    required this.prefabId,
    required this.unitName,
    this.rarity,
    required this.searchAreaWidth,
    this.rank,
    this.currentRarity,
    this.id,
  });

  factory Chara.fromJson(Map<String, dynamic> jsonRes) => Chara(
        prefabId: asT<int>(jsonRes['prefabId'])!,
        unitName: asT<String>(jsonRes['unitName'])!,
        rarity: asT<int?>(jsonRes['rarity']),
        searchAreaWidth: asT<int>(jsonRes['searchAreaWidth'])!,
        rank: asT<int?>(jsonRes['rank']),
        currentRarity: asT<int?>(jsonRes['currentRarity']),
        id: asT<int?>(jsonRes['id']),
      );
  @HiveField(0)
  int prefabId;
  @HiveField(1)
  String unitName;
  @HiveField(2)
  int? rarity;
  @HiveField(3)
  int searchAreaWidth;
  @HiveField(4)
  int? rank;
  @HiveField(5)
  int? currentRarity;
  @HiveField(6)
  int? id;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'prefabId': prefabId,
        'unitName': unitName,
        'rarity': rarity,
        'searchAreaWidth': searchAreaWidth,
        'rank': rank,
        'currentRarity': currentRarity,
        'id': id,
      };

  Chara clone() =>
      Chara.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chara &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          prefabId == other.prefabId &&
          unitName == other.unitName &&
          rarity == other.rarity &&
          searchAreaWidth == other.searchAreaWidth &&
          rank == other.rank &&
          currentRarity == other.currentRarity;
}

@HiveType(typeId: MyHive.LinkId)
class Link extends HiveObject {
  Link({
    required this.name,
    required this.link,
  });

  factory Link.fromJson(Map<String, dynamic> jsonRes) => Link(
        name: asT<String>(jsonRes['name'])!,
        link: asT<String>(jsonRes['link'])!,
      );
  @HiveField(0)
  String name;
  @HiveField(1)
  String link;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'link': link,
      };

  Link clone() =>
      Link.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Link &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          link == other.link;
}
