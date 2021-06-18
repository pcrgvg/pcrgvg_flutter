// import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';

class CommRes {
  CommRes({required this.status, required this.msg, this.data});
  int status;
  String msg;
  dynamic data;
}

// TODO(kurumi): 根据uri 返回不同的res
class PcrTransFormer extends DefaultTransformer {
  @override
  Future<dynamic> transformResponse(
    RequestOptions options,
    ResponseBody response,
  ) async {
    final dynamic transformResponse = await super.transformResponse(options, response);
    return transformResponse;
  }
}

class NetUtil {
  final String baseUrl = '';
  static final Dio dio = Dio(BaseOptions(
    baseUrl: kReleaseMode ? '' : '',
    // baseUrl: "https://www.5dm.tv/",
    connectTimeout: 15000,
    receiveTimeout: 15000,
  ));

  static void init() {
    dio.transformer = PcrTransFormer();
     dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      'net start'.debug();
      return handler.next(options);
      // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
      // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
      //
      // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
      // 这样请求将被中止并触发异常，上层catchError会被调用。
    }, onResponse: (Response<dynamic> response, ResponseInterceptorHandler handler) {
      'net end'.debug();

      // response.data = CommRes(status: status, msg: msg)
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
}


// class Http {
//   const Http._();

//   static Future<void> isolateHttp() async {
//     final ReceivePort receivePort =  ReceivePort();
//     SendPort port = receivePort.sendPort;

//     receivePort.listen((message) { })
//   }

//   static Future<CommRes> get({required String url}) async {
//       await isolateHttp()
//   }
// }
