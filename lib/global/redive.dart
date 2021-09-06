import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/model/models.dart';

//  日服在1037期后将4 5阶段合并
List<LvPair> setStageOption(int clanId, String server) {
  if (server == ServerType.jp) {
    if (clanId > 1037) {
      return <LvPair>[
        LvPair(label: "1", value: 1),
        LvPair(label: "2", value: 2),
        LvPair(label: "3", value: 3),
        LvPair(label: "4+5", value: 6),
      ];
    }
    if (clanId > 1041) {
      return <LvPair>[
        LvPair(label: "1+2", value: 1),
        LvPair(label: "3", value: 3),
        LvPair(label: "4+5", value: 6),
      ];
    }
  }

  if (server == ServerType.tw) {
    return <LvPair>[
      LvPair(label: "1", value: 1),
      LvPair(label: "2", value: 2),
      LvPair(label: "3", value: 3),
      LvPair(label: "4+5", value: 6),
    ];
  }

  return <LvPair>[
    LvPair(label: "1", value: 1),
    LvPair(label: "2", value: 2),
    LvPair(label: "3", value: 3),
    LvPair(label: "4", value: 4),
    LvPair(label: "5", value: 5),
  ];
}
