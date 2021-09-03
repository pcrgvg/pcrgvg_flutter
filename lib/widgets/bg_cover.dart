

import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/providers/user_provider.dart';
import 'package:provider/provider.dart';



class BgCover extends StatelessWidget {
   const BgCover({
    Key? key,
     this.bgUrl,
    this.sigmaX,
    this.sigmaY
  }) : super(key: key);

  final String? bgUrl;
  final double? sigmaY;
  final double? sigmaX;

  @override
  Widget build(BuildContext context) {
    final int prefabId = context.select<UserProvider, int>((UserProvider model) => model.userConfig.bgCharaPrefabId);
    final double bgBlurY = context.select<UserProvider, double>((UserProvider model) => model.userConfig.bgBlurY);
    final double bgBlurX = context.select<UserProvider, double>((UserProvider model) => model.userConfig.bgBlurX);
       final String url = PcrDbUrl.cardImg
        .replaceFirst('{0}', '${prefabId + 30}');
    final bool showBg = context.select<UserProvider, bool>((UserProvider model) => model.userConfig.showBg);
    return Positioned.fill(
      child: showBg ? Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExtendedNetworkImageProvider(bgUrl ?? url), fit: BoxFit.cover)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: sigmaY ?? bgBlurY, sigmaX: sigmaX ?? bgBlurX),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ): Container(),
    );
  }
}



