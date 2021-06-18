import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Screens {
  const Screens._();
  static MediaQueryData mediaQueryData = MediaQueryData.fromWindow(ui.window);
  static num setWidth(double size) {
    return ScreenUtil().setWidth(size);
  }

  static num setHeight(double size) {
    return ScreenUtil().setWidth(size);
  }

  static num setSp(double size) {
    return ScreenUtil().setWidth(size);
  }

  static double get screenWidth => ScreenUtil().screenWidth;

  static double get width => mediaQueryData.size.width;
  static double get height => mediaQueryData.size.height;
  static double get statusHeight => mediaQueryData.padding.top;
  static double get keyBoardHeight => mediaQueryData.viewInsets.bottom;
  static double get navigationBarHeight =>
      mediaQueryData.padding.top + kToolbarHeight;
  static double get bottomSafeHeight => mediaQueryData.padding.bottom;
}
