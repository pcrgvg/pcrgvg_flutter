import 'package:extended_sliver/extended_sliver.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/providers/home_filter_provider.dart';
@FFArgumentImport()
import 'package:pcrgvg_flutter/providers/home_provider.dart';
import 'package:pcrgvg_flutter/widgets/animate_header.dart';
import 'package:pcrgvg_flutter/widgets/list_box.dart';
import 'package:provider/provider.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tuple/tuple.dart';

@FFRoute(
  name: "homeFilterPage",
  routeName: "homeFilterPage",
)
class HomeFilterPage extends StatelessWidget {
  const HomeFilterPage({Key? key, required this.homeProvider})
      : super(key: key);
  final HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ChangeNotifierProvider<HomeFilterProvider>(
        create: (_) => HomeFilterProvider(),
        child: Scaffold(
          body: ListBox<HomeFilterProvider>(
              child: CustomScrollView(
            slivers: <Widget>[
              _Header(theme: theme),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                sliver: MultiSliver(children: [
                  _ServerSelection(theme: theme),
                  _ClanSelection(
                    theme: theme,
                  ),
                  _BossSelection(
                    theme: theme,
                  ),
                  _StageSelection(
                    theme: theme,
                  ),
                  _MethodSelection(
                    theme: theme,
                  ),
                  _UsedOrRemovedSelection(
                    theme: theme,
                  ),
                ]),
              ),
            ],
          )),
        ));
  }
}

class _UsedOrRemovedSelection extends StatelessWidget {
  const _UsedOrRemovedSelection(
      {Key? key, required this.theme,})
      : super(key: key);
  final ThemeData theme;
  Color getColor(bool selected) {
    return selected ? theme.accentColor : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
      final HomeFilterProvider homeFiltermodel = context.read<HomeFilterProvider>();
    final List<String> taskTypes = context.select<HomeFilterProvider, List<String>>(
        (HomeFilterProvider model) => model.gvgTaskFilter.taskTypes);
    return SliverToBoxAdapter(
      child: Row(
        children: [
          const SizedBox(
            width: 56,
            child: Text(
              '类别',
              style: textStyleH2,
            ),
          ),
          Expanded(
              child: Wrap(
            children: [
              _buildButton(taskTypes, TaskType.all, homeFiltermodel),
              _buildButton(taskTypes, TaskType.used, homeFiltermodel),
              _buildButton(taskTypes, TaskType.removed, homeFiltermodel),
              _buildButton(taskTypes, TaskType.tail,homeFiltermodel),
            ],
          ))
        ],
      ),
    );
  }



  Padding _buildButton(List<String> usedOrRemoved, String type, HomeFilterProvider homeFiltermodel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MaterialButton(
        minWidth: 0,
        elevation: 0,
        onPressed: () {
          homeFiltermodel.setTaskTypes(type);
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        color: getColor(usedOrRemoved.contains(type)).withOpacity(0.2),
        child: Text(
         TaskType.getName(type),
          style: TextStyle(color: getColor(usedOrRemoved.contains(type))),
        ),
      ),
    );
  }
}

class _MethodSelection extends StatelessWidget {
  const _MethodSelection(
      {Key? key,  required this.theme})
      : super(key: key);
  final ThemeData theme;
  Color getColor(bool selected) {
   return selected ? theme.accentColor : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
      final HomeFilterProvider homeFiltermodel = context.read<HomeFilterProvider>();
    return SliverToBoxAdapter(
        child: Selector<HomeFilterProvider, List<int>>(
      selector: (_, HomeFilterProvider model) => model.gvgTaskFilter.methods,
      builder: (_, List<int> methods, __) {
        return Row(
          children: [
            const SizedBox(
              width: 56,
              child: Text(
                '自动',
                style: textStyleH2,
              ),
            ),
            Expanded(
                child: Wrap(
              children: [
                _buildButton(methods, AutoType.manual, homeFiltermodel),
                _buildButton(methods, AutoType.auto, homeFiltermodel),
                _buildButton(methods, AutoType.harfAuto, homeFiltermodel),
              ],
            ))
          ],
        );
      },
    ));
  }

  Padding _buildButton(List<int> methods, int autoType, HomeFilterProvider homeFiltermodel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MaterialButton(
        minWidth: 0,
        elevation: 0,
        onPressed: () {
          homeFiltermodel.setMethods(autoType);
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        color: getColor(methods.contains(autoType)).withOpacity(0.2),
        child: Text(
          AutoType.getName(autoType),
          style: TextStyle(color: getColor(methods.contains(autoType))),
        ),
      ),
    );
  }
}

class _StageSelection extends StatelessWidget {
  const _StageSelection(
      {Key? key, required this.theme})
      : super(key: key);

