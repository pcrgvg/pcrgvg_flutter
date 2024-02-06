import 'package:extended_sliver/extended_sliver.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/providers/manage_chara_provider.dart';
import 'package:pcrgvg_flutter/widgets/animate_header.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/widgets/icon_chara.dart';
import 'package:pcrgvg_flutter/widgets/list_box.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:tuple/tuple.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

@FFRoute(
  name: "manageCharaPage",
  routeName: "manageCharaPage",
)
class ManageCharaPage extends StatelessWidget {
  bool getTypeChara(Chara chara, List<Chara> charaList, int showType) {
    if (showType == 1) {
      return true;
    } else if (showType == 2) {
      return charaList.indexWhere((a) => a.prefabId == chara.prefabId) > -1;
    } else if (showType == 3) {
      return charaList.indexWhere((a) => a.prefabId != chara.prefabId) > -1;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ChangeNotifierProvider<ManageCharaProvider>(
        create: (_) => ManageCharaProvider(),
        child: Scaffold(
          body: ListBox<ManageCharaProvider>(
            child: CustomScrollView(
              slivers: [
                _Header(theme: theme),
                Selector<ManageCharaProvider,
                    Tuple5<int, List<Chara>, List<Chara>, int, bool>>(
                  selector: (_, ManageCharaProvider model) =>
                      Tuple5<int, List<Chara>, List<Chara>, int, bool>(
                          model.showType,
                          model.hiveCharaList,
                          model.charaList,
                          model.sortType,
                          model.showName),
                  shouldRebuild:
                      (Tuple5<int, List<Chara>, List<Chara>, int, bool> prev,
                              Tuple5<int, List<Chara>, List<Chara>, int, bool>
                                  next) =>
                          prev.item1 != next.item1 ||
                          prev.item2.ne(next.item2) ||
                          prev.item3.ne(next.item3) ||
                          prev.item5 != next.item5 ||
                          prev.item4 != next.item4,
                  builder: (_,
                      Tuple5<int, List<Chara>, List<Chara>, int, bool> tuple,
                      __) {
                    final int showType = tuple.item1;
                    final List<Chara> charaList = tuple.item3;
                    final List<Chara> hiveCharaList = tuple.item2;
                    final int sortType = tuple.item4;
                    final bool showName = tuple.item5;
                    final List<Chara> front = charaList
                        .where((Chara chara) =>
                            chara.searchAreaWidth < 300 &&
                            getTypeChara(chara, hiveCharaList, showType))
                        .toList();
                    final List<Chara> middle = charaList
                        .where((Chara chara) =>
                            chara.searchAreaWidth > 300 &&
                            chara.searchAreaWidth < 600 &&
                            getTypeChara(chara, hiveCharaList, showType))
                        .toList();
                    final List<Chara> back = charaList
                        .where((Chara chara) =>
                            chara.searchAreaWidth > 600 &&
                            getTypeChara(chara, hiveCharaList, showType))
                        .toList();
                    if (sortType == 2) {
                      front.sort((a, b) => a.unitName.compareTo(b.unitName));
                      middle.sort((a, b) => a.unitName.compareTo(b.unitName));
                      back.sort((a, b) => a.unitName.compareTo(b.unitName));
                    }
                    return MultiSliver(children: [
                      _PinHeader(
                        theme: theme,
                        title: '前卫',
                      ),
                      _GroupChara(
                          charas: front,
                          hiveCharas: hiveCharaList,
                          showName: showName),
                      _PinHeader(
                        theme: theme,
                        title: '中卫',
                      ),
                      _GroupChara(
                          charas: middle,
                          hiveCharas: hiveCharaList,
                          showName: showName),
                      _PinHeader(
                        theme: theme,
                        title: '后卫',
                      ),
                      _GroupChara(
                          charas: back,
                          hiveCharas: hiveCharaList,
                          showName: showName),
                    ]);
                  },
                )
              ],
            ),
          ),
        ));
  }
}

class _GroupChara extends StatelessWidget {
  const _GroupChara({
    Key? key,
    required this.charas,
    required this.hiveCharas,
    required this.showName,
  }) : super(key: key);

