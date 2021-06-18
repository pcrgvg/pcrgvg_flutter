import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
@FFArgumentImport()
import 'package:pcrgvg_flutter/model/test_model.dart';



@FFRoute(
  name: "ffArgPage",
  routeName: "ffArgPage",
)
class FfArgPage extends StatefulWidget {
 
  const FfArgPage({Key? key, required this.testMode1}) : super(key: key);
   final TestMode1 testMode1;

  @override
  _FfArgPage createState() => _FfArgPage();
}

class _FfArgPage extends State<FfArgPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
