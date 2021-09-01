import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';

class AutoTypeView extends StatelessWidget {
  const AutoTypeView({Key? key, required this.type}) : super(key: key);
  final int type;

  Color getColor(int type) {
    switch (type) {
      case AutoType.auto:
        return HexColor.fromHex('#68B9FF');
      case AutoType.harfAuto:
        return HexColor.fromHex('#1cbbb4');
      case AutoType.manual:
      default:
        return HexColor.fromHex('#FF2277');
    }
  }


  @override
  Widget build(BuildContext context) {
    final Color color = getColor(type);
    final String text = AutoType.getName(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Text(text, style: TextStyle(color: color, height: 1.1),),
    );

    // return Container(
    //   width: 20,
    //   decoration: BoxDecoration(
    //       color: color,
    //       borderRadius: const BorderRadius.only(
    //           topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))),
    //   child: Center(
    //     child: Text(
    //       text,
    //       textAlign: TextAlign.center,
    //       style: const TextStyle(color: Colors.white),
    //     ),
    //   ),
    // );
  }
}
