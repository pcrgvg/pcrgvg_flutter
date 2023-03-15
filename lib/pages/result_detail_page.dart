import 'dart:math' as math;
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_routes.dart';
import 'package:pcrgvg_flutter/providers/home_filter_provider.dart';
import 'package:pcrgvg_flutter/providers/user_provider.dart';
import 'package:pcrgvg_flutter/widgets/auto_type_view.dart';
import 'package:pcrgvg_flutter/widgets/bg_cover.dart';
import 'package:pcrgvg_flutter/widgets/boss_icon.dart';
import 'package:pcrgvg_flutter/widgets/icon_chara.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:provider/provider.dart';

@FFRoute(
  name: "resultDetailPage",
  routeName: "resultDetailPage",
)
class ResultDetailPage extends StatefulWidget {
  const ResultDetailPage({Key? key, required this.taskResult})
      : super(key: key);
  final List<TaskFilterResult> taskResult;

  @override
  _ResultDetailPageState createState() => _ResultDetailPageState();
}

class _ResultDetailPageState extends State<ResultDetailPage> {
  late String bgUrl;
  PageController pageController =
      PageController(initialPage: 0, keepPage: true);
  int current = 0;
  @override
  void initState() {
    super.initState();
    final int index = math.Random().nextInt(widget.taskResult.length);
    final TaskFilterResult taskResult = widget.taskResult[index];
    final int i = math.Random().nextInt(taskResult.task.charas.length);
    bgUrl = PcrDbUrl.cardImg
        .replaceFirst('{0}', '${taskResult.task.charas[i].prefabId + 30}');
  }

  void onBottomTap(int index) {
    current = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool random = context.select<UserProvider, bool>(
        (UserProvider model) => model.userConfig.randomBg);
    final ThemeData theme = Theme.of(context);
    return ChangeNotifierProvider<HomeFilterProvider>(
        create: (_) => HomeFilterProvider(),
        child: Scaffold(
          body: Stack(
            children: [
              BgCover(
                bgUrl: random ? bgUrl : null,
              ),
              Positioned.fill(
                  child: PageView(
                controller: pageController,
                onPageChanged: (int index) {
                  current = index;
                  setState(() {});
                },
                children: [
                  for (TaskFilterResult taskResult in widget.taskResult)
                    _Content(
                      key: PageStorageKey<int>(taskResult.task.id),
                      theme: theme,
                      taskResult: taskResult,
                      bossPrefab: taskResult.prefabId,
                      bgUrl: bgUrl,
                    ),
                ],
              )),
              _Bottom(
                  theme: theme,
                  taskResult: widget.taskResult,
                  current: current,
                  onBottomTap: onBottomTap),
              _Back(theme: theme),
              // _Like(theme: theme)
            ],
          ),
        ));
  }
}

class _Like extends StatelessWidget {
  const _Like({Key? key, required this.theme}) : super(key: key);
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 16,
        top: Screens.statusBarHeight,
        child: MaterialButton(
          minWidth: 36,
          height: 36,
          shape: circleShape,
          color: theme.backgroundColor,
          padding: EdgeInsets.zero,
          onPressed: null,
          child: Center(
            child: LikeButton(
              onTap: (bool isLiked) async {
                return !isLiked;
              },
              likeBuilder: (bool isLiked) {
                return isLiked
                    ? ExtendedImage.asset(
                        Images.kkr,
                      )
                    : ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                            Colors.orange, BlendMode.color),
                        child: ExtendedImage.asset(
                          Images.kkr,
                          fit: BoxFit.cover,
                          shape: BoxShape.circle,
                        ));
              },
            ),
          ),
        ));
  }
}

class _Bottom extends StatelessWidget {
  const _Bottom(
      {Key? key,
      required this.theme,
      required this.taskResult,
      required this.current,
      required this.onBottomTap})
      : super(key: key);

