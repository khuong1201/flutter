import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class LiquidPullWrapper extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const LiquidPullWrapper({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: onRefresh,
      color: Theme.of(context).colorScheme.primary, // Màu chất lỏng rớt xuống
      backgroundColor: Colors.white, // Màu cục xoay bên trong chất lỏng
      height: 120, // Độ sâu của chất lỏng
      animSpeedFactor: 2.0, // Tốc độ giọt nước rơi
      showChildOpacityTransition: false,
      child: child, // Phải là một ListView hoặc ScrollView
    );
  }
}
