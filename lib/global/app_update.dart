import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pcrgvg_flutter/apis/git_api.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpgrade {
  static void upgradeModal(String releaseTag) {
    showToastWidget(Builder(builder: (BuildContext context) {
      final Color bgc = Theme.of(context).accentColor;
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
                    final String url = GitUrl.cdnGitHost + '@$releaseTag/releases/app-release.apk';
                    if (await canLaunch(url)) {
                      launch(url);
                    }
                  },
                  child: Text(
                    '确定',
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

  static Future<void> checkAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    final String buildNumber = packageInfo.buildNumber;
    final String appVersionName = version.split('.').join();
    final info = await GitApi.releaseInfo();
    final versionCode = info['elements'][0]['versionCode'] as int;
    final versionName = info['elements'][0]['versionName'] as String;
    final String releaseVersionName = versionName.toString().split('.').join();
    if (releaseVersionName != appVersionName || versionCode != int.parse(buildNumber)) {
      upgradeModal(versionName + '+$versionCode');
    }
  }
}
