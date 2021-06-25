import 'package:extended_sliver/extended_sliver.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/screens.dart';
import 'package:pcrgvg_flutter/providers/home_filter_provider.dart';
@FFArgumentImport()
import 'package:pcrgvg_flutter/providers/home_provider.dart';
import 'package:pcrgvg_flutter/widgets/animate_header.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@FFRoute(
  name: "homeFilterPage",
  routeName: "homeFilterPage",
)
class HomeFilterPage extends StatelessWidget {
  const HomeFilterPage({Key? key, required this.homeProvider})
      : super(key: key);
  final HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ChangeNotifierProvider<HomeFilterProvider>(
        create: (_) => HomeFilterProvider(),
        child: Scaffold(
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification notification) {
              notification.disallowGlow();
              return true;
            },
            child: Selector<HomeFilterProvider, HomeFilterProvider>(
              selector: (_, HomeFilterProvider model) => model,
              builder: (_, HomeFilterProvider model, Widget? c) {
                return SmartRefresher(
                  controller: model.refreshController,
                  enablePullDown: true,
                  enablePullUp: false,
                  header: WaterDropMaterialHeader(
                    backgroundColor: theme.accentColor,
                    color: theme.accentColor.computeLuminance() < 0.5
                        ? Colors.white
                        : Colors.black,
                    distance: 42.0,
                  ),
                  onRefresh: model.refresh,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      _Header(theme: theme),
                      SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Text('服务器'),
                            Text('日服'),
                            Text('国服'),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Text('期次'),
                            Text('日服'),
                            Text('国服'),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Text('自动'),
                            Text('自动'),
                            Text('半自动'),
                            Text('手动'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ));
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SliverPinnedToBoxAdapter(
      child: AnimateHeader(
        hasScrolled: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            Text('搜索'),
          ],
        ),
      ),
    );
  }
}
