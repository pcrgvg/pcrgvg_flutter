import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';

class BossIcon extends StatelessWidget {
  const BossIcon(
      {Key? key, this.width, this.height, required this.prefabId, this.shape})
      : super(key: key);
  final double? width;
  final double? height;
  final int prefabId;
  final BoxShape? shape;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      PcrDbUrl.unitImg.replaceFirst(
        '{0}',
        prefabId.toString(),
      ),
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
    );
  }
}
