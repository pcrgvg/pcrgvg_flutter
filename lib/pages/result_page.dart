import 'package:extended_image/extended_image.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
@FFArgumentImport()
import 'package:pcrgvg_flutter/isolate/filter_task.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_routes.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';
import 'package:pcrgvg_flutter/widgets/animate_header.dart';
import 'package:pcrgvg_flutter/widgets/auto_type_view.dart';
import 'package:pcrgvg_flutter/widgets/boss_icon.dart';
import 'package:pcrgvg_flutter/widgets/icon_chara.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

@FFRoute(
  name: "resultPage",
  routeName: "resultPage",
)
class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late List<List<TaskFilterResult>> list;
  late List<int> usedList;
  @override
  void initState() {
    super.initState();
    list = MyStore.filterResList;
    usedList = MyHive.usedBox.values.toList();
  }

  bool hasScrolled = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: NotificationListener<Notification>(
            onNotification: (Notification notification) {
              if (notification is ScrollUpdateNotification) {
                if (notification.depth == 0) {
                  final double offset = notification.metrics.pixels;
                  final bool _hasScrolled = offset > 0.0;
                  if (hasScrolled != _hasScrolled) {
                    hasScrolled = _hasScrolled;
                    setState(() {});
                  }
                }
              }
              if (notification is OverscrollIndicatorNotification) {
                notification.disallowGlow();
              }
              return true;
            },
            child: CustomScrollView(
              slivers: [
                _Header(hasScrolled: hasScrolled, theme: theme),
                _Content(list: list, theme: theme, usedList: usedList)
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content(
      {Key? key,
      required this.list,
      required this.theme,
      required this.usedList})
      : super(key: key);

  final List<List<TaskFilterResult>> list;
  final ThemeData theme;
  final List<int> usedList;

  @override
  Widget build(BuildContext context) {
    return SliverWaterfallFlow(
        gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate((
          BuildContext c,
          int index,
        ) {
          final List<TaskFilterResult> taskList = list[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(Routes.resultDetailPage.name,
                    arguments: Routes.resultDetailPage.d(taskResult: taskList));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        LikeButton(
                          onTap: (bool isLiked) async {
                            return !isLiked;
                          },
                          likeBuilder: (bool isLiked) {
                            return isLiked
                                ? Image.asset(
                                    Images.kkr,
                                    width: 10,
                                    height: 10,
                                  )
                                : ColorFiltered(
                                    colorFilter: const ColorFilter.mode(
                                        Colors.orange, BlendMode.color),
                                    child: Image.asset(
                                      Images.kkr,
                                      width: 10,
                                      height: 10,
                                    ));
                          },
                        )
                      ],
                    ),
                    for (TaskFilterResult taskResult in taskList)
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                BossIcon(
                                  prefabId: taskResult.prefabId,
                                  width: 35,
                                  height: 35,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    '${taskResult.task.damage}w',
                                    style: TextStyle(
                                        color: HexColor.fromHex('#ff2277'),
                                        fontSize: 18),
                                  ),
                                ),
                                for (int item in taskResult.task.canAuto)
                                  AutoTypeView(
                                    type: item,
                                  )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                for (Chara chara in taskResult.task.charas)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 4),
                                    child: IconChara(
                                      chara: chara,
                                      shimmer:
                                          taskResult.borrowChara?.prefabId ==
                                              chara.prefabId,
                                    ),
                                  ),
                                if (usedList.contains(taskResult.task.id))
                                  Image.asset(
                                    Images.kkr,
                                    width: 30,
                                    height: 30,
                                  )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
          );
        }, childCount: list.length));
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.hasScrolled,
    required this.theme,
  }) : super(key: key);

  final bool hasScrolled;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SliverPinnedToBoxAdapter(
      child: AnimateHeader(
        hasScrolled: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MaterialButton(
              minWidth: 36,
              height: 36,
              child: const Icon(Icons.chevron_left),
              shape: circleShape,
              color: hasScrolled
                  ? theme.scaffoldBackgroundColor
                  : theme.backgroundColor,
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              minWidth: 36,
              height: 36,
              child: const Icon(Icons.expand_more),
              shape: circleShape,
              color: hasScrolled
                  ? theme.scaffoldBackgroundColor
                  : theme.backgroundColor,
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
