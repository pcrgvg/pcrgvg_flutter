import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pcrgvg_flutter/providers/base_provider.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';

class ThemeProvider extends BaseProvider {


  SystemUiOverlayStyle systemUiOverlayStyle({bool isDark = false}) {
    return  SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness:  isDark ? Brightness.dark : Brightness.light,
    );
  }

  ThemeData theme({bool isDark = false}) {
    final Brightness brightness = isDark ? Brightness.dark : Brightness.light;
    final Color accentColor = HexColor.fromHex("#f94800");
    final Color primaryColor = HexColor.fromHex("#64b8ff");
    final Color lightScaffoldBackgroundColor = HexColor.fromHex("#f1f2f7");
    const Color lightBackgroundColor = Colors.white;
    final Color darkBackgroundColor = HexColor.fromHex("#132149");
    final Color darkScaffoldBackgroundColor = HexColor.fromHex("#000000");
    final Color scaffoldBackgroundColor =
        isDark ? darkScaffoldBackgroundColor : lightScaffoldBackgroundColor;
    final Color backgroundColor =
        isDark ? darkBackgroundColor : lightBackgroundColor;
    return ThemeData(
      primaryColor: primaryColor,
      brightness: brightness, // 影响TextStyle, when dark, is white
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      backgroundColor: backgroundColor,
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        brightness: brightness,
      ),
      splashColor: accentColor.withOpacity(0.27),
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: primaryColor,
              primaryContainer: primaryColor.darken(0.24),
              secondary: accentColor,
              secondaryContainer : accentColor.darken(0.36),
              background: backgroundColor,
              surface: backgroundColor,
            )
          : ColorScheme.light(
              primary: primaryColor,
              primaryContainer: primaryColor.darken(0.2),
              secondary: accentColor,
              secondaryContainer: accentColor.darken(0.36),
              background: backgroundColor,
              surface: backgroundColor,
            ),
      sliderTheme: SliderThemeData(
        activeTickMarkColor: accentColor,
        activeTrackColor: accentColor,
        thumbColor: accentColor,
        // inactiveTrackColor: primaryColor
      )
    );
  }
}
