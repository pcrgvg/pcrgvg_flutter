part of 'models.dart';

@HiveType(typeId: MyHive.PcrDbId)
class PcrDbVersion extends HiveObject {
  PcrDbVersion({
    required this.truthVersion,
    required this.hash,
    this.prefabVer,
  });

  factory PcrDbVersion.fromJson(Map<String, dynamic> jsonRes) => PcrDbVersion(
        truthVersion: asT<String>(jsonRes['TruthVersion'])!,
        hash: asT<String>(jsonRes['hash'])!,
        prefabVer: asT<String?>(jsonRes['PrefabVer']),
      );
  @HiveField(0)
  String truthVersion;
  @HiveField(1)
  String hash;
  @HiveField(2)
  String? prefabVer;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'TruthVersion': truthVersion,
        'hash': hash,
        'PrefabVer': prefabVer,
      };

  PcrDbVersion clone() => PcrDbVersion.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
