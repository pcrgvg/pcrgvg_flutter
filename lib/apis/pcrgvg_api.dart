import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/utils/net_util.dart';
import 'package:dio/dio.dart';
import '1.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';

class PcrGvgApi {
  static Future<List<GvgTask>> getGvgTaskList(
      {required int stage,
      required String server,
      required int clanBattleId}) async {
    // final CommRes res = await Http.fetch(RequestOptions(
    //     path: PcrGvgUrl.gvgTaskList,
    //     method: RequestMethods.Post,
    //     data: {stage: stage, server: server, clanBattleId: clanBattleId}));
    final List<GvgTask> list = [];
    if (templist['data'] is List) {
      for (final item in templist['data']! as List) {
        list.add(GvgTask.fromJson(item as Map<String, dynamic>));
      }
    }
    // if (res.data is List) {
    //   for (final item in res.data! as List) {
    //     list.add(GvgTask.fromJson(item as Map<String, dynamic>));
    //   }
    // }
    return list;
  }
}
