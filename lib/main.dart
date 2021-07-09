import 'package:connectivity/connectivity.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_route.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_routes.dart';
import 'package:pcrgvg_flutter/providers/theme_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';
import 'package:provider/provider.dart';
import 'package:pcrgvg_flutter/utils/net_util.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NetUtil.init();
  await MyStore.init();
  await MyHive.init();
  await PcrDb.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  void _subscribeConnectivityChange() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.wifi:
          "您正在使用WiFi网络".toast();
          break;
        case ConnectivityResult.mobile:
          "您正在使用移动网络".toast();
          break;
        case ConnectivityResult.none:
          "您已断开网络".toast();
          break;
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // _subscribeConnectivityChange();
    return RefreshConfiguration(
        child: OKToast(
            position: ToastPosition.bottom,
            child: MultiProvider(
              providers: <SingleChildWidget>[
                ChangeNotifierProvider<ThemeProvider>(
                  create: (_) => ThemeProvider(),
                ),
              ],
              child: Consumer<ThemeProvider>(
                  builder: (_, ThemeProvider themeProvider, __) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'PCRGVG',
                  theme: themeProvider.theme(),
                  darkTheme: themeProvider.theme(isDark: true),
                  initialRoute: Routes.spalshPage.name,
                  onGenerateRoute: (RouteSettings settings) {
                    return onGenerateRoute(
                      settings: settings,
                      getRouteSettings: getRouteSettings,
                    );
                  },
                  builder: (BuildContext context, Widget? w) {
                    final MediaQueryData data = MediaQuery.of(context);
                    final bool isDark = Theme.of(context)
                            .scaffoldBackgroundColor
                            .computeLuminance() <
                        0.5;
                    return MediaQuery(
                        data: data,
                        child: AnnotatedRegion<SystemUiOverlayStyle>(
                          value: themeProvider.systemUiOverlayStyle(
                              isDark: isDark),
                          child: w!,
                        ));
                  },
                );
              }),
            )));
  }
}
