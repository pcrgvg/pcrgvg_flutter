import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/providers/base_provider.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';

class ThemeProvider extends BaseProvider {
  ThemeProvider() {}
  final Color _themeColor = HexColor.fromHex("#39c7a5");
  Color get themeColor => _themeColor;
  Brightness _brightness = Brightness.light;
  Brightness get brightness => _brightness;

  bool _darkMode = false;
  bool get darkMode => _darkMode;

  set darkMode(bool value) {
    if (_darkMode == value) {
      return;
    }
    _darkMode = value;
    notifyListeners();
    // TODO(kurumi): store mode
  }

  ThemeData theme({bool isDark = false}) {
    final Brightness brightness = isDark ? Brightness.dark : Brightness.light;
    final Color accentColor = HexColor.fromHex("#f94800");
    final Color primaryColor = HexColor.fromHex("#39c7a5");
    final Color lightScaffoldBackgroundColor = HexColor.fromHex("#f1f2f7");
    const Color lightBackgroundColor = Colors.white;
    final Color darkBackgroundColor = HexColor.fromHex("#132149");
    final Color darkScaffoldBackgroundColor = HexColor.fromHex("#000000");
    return ThemeData(
      primaryColor: primaryColor,
      brightness: brightness, // 影响TextStyle, when dark, is white
      accentColor: accentColor,
      accentColorBrightness: accentColor.computeLuminance() > 0.5
          ? Brightness.light
          : Brightness.dark,
      primaryColorBrightness: primaryColor.computeLuminance() > 0.5
          ? Brightness.light
          : Brightness.dark,
      scaffoldBackgroundColor:
          isDark ? darkScaffoldBackgroundColor : lightScaffoldBackgroundColor,
        backgroundColor: isDark ? darkBackgroundColor: lightBackgroundColor,
    );
  }
}
