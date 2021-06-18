import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@FFRoute(
  name: 'homePage',
  routeName: "homePage",
)
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    // Navigator.pushNamed(context, Routes.ffArgPage.name, arguments: Routes.ffArgPage.d(testMode1: testMode1))
    return Scaffold(
        body: NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        return true;
      },
      child: Container(
        child: Container(),
      ),
    ));
  }
}
