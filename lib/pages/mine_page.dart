import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/global/app_update.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_routes.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/widgets/bg_cover.dart';

@FFRoute(
  name: "minePage",
  routeName: "minePage",
)
class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  _MinePage createState() => _MinePage();
}

class _MinePage extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Stack(
      children: [
        const BgCover(sigmaX: 0, sigmaY: 0,),
        Positioned.fill(
            child: Center(
          child: Container(
            width: 150,
            decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.manageCharaPage);
                  },
                  child: Container(
                     padding: const EdgeInsets.all(8),
                    child: const Text('管理角色'),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    '检查数据中'.toast();
                   
                     if( !await PcrDb.checkUpdate()) {
                       '数据库已经是最新'.toast();
                     }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('更新数据库'),
                  ),
                ),
                    GestureDetector(
                  onTap: () {
                    '检查数据中'.toast();
                     AppUpgrade.checkAppVersion();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('更新APP'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.aboutPage.name);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('关于'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.settingPage.name);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('设置'),
                  ),
                ),
              ],
            ),
          ),
        ))
      ],
    );
  }
}