  final List<Chara> charas;
  final List<Chara> hiveCharas;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    final ManageCharaProvider model = context.read<ManageCharaProvider>();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: showName ? _nameDelegate(model) : _defaultDelegate(model),
    );
  }

  /// 显示名称，一行2个
  SliverWaterfallFlow _nameDelegate(ManageCharaProvider model) {
    return SliverWaterfallFlow(
        gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 8, mainAxisSpacing: 8, crossAxisCount: 2),
        delegate: SliverChildBuilderDelegate((BuildContext c, int index) {
          final Chara chara = charas[index];
          final bool contain =
              hiveCharas.indexWhere((a) => a.prefabId == chara.prefabId) > -1;
          return GestureDetector(
            onTap: () {
              model.addChara(chara);
            },
            // child: Text(chara.unitName),
            child: Row(
              children: [
                Opacity(
                  opacity: contain ? 1 : 0.6,
                  child: IconChara(
                    chara: chara,
                    showRR: false,
                    shimmer: contain,
                  ),
                ),
                Expanded(
                  child: Text(
                    chara.unitName,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          );
        }, childCount: charas.length));
  }

  /// 默认视图，不显示名称
  SliverWaterfallFlow _defaultDelegate(ManageCharaProvider model) {
    return SliverWaterfallFlow(
        gridDelegate: const SliverWaterfallFlowDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 8, mainAxisSpacing: 8, maxCrossAxisExtent: 50),
        delegate: SliverChildBuilderDelegate((BuildContext c, int index) {
          final Chara chara = charas[index];
          final bool contain =
              hiveCharas.indexWhere((a) => a.prefabId == chara.prefabId) > -1;
          return GestureDetector(
            onTap: () {
              model.addChara(chara);
            },
            // child: Text(chara.unitName),
            child: Opacity(
              opacity: contain ? 1 : 0.6,
              child: IconChara(
                chara: chara,
                showRR: false,
                shimmer: contain,
              ),
            ),
          );
        }, childCount: charas.length));
  }
}

class _PinHeader extends StatelessWidget {
  const _PinHeader({
    Key? key,
    required this.theme,
    required this.title,
  }) : super(key: key);

  final ThemeData theme;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverPinnedToBoxAdapter(
      child: Container(
          color: theme.scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(title, style: textStyleH2)),
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
    final bool hasScrolled = context.select<ManageCharaProvider, bool>(
        (ManageCharaProvider model) => model.hasScrolled);
    final String serverType = context.select<ManageCharaProvider, String>(
        (ManageCharaProvider model) => model.serverType);
    final ManageCharaProvider model = context.read<ManageCharaProvider>();
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
                  ServerType.getName(serverType),
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
                          return _BottomFilter(
                            model: model,
                          );
                        });
                  },
                ),
              ],
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class _BottomFilter extends StatelessWidget {
  const _BottomFilter({Key? key, required this.model}) : super(key: key);

  final ManageCharaProvider model;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ChangeNotifierProvider<ManageCharaProvider>.value(
        value: model,
        child: Selector<ManageCharaProvider, Tuple4<int, String, bool, int>>(
          selector: (_, ManageCharaProvider model) =>
              Tuple4<int, String, bool, int>(model.showType, model.serverType,
                  model.showName, model.sortType),
          builder: (_, Tuple4<int, String, bool, int> tuple, __) {
            final String serverType = tuple.item2;
            final int showType = tuple.item1;
            final bool showName = tuple.item3;
            final int sortType = tuple.item4;
            return Container(
              height: 300,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ServerSelection(
                    theme: theme,
                    server: serverType,
                    model: model,
                  ),
                  _TypeSelection(
                    theme: theme,
                    showType: showType,
                    model: model,
                  ),
                  _NameSelection(
                    theme: theme,
                    showName: showName,
                    model: model,
                  ),
                  _SortSelection(
                    theme: theme,
                    sortType: sortType,
                    model: model,
                  ),
                ],
              ),
            );
          },
        ));
  }
}

