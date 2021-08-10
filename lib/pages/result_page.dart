import 'package:extended_image/extended_image.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
@FFArgumentImport()
import 'package:pcrgvg_flutter/isolate/filter_task.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_routes.dart';
import 'package:pcrgvg_flutter/widgets/animate_header.dart';
import 'package:pcrgvg_flutter/widgets/auto_type_view.dart';
import 'package:pcrgvg_flutter/widgets/icon_chara.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

@FFRoute(
  name: "resultPage",
  routeName: "resultPage",
)
class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.list}) : super(key: key);
  final List<List<TaskFilterResult>> list;

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: CustomScrollView(
            slivers: [
              SliverPinnedToBoxAdapter(
                child: AnimateHeader(
                  hasScrolled: false,
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                         MaterialButton(
                      minWidth: 36,
                      height: 36,
                      child: const Icon(Icons.chevron_left),
                      shape: circleShape,
                      color: true
                          ? theme.scaffoldBackgroundColor
                          : theme.backgroundColor,
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                     MaterialButton(
                      minWidth: 36,
                      height: 36,
                      child: const Icon(Icons.expand_more),
                      shape: circleShape,
                      color: true
                          ? theme.scaffoldBackgroundColor
                          : theme.backgroundColor,
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(),
                     ],
                  ),
                ),
              ),
              SliverWaterfallFlow(
                  gridDelegate:
                      const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate((
                    BuildContext c,
                    int index,
                  ) {
                    final List<TaskFilterResult> taskList = widget.list[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(Routes.resultDetailPage.name, arguments: Routes.resultDetailPage.d(taskResult: taskList));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: theme.backgroundColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16))),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
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
                                  )
                                ],
                              ),
                              for (TaskFilterResult taskResult in taskList)
                                Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ExtendedImage.network(
                                            PcrDbUrl.unitImg.replaceFirst(
                                              '{0}',
                                              taskResult.prefabId.toString(),
                                            ),
                                            width: 30,
                                            height: 30,
                                          ),
                                          Text(
                                            '${taskResult.task.damage}w',
                                            style: TextStyle(
                                                color:
                                                    HexColor.fromHex('#ff2277'),
                                                fontSize: 18),
                                          ),
                                          for (var item
                                              in taskResult.task.canAuto)
                                            AutoTypeView(
                                              type: item,
                                            )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          for (var chara
                                              in taskResult.task.charas)
                                            IconChara(chara: chara),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    );
                  }, childCount: widget.list.length))
            ],
          ))
        ],
      ),
    );
  }
}
