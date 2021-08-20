import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:shimmer/shimmer.dart';

class IconChara extends StatelessWidget {
  const IconChara(
      {Key? key,
      required this.chara,
      this.showRR = true,
      this.shimmer = false,
      this.height = 40,
      this.width = 40})
      : super(key: key);
  final double? width;
  final double? height;
  final bool shimmer;

  final Chara chara;

  /// 是否显示rank Rarity
  final bool showRR;

  String getIconUrl(Chara chara) {
    if (chara.prefabId >= 100000 && chara.prefabId < 199999) {
      return PcrDbUrl.unitImg.replaceFirst(
          '{0}',
          (chara.prefabId +
                  ((chara.currentRarity ?? chara.rarity)! < 6 ? 30 : 60))
              .toString());
    }
    return PcrDbUrl.unitImg.replaceFirst('{0}', chara.prefabId.toString());
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Stack(
          children: [
            ExtendedImage.network(
              getIconUrl(chara),
              width: width,
              border: Border.all(
                  color: shimmer ? theme.accentColor : Colors.transparent,width: 2),
              cache: true,
              height: height,
              loadStateChanged: (ExtendedImageState state) {
                if (state.extendedImageLoadState == LoadState.loading) {
                  return Image.asset(
                    Images.unitIcon,
                    width: width,
                    height: height,
                  );
                } else if (state.extendedImageLoadState == LoadState.failed) {
                  return Image.asset(
                    Images.unitIcon,
                    width: width,
                    height: height,
                  );
                } else {}
              },
            ),
            if (shimmer)
            Shimmer.fromColors(child: Container(
              width: width,
              height: width,
              color: Colors.white.withOpacity(0.4),
            ), baseColor: Colors.transparent, highlightColor: Colors.white)
          ],
        ),
        if (showRR)
          Row(
            children: <Widget>[
              Text(
                '${chara.currentRarity}X',
                style: TextStyle(
                  color: HexColor.fromHex('#ff8a00'),
                ),
              ),
              Text(
                'R${chara.rank}',
                style: TextStyle(
                  color: HexColor.fromHex('#ff2277'),
                ),
              )
            ],
          )
      ],
    );
  }
}
