import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pcrgvg_flutter/apis/git_api.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:path/path.dart';

Future<void> checkAppVersion() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final String version = packageInfo.version;
  final String buildNumber = packageInfo.buildNumber;
  final String v = version.split('.').join();
  final info = await GitApi.releaseInfo();
  print(info);
  buildNumber.debug();
}
