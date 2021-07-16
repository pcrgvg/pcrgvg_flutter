import 'dart:async';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_routes.dart';

@FFRoute(
  name: 'spalshPage',
  routeName: "spalshPage",
)
class SpalshPage extends StatefulWidget {
  const SpalshPage({ Key? key }) : super(key: key);

  @override
  _SpalshPage createState() => _SpalshPage();
}

class _SpalshPage extends State<SpalshPage> {

  @override
  void initState() {
     
    Future<void>.delayed(const Duration(seconds: 3)).whenComplete((){
     
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.mainPage.name, (_) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(Images.loading),
      ),
    );
  }
}





