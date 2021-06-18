
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/utils/net_util.dart';
import 'package:dio/dio.dart';


class PcrDbApi {
  static Future<PcrDbVersion> dbVersionJp() async {
    final Response<Map<String, dynamic>> res = await  NetUtil.dio.get(PcrDbUrl.lastVersionJp);
    return PcrDbVersion.fromJson(res.data!);
  } 

 static Future<PcrDbVersion> dbVersionCn() async {
    final Response<Map<String, dynamic>> res = await  NetUtil.dio.get(PcrDbUrl.lastVersionCn);
    return PcrDbVersion.fromJson(res.data!);
  } 

  static Future<Response<dynamic>> downloadDbJp(String path) async {
    return await NetUtil.dio.download(PcrDbUrl.rediveDbJp, path);
  }

  
  static Future<Response<dynamic>> downloadDbCn(String path) async {
    return await NetUtil.dio.download(PcrDbUrl.rediveDbCn, path);
  }
}