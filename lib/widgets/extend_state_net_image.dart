import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ExtendStateNetImage extends StatelessWidget {
  const ExtendStateNetImage(
      {Key? key, required this.url, this.width, this.height})
      : super(key: key);
  final String url;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(url,
        cache: true,
        width: width,
        height: height,
        cacheKey: url,
        fit: BoxFit.cover,
        loadStateChanged: (ExtendedImageState state) {
          if (state.extendedImageLoadState == LoadState.loading) {
              
          } else if (state.extendedImageLoadState == LoadState.failed) {

          } else {
            
          }
        });
  }
}
