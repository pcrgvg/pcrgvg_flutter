import 'dart:collection';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/extension/extensions.dart';

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


