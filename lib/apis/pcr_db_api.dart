import 'package:dio/dio.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/utils/net_util.dart';


class PcrDbApi {
  const PcrDbApi();
  static Future<PcrDbVersion> dbVersionJp() async {
    final Resp res = await Http.fetch(RequestOptions(
        path: PcrDbUrl.lastVersionJp, method: RequestMethods.Get));
    return res.data as PcrDbVersion;
  }

  static Future<PcrDbVersion> dbVersionCn() async {
    final Resp res = await Http.fetch(RequestOptions(
        path: PcrDbUrl.lastVersionCn, method: RequestMethods.Get));
    return res.data as PcrDbVersion;
  }

  static Future<Response<dynamic>> downloadDbJp(String path) async {
    return await NetUtil.dio.download(PcrDbUrl.rediveDbJp, path);
  }

  static Future<Response<dynamic>> downloadDbCn(String path) async {
    return await NetUtil.dio.download(PcrDbUrl.rediveDbCn, path);
  }
}
