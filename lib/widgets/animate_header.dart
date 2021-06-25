import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';

class AnimateHeader extends StatelessWidget {
  const AnimateHeader(
      {Key? key,  this.hasScrolled = false, required this.child})
      : super(key: key);
  final bool hasScrolled;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      padding: EdgeInsets.only(
        top:  Screens.statusBarHeight,
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight:Radius.circular(16),
      ),
        color:
            hasScrolled ? theme.backgroundColor : theme.scaffoldBackgroundColor,
        boxShadow: hasScrolled
            ? <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.024),
                  offset: const Offset(0, 1),
                  blurRadius: 3.0,
                  spreadRadius: 3.0,
                ),
              ]
            : <BoxShadow>[],
      ),
      child: child,
    );
  }
}
