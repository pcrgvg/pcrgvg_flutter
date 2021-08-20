class ServerType {
  ServerType({required this.name, required this.value});
  String value;
  String name;
  
  static const String tw = 'tw';
  static const String jp = 'jp';
  static const String cn = 'cn';

  static String getName(String name) {
    if (name == tw){
      return '台服';
    } else if (name == jp) {
      return '日服';
    } else if (name == 'cn') {
      return '国服';
    } else {
      return '';
    }
  }
}


class AutoType {
   const AutoType._();
  static const int manual = 10;
  static const int auto = 20;
  static const int harfAuto = 40;
  static String getName(int type) {
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
}

String getTypeText(int type) {
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
