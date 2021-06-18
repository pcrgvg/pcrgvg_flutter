import 'dart:io';

import 'package:hive/hive.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';


class MyHive {
  const MyHive._();
  static const int PcrDbId = 1;

  static late Box<PcrDbVersion> pcrDbBox;

  static Future<void> init() async {
    Hive.init('${MyStore.appSurDir.path}${Platform.pathSeparator}hivedb');
    Hive.registerAdapter(PcrDbVersionAdapter());
    pcrDbBox = await Hive.openBox('PcrDbVersion');
    pcrDbBox.put('cn', PcrDbVersion(truthVersion: 'truthVersion', hash: 'hash'));
  }
}