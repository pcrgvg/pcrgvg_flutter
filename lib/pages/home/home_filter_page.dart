import 'package:extended_image/extended_image.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/providers/home_filter_provider.dart';
@FFArgumentImport()
import 'package:pcrgvg_flutter/providers/home_provider.dart';
import 'package:pcrgvg_flutter/widgets/animate_header.dart';
import 'package:pcrgvg_flutter/widgets/list_box.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
        child: Selector<HomeFilterProvider, HomeFilterProvider>(
            selector: (_, HomeFilterProvider homeFiltermodel) =>
                homeFiltermodel,
            builder: (_, HomeFilterProvider homeFiltermodel, Widget? c) {
              return ListBox<HomeFilterProvider>(model: homeFiltermodel, child: CustomScrollView(
                      slivers: <Widget>[
                        _Header(theme: theme, homeFiltermodel: homeFiltermodel),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          sliver: MultiSliver(children: [
                            _ServerSelection(
                                theme: theme, homeFiltermodel: homeFiltermodel),
                            _ClanSelection(
                              theme: theme,
                              homeFiltermodel: homeFiltermodel,
                            ),
                            _BossSelection(
                              homeFiltermodel: homeFiltermodel,
                              theme: theme,
                            ),
                            _StageSelection(
                                theme: theme, homeFiltermodel: homeFiltermodel),
                            _MethodSelection(
                                theme: theme, homeFiltermodel: homeFiltermodel),
                            _UsedOrRemovedSelection(
                                theme: theme, homeFiltermodel: homeFiltermodel),
                          ]),
                        ),
                      ],
                    ));

            }));
  }
}

class _UsedOrRemovedSelection extends StatelessWidget {
  const _UsedOrRemovedSelection(
      {Key? key, required this.theme, required this.homeFiltermodel})
      : super(key: key);
  final HomeFilterProvider homeFiltermodel;
  final ThemeData theme;
  Color getColor(bool selected) {
    return selected ? theme.primaryColor : theme.accentColor;
  }

  @override
  Widget build(BuildContext context) {
    final String usedOrRemoved = context.select<HomeFilterProvider, String>(
        (HomeFilterProvider model) => model.gvgTaskFilter.usedOrRemoved);
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
              _buildButton(usedOrRemoved, 'all'),
              _buildButton(usedOrRemoved, 'used'),
              _buildButton(usedOrRemoved, 'removed'),
              _buildButton(usedOrRemoved, 'tail'),
            ],
          ))
        ],
      ),
    );
  }

  String getText(String type) {
    switch (type) {
      case 'used':
        return '已使用';
      case 'removed':
        return '已去除';
      case 'tail':
        return '尾刀';
      case 'all':
      default:
        return '全部';
    }
  }

  Padding _buildButton(String usedOrRemoved, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MaterialButton(
        minWidth: 0,
        elevation: 0,
        onPressed: () {
          homeFiltermodel.setUsedOrRemoved(type);
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        color: getColor(usedOrRemoved == type).withOpacity(0.2),
        child: Text(
          getText(type),
          style: TextStyle(color: getColor(usedOrRemoved == type)),
        ),
      ),
    );
  }
}

class _MethodSelection extends StatelessWidget {
  const _MethodSelection(
      {Key? key, required this.homeFiltermodel, required this.theme})
      : super(key: key);
  final HomeFilterProvider homeFiltermodel;
  final ThemeData theme;
  Color getColor(bool selected) {
    return selected ? theme.primaryColor : theme.accentColor;
  }

  @override
  Widget build(BuildContext context) {
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
                _buildButton(methods, AutoType.manual),
                _buildButton(methods, AutoType.auto),
                _buildButton(methods, AutoType.harfAuto),
              ],
            ))
          ],
        );
      },
    ));
  }

  String getText(int type) {
    switch (type) {
      case AutoType.auto:
        return '自动';
      case AutoType.harfAuto:
        return '半自动';
      case AutoType.manual:
      default:
        return '手动';
    }
  }

  Padding _buildButton(List<int> methods, int autoType) {
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
          getText(autoType),
          style: TextStyle(color: getColor(methods.contains(autoType))),
        ),
      ),
    );
  }
}

class _StageSelection extends StatelessWidget {
  const _StageSelection(
      {Key? key, required this.homeFiltermodel, required this.theme})
      : super(key: key);

  final HomeFilterProvider homeFiltermodel;
  final ThemeData theme;
  Color getColor(bool selected) {
    return selected ? theme.primaryColor : theme.accentColor;
  }

  @override
  Widget build(BuildContext context) {
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
      {Key? key, required this.homeFiltermodel, required this.theme})
      : super(key: key);
  final HomeFilterProvider homeFiltermodel;

  Color getColor(bool selected) {
    return selected ? theme.primaryColor : theme.accentColor;
  }

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
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
    required this.homeFiltermodel,
  }) : super(key: key);

  final ThemeData theme;
  final HomeFilterProvider homeFiltermodel;

  Color getColor(bool selected) {
    return selected ? theme.primaryColor : theme.accentColor;
  }

  @override
  Widget build(BuildContext context) {
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
    required this.homeFiltermodel,
  }) : super(key: key);

  final ThemeData theme;
  final HomeFilterProvider homeFiltermodel;
  // final GvgTaskFilterHive gvgTaskFilterHive;

  Color getColor(bool selected) {
    return selected ? theme.primaryColor : theme.accentColor;
  }

  @override
  Widget build(BuildContext context) {
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: MaterialButton(
                      minWidth: 0,
                      elevation: 0,
                      onPressed: () {
                        homeFiltermodel.setServer('jp');
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      color: getColor(server == 'jp').withOpacity(0.2),
                      child: Text(
                        '日服',
                        style: TextStyle(color: getColor(server == 'jp')),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: MaterialButton(
                      minWidth: 0,
                      elevation: 0,
                      onPressed: () {
                        homeFiltermodel.setServer('cn');
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      color: getColor(server == 'cn').withOpacity(0.2),
                      child: Text(
                        '国服',
                        style: TextStyle(color: getColor(server == 'cn')),
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

class _Header extends StatelessWidget {
  const _Header({Key? key, required this.theme, required this.homeFiltermodel})
      : super(key: key);

  final ThemeData theme;
  final HomeFilterProvider homeFiltermodel;

  @override
  Widget build(BuildContext context) {
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