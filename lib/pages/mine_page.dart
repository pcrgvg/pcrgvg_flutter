import 'package:extended_image/extended_image.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_routes.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';

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
        const _Bg(),
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
                  onTap: () {
                    '检查数据中'.toast();
                     PcrDb.checkUpdate();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('更新数据库'),
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
              ],
            ),
          ),
        ))
      ],
    );
  }
}

class _Bg extends StatelessWidget {
  const _Bg({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: ExtendedImage.network(
      PcrDbUrl.cardImg.replaceFirst('{0}', '115531'),
      fit: BoxFit.cover,
    ));
  }
}
