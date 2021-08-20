import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/providers/base_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

class ListBox<T extends BaseListProvider> extends StatelessWidget {
  const ListBox(
      {Key? key,
      required this.child,
      this.enablePullDown = true,
      this.enablePullUp = false})
      : super(key: key);

  final Widget child;
  final bool enablePullDown;
  final bool enablePullUp;

  @override
  Widget build(BuildContext context) {
    final model = context.read<T>();
    return Scaffold(
      body: NotificationListener<Notification>(
        onNotification: (Notification notification) {
          if (notification is ScrollUpdateNotification) {
            if (notification.depth == 0) {
              final double offset = notification.metrics.pixels;
              model.hasScrolled = offset > 0.0;
            }
          }
          // 保持ios与安卓的一致性, ios不再滚动
          if (notification is OverscrollIndicatorNotification) {
            notification.disallowGlow();
          }
          return true;
        },
        child: SmartRefresher(
          controller: model.controller,
          onRefresh: model.refresh,
          enablePullDown: enablePullDown,
          enablePullUp: enablePullUp,
          child: child,
        ),
      ),
    );
  }
}
