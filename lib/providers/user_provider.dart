import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pcrgvg_flutter/apis/pcrgvg_api.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/db/pcr_db.dart';
import 'package:pcrgvg_flutter/global/app_update.dart';
import 'package:pcrgvg_flutter/global/pcr_enum.dart';
import 'package:pcrgvg_flutter/isolate/filter_task.dart';
import 'package:pcrgvg_flutter/model/models.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/utils/store_util.dart';
import 'base_provider.dart';

class UserProvider extends BaseProvider {
  UserProvider() {
      userConfig = MyHive.userConfBox.get(HiveDbKey.UserConfig) as UserConfig;
  }

   late final UserConfig userConfig;

  void changeBgChara(int prefabId) {
    if (prefabId != userConfig.bgCharaPrefabId) {
      userConfig.bgCharaPrefabId = prefabId;
       notifyListeners();
    }
   
  }

  void changeBlur(double x, double y) {

    
    if (userConfig.bgBlurX != x || userConfig.bgBlurY != y) {
      userConfig.bgBlurY  =y;
       userConfig.bgBlurX = x;
        notifyListeners();
    }
   
  
  }

  void toggleShowBg() {
     userConfig.showBg = !userConfig.showBg;
      notifyListeners();
  }

  void toggelRandomBg() {
    userConfig.randomBg = !userConfig.randomBg;
    notifyListeners();
  }
}