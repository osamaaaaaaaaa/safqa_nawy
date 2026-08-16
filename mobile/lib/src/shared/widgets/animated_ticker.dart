import 'package:flutter/material.dart';

class AnimatedTicker extends StatelessWidget {
  const AnimatedTicker({
    required this.targetValue,
    this.suffix = '',
    this.style,
    super.key,
  });

  final int targetValue;
  final String suffix;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: targetValue.toDouble()),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOutExpo,
      builder: (context, value, child) {
        return Text(
          '${value.toInt()}$suffix',
          style: style,
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
