import 'package:extended_image/extended_image.dart';
import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
@FFArgumentImport()
import 'package:flutter/material.dart';
import 'package:pcrgvg_flutter/constants/api_urls.dart';
@FFArgumentImport()
import 'package:pcrgvg_flutter/model/models.dart';

@FFRoute(
  name: "taskDetailPage",
  routeName: "taskDetailPage",
)
class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({Key? key, required this.bossPrefab, required this.task})
      : super(key: key);
  final Task task;
  final int bossPrefab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(child: ),
          Container(
            child: Hero(
                tag: '$bossPrefab',
                child: ExtendedImage.network(
                  PcrDbUrl.unitImg.replaceFirst(
                    '{0}',
                    bossPrefab.toString(),
                  ),
                  width: 40,
                  height: 40,
                )),
          )
        ],
      ),
    );
  }
}
