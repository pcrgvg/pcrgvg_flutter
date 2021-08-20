import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_routes.dart';
import 'package:pcrgvg_flutter/providers/home_provider.dart';
import 'package:pcrgvg_flutter/isolate/filter_task.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';
import 'package:pcrgvg_flutter/widgets/animate_header.dart';
import 'package:pcrgvg_flutter/widgets/auto_type_view.dart';
import 'package:pcrgvg_flutter/widgets/boss_icon.dart';
import 'package:pcrgvg_flutter/widgets/icon_chara.dart';
import 'package:pcrgvg_flutter/widgets/list_box.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:sliver_tools/sliver_tools.dart';

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
    // TODO(KURUMI): CHECKUPDATE
    PcrDb.checkUpdate();

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
                // TODO(KURUMI): 处理判断
                'build'.debug();
                return ListBox<HomeProvider>(
                    child: CustomScrollView(
                      slivers: <Widget>[
                        _Header(theme: theme),
                        ...List<MultiSliver>.generate(gvgTaskList.length,
                            (int index) {
                          final GvgTask gvgTask = gvgTaskList[index];
                          return MultiSliver(
                              pushPinnedChildren: true,
                              children: [
                                _BossHeader(theme: theme, gvgTask: gvgTask),
                                if (gvgTask.tasks.isNotEmpty)
                                  SliverPadding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      sliver: SliverGrid(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            crossAxisSpacing: 16.0,
                                            mainAxisSpacing: 8.0,
                                            mainAxisExtent: 120.0,
                                          ),
                                          delegate: SliverChildBuilderDelegate(
                                            (_, int index) {
                                              final Task task =
                                                  gvgTask.tasks[index];
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
                    ));
              },
            ));
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
    return SliverPinnedToBoxAdapter(
      child: Selector<HomeProvider, bool>(
        selector: (_, HomeProvider model) => model.hasScrolled,
        builder: (BuildContext context, bool hasScrolled, __) {
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
                            Text( ServerType.getName(context.select<HomeProvider, String>(
                                          (HomeProvider value) =>
                                              value.gvgTaskFilter.server)),
                              style: textStyleH1,
                            ),
                            Text(
                              context
                                  .select<HomeProvider, String>(
                                      (HomeProvider value) =>
                                          value.gvgTaskFilter.startTime)
                                  .dateFormate(),
                              style: textStyleH1,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            for (int method
                                in context.select<HomeProvider, List<int>>(
                                    (HomeProvider model) =>
                                        model.gvgTaskFilter.methods))
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(
                                    getTypeText(method),
                                    style: textStyleH2,
                                  ))
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
                    final List<int> removedList =
                        MyHive.removedBox.values.toList();
                    final List<int> usedList = MyHive.usedBox.values.toList();

                    /// TODO unhavechara
                    final List<List<TaskFilterResult>> res =
                        await isolateFilter(FilterIsolateConfig(
                            removeList: removedList,
                            usedList: usedList,
                            taskList: homeModel.gvgTaskList,
                            unHaveCharaList: []));
                    MyStore.filterResList = res;
                    Navigator.of(context).pushNamed(Routes.resultPage.name);
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

class _TaskItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.taskDetailPage.name,
            arguments:
                Routes.taskDetailPage.d(bossPrefab: bossPrefab, task: task));
      },
      child: Container(
        decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (Chara chara in task.charas)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: IconChara(
                      chara: chara,
                    ),
                  ),
                const Icon(FluentIcons.chevron_right_16_regular),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
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
                    for (int type in task.canAuto)
                      AutoTypeView(
                        type: type,
                      ),
                  ],
                ),
                Row(
                  children: [
                    _buildRemoved(),
                    _buildLike(),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  ValueListenableBuilder<Box<int>> _buildLike() {
    return ValueListenableBuilder<Box<int>>(
      valueListenable: Hive.box<int>(HiveBoxKey.usedBox).listenable(),
      builder: (_, Box<int> box, __) {
        final bool isLiked = box.values.contains(task.id);
        final int index = box.values.toList().indexOf(task.id);
        return LikeButton(
          isLiked: isLiked,
          onTap: (bool isLiked) async {
            if (isLiked) {
              await box.deleteAt(index);
            } else {
              await box.add(task.id);
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
                         ColorFilter.mode(theme.primaryColor, BlendMode.color),
                    child: Image.asset(
                      Images.kkr,
                      width: 10,
                      height: 10,
                    ));
          },
        );
      },
    );
  }

  ValueListenableBuilder<Box<int>> _buildRemoved() {
    return ValueListenableBuilder<Box<int>>(
      valueListenable: Hive.box<int>(HiveBoxKey.removedBox).listenable(),
      builder: (_, Box<int> box, __) {
        final bool removed = box.values.contains(task.id);
        final int index = box.values.toList().indexOf(task.id);
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: IconButton(
              iconSize: 24,
              key: ValueKey<String>('${task.id}$removed'),
              onPressed: () {
                if (removed) {
                  box.deleteAt(index);
                } else {
                  box.add(task.id);
                }
              },
              color: removed ? Colors.green : theme.accentColor,
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
