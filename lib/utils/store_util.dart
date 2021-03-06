import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pcrgvg_flutter/isolate/filter_task.dart';
import 'package:pcrgvg_flutter/model/models.dart';

class MyStore {
  const MyStore._();

  static late Directory tempDir;
//  放置用户生成的数据或不能有应用程序重新创建的数据 用户不可见 APPDATA
  static late Directory appDocDir;
   // 存储应用支持的目录 对用户是不可见
  static late Directory appSurDir;

  static Future<void> init() async {
    tempDir = await getTemporaryDirectory();
    appDocDir = await getApplicationDocumentsDirectory();
    appSurDir = await getApplicationSupportDirectory();
  }
  // 分刀数据可能比较大,使用路由传参可能会出现卡顿
  static  List<List<TaskFilterResult>> filterResList = [];

}
