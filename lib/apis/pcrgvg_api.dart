import 'package:dio/dio.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/utils/net_util.dart';


class PcrGvgApi {
  const PcrGvgApi();
  static Future<List<GvgTask>> getGvgTaskList(
      {required int stage,
      required String server,
      required int clanBattleId}) async {
    final Resp res = await Http.fetch(RequestOptions(
        path: PcrGvgUrl.gvgTaskList,
        method: RequestMethods.Post,
        data: {"stage": stage, "server": server, "clanBattleId": clanBattleId}));
    if (res.success) {
      final List<GvgTask> list = [];
      if (res.data is List) {
        for (final item in res.data! as List) {
          list.add(GvgTask.fromJson(item as Map<String, dynamic>));
        }
      }
      return list;
    } else {
      '加载失败'.toast();
      return [];
    }
  }
}
