class PcrDbUrl {
  const PcrDbUrl._();
  static String host = 'https://redive.estertion.win';

  static String lastVersionJp = '$host/last_version_jp.json';
  static String rediveDbJp = '$host/db/redive_jp.db.br';
  static String lastVersionCn = '$host/last_version_cn.json';
  static String rediveDbCn = '$host/db/redive_cn.db.br';
}

class PcrGvgUrl {
  const PcrGvgUrl._();
  static String host = 'https://www.aikurumi.cn';

  static String gvgTaskList = '$host/api/pcr/gvgTask';
}
