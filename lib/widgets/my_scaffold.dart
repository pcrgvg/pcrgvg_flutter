import 'package:flutter/material.dart';


class MyScaffold extends StatefulWidget {
  const MyScaffold({Key? key, required this.body, this.bottomBar}) : super(key: key);
  final Widget body;
  final Widget? bottomBar;
  @override
  _MyScaffold createState() => _MyScaffold();
}

class _MyScaffold extends State<MyScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Positioned.fill(child: widget.body),
        if (widget.bottomBar != null) widget.bottomBar!
      ],),
    );
  }
}
