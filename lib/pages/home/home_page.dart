import 'dart:ui';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_routes.dart';
import 'package:pcrgvg_flutter/providers/home_provider.dart';
import 'package:pcrgvg_flutter/widgets/animate_header.dart';
import 'package:pcrgvg_flutter/widgets/auto_type_view.dart';
import 'package:pcrgvg_flutter/widgets/blank.dart';
import 'package:pcrgvg_flutter/widgets/boss_icon.dart';
import 'package:pcrgvg_flutter/widgets/icon_chara.dart';
import 'package:provider/provider.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

@FFRoute(
  name: 'homePage',
  routeName: "homePage",
)
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ChangeNotifierProvider<HomeProvider>(
        create: (_) => HomeProvider(),
        child: Selector<HomeProvider, List<GvgTask>>(
          selector: (_, HomeProvider homeModel) => homeModel.gvgTaskList,
          shouldRebuild: (List<GvgTask> pre, List<GvgTask> next) =>
              pre.ne(next),
          builder: (_, List<GvgTask> gvgTaskList, __) {
            return Scaffold(
                body: Stack(
              children: <Widget>[
                _ListContent(theme: theme, gvgTaskList: gvgTaskList),
                _RightControl(gvgTaskList: gvgTaskList)
              ],
            ));
          },
        ));
  }
}

class _RightControl extends StatelessWidget {
  const _RightControl({Key? key, required this.gvgTaskList}) : super(key: key);
  final List<GvgTask> gvgTaskList;

  @override
  Widget build(BuildContext context) {
    final HomeProvider model = context.read<HomeProvider>();
    final bool showRightControll = context.select<HomeProvider, bool>(
        (HomeProvider value) => value.showRightControll);
    return Positioned(
        right: 16,
        bottom: 16,
        top: 16,
        child: Offstage(
            offstage: !showRightControll,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<GestureDetector>.generate(
                    gvgTaskList.length,
                    (int index) => GestureDetector(
                        onTap: () {
                          model.scrollTo(index);
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: BossIcon(
                              prefabId: gvgTaskList[index].prefabId,
                              width: 35,
                            )))))));
  }
}

class _ListContent extends StatelessWidget {
  const _ListContent({
    Key? key,
    required this.theme,
    required this.gvgTaskList,
  }) : super(key: key);

  final ThemeData theme;
  final List<GvgTask> gvgTaskList;

