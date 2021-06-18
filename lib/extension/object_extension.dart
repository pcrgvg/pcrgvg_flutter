part of 'extensions.dart';

DateFormat _logDateFormatter = DateFormat("HH:mm:ss.SSS");


extension Log on Object? {
  void debug({int level = 2}) {
    d(this, level: level);
  }

  void error({StackTrace? trace, int level = 2}) {
    e(this, trace: trace, level: level);
  }

  static void e(dynamic any, {StackTrace? trace, int level = 1}) {
    if (kDebugMode) {
      final String tag;
      if (trace != null) {
        tag =
            "${_logDateFormatter.format(DateTime.now())} E/${trace.toString().split("\n")[level].replaceAll(RegExp("(#\\d+\\s+)|(<anonymous closure>)"), "").replaceAll(". (", ".() (")} => ";
      } else {
        tag = "${_logDateFormatter.format(DateTime.now())} E => ";
      }
      Log.p(any, tag: tag);
    }
  }

  static void d(dynamic any, {int level = 1}) {
    if (kDebugMode) {
      final String tag =
          "${_logDateFormatter.format(DateTime.now().toLocal())} D/${StackTrace.current.toString().split("\n")[level].replaceAll(RegExp("(#\\d+\\s+)|(<anonymous closure>)"), "").replaceAll(". (", ".() (")} => ";
      Log.p(any, tag: tag);
    }
  }

   static void p(dynamic msg, {int wrapWidth = 800, String tag = "DEBUG"}) {
    if (kDebugMode) {
      dev.log('$msg', name: tag);
    }
  }
}
