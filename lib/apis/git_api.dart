import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/utils/net_util.dart';
import 'package:dio/dio.dart';

class GitApi {
  static Future releaseInfo(String sha) async {
    final Resp resp = await Http.fetch(RequestOptions(
        path: GitUrl.releaseInfo.replaceAll('{sha}', sha), method: RequestMethods.Get));
    return resp.data;
  }

  static Future<Resp> masterSha() async {
    final Resp resp = await Http.fetch(RequestOptions(
        path: GitUrl.commitsMaster, method: RequestMethods.Get));
        return resp;
       
  }
}