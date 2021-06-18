
import 'package:pcrgvg_flutter/providers/base_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BaseListProvider extends BaseProvider {
  int page = 1;
  final RefreshController _controller = RefreshController();

  
}