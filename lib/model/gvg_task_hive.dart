part of 'models.dart';

@immutable
class GvgTask {
  const GvgTask({
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
      server: asT<String?>(jsonRes['server']),
      index: asT<int>(jsonRes['index'])!,
      tasks: tasks!,
    );
  }

  final int id;

  final int prefabId;

  final String unitName;

  final String? server;

  final int index;

  final List<Task> tasks;

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

  @override
  int get hashCode =>
      id.hashCode ^
      prefabId.hashCode ^
      unitName.hashCode ^
      server.hashCode ^
      index.hashCode ^
      tasks.hashCode;
}

@HiveType(typeId: MyHive.TaskId)
class Task {
  Task({
    required this.id,
    required this.canAuto,
    required this.stage,
    required this.damage,
    required this.autoDamage,
    required this.halfAutoDamage,
    required this.charas,
    required this.remarks,
    required this.exRemarks,
    required this.links,
    required this.type,
    this.fixedBorrowChara,
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
      autoDamage: asT<int?>(jsonRes['autoDamage']),
      halfAutoDamage: asT<int?>(jsonRes['halfAutoDamage']),
      charas: charas!,
      remarks: asT<String>(jsonRes['remarks'])!,
      exRemarks: asT<String>(jsonRes['exRemarks'])!,
      type: asT<int>(jsonRes['type'])!,
      links: links!,
    );
  }
  @HiveField(0)
  final int id;
  @HiveField(1)
  final List<int> canAuto;
  @HiveField(2)
  final int stage;
  @HiveField(3)
  int damage;
  @HiveField(4)
  final int? autoDamage;
  @HiveField(5)
  final List<Chara> charas;
  @HiveField(6)
  final String remarks;
  @HiveField(7)
  final List<Link> links;
  // 1尾刀,2正常
  @HiveField(8)
  final int type;

  @HiveField(9)
  final String exRemarks;

  @HiveField(10)
  final int? halfAutoDamage;

  Chara? fixedBorrowChara;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'canAuto': canAuto,
        'stage': stage,
        'damage': damage,
        'autoDamage': autoDamage,
        'halfAutoDamage': halfAutoDamage,
        'fixedBorrowChara': fixedBorrowChara,
        'charas': charas,
        'remarks': remarks,
        'exRemarks': exRemarks,
        'type': type,
        'links': links,
      };

  Task clone() =>
      Task.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
  Task copy() {
    return Task(
        canAuto: List<int>.from(canAuto),
        id: id,
        stage: stage,
        damage: damage,
        autoDamage: autoDamage,
        halfAutoDamage: halfAutoDamage,
        remarks: remarks,
        exRemarks: exRemarks,
        fixedBorrowChara: fixedBorrowChara,
        type: type,
        links: links.map((e) => e.copy()).toList(),
        charas: charas.map((r) => r.cpoy()).toList());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          canAuto == other.canAuto &&
          stage == other.stage &&
          damage == other.damage &&
          exRemarks == other.exRemarks &&
          remarks == other.remarks &&
          autoDamage == other.autoDamage &&
          halfAutoDamage == other.halfAutoDamage &&
          fixedBorrowChara == other.fixedBorrowChara &&
          type == other.type &&
          charas.eq(other.charas) &&
          links.eq(other.links);

  @override
  int get hashCode =>
      id.hashCode ^
      canAuto.hashCode ^
      stage.hashCode ^
      damage.hashCode ^
      autoDamage.hashCode ^
      halfAutoDamage.hashCode ^
      fixedBorrowChara.hashCode ^
      type.hashCode ^
      remarks.hashCode ^
      exRemarks.hashCode ^
      charas.hashCode ^
      charas.hashCode ^
      links.hashCode;
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

  Chara cpoy() => Chara(
      prefabId: prefabId, unitName: unitName, searchAreaWidth: searchAreaWidth);

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

  @override
  int get hashCode =>
      id.hashCode ^
      prefabId.hashCode ^
      unitName.hashCode ^
      rarity.hashCode ^
      rank.hashCode ^
      currentRarity.hashCode ^
      searchAreaWidth.hashCode;
}

@HiveType(typeId: MyHive.LinkId)
class Link {
  const Link({
    required this.name,
    required this.link,
    required this.remarks,
  });

  factory Link.fromJson(Map<String, dynamic> jsonRes) => Link(
        name: asT<String>(jsonRes['name'])!,
        link: asT<String>(jsonRes['link'])!,
        remarks: asT<String>(jsonRes['remarks'])!,
      );
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String link;
    @HiveField(2)
  final String remarks;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'link': link,
        'remarks': remarks,
      };

  Link clone() =>
      Link.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
  Link copy() => Link(name: name, link: link, remarks: remarks);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Link &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          remarks == other.remarks &&
          link == other.link;

  @override
  int get hashCode => name.hashCode ^ link.hashCode ^ remarks.hashCode;
}
