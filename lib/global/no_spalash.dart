// import 'package:flutter/material.dart';

// class NoSplashFactory extends InteractiveInkFeatureFactory {
//     const NoSplashFactory();

//     @override
//   InteractiveInkFeature create({
//         required MaterialInkController controller,
//         required RenderBox referenceBox,
//         required Offset position,
//         required Color color,
//         bool containedInkWell: false,
//         required VoidCallback onRemoved,
//     }) {
//         return new NoSplash(
//             controller: controller,
//             referenceBox: referenceBox,
//             color: color,
//             onRemoved: onRemoved,
//         );
//     }
// }

// class NoSplash extends InteractiveInkFeature {
//     NoSplash({
//         required MaterialInkController controller,
//         required RenderBox referenceBox,
//         required VoidCallback onRemoved,
//     }) : super(null, null, null) {
//         controller.addInkFeature(this);
//     }
//     @override
//     void paintFeature(Canvas canvas, Matrix4 transform) { }
// }