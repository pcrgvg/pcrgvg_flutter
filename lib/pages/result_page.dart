import 'package:extended_sliver/extended_sliver.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/global/collection.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
@FFArgumentImport()
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_routes.dart';
import 'package:pcrgvg_flutter/providers/result_provider.dart';
import 'package:pcrgvg_flutter/widgets/animate_header.dart';
import 'package:pcrgvg_flutter/widgets/auto_type_view.dart';
import 'package:pcrgvg_flutter/widgets/boss_icon.dart';
import 'package:pcrgvg_flutter/widgets/icon_chara.dart';
import 'package:pcrgvg_flutter/widgets/list_box.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

@FFRoute(
  name: "resultPage",
  routeName: "resultPage",
)
class ResultPage extends StatelessWidget {
  const ResultPage({required this.bossList});
  final List<ResultBoss> bossList;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: ChangeNotifierProvider<ResultProvider>(
        create: (_) => ResultProvider(bossList),
        child: ListBox<ResultProvider>(
            enablePullDown: false,
            child: CustomScrollView(
              slivers: <Widget>[
                _Header(theme: theme),
                _Content(
                  theme: theme,
                )
              ],
            )),
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
    final List<List<TaskFilterResult>> list =
        context.select<ResultProvider, List<List<TaskFilterResult>>>(
            (ResultProvider model) => model.resultList);
    final List<int> usedList = context.select<ResultProvider, List<int>>(
        (ResultProvider model) => model.usedList);
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

    Wrap _buildDamage(Task task) {
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
          if (type == AutoType.auto || type == AutoType.harfAuto)
            Text('(${task.autoDamage ?? task.damage}w)',
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
              Expanded(child: _buildDamage(taskResult.task))
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

class _CollectButton extends StatelessWidget {
  const _CollectButton({Key? key, required this.list}) : super(key: key);

  final List<TaskFilterResult> list;
  @override
  Widget build(BuildContext context) {
    final ResultProvider model = context.read<ResultProvider>();
    final List<List<TaskFilterResult>> collectionTask =
        context.select<ResultProvider, List<List<TaskFilterResult>>>(
            (ResultProvider value) => value.collectionTask);
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
                child: Container(
                  color: Colors.white,
                  child: Image.asset(
                    Images.kkr,
                    width: 10,
                    height: 10,
                  ),
                ));
      },
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
    final bool hasScrolled = context.select<ResultProvider, bool>(
        (ResultProvider model) => model.hasScrolled);
    final String server = context.select<ResultProvider, String>(
        (ResultProvider model) => model.serverType);
    final ResultProvider model = context.read<ResultProvider>();
    return SliverPinnedToBoxAdapter(
      child: AnimateHeader(
        hasScrolled: hasScrolled,
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
                    showMaterialModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return _BossFilter(model, theme);
                        });
                  },
                )
              ],
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class _BossFilter extends StatelessWidget {
  const _BossFilter(
    this.model,
    this.theme, {
    Key? key,
  }) : super(key: key);

  final ResultProvider model;
  final ThemeData theme;

  Color getColor(bool selected) {
    return selected ? theme.accentColor : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ResultProvider>.value(
        value: model,
        child: Selector<ResultProvider, Tuple2<List<int>, List<ResultBoss>>>(
          selector: (_, ResultProvider model) =>
              Tuple2<List<int>, List<ResultBoss>>(
                  model.bossSet, model.resultBossList),
          shouldRebuild: (Tuple2<List<int>, List<ResultBoss>> prev,
                  Tuple2<List<int>, List<ResultBoss>> next) =>
              prev.item1.ne(next.item1) || prev.item2.ne(next.item2),
          builder: (_, Tuple2<List<int>, List<ResultBoss>> tuple, __) {
            final List<ResultBoss> resultBossList = tuple.item2;
            final List<int> bossSet = tuple.item1;
            return Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (ResultBoss boss in resultBossList)
                    _buildSelection(boss, bossSet),
                  MaterialButton(
                    minWidth: 120,
                    elevation: 0,
                    onPressed: () {
                      if (model.filterTask()) {
                        Navigator.pop(context);
                      }
                    },
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    color: theme.accentColor,
                    child:
                        const Text('确定', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            );
          },
        ));
  }

  Padding _buildSelection(ResultBoss boss, List<int> bossSet) {
    final bool shimmer = bossSet.contains(boss.prefabId);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                model.changeBossSet(boss.prefabId);
              },
              child: Opacity(
                opacity: shimmer ? 1 : 0.65,
                child: BossIcon(
                  prefabId: boss.prefabId,
                  shimmer: shimmer,
                  width: 45,
                  height: 45,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Wrap(
              children: [
                for (int count in <int>[1, 2, 3])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: MaterialButton(
                      minWidth: 0,
                      elevation: 0,
                      onPressed: () {
                        model.changeBossCount(count, boss);
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      color: getColor(count == boss.count).withOpacity(0.2),
                      child: Text(
                        '$count',
                        style: TextStyle(color: getColor(count == boss.count)),
                      ),
                    ),
                  )
              ],
            )
          ],
        ));
  }
}
