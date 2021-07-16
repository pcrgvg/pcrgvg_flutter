part of 'models.dart';


class LvPair {
  LvPair({
    required this.label,
    required this.value,
  });

  factory LvPair.fromJson(Map<String, dynamic> jsonRes) => LvPair(
        label: asT<String>(jsonRes['label'])!,
        value: asT<dynamic>(jsonRes['value'])!,
      );

  String label;
  dynamic value;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'label': label,
        'value': value,
      };

  LvPair clone() =>
      LvPair.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
