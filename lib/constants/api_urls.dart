class PcrDbUrl {
  const PcrDbUrl._();
  static const String host = 'https://redive.estertion.win';

  static const String lastVersionJp = '$host/last_version_jp.json';
  static const String rediveDbJp = '$host/db/redive_jp.db.br';
  static const String lastVersionCn = '$host/last_version_cn.json';
  static const String rediveDbCn = '$host/db/redive_cn.db.br';
  static const String unitImg = '$host/icon/unit/{0}.webp';
  static const String cardImg = '$host/card/full/{0}.webp';
}

class PcrGvgUrl {
  const PcrGvgUrl._();
  static const String host = 'https://www.aikurumi.cn';
  // static const String host = 'http://192.168.101.107:5000';

  static const String gvgTaskList = '$host/api/pcr/gvgTask';
}

class GitUrl {
  static const String cdnGitHost = 'https://cdn.jsdelivr.net/gh/pcrgvg/pcrgvg_flutter';
  static const String gitApiHost = 'https://api.github.com/repos/pcrgvg/pcrgvg_flutter';
  static const String gitRepo = '$cdnGitHost@master';
  static const String release = '$gitApiHost/releases/latest';
  static const String releaseInfo = '$gitRepo/releases/output-metadata.json';
}
