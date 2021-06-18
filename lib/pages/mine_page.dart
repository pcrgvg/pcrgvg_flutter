import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';


@FFRoute(
  name: "minePage",
  routeName: "minePage",
)
class MinePage extends StatefulWidget {
  const MinePage({ Key? key }) : super(key: key);

  @override
  _MinePage createState() => _MinePage();
}

class _MinePage extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('s'),
    );
  }
}





