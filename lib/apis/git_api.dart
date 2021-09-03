import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/utils/net_util.dart';
import 'package:dio/dio.dart';

class GitApi {
  static Future release() async {
    final Resp resp = await Http.fetch(RequestOptions(
        path: GitUrl.release, method: RequestMethods.Get));
    return resp.data;
  }
}