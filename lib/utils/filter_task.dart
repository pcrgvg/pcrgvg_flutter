import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:pcrgvg_flutter/model/models.dart';


Future<void> isolateFilter({required List<GvgTask> GvgTaskList}) async {
   await compute<List<GvgTask>, int>(filterTask, GvgTaskList);
}

Future<int> filterTask() async {
   return  1;
}