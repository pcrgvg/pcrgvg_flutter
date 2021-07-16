import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/model/models.dart';
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

  String getText(int type) {
    switch (type) {
      case AutoType.auto:
        return '自动';
      case AutoType.harfAuto:
        return '半自动';
      case AutoType.manual:
      default:
        return '手动';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = getColor(type);
    final String text = getText(type);
    return Container(
      width: 20,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
