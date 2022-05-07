import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pcrgvg_flutter/apis/git_api.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/db/hive_db.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// 每天检查一次
class AppUpgrade {
  const AppUpgrade._();
  static late final PackageInfo packageInfo;
  static void upgradeModal() {
    showToastWidget(Builder(builder: (BuildContext context) {
      final Color bgc = Theme.of(context).colorScheme.secondary;
      final TextStyle textStyle = TextStyle(
        color: bgc.computeLuminance() < 0.5 ? Colors.white : Colors.black,
      );
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: HexColor.fromHex('#f94800'),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.024),
              offset: const Offset(0, 1),
              blurRadius: 3.0,
              spreadRadius: 3.0,
            ),
          ],
        ),
        width: Screens.width * 0.7,
        height: Screens.width / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              'app有新版本,是否更新?',
              style: textStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    dismissAllToast();
                  },
                  child: Text(
                    '下次一定',
                    style: textStyle,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // final String url = GitUrl.cdnGitHost + '@$releaseTag/releases/app-release.apk';
                    dismissAllToast();
                    if (Platform.isAndroid) {
                      if (await canLaunchUrlString(OSS_APP_URL)) {
                        launchUrlString(OSS_APP_URL);
                      }
                    }
                    if (Platform.isIOS) {
                      if (await canLaunchUrlString(IOS_APP_URL)) {
                        launchUrlString(IOS_APP_URL);
                      }
                    }
                  },
                  child: Text(
                    '现在更新',
                    style: textStyle,
                  ),
                )
              ],
            )
          ],
        ),
      );
    }),
        position: ToastPosition.center,
        handleTouch: true,
        duration: const Duration(hours: 24));
  }

  static Future<void> appInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  static Future<void> checkAppVersion() async {
    final int nowDate = DateTime.now().millisecondsSinceEpoch;
    MyHive.userConfBox.put(HiveDbKey.AppCheckDate, nowDate);
    final String version = packageInfo.version;
    final int buildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;
    final List<String> appVersion = version.split('.');
    final shaResp = await GitApi.masterSha();
    if (shaResp.success) {
      final info = await GitApi.releaseInfo(shaResp.data['sha'] as String);
      final int lastBuildNumber = info['elements'][0]['versionCode'] as int;
      final List<String> lastVersion =
          (info['elements'][0]['versionName'] as String).split('.');
      bool needUpdate = false;
      if (buildNumber < lastBuildNumber) {
        needUpdate = true;
      }
      for (var i = 0; i < appVersion.length; i++) {
        if (appVersion[i].compareTo(lastVersion[i]) < 0) {
          needUpdate = true;
          break;
        }
      }
      if (needUpdate) {
        upgradeModal();
      } else {
        '暂无更新'.toast();
      }
    } else {
      '检测更新失败,可到关于页面点击下载最新APP'.toast();
      return;
    }
  }

  // 从gitee release info 中获取apk下载地址
  static String? apkDownloadUrl(List<dynamic> assest) {
    for (final item in assest) {
      if (item['name'] == 'app-release.apk') {
        return item['browser_download_url'] + '/' + item['name'] as String;
      }
    }
  }
}
