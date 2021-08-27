import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:shimmer/shimmer.dart';

class BossIcon extends StatelessWidget {
  const BossIcon(
      {Key? key, this.width, this.shimmer = false, this.height, required this.prefabId, this.shape})
      : super(key: key);
  final double? width;
  final double? height;
  final int prefabId;
  final BoxShape? shape;
   final bool shimmer;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExtendedImage.network(
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
        ),
         if (shimmer)
            Shimmer.fromColors(child: Container(
              width: width,
              height: width,
              color: Colors.white.withOpacity(0.4),
            ), baseColor: Colors.transparent, highlightColor: Colors.white)
      ],
    );
  }
}
