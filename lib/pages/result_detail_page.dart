import 'dart:math' as math;
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:like_button/like_button.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
@FFArgumentImport()
import 'package:pcrgvg_flutter/isolate/filter_task.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/widgets/auto_type_view.dart';
import 'package:pcrgvg_flutter/widgets/boss_icon.dart';
import 'package:pcrgvg_flutter/widgets/icon_chara.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

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
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          _BgCover(
            bgUrl: bgUrl,
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
                ),
            ],
          )),
          _Bottom(
              theme: theme,
              taskResult: widget.taskResult,
              current: current,
              onBottomTap: onBottomTap),
          _Back(theme: theme),
          _Like(theme: theme)
        ],
      ),
    );
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

class _BgCover extends StatelessWidget {
  const _BgCover({
    Key? key,
    required this.bgUrl,
  }) : super(key: key);

  final String bgUrl;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExtendedNetworkImageProvider(bgUrl), fit: BoxFit.cover)),
        child: BackdropFilter(
          // filter: ImageFilter.blur(sigmaY: 0, sigmaX: 0),
          filter: ImageFilter.blur(sigmaY: 2.0, sigmaX: 2.0),
          child: Container(
            color: Colors.transparent,
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
  const _Content({
    Key? key,
    required this.theme,
    required this.taskResult,
    required this.bossPrefab,
  }) : super(key: key);

  final ThemeData theme;
  final TaskFilterResult taskResult;
  final int bossPrefab;

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
        _Link(theme: theme, task: task),
        if (!task.remarks.isNullOrEmpty)
          Container(
            decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '备注',
                  style: textStyleH1,
                ),
                Text(task.remarks)
              ],
            ),
          )
      ],
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({
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
        children: [
          const Text(
            '视频',
            style: textStyleH1,
          ),
          for (Link link in task.links)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: GestureDetector(
                onTap: () {
                  launch(link.link);
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (int type in task.canAuto)
                    AutoTypeView(
                      type: type,
                    ),
                  Text(
                    '${task.damage}w',
                    style: TextStyle(
                        color: HexColor.fromHex('#ff2277'), fontSize: 18),
                  ),
                  if (task.type == 1)
                    const Text(
                      '(尾刀)',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
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
}
