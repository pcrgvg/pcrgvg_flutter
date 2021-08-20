import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar(
      {Key? key,
      required this.items,
      required this.onItemClick,
      this.bottomBarindex = 1,
      this.height = 54.0})
      : super(key: key);
  final List<BottomBarItem> items;
  final double height;
  final Function(int index) onItemClick;
  final int bottomBarindex;

  @override
  _BottomBar createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
        child: Container(
          height: widget.height,
          color: Theme.of(context).backgroundColor.withOpacity(0.72),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: List<Expanded>.generate(
                widget.items.length,
                (int index) => Expanded(
                      child: BottomBarItemView(
                        onItemClick: () {
                          widget.onItemClick(index);
                        },
                        isActive: widget.bottomBarindex == index,
                        bottomBarItem: widget.items[index],
                      ),
                    )),
          ),
        ),
      ),
    );
  }
}

class BottomBarItem {
  BottomBarItem({
    required this.iconPath,
    required this.activeIconPath,
    this.size = 40,
  });
  String iconPath;
  String activeIconPath;
  double size;
}

class BottomBarItemView extends StatefulWidget {
  const BottomBarItemView(
      {Key? key,
      required this.isActive,
      required this.bottomBarItem,
      required this.onItemClick})
      : super(key: key);
  final BottomBarItem bottomBarItem;
  final bool isActive;
  final Function onItemClick;

  @override
  _BottomBarItemViewState createState() => _BottomBarItemViewState();
}

class _BottomBarItemViewState extends State<BottomBarItemView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (mounted) {
            _controller.reverse();
          }
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Image _buildIcon(BottomBarItem bottomBarItem) {
    return widget.isActive
        ? Image.asset(
            bottomBarItem.activeIconPath,
            key: ValueKey(bottomBarItem.activeIconPath + DateTime.now().microsecondsSinceEpoch.toString()),
            width: bottomBarItem.size,
            height: bottomBarItem.size,
          )
        : Image.asset(
            bottomBarItem.iconPath,
            width: bottomBarItem.size,
            height: bottomBarItem.size,
            key: ValueKey(bottomBarItem.iconPath),
          );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isActive) {
          _controller.forward();
        }
        widget.onItemClick();
        setState(() {
          
        });
      },
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.88, end: 1).animate(CurvedAnimation(
          parent: _controller,
          curve: const Interval(
            0.1,
            1.0,
            curve: Curves.linear,
          ),
        )),
        alignment: Alignment.center,
        child: _buildIcon(widget.bottomBarItem),)
      
    );
  }
}