  final ThemeData theme;
  Color getColor(bool selected) {
   return selected ? theme.accentColor : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
      final HomeFilterProvider homeFiltermodel = context.read<HomeFilterProvider>();
    return SliverToBoxAdapter(
        child: Selector<HomeFilterProvider, Tuple2<List<LvPair>, int>>(
      selector: (_, HomeFilterProvider model) => Tuple2<List<LvPair>, int>(
          model.stageOption, model.gvgTaskFilter.stage),
      builder: (_, Tuple2<List<LvPair>, int> tuple, __) {
        return Row(
          children: [
            const SizedBox(
              width: 56,
              child: Text(
                '阶段',
                style: textStyleH2,
              ),
            ),
            Expanded(
                child: Wrap(
              children: [
                for (LvPair item in tuple.item1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: MaterialButton(
                      minWidth: 0,
                      elevation: 0,
                      onPressed: () {
                        homeFiltermodel.setStage(item.value as int);
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      color:
                          getColor(item.value == tuple.item2).withOpacity(0.2),
                      child: Text(
                        item.label,
                        style: TextStyle(
                            color: getColor(item.value == tuple.item2)),
                      ),
                    ),
                  ),
              ],
            ))
          ],
        );
      },
    ));
  }
}

class _BossSelection extends StatelessWidget {
  const _BossSelection(
      {Key? key,  required this.theme})
      : super(key: key);

  Color getColor(bool selected) {
   return selected ? theme.accentColor : Colors.grey;
  }

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
      final HomeFilterProvider homeFiltermodel = context.read<HomeFilterProvider>();
    return SliverToBoxAdapter(
      child: Selector<HomeFilterProvider, List<int>>(
        selector: (_, HomeFilterProvider model) =>
            model.gvgTaskFilter.bossNumber,
        builder: (_, List<int> bossNumberList, __) {
          return Row(
            children: [
              const SizedBox(
                width: 56,
                child: Text(
                  'BOSS',
                  style: textStyleH2,
                ),
              ),
              Expanded(
                  child: Wrap(
                direction: Axis.horizontal,
                children: [
                  for (int item in [1, 2, 3, 4, 5])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () {
                          homeFiltermodel.setBoss(item);
                        },
                        child: MaterialButton(
                          minWidth: 0,
                          elevation: 0,
                          onPressed: () {
                            homeFiltermodel.setBoss(item);
                          },
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          color: getColor(bossNumberList.contains(item))
                              .withOpacity(0.2),
                          child: Text(
                            '$item',
                            style: TextStyle(
                                color: getColor(bossNumberList.contains(item))),
                          ),
                        ),
                      ),
                    )
                ],
              ))
            ],
          );
        },
      ),
    );
  }
}

class _ClanSelection extends StatelessWidget {
  const _ClanSelection({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  Color getColor(bool selected) {
   return selected ? theme.accentColor : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
      final HomeFilterProvider homeFiltermodel = context.read<HomeFilterProvider>();
    return SliverToBoxAdapter(
      child: Selector<HomeFilterProvider, Tuple2<List<ClanPeriod>, int>>(
        selector: (_, HomeFilterProvider model) =>
            Tuple2<List<ClanPeriod>, int>(
                model.clanPeriodList, model.gvgTaskFilter.clanBattleId),
        builder: (_, Tuple2<List<ClanPeriod>, int> tuple, __) {
          return Row(
            children: [
              const SizedBox(
                width: 56,
                child: Text(
                  '期次',
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                      textBaseline: TextBaseline.alphabetic),
                ),
              ),
              Expanded(
                  child: Wrap(
                direction: Axis.horizontal,
                children: [
                  for (ClanPeriod item in tuple.item1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: MaterialButton(
                        minWidth: 0,
                        elevation: 0,
                        onPressed: () {
                          homeFiltermodel.setClanPeriod(item);
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        color: getColor(item.clanBattleId == tuple.item2)
                            .withOpacity(0.2),
                        child: Text(
                          item.startTime.dateFormate(),
                          style: TextStyle(
                              color:
                                  getColor(item.clanBattleId == tuple.item2)),
                        ),
                      ),
                    ),
                ],
              ))
            ],
          );
        },
      ),
    );
  }
}

class _ServerSelection extends StatelessWidget {
  const _ServerSelection({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;


  Color getColor(bool selected) {
    return selected ? theme.accentColor : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
      final HomeFilterProvider homeFiltermodel = context.read<HomeFilterProvider>();
    return SliverToBoxAdapter(
      child: Selector<HomeFilterProvider, String>(
        selector: (_, HomeFilterProvider model) => model.gvgTaskFilter.server,
        builder: (_, String server, __) {
          return Flex(
            direction: Axis.horizontal,
            children: [
              const SizedBox(
                width: 56,
                child: Text('服务器', style: textStyleH2),
              ),
              Expanded(
                  child: Row(
                children: [
                  _buildButton(server, ServerType.jp, homeFiltermodel),
                  _buildButton(server, ServerType.cn, homeFiltermodel),
                  _buildButton(server, ServerType.tw, homeFiltermodel),
                ],
              ))
            ],
          );
        },
      ),
    );
  }

  Padding _buildButton(String server, String serverType, HomeFilterProvider homeFiltermodel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MaterialButton(
        minWidth: 0,
        elevation: 0,
        onPressed: () {
          homeFiltermodel.setServer(serverType);
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        color: getColor(server == serverType).withOpacity(0.2),
        child: Text(
          ServerType.getName(serverType),
          style: TextStyle(color: getColor(server == serverType)),
        ),
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
    final HomeFilterProvider homeFiltermodel =
        context.read<HomeFilterProvider>();
    return SliverPinnedToBoxAdapter(
      child: AnimateHeader(
        hasScrolled: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              '搜索',
              style: textStyleH1,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(homeFiltermodel.gvgTaskFilter);
                },
                child: const Text('确定'))
          ],
        ),
      ),
    );
  }
}
