import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_routes.dart';
import 'package:pcrgvg_flutter/providers/user_provider.dart';
import 'package:pcrgvg_flutter/widgets/bg_cover.dart';
import 'package:provider/provider.dart';

@FFRoute(
  name: "settingPage",
  routeName: "settingPage",
)
class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [const BgCover(), const _Content(), _Back(theme: theme)],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Positioned(
        top: Screens.statusBarHeight + 80,
        left: 16,
        right: 16,
        child: Container(
          decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ShowBg(
                theme: theme,
              ),
              _RandomBg(
                theme: theme,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.bgSettiongPage.name);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('选择背景'),
                      Icon(FluentIcons.chevron_right_16_regular)
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class _RandomBg extends StatelessWidget {
  const _RandomBg({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final UserProvider model = context.read<UserProvider>();
    final bool randomBg = context
        .select<UserProvider, bool>((value) => value.userConfig.randomBg);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('随机背景'),
        Switch(
            value: randomBg,
            onChanged: (bool value) {
              model.toggelRandomBg();
            })
      ],
    );
  }
}

class _ShowBg extends StatelessWidget {
  const _ShowBg({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final UserProvider model = context.read<UserProvider>();
    final bool showBg =
        context.select<UserProvider, bool>((value) => value.userConfig.showBg);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('显示背景'),
        Switch(
            value: showBg,
            onChanged: (bool value) {
              model.toggleShowBg();
            })
      ],
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
