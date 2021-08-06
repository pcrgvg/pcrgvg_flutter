import 'dart:collection';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BaseProvider extends ChangeNotifier {
  bool _disposed = false;
  bool get disposed => _disposed;

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}


class CancelableBaseModel extends BaseProvider {
  final ListQueue<CancelableCompleter<dynamic>> _jobs = ListQueue<CancelableCompleter<dynamic>>();

  @mustCallSuper
  @override
  void dispose() {
    CancelableCompleter<dynamic> job;
    "等待取消任务: ${_jobs.length}".debug();
    while (_jobs.isNotEmpty) {
      job = _jobs.removeFirst();
      job.operation.cancel();
    }
    super.dispose();
  }

  Future<dynamic> operator +(Future<dynamic> future) {
    final CancelableCompleter<dynamic> completer = CancelableCompleter<dynamic>(onCancel: () {
      "取消了一个任务".debug();
    });
    _jobs.add(completer);
    completer.complete(future);
    completer.operation.value.catchError((dynamic e) {
      "$runtimeType: $e".debug();
    }).whenComplete(() {
      _jobs.remove(completer);
      "$runtimeType 执行完了一个任务".debug();
    });
    return completer.operation.value;
  }
}


abstract class BaseListProvider extends CancelableBaseModel {

  bool _hasScrolled = true;
  bool get hasScrolled => _hasScrolled;

  // ignore: prefer_final_fields
  int _pageIndex = 1;
  int get pageIndex => _pageIndex;

  set hasScrolled(bool value) {
    if (value != _hasScrolled) {
      _hasScrolled = value;
      notifyListeners();
    }
  }

  final RefreshController _controller = RefreshController();
  RefreshController get controller => _controller;

  Future<void> refresh();
  Future<void> loadMore();
}


