import 'package:dio/dio.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/utils/net_util.dart';


class GitApi {
  const GitApi();
  static Future releaseInfo() async {
    final Resp resp = await Http.fetch(RequestOptions(
        path: OSS_APP_VERSION, method: RequestMethods.Get));
    return resp.data;
  }

  static Future<Resp> masterSha() async {
    final Resp resp = await Http.fetch(RequestOptions(
        path: GitUrl.commitsMaster, method: RequestMethods.Get));
        return resp;
       
  }
}