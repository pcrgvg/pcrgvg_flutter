import 'package:extended_image/extended_image.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/global/collection.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_routes.dart';
import 'package:pcrgvg_flutter/providers/collect_provider.dart';
import 'package:pcrgvg_flutter/widgets/animate_header.dart';
import 'package:pcrgvg_flutter/widgets/auto_type_view.dart';
import 'package:pcrgvg_flutter/widgets/boss_icon.dart';
import 'package:pcrgvg_flutter/widgets/icon_chara.dart';
import 'package:pcrgvg_flutter/widgets/list_box.dart';
import 'package:provider/provider.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

@FFRoute(
  name: "collectionPage",
  routeName: "collectionPage",
)
class CollectionPage extends StatelessWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: ChangeNotifierProvider<CollectProvider>(
        create: (_) => CollectProvider(),
        child: ListBox<CollectProvider>(
          child: CustomScrollView(
            slivers: [
              _Header(theme: theme),
              _Content(
                theme: theme,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CollectButton extends StatelessWidget {
  const _CollectButton({Key? key, required this.list}) : super(key: key);

  final List<TaskFilterResult> list;
  @override
  Widget build(BuildContext context) {
    final CollectProvider model = context.read<CollectProvider>();
    final List<List<TaskFilterResult>> collectionTask =
        context.select<CollectProvider, List<List<TaskFilterResult>>>(
            (CollectProvider value) => value.collectionList);
    return LikeButton(
      isLiked: Collection.indexOfCollection(list, collectionTask) > -1,
      onTap: (bool isLiked) async {
        model.changeCollect(list);
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
                child: Image.asset(
                  Images.kkr,
                  width: 10,
                  height: 10,
                ));
      },
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
    final List<List<TaskFilterResult>> list =
        context.select<CollectProvider, List<List<TaskFilterResult>>>(
            (CollectProvider model) => model.collectionList);
    final List<int> usedList = context.select<CollectProvider, List<int>>(
        (CollectProvider model) => model.usedList);
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
                        _CollectButton(
                          list: taskList,
                        )
                      ],
                    ),
                    for (TaskFilterResult taskResult in taskList)
                      _buildTaskItem(taskResult, usedList)
                  ],
                ),
              ),
            ),
          );
        }, childCount: list.length));
  }

  Container _buildTaskItem(TaskFilterResult taskResult, List<int> usedList) {
    return Container(
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
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  '${taskResult.task.damage}w',
                  style: TextStyle(
                      color: HexColor.fromHex('#ff2277'), fontSize: 18),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: IconChara(
                    chara: chara,
                    shimmer: taskResult.borrowChara?.prefabId == chara.prefabId,
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
    );
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
    final bool hasScrolled = context.select<CollectProvider, bool>(
        (CollectProvider model) => model.hasScrolled);
    final String server = context.select<CollectProvider, String>(
        (CollectProvider model) => model.serverType);
    final CollectProvider model = context.read<CollectProvider>();
    return SliverPinnedToBoxAdapter(
      child: AnimateHeader(
        hasScrolled: hasScrolled,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox.shrink(),
            Row(
              children: [
                Text(
                  ServerType.getName(server),
                  style: textStyleH1,
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
                    // showMaterialModalBottomSheet(
                    //     backgroundColor: Colors.transparent,
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return _BossFilter(model, theme);
                    //     });
                  },
                )
              ],
            ),
            MaterialButton(
               minWidth: 0,
                  elevation: 0,
              child: const Text('清空'),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
               color: theme.accentColor.withOpacity(0.2),
              onPressed: () async {},
            )
          ],
        ),
      ),
    );
  }
}
