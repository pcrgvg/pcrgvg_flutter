part of 'models.dart';

@HiveType(typeId: MyHive.UserId)
class UserConfig extends HiveObject {
  UserConfig({
    this.showBg = true,
    this.bgCharaPrefabId = 110001,
    this.bgBlurX = 2,
    this.bgBlurY = 2,
    this.randomBg  = true
  });
  @HiveField(0, defaultValue: true)
  bool showBg;
  @HiveField(1, defaultValue: 110001)
  int bgCharaPrefabId;
  @HiveField(2, defaultValue: 2)
  double bgBlurX;
  @HiveField(3, defaultValue: 2)
  double bgBlurY;
   @HiveField(4, defaultValue: true)
  bool randomBg;
}
