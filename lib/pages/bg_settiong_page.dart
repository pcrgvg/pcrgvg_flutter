import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/providers/user_provider.dart';
import 'package:pcrgvg_flutter/widgets/icon_chara.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:provider/provider.dart';

@FFRoute(
  name: "bgSettiongPage",
  routeName: "bgSettiongPage",
)
class BgSettiongPage extends StatefulWidget {
  const BgSettiongPage({Key? key}) : super(key: key);

  @override
  _BgSettiongPage createState() => _BgSettiongPage();
}

class _BgSettiongPage extends State<BgSettiongPage> {
  List<Chara> charaList = [];
  @override
  void initState() {
    getCharaList();
    super.initState();
  }

  void getCharaList() {
    PcrDb.charaList(ServerType.jp).then((List<Chara> value) {
      charaList = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // const BgCover(),
          Positioned.fill(
            child: WaterfallFlow(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                top: Screens.statusBarHeight + 100,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              gridDelegate:
                  const SliverWaterfallFlowDelegateWithMaxCrossAxisExtent(
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      maxCrossAxisExtent: 50),
              children: [
                for (Chara chara in charaList)
                  GestureDetector(
                    onTap: () {
                      showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return _SetBg(prefabId: chara.prefabId);
                          });
                    },
                    child: IconChara(
                      chara: chara,
                      showRR: false,
                    ),
                  )
              ],
            ),
          ),
          _Back(theme: theme),
        ],
      ),
    );
  }
}

class _SetBg extends StatefulWidget {
  const _SetBg({
    Key? key,
    required this.prefabId,
  }) : super(key: key);
  final int prefabId;

  @override
  __SetBgState createState() => __SetBgState();
}

class __SetBgState extends State<_SetBg> {
  double sigmaY = 0;

  double sigmaX = 0;

  @override
  Widget build(BuildContext context) {
    final String url =
        PcrDbUrl.cardImg.replaceFirst('{0}', '${widget.prefabId + 30}');
    final UserProvider model = context.read<UserProvider>();
    final ThemeData theme = Theme.of(context);
    return Container(
      child: Stack(
        children: [
          _buildBg(url),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('X'),
                        Expanded(
                          child: Slider.adaptive(
                              value: sigmaX,
                              max: 15,
                              min: 0,
                              divisions: 15,
                              label: '$sigmaX',
                              onChanged: (value) {
                                sigmaX = value;
                                setState(() {});
                              }),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Y'),
                        Expanded(child: Slider.adaptive(
                            value: sigmaY,
                            max: 15,
                            min: 0,
                            divisions: 15,
                            label: '$sigmaY',
                            onChanged: (value) {
                              sigmaY = value;
                              setState(() {});
                            })),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MaterialButton(
                            minWidth: 80,
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            color: theme.primaryColor.withOpacity(0.2),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "取消",
                              style: TextStyle(color: theme.primaryColor),
                            )),
                        MaterialButton(
                            minWidth: 80,
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            color: theme.colorScheme.secondary.withOpacity(0.2),
                            onPressed: () {
                              Navigator.pop(context);
                              model.changeBgChara(widget.prefabId);
                              model.changeBlur(sigmaX, sigmaY);
                            },
                            child: Text(
                              "确定",
                              style: TextStyle(color: theme.colorScheme.secondary),
                            )),
                      ],
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Positioned _buildBg(String url) {
    return Positioned.fill(
        child: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: ExtendedNetworkImageProvider(url),
        fit: BoxFit.cover,
      )),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: sigmaY, sigmaX: sigmaX),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    ));
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