  final ThemeData theme;
  final List<TaskFilterResult> taskResult;
  final int current;
  final Function onBottomTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 16,
      child: Center(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor.withOpacity(0.8)),
              width: 200,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List<GestureDetector>.generate(taskResult.length,
                    (int index) {
                  final TaskFilterResult item = taskResult[index];
                  return GestureDetector(
                      onTap: () {
                        onBottomTap(index);
                      },
                      child: AnimatedContainer(
                          width: current == index ? 40 : 35,
                          height: current == index ? 40 : 35,
                          duration: const Duration(milliseconds: 300),
                          child: BossIcon(
                            prefabId: item.prefabId,
                            shape: current == index
                                ? BoxShape.rectangle
                                : BoxShape.circle,
                          )));
                }),
              ),
            ),
          ),
        ),
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
  const _Content(
      {Key? key,
      required this.theme,
      required this.taskResult,
      required this.bossPrefab,
      required this.bgUrl})
      : super(key: key);

  final ThemeData theme;
  final TaskFilterResult taskResult;
  final int bossPrefab;
  final String? bgUrl;

  @override
  Widget build(BuildContext context) {
    final Task task = taskResult.task;
    return WaterfallFlow(
      gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 16,
      ),
      padding: EdgeInsets.only(
          top: Screens.statusBarHeight + 100, left: 16, right: 16, bottom: 92),
      physics: const BouncingScrollPhysics(),
      children: [
        _Head(theme: theme, taskResult: taskResult),
        _Link(theme: theme, task: task, bgUrl: bgUrl),
        if (!task.remarks.isNullOrEmpty)
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
                Text(task.remarks)
              ],
            ),
          )
      ],
    );
  }
}

class _Link extends StatefulWidget {
  const _Link(
      {Key? key, required this.theme, required this.task, required this.bgUrl})
      : super(key: key);

  final ThemeData theme;
  final Task task;
  final String? bgUrl;

  @override
  State<_Link> createState() => _LinkState();
}

class _LinkState extends State<_Link> {
  bool showLink(List<int> methods, int? method) {
    if (method != null) {
      final bool show = methods.contains(method);
      if (widget.task.linkShowMethod != null) {
        return show && widget.task.linkShowMethod == method;
      }
      return show;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final List<int> methods = context.select<HomeFilterProvider, List<int>>(
        (value) => value.gvgTaskFilter.methods);
    return Container(
      decoration: BoxDecoration(
          color: widget.theme.backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '视频',
                style: textStyleH2,
              ),
              for (int type in widget.task.canAuto)
                GestureDetector(
                  onTap: () {
                    if (widget.task.linkShowMethod != null) {
                      widget.task.linkShowMethod = null;
                    } else {
                      widget.task.linkShowMethod = type;
                    }
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      border: widget.task.linkShowMethod == type
                          ? Border.all(color: Colors.red)
                          : Border.all(color: Colors.transparent),
                    ),
                    child: AutoTypeView(type: type),
                  ),
                )
            ],
          ),
          for (Link link in widget.task.links)
            if (showLink(methods, link.type))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: GestureDetector(
                  onTap: () {
                    if (link.remarks.isNotEmpty) {
                      Navigator.of(context).pushNamed(
                          Routes.linkDetailPage.name,
                          arguments: Routes.linkDetailPage
                              .d(link: link, bgUrl: widget.bgUrl));
                    } else {
                      link.link.launchApp();
                    }
                  },
                  child: Row(
                    children: [
                      if (link.type != null) AutoTypeView(type: link.type!),
                      Text(
                        link.name,
                        style: TextStyle(color: HexColor.fromHex('#1890ff')),
                      )
                    ],
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
    required this.taskResult,
  }) : super(key: key);

  final ThemeData theme;
  final TaskFilterResult taskResult;

  @override
  Widget build(BuildContext context) {
    final Task task = taskResult.task;
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
                  Expanded(child: _buildDamage(task))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  for (Chara chara in task.charas)
                    Container(
                      padding: const EdgeInsets.only(right: 4),
                      child: Stack(
                        children: [
                          IconChara(
                              chara: chara,
                              shimmer: taskResult.borrowChara?.prefabId ==
                                  chara.prefabId),
                          Positioned(left: 0, top: 0, child: Container())
                        ],
                      ),
                    )
                ],
              ),
              if (taskResult.task.exRemarks.isNotEmpty)
                Text(taskResult.task.exRemarks),
            ],
          ),
        ),
        Positioned(
            left: 20,
            top: -30,
            child: BossIcon(
              prefabId: taskResult.prefabId,
              width: 60,
              height: 60,
            )),
      ],
    );
  }

  Wrap _buildDamage(Task task) {
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
            Text(
                '(${task.halfAutoDamage ?? (task.autoDamage ?? task.damage)}w)',
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
