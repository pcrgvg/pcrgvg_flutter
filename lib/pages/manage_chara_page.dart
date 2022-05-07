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
                      Tuple3<int, List<Chara>, List<Chara>>>(
                    selector: (_, ManageCharaProvider model) =>
                        Tuple3<int, List<Chara>, List<Chara>>(
                            model.showType, model.hiveCharaList, model.charaList),
                    shouldRebuild: (Tuple3<int, List<Chara>, List<Chara>> prev,
                            Tuple3<int, List<Chara>, List<Chara>> next) =>
                        prev.item1 != next.item1 ||
                        prev.item2.ne(next.item2) ||
                        prev.item3.ne(next.item3),
                    builder:
                        (_, Tuple3<int, List<Chara>, List<Chara>> tuple, __) {
                      final int showType = tuple.item1;
                      final List<Chara> charaList = tuple.item3;
                      final List<Chara> hiveCharaList = tuple.item2;
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
                      return MultiSliver(children: [
                        _PinHeader(
                          theme: theme,
                          title: '前卫',
                        ),
                        _GroupChara(
                          charas: front,
                          hiveCharas: hiveCharaList,
                        ),
                        _PinHeader(
                          theme: theme,
                          title: '中卫',
                        ),
                        _GroupChara(
                          charas: middle,
                          hiveCharas: hiveCharaList,
                        ),
                        _PinHeader(
                          theme: theme,
                          title: '后卫',
                        ),
                        _GroupChara(
                          charas: back,
                          hiveCharas: hiveCharaList,
                        ),
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
  }) : super(key: key);

  final List<Chara> charas;
  final List<Chara> hiveCharas;

  @override
  Widget build(BuildContext context) {
    final ManageCharaProvider model = context.read<ManageCharaProvider>();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverWaterfallFlow(
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
              child: Opacity(
                opacity: contain ? 1 : 0.6,
                child: IconChara(
                  chara: chara,
                  showRR: false,
                  shimmer: contain,
                ),
              ),
            );
          }, childCount: charas.length)),
    );
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
    final bool hasScrolled =
        context.select<ManageCharaProvider, bool>((ManageCharaProvider model) => model.hasScrolled);
    final String serverType = context
        .select<ManageCharaProvider, String>((ManageCharaProvider model) => model.serverType);
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
        child: Selector<ManageCharaProvider, Tuple2<int, String>>(
          selector: (_, ManageCharaProvider model) =>
              Tuple2<int, String>(model.showType, model.serverType),
          builder: (_, Tuple2<int, String> tuple, __) {
            final String serverType = tuple.item2;
            final int showType = tuple.item1;
            return Container(
              height: 200,
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
                  )
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
