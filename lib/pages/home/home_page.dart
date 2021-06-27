import 'package:extended_image/extended_image.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_routes.dart';
import 'package:pcrgvg_flutter/providers/home_provider.dart';
import 'package:pcrgvg_flutter/widgets/animate_header.dart';
import 'package:pcrgvg_flutter/widgets/auto_type_view.dart';
import 'package:pcrgvg_flutter/widgets/icon_chara.dart';
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
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final HomeProvider homeModel =
        Provider.of<HomeProvider>(context, listen: false);
    return Scaffold(
        body: NotificationListener<Notification>(
      onNotification: (Notification notification) {
        if (notification is ScrollUpdateNotification) {
          if (notification.depth == 0) {
            final double offset = notification.metrics.pixels;
            homeModel.hasScrolled = offset > 0.0;
          }
        }
        // 保持ios与安卓的一致性, ios不再滚动
        if (notification is OverscrollIndicatorNotification) {
          notification.disallowGlow();
        }
        return true;
      },
      child: Selector<HomeProvider, List<GvgTask>>(
        selector: (_, HomeProvider homeModel) => homeModel.gvgTaskList,
        shouldRebuild: (List<GvgTask> pre, List<GvgTask> next) => pre.ne(next),
        builder: (_, List<GvgTask> gvgTaskList, __) {
          return SmartRefresher(
            controller: homeModel.controller,
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropMaterialHeader(
              backgroundColor: theme.accentColor,
              color: theme.accentColor.computeLuminance() < 0.5
                  ? Colors.white
                  : Colors.black,
              distance: 42.0,
            ),
            onRefresh: homeModel.refresh,
            child: CustomScrollView(
              slivers: <Widget>[
                _header(theme, homeModel),
                ...List<MultiSliver>.generate(gvgTaskList.length, (int index) {
                  final GvgTask gvgTask = gvgTaskList[index];
                  return MultiSliver(pushPinnedChildren: true, children: [
                    _BossHeader(theme: theme, gvgTask: gvgTask),
                    SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                final Task task = gvgTask.tasks[index];
                                return _TaskItem(theme: theme, task: task);
                              },
                              childCount: gvgTask.tasks.length,
                            ))),
                  ]);
                })
              ],
            ),
          );
        },
      ),
    ));
  }

  SliverPinnedToBoxAdapter _header(ThemeData theme, HomeProvider homeModel) {
    return SliverPinnedToBoxAdapter(
      child: Selector<HomeProvider, bool>(
        selector: (_, HomeProvider model) => model.hasScrolled,
        builder: (BuildContext context, bool hasScrolled, __) {
          return AnimateHeader(
            hasScrolled: hasScrolled,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  context.select<HomeProvider, String>((HomeProvider value) =>
                              value.gvgTaskFilter.server) ==
                          'jp'
                      ? '日服'
                      : '国服',
                  style: textStyleTile,
                ),
                Text(context
                    .select<HomeProvider, String>(
                        (HomeProvider value) => value.gvgTaskFilter.startTime)
                    .dateFormate()),
                MaterialButton(
                  minWidth: 36,
                  height: 36,
                  child: const Icon(Icons.expand_more),
                  shape: circleShape,
                  color: hasScrolled
                      ? theme.scaffoldBackgroundColor
                      : theme.backgroundColor,
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.homeFilterPage.name,
                        arguments:
                            Routes.homeFilterPage.d(homeProvider: homeModel));
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  const _TaskItem({
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
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      // padding: const EdgeInsets.symmetric(
      //     vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AutoTypeView(
            type: task.canAuto,
          ),
          Expanded(
              child: Padding(
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
                    Text(
                      '${task.damage}w',
                      style: TextStyle(color: HexColor.fromHex('#ff2277')),
                    ),
                    Row(
                      children: [
                        ValueListenableBuilder<Box<int>>(
                          valueListenable:
                              Hive.box<int>(HiveBoxKey.removedBox).listenable(),
                          builder: (_, Box<int> box, __) {
                            final bool removed = box.values.contains(task.id);
                            // box.keys.debug();
                            final int index =
                                box.values.toList().indexOf(task.id);
                            return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: IconButton(
                                  iconSize: 24,
                                  key: ValueKey<String>('${task.id}$removed'),
                                  onPressed: () {
                                    if (removed) {
                                      index.debug();
                                      box.deleteAt(index);
                                    } else {
                                      box.add(task.id);
                                    }
                                  },
                                  color: removed
                                      ? Colors.green
                                      : theme.accentColor,
                                  icon: removed
                                      ? const Icon(
                                          FluentIcons
                                              .add_square_multiple_16_regular,
                                        )
                                      : const Icon(
                                          FluentIcons
                                              .dismiss_square_multiple_16_regular,
                                        ),
                                ));
                          },
                        ),
                        LikeButton(
                          onTap: (bool isLiked) async {
                            return !isLiked;
                          },
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              isLiked
                                  ? FluentIcons.heart_16_filled
                                  : FluentIcons.heart_16_regular,
                              color: theme.accentColor,
                            );
                          },
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          )),
        ],
      ),
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
              ExtendedImage.network(
                PcrDbUrl.unitImg.replaceFirst(
                  '{0}',
                  gvgTask.prefabId.toString(),
                ),
                width: 40,
                height: 40,
              ),
              Text(gvgTask.unitName)
            ],
          )),
    );
  }
}