  @override
  Widget build(BuildContext context) {
    final HomeProvider model = context.read<HomeProvider>();
    return Positioned.fill(
        child: NotificationListener<Notification>(
            onNotification: (Notification notification) {
              if (notification is ScrollUpdateNotification) {
                if (notification.depth == 0) {
                  final double offset = notification.metrics.pixels;
                  model.hasScrolled = offset > 0.0;
                }
                final double scrollDelta = notification.scrollDelta ?? 0;
                if (scrollDelta >= 0.05) {
                  model.showRightControll = false;
                }
                if (scrollDelta <= 0.05) {
                  model.showRightControll = true;
                }
              }
              if (notification is OverscrollIndicatorNotification) {
                notification.disallowGlow();
              }
              return true;
            },
            child: SmartRefresher(
              controller: model.controller,
              onRefresh: model.refresh,
              enablePullDown: true,
              enablePullUp: false,
              child: CustomScrollView(
                controller: model.scrollController,
                slivers: <Widget>[
                  _Header(theme: theme),
                  if (gvgTaskList.isEmpty)
                    const SliverToBoxAdapter(
                      child: Blank(
                        tip: '果咩,啥都没有,如果是第一次请更新数据库',
                      ),
                    ),
                  ...List<MultiSliver>.generate(gvgTaskList.length,
                      (int index) {
                    final GvgTask gvgTask = gvgTaskList[index];
                    return MultiSliver(pushPinnedChildren: true, children: [
                      _BossHeader(
                        theme: theme,
                        gvgTask: gvgTask,
                        key: model.keyList[index],
                      ),
                      if (gvgTask.tasks.isNotEmpty)
                        SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverWaterfallFlow(
                                gridDelegate:
                                    const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  mainAxisSpacing: 16,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (_, int index) {
                                    final Task task = gvgTask.tasks[index];
                                    return _TaskItem(
                                        theme: theme,
                                        task: task,
                                        bossPrefab: gvgTask.prefabId);
                                  },
                                  childCount: gvgTask.tasks.length,
                                ))),
                    ]);
                  })
                ],
              ),
            )));
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeModel = context.read<HomeProvider>();
    final String server = context.select<HomeProvider, String>(
        (HomeProvider value) => value.gvgTaskFilter.server);
    return SliverPinnedToBoxAdapter(
      child: Selector<HomeProvider, bool>(
        selector: (_, HomeProvider model) => model.hasScrolled,
        builder: (BuildContext context, bool hasScrolled, __) {
          final String startTime = context
              .select<HomeProvider, String>(
                  (HomeProvider value) => value.gvgTaskFilter.startTime)
              .dateFormate();
          final String stage = context.select<HomeProvider, String>(
              (HomeProvider value) => value.stageLabel);
          return AnimateHeader(
            hasScrolled: hasScrolled,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox(),
                Row(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              ServerType.getName(server),
                              style: textStyleH1,
                            ),
                            Text(
                              startTime,
                              style: textStyleH1,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('阶段$stage', style: textStyleH2),
                            for (int method
                                in context.select<HomeProvider, List<int>>(
                                    (HomeProvider model) =>
                                        model.gvgTaskFilter.methods))
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(
                                    AutoType.getName(method),
                                    style: textStyleH2,
                                  )),
                          ],
                        )
                      ],
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
                        final dynamic filter = await Navigator.of(context)
                            .pushNamed(Routes.homeFilterPage.name,
                                arguments: Routes.homeFilterPage
                                    .d(homeProvider: homeModel));
                        if (filter != null) {
                          homeModel.changeFilter(filter as GvgTaskFilterHive);
                        }
                      },
                    )
                  ],
                ),
                MaterialButton(
                  minWidth: 0,
                  elevation: 0,
                  onPressed: () async {
                    final ToastFuture loading = '分刀处理中'.loading();
                    try {
                      final List<ResultBoss> bossList =
                          await homeModel.filterIsolate();
                      if (bossList.isNotEmpty) {
                        loading.dismiss();
                        Navigator.of(context).pushNamed(Routes.resultPage.name,
                            arguments: Routes.resultPage.d(bossList: bossList));
                      }
                    } catch (e) {
                      loading.dismiss();
                    }
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  color: theme.accentColor.withOpacity(0.2),
                  child: Text(
                    '分刀',
                    style: TextStyle(color: theme.accentColor),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TaskItem extends StatefulWidget {
  const _TaskItem(
      {Key? key,
      required this.theme,
      required this.task,
      required this.bossPrefab})
      : super(key: key);

  final ThemeData theme;
  final Task task;
  final int bossPrefab;

  @override
  __TaskItemState createState() => __TaskItemState();
}

class __TaskItemState extends State<_TaskItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.taskDetailPage.name,
            arguments: Routes.taskDetailPage
                .d(bossPrefab: widget.bossPrefab, task: widget.task));
      },
      child: Container(
        decoration: BoxDecoration(
            color: widget.theme.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (Chara chara in widget.task.charas)
                  GestureDetector(
                    onTap: () {
                      if (widget.task.fixedBorrowChara?.prefabId ==
                          chara.prefabId) {
                        widget.task.fixedBorrowChara = null;
                      } else {
                        widget.task.fixedBorrowChara = chara;
                      }
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: IconChara(
                          chara: chara,
                          shimmer: widget.task.fixedBorrowChara?.prefabId ==
                              chara.prefabId),
                    ),
                  ),
                const Icon(FluentIcons.chevron_right_16_regular),
              ],
            ),
            if (widget.task.exRemarks.isNotEmpty) Text(widget.task.exRemarks),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildDamage(),
                ),
                Row(
                  children: [
                    _buildRemoved(),
                    _buildLike(),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Wrap _buildDamage() {
    final task = widget.task;
    return Wrap(
      children: [
        for (int type in task.canAuto) ...[
          AutoTypeView(
            type: type,
          ),
          if (type == AutoType.manual)
            Text('(${task.damage}w)',
                style:
                    TextStyle(color: HexColor.fromHex('#ff2277'), height: 1.1)),
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

  ValueListenableBuilder<Box<int>> _buildLike() {
    return ValueListenableBuilder<Box<int>>(
      valueListenable: Hive.box<int>(HiveBoxKey.usedBox).listenable(),
      builder: (_, Box<int> box, __) {
        final bool isLiked = box.values.contains(widget.task.id);
        final int index = box.values.toList().indexOf(widget.task.id);
        return LikeButton(
          isLiked: isLiked,
          onTap: (bool isLiked) async {
            if (isLiked) {
              await box.deleteAt(index);
            } else {
              '加入已使用'.toast();
              await box.add(widget.task.id);
            }
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
                    colorFilter:
                        const ColorFilter.mode(Colors.orange, BlendMode.color),
                    child: Container(
                        color: Colors.white,
                        child: Image.asset(
                          Images.kkr,
                          width: 10,
                          height: 10,
                        )));
          },
        );
      },
    );
  }

  ValueListenableBuilder<Box<int>> _buildRemoved() {
    return ValueListenableBuilder<Box<int>>(
      valueListenable: Hive.box<int>(HiveBoxKey.removedBox).listenable(),
      builder: (_, Box<int> box, __) {
        final bool removed = box.values.contains(widget.task.id);
        final int index = box.values.toList().indexOf(widget.task.id);
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: IconButton(
              iconSize: 24,
              key: ValueKey<String>('${widget.task.id}$removed'),
              onPressed: () {
                if (removed) {
                  box.deleteAt(index);
                  '已加入分刀'.toast();
                } else {
                  '已去除'.toast();
                  box.add(widget.task.id);
                }
              },
              color: removed ? Colors.green : widget.theme.accentColor,
              icon: removed
                  ? const Icon(
                      FluentIcons.add_square_multiple_16_regular,
                    )
                  : const Icon(
                      FluentIcons.dismiss_square_multiple_16_regular,
                    ),
            ));
      },
    );
  }
}

class _BossHeader extends StatelessWidget {
  const _BossHeader({
    Key? key,
    required this.theme,
    required this.gvgTask,
  }) : super(key: key);

  final ThemeData theme;
  final GvgTask gvgTask;

  @override
  Widget build(BuildContext context) {
    return SliverPinnedToBoxAdapter(
      child: Container(
          color: theme.scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              Hero(
                  tag: '${gvgTask.prefabId}',
                  child: BossIcon(
                      width: 40, height: 40, prefabId: gvgTask.prefabId)),
              Container(
                width: 10,
              ),
              Text(gvgTask.unitName, style: textStyleH2)
            ],
          )),
    );
  }
}
