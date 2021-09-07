import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/widgets/bg_cover.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

@FFRoute(
  name: "aboutPage",
  routeName: "aboutPage",
)
class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Scaffold(
        body: Stack(
          children: [
            const BgCover(),
            _Content(
              theme: theme,
            ),
            _Back(theme: theme)
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: WaterfallFlow(
      gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 16,
      ),
      padding: EdgeInsets.only(
          top: Screens.statusBarHeight + 100, left: 16, right: 16, bottom: 16),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildItem('基本功能同公会战作业网网页'),
        _buildItem('资源为cygames所属'),
        _buildItem('部分页面不想要背景可在设置关闭'),
        InkWell(
          onTap: () {
            launch('https://github.com/pcrgvg/pcrgvg_flutter');
          },
          child: Container(
                decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              children: const [
                Text('有任何bug或者建议可上github提建议'),
                  Icon(FluentIcons.chevron_right_16_regular)
              ],
            ),
          ),
        )
      ],
    ));
  }

  Container _buildItem(String text) {
    return Container(
        decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        padding: const EdgeInsets.all(16),
        child:  Text(text),
      );
  }
}

class _Back extends StatelessWidget {
  const _Back({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 16,
        top: Screens.statusBarHeight,
        child: MaterialButton(
          minWidth: 36,
          height: 36,
          child: const Icon(Icons.chevron_left),
          shape: circleShape,
          color: theme.backgroundColor,
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
        ));
  }
}
