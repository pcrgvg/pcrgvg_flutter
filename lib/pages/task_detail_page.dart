import 'dart:math' as math;
import 'dart:ui';

import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
@FFArgumentImport()
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_routes.dart';
import 'package:pcrgvg_flutter/providers/user_provider.dart';
import 'package:pcrgvg_flutter/widgets/auto_type_view.dart';
import 'package:pcrgvg_flutter/widgets/bg_cover.dart';
import 'package:pcrgvg_flutter/widgets/boss_icon.dart';
import 'package:pcrgvg_flutter/widgets/icon_chara.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:provider/provider.dart';

@FFRoute(
  name: "taskDetailPage",
  routeName: "taskDetailPage",
)
class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({Key? key, required this.bossPrefab, required this.task})
      : super(key: key);
  final Task task;
  final int bossPrefab;

  @override
  Widget build(BuildContext context) {
    final int index = math.Random().nextInt(task.charas.length);
    final String bgUrl = PcrDbUrl.cardImg
        .replaceFirst('{0}', '${task.charas[index].prefabId + 30}');
    final bool random = context.select<UserProvider, bool>(
        (UserProvider model) => model.userConfig.randomBg);
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          BgCover(bgUrl: random ? bgUrl : null),
          _Content(
              theme: theme, task: task, bossPrefab: bossPrefab, bgUrl: bgUrl),
          _Back(theme: theme)
        ],
      ),
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

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.theme,
    required this.task,
    required this.bossPrefab,
    required this.bgUrl,
  }) : super(key: key);

  final ThemeData theme;
  final Task task;
  final int bossPrefab;
  final String bgUrl;

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
        _Head(theme: theme, task: task, bossPrefab: bossPrefab),
        _Link(theme: theme, task: task, bgUrl: bgUrl),
        if (!task.remarks.isNullOrEmpty) _Remarks(theme: theme, task: task)
      ],
    ));
  }
}

class _Remarks extends StatelessWidget {
  const _Remarks({
    Key? key,
    required this.theme,
    required this.task,
  }) : super(key: key);

  final ThemeData theme;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '备注',
                style: textStyleH2,
              ),
              MaterialButton(
                minWidth: 0,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                color: theme.colorScheme.secondary.withOpacity(0.2),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: task.remarks));
                  '已复制'.toast();
                },
                child: Text(
                  '复制',
                  style: TextStyle(color: theme.colorScheme.secondary),
                ),
              ),
            ],
          ),
          Text(
            task.remarks,
          )
        ],
      ),
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({
    Key? key,
    required this.theme,
    required this.task,
    required this.bgUrl,
  }) : super(key: key);

  final ThemeData theme;
  final Task task;
  final String bgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '视频',
            style: textStyleH2,
          ),
          for (Link link in task.links)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: GestureDetector(
                onTap: () {
                  if (link.remarks.isNotEmpty) {
                    Navigator.of(context).pushNamed(Routes.linkDetailPage.name,
                        arguments:
                            Routes.linkDetailPage.d(link: link, bgUrl: bgUrl));
                  } else {
                    launchUrlString(link.link);
                  }
                },
                child: Text(
                  link.name,
                  style: TextStyle(color: HexColor.fromHex('#1890ff')),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class _Head extends StatelessWidget {
  const _Head({
    Key? key,
    required this.theme,
    required this.task,
    required this.bossPrefab,
  }) : super(key: key);

  final ThemeData theme;
  final Task task;
  final int bossPrefab;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 65,
                  ),
                  Expanded(child: _buildDamage())
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  for (Chara chara in task.charas)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: IconChara(
                        chara: chara,
                      ),
                    ),
                ],
              ),
              if (task.exRemarks.isNotEmpty) Text(task.exRemarks)
            ],
          ),
        ),
        Positioned(
            left: 20,
            top: -30,
            child: Hero(
              tag: '$bossPrefab',
              child: BossIcon(
                prefabId: bossPrefab,
                width: 60,
                height: 60,
              ),
            )),
      ],
    );
  }

  Wrap _buildDamage() {
    return Wrap(
      alignment: WrapAlignment.end,
      children: [
        for (int type in task.canAuto) ...[
          AutoTypeView(
            type: type,
          ),
          if (type == AutoType.manual)
            Text('${task.damage}w',
                style: TextStyle(color: HexColor.fromHex('#ff2277'))),
          if (type == AutoType.auto)
            Text('(${task.autoDamage ?? task.damage}w)',
                style:
                    TextStyle(color: HexColor.fromHex('#ff2277'), height: 1.1)),
          if (type == AutoType.harfAuto)
            Text('(${task.halfAutoDamage ?? (task.autoDamage ?? task.damage)}w)',
                style:
                    TextStyle(color: HexColor.fromHex('#ff2277'), height: 1.1)),
        ],
        if (task.type == 1)
          const Text(
            '(尾刀)',
            style: TextStyle(color: Colors.deepPurple, height: 1.1),
          ),
      ],
    );
  }
}
