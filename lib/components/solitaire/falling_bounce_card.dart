import 'dart:math';

import 'package:flutter/material.dart';

class FallingBounceCard extends StatefulWidget {
  const FallingBounceCard({
    super.key,
    required this.child,
    required this.initialRect,
    required this.tableSize,
    required this.onLeave,
  });
  final Widget child;
  final Rect initialRect;
  final Size tableSize;
  final VoidCallback onLeave;

  @override
  State<FallingBounceCard> createState() => _FallingBounceCardState();
}

class _FallingBounceCardState extends State<FallingBounceCard> with SingleTickerProviderStateMixin {
  static const double gravity = 9.8;  // 重力加速度
  static const double dampingFactor = 0.7; // 每次反彈後速度減少

  late Rect rect = widget.initialRect;
  late Offset velocity = Offset(
    (Random().nextDouble() * 1 + 1) * (Random().nextBool() ? -1 : 1),
    0,
  ); // 初始隨機水平速度
  late double verticalVelocity = 0; // 垂直速度（初始為0）
  double previousValue = 0.0;


  late final AnimationController _controller = AnimationController.unbounded(
    vsync: this,
    duration: const Duration(days: 1), // 長時間重複
  );

  @override
  void initState() {
    super.initState();

    _controller.addListener(() => setState(() => _updatePosition()));
    _controller.forward();
  }

  void _updatePosition() {
    // 更新位置與速度的邏輯
    final lastElapsedTime = (_controller.lastElapsedDuration?.inMilliseconds ?? 16) / 1000.0;
    final deltaTime = lastElapsedTime - previousValue;
    previousValue = lastElapsedTime;

    // 計算新位置
    verticalVelocity += gravity * deltaTime; // 垂直加速度更新速度
    Offset newVelocity = Offset(velocity.dx, verticalVelocity);
    Offset newPosition = Offset(rect.left + newVelocity.dx, rect.top + newVelocity.dy);

    // 檢查落地並反彈
    if (newPosition.dy + rect.height >= widget.tableSize.height) {
      newPosition = Offset(newPosition.dx, widget.tableSize.height - rect.height);
      verticalVelocity = -verticalVelocity * dampingFactor; // 反彈，並衰減速度
      if (verticalVelocity.abs() < 0.5) {
        verticalVelocity = 0; // 速度過小，停止反彈
      }
    }

    rect = Rect.fromLTWH(newPosition.dx, newPosition.dy, rect.width, rect.height);
    velocity = newVelocity;

    if(rect.right < 0 || rect.left > widget.tableSize.width) {
      widget.onLeave.call();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: rect,
      child: widget.child,
    );
  }
}