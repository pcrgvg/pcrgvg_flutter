import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/model/models.dart';

class IconChara extends StatelessWidget {
  const IconChara({Key? key, required this.chara, this.showRR = true})
      : super(key: key);

  final Chara chara;

  /// 是否显示rank Rarity
  final bool showRR;

  String getIconUrl(Chara chara) {
    if (chara.prefabId >= 100000 && chara.prefabId < 199999) {
      return PcrDbUrl.unitImg.replaceFirst('{0}',
          (chara.prefabId + (chara.currentRarity! < 6 ? 30 : 60)).toString());
    }
    return PcrDbUrl.unitImg.replaceFirst('{0}', chara.prefabId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExtendedImage.network(
          PcrDbUrl.unitImg.replaceFirst(
              '{0}',
              (chara.prefabId + (chara.currentRarity! < 6 ? 30 : 60))
                  .toString()),
          width: 40,
          cache: true,
          height: 40,
          loadStateChanged: (ExtendedImageState state) {
            if (state.extendedImageLoadState == LoadState.loading) {
              return Image.asset(Images.unitIcon, width: 40, height: 40,);
            } else if (state.extendedImageLoadState == LoadState.failed) {
               return Image.asset(Images.unitIcon, width: 40, height: 40,);
            } else {}
          },
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