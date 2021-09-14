import 'dart:math' as math;
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pcrgvg_flutter/apis/git_api.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:crypto/crypto.dart';
// import 'package:isolate/load_balancer.dart';

abstract class RequestMethods {
  static const String Get = 'get';
  static const String Post = 'POST';
}

class CommRes {
  CommRes({required this.success, this.msg, this.data});
  bool success;
  String? msg;
  dynamic data;
}

class Resp {
  Resp({required this.success, this.data});
  bool success;
  dynamic data;
}

abstract class HttpStatus {
  static const int OK = 200; 
  static const int Fail = 500; 
}

// TODO(kurumi): 根据uri 返回不同的res
class PcrTransFormer extends DefaultTransformer {
  @override
  // ignore: always_specify_types
  Future transformResponse(
    RequestOptions options,
    ResponseBody response,
  ) async {
    final dynamic transformResponse =
        await super.transformResponse(options, response);
    final String uri = '${options.uri}';
    if (<String>[PcrDbUrl.lastVersionCn, PcrDbUrl.lastVersionJp].contains(uri)) {
      return Resp(
          success: true,
          data:
              PcrDbVersion.fromJson(transformResponse as Map<String, dynamic>));
    }
    if (uri.contains(PcrGvgUrl.host)) {
      if (transformResponse['code'] == 200) {
        return Resp(success: true,data: transformResponse['data']);
      }
      return Resp(success: false);
    }
    if (skipTransform(uri)) {
      return Resp(success: true, data:transformResponse);
    }

    return transformResponse;
  }


  List<String> whiteList = [GitUrl.gitApiHost, GitUrl.cdnGitHost, GitUrl.giteeHost];

  bool skipTransform(String uri) {
    for (final String item in whiteList) {
      if(uri.contains(item)) {
        return true;
      }
    }
    return false; 
  }
}

class NetUtil {
  final String baseUrl = '';
  static final Dio dio = Dio(BaseOptions(
    baseUrl: kReleaseMode ? '' : '',
    connectTimeout: 60000,
    receiveTimeout: 60000,
  ));
  static late final String _d;
  static late final int _l;
  static late final String _t;

  static void init() {
    _d = DateTime.now().millisecondsSinceEpoch.toString();
     _l = math.Random().nextInt(_d.length);
     _t = sha1.convert(utf8.encode(_d.substring(_l) + '123456')).toString();
    dio.transformer = PcrTransFormer();
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      'net start'.debug();
      options.headers.addAll({
        "d": _d,
        "l": _l.toString(),
        "t": _t
      });
      return handler.next(options);
      // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
      // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
      //
      // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
      // 这样请求将被中止并触发异常，上层catchError会被调用。
    }, onResponse:
            (Response<dynamic> response, ResponseInterceptorHandler handler) {
      'net end'.debug();
      return handler.next(response); // continue
    }, onError: (DioError dioError, ErrorInterceptorHandler handler) {
      "dioError: ${dioError.message}".debug();
      if (dioError.type == DioErrorType.connectTimeout ||
          dioError.type == DioErrorType.receiveTimeout) {
        '网络连接超时'.toast();
      }
      return handler.next(dioError);
    }));
  }

  static Future<Response<T>> fetch<T>(RequestOptions requestOptions) async {
    return await dio.fetch(requestOptions);
    // return await  dio.request(requestOptions.path, data: requestOptions.data, options: Options(method: requestOptions.method));
  }
}

class Http {
  const Http._();

  static Future<CommRes> isolateHttp(RequestOptions requestOptions) async {
    // TODO(KURUMI): fixed ISOLATE HTTP function must be top-level function
    final Response res = await compute(NetUtil.fetch, requestOptions);
    if (res.statusCode == HttpStatus.OK && res.data['code'] == HttpStatus.OK) {
      return CommRes(success: true, data: res.data['data']);
    }
    return CommRes(success: false, msg: '');
  }

  static Future<Resp> fetch(
    RequestOptions requestOptions,
  ) async {
    Response<Resp> res;
    if (requestOptions.method.isEmpty) {
       return Resp(success: false);
    }
   res = await NetUtil.fetch<Resp>(requestOptions);
    if (res.statusCode == HttpStatus.OK && res.data?.success == true) {
      return res.data!;
    }
    '网络连接失败'.toast();
    return Resp(success: false);
  }
}
