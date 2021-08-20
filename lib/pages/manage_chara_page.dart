import 'package:extended_sliver/extended_sliver.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
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
  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    return ChangeNotifierProvider<ManageCharaProvider>(
      create: (_) => ManageCharaProvider(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _Header(theme: theme),
          ],
        ),
      ),
    );
  }
}

// class _GroupChara extends StatelessWidget {
//   const _GroupChara({
//     Key? key,
//     required this.theme,
//     required this.title,
//     required this.charas,
//   }) : super(key: key);

//   final ThemeData theme;
//   final String title;
//   final List<Chara> charas;

//   @override
//   Widget build(BuildContext context) {
//     final ManageCharaProvider model = context.read<ManageCharaProvider>();
//     return MultiSliver(pushPinnedChildren: true, children: [
//       SliverPinnedToBoxAdapter(
//         child: Container(
//             color: theme.scaffoldBackgroundColor,
//             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             child: Text(title, style: textStyleH2)),
//       ),
//       Selector<ManageCharaProvider, Tuple3<int, List<Chara>, String>>( selector: (_, model) => Tuple3(model.showType, model.hiveCharaList, model.serverType), builder: (_,  tuple, __) {
//         return SliverPadding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         sliver: SliverWaterfallFlow(
//             gridDelegate:
//                 const SliverWaterfallFlowDelegateWithMaxCrossAxisExtent(
//               crossAxisSpacing: 8,
//               mainAxisSpacing: 8,
//               maxCrossAxisExtent: 50,
//             ),
//             delegate: SliverChildBuilderDelegate((
//               BuildContext c,
//               int index,
//             ) {
//               final Chara chara = charas[index];

//               return GestureDetector(
//                 onTap: () {
//                   model.addChara(chara);
//                 },
//                 child: Opacity(
//                   opacity: 2,
//                   child: IconChara(
//                     chara: chara,
//                     showRR: false,
//                   ),
//                 ),
//               );
//             }, childCount: charas.length)),
//       );
//       },),
//     ]);
//   }
// }

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final bool hasScrolled = context.watch<ManageCharaProvider>().hasScrolled;
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
                  ServerType.getName(context.watch<ManageCharaProvider>().serverType),
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
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container();
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
