import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';

@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/global/app_update.dart';
import 'package:pcrgvg_flutter/pcrgvg_flutter_routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';

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
   requestPermission();
    super.initState();
  }

  Future<void> requestPermission() async {
     await AppUpgrade.appInfo();
     final PermissionStatus status = await Permission.storage.request();
     if (status == PermissionStatus.permanentlyDenied) {
       openAppSettings();
     } else if (status == PermissionStatus.denied) {
       '数据库将无法更新成功'.toast();
     }
     Future<void>.delayed(const Duration(milliseconds: 500)).then((_) => Navigator.of(context).pushNamedAndRemoveUntil(Routes.mainPage.name, (_) => false));
  }

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(Images.loading, width: 200,),
      ),
    );
  }
}





