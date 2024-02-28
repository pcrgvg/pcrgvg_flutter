import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';

class TalentIcon extends StatelessWidget {
  const TalentIcon(
      {Key? key, this.width, this.height, this.shape, this.talentId})
      : super(key: key);
  final double? width;
  final double? height;
  final BoxShape? shape;
  final int? talentId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExtendedImage.asset(
          Talent.getTalent(talentId),
          shape: shape,
          width: width,
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
      ],
    );
  }
}
