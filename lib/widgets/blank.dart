

import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/constants/constants.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';



class Blank extends StatelessWidget {
  const Blank({ Key? key, this.tip ='果咩,啥都没有' }) : super(key: key);
  final String tip;
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(Images.u1Blank, width: Screens.width / 2,),
          const SizedBox(height: 20),
          Text(tip, style: textStyleH2,)
        ],
      );
  }
} 