class _TypeSelection extends StatelessWidget {
  const _TypeSelection({
    Key? key,
    required this.theme,
    required this.showType,
    required this.model,
  }) : super(key: key);
  final ThemeData theme;
  final int showType;
  final ManageCharaProvider model;
  Color getColor(bool selected) {
    return selected ? theme.colorScheme.secondary : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
            _buildButton(showType, 1, model),
            _buildButton(showType, 2, model),
            _buildButton(showType, 3, model),
          ],
        ))
      ],
    );
  }

  String getText(int type) {
    switch (type) {
      case 2:
        return '已选中';
      case 3:
        return '未选中';
      case 1:
      default:
        return '全部';
    }
  }

  Padding _buildButton(int showTpye, int type, ManageCharaProvider model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MaterialButton(
        minWidth: 0,
        elevation: 0,
        onPressed: () {
          model.showType = type;
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        color: getColor(showTpye == type).withOpacity(0.2),
        child: Text(
          getText(type),
          style: TextStyle(color: getColor(showTpye == type)),
        ),
      ),
    );
  }
}

class _ServerSelection extends StatelessWidget {
  const _ServerSelection({
    Key? key,
    required this.theme,
    required this.server,
    required this.model,
  }) : super(key: key);

  final ThemeData theme;
  final String server;
  final ManageCharaProvider model;

  Color getColor(bool selected) {
    return selected ? theme.colorScheme.secondary : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        const SizedBox(
          width: 56,
          child: Text(
            '服务器',
            style: textStyleH2,
          ),
        ),
        Expanded(
            child: Row(
          children: [
            _buildButton(
              server,
              ServerType.jp,
            ),
            _buildButton(
              server,
              ServerType.cn,
            ),
            _buildButton(
              server,
              ServerType.tw,
            ),
          ],
        ))
      ],
    );
  }

  Padding _buildButton(String server, String serverType) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MaterialButton(
        minWidth: 0,
        elevation: 0,
        onPressed: () {
          model.serverType = serverType;
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

class _NameSelection extends StatelessWidget {
  const _NameSelection({
    Key? key,
    required this.theme,
    required this.showName,
    required this.model,
  }) : super(key: key);

  final ThemeData theme;
  final bool showName;
  final ManageCharaProvider model;

  Color getColor(bool selected) {
    return selected ? theme.colorScheme.secondary : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        const SizedBox(
          width: 56,
          child: Text(
            '名称',
            style: textStyleH2,
          ),
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
                  model.showName = true;
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                color: getColor(showName).withOpacity(0.2),
                child: Text(
                  '显示',
                  style: TextStyle(color: getColor(showName)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: MaterialButton(
                minWidth: 0,
                elevation: 0,
                onPressed: () {
                  model.showName = false;
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                color: getColor(!showName).withOpacity(0.2),
                child: Text(
                  '不显示',
                  style: TextStyle(color: getColor(!showName)),
                ),
              ),
            )
          ],
        ))
      ],
    );
  }
}

class _SortSelection extends StatelessWidget {
  const _SortSelection({
    Key? key,
    required this.theme,
    required this.sortType,
    required this.model,
  }) : super(key: key);

  final ThemeData theme;
  final int sortType;
  final ManageCharaProvider model;

  Color getColor(bool selected) {
    return selected ? theme.colorScheme.secondary : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        const SizedBox(
          width: 56,
          child: Text(
            '排序',
            style: textStyleH2,
          ),
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
                  model.sortType = 1;
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                color: getColor(sortType == 1).withOpacity(0.2),
                child: Text(
                  '站位',
                  style: TextStyle(color: getColor(sortType == 1)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: MaterialButton(
                minWidth: 0,
                elevation: 0,
                onPressed: () {
                  model.sortType = 2;
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                color: getColor(sortType == 2).withOpacity(0.2),
                child: Text(
                  '名称',
                  style: TextStyle(color: getColor(sortType == 2)),
                ),
              ),
            )
          ],
        ))
      ],
    );
  }
}
