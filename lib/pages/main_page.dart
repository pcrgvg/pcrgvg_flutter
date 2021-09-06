import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/Images.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pcrgvg_flutter/pages/collection_page.dart';
import 'package:pcrgvg_flutter/pages/home/home_page.dart';
import 'package:pcrgvg_flutter/pages/mine_page.dart';
import 'package:pcrgvg_flutter/widgets/bottom_bar.dart';

@FFRoute(
  name: "mainPage",
  routeName: "mainPage",
)
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  int currentBackPressTime = 0;
  int currentPageIndex = 1;
  final List<Widget> pages = <Widget>[const CollectionPage(),const HomePage(), const MinePage()];

  Future<bool> _onWillPop() async {
    final int now = DateTime.now().millisecondsSinceEpoch;
    if (currentBackPressTime == 0 || now - currentBackPressTime > 2000) {
      currentBackPressTime = now;
      '再按一次退出'.toast();
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          child: IndexedStack(
            children: pages,
            index: currentPageIndex,
          ),
          onWillPop: _onWillPop),
      bottomNavigationBar: BottomBar(
        height: Screens.bottomSafeHeight + 64,
        bottomBarindex: currentPageIndex,
        onItemClick: (int index) {
          currentPageIndex = index;
          setState(() {});
        },
        items: <BottomBarItem>[
          BottomBarItem(iconPath: Images.tabMm, activeIconPath: Images.tabMmActive, label: '收藏'),
          BottomBarItem(iconPath: Images.tabMmt, activeIconPath: Images.tabMmtActive, label: '作业'),
          BottomBarItem(iconPath: Images.tabNnk, activeIconPath: Images.tabNnkActive, label: '我的'),
        ],
      ),
    );
  }
}
