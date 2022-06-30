import 'dart:ui';

import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
@FFArgumentImport()
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/widgets/bg_cover.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

@FFRoute(
  name: "linkDetailPage",
  routeName: "linkDetailPage",
)
class LinkDetailPage extends StatelessWidget {
  const LinkDetailPage({Key? key, required this.link, this.bgUrl})
      : super(key: key);
  final Link link;
  final String? bgUrl;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          BgCover(bgUrl: bgUrl),
          Positioned.fill(
            child: WaterfallFlow(
                gridDelegate:
                    const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 16,
                ),
                padding: EdgeInsets.only(
                    top: Screens.statusBarHeight + 100,
                    left: 16,
                    right: 16,
                    bottom: 16),
                physics: const BouncingScrollPhysics(),
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (link.link.isNotEmpty) {
                        link.link.launchApp();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: theme.backgroundColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16))),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '视频地址',
                            style: textStyleH2,
                          ),
                          Text(
                            link.name,
                            style:
                                TextStyle(color: HexColor.fromHex('#1890ff')),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16))),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '备注',
                              style: textStyleH2,
                            ),
                            MaterialButton(
                              minWidth: 0,
                              elevation: 0,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              color:
                                  theme.colorScheme.secondary.withOpacity(0.2),
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: link.remarks));
                                '已复制'.toast();
                              },
                              child: Text(
                                '复制',
                                style: TextStyle(
                                    color: theme.colorScheme.secondary),
                              ),
                            ),
                          ],
                        ),
                        Text(link.remarks)
                      ],
                    ),
                  )
                ]),
          ),
          _Back(theme: theme),
        ],
      ),
    );
  }
}

class _Back extends StatelessWidget {
  const _Back({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 16,
        top: Screens.statusBarHeight,
        child: MaterialButton(
          minWidth: 36,
          height: 36,
          child: const Icon(Icons.chevron_left),
          shape: circleShape,
          color: theme.backgroundColor,
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
        ));
  }
}
