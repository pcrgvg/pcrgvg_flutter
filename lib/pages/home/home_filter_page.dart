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
              return Scaffold(
                body: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification:
                      (OverscrollIndicatorNotification notification) {
                    notification.disallowGlow();
                    return true;
                  },
                  child: SmartRefresher(
                    controller: homeFiltermodel.refreshController,
                    enablePullDown: true,
                    enablePullUp: false,
                    header: WaterDropMaterialHeader(
                      backgroundColor: theme.accentColor,
                      color: theme.accentColor.computeLuminance() < 0.5
                          ? Colors.white
                          : Colors.black,
                      distance: 42.0,
                    ),
                    onRefresh: homeFiltermodel.refresh,
                    child: CustomScrollView(
                      slivers: <Widget>[
                        _Header(theme: theme),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          sliver: MultiSliver(children: [
                            _ServerSelection(
                                theme: theme, homeFiltermodel: homeFiltermodel),
                            _ClanSelection(
                                theme: theme, homeFiltermodel: homeFiltermodel),
                            _BossSelection(homeFiltermodel: homeFiltermodel),
                            SliverToBoxAdapter(
                              // child: ,
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}

class _BossSelection extends StatelessWidget {
  const _BossSelection({
    Key? key,
    required this.homeFiltermodel
  }) : super(key: key);
   final HomeFilterProvider homeFiltermodel;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Selector<HomeFilterProvider,
          Tuple2<List<UnitBoss>, List<int>>>(
        selector: (_, HomeFilterProvider model) =>
            Tuple2<List<UnitBoss>, List<int>>(
                model.bossList,
                model.gvgTaskFilter.bossPrefabs),
        builder: (_,
            Tuple2<List<UnitBoss>, List<int>> tuple,
            __) {
          return Row(
            children: [
              const SizedBox(
                width: 56,
                child: Text(
                  'BOSS',
                  style: textStyleH2,
                ),
              ),
              for (UnitBoss item in tuple.item1)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      homeFiltermodel.setBoss(item.prefabId);
                    },
                    child: Opacity(opacity: tuple.item2.contains(item.prefabId) ? 1: 0.7, child: 
                    ExtendedImage.network(
                      PcrDbUrl.unitImg.replaceFirst(
                        '{0}',
                        item.prefabId.toString(),
                      ),
                      width: 40,
                      height: 40,
                      
                    ),),
                  ),
                )
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
  const _Header({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SliverPinnedToBoxAdapter(
      child: AnimateHeader(
        hasScrolled: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '搜索',
              style: textStyleH1,
            ),
            TextButton(onPressed: () {}, child: Text('确定'))
          ],
        ),
      ),
    );
  }
}
