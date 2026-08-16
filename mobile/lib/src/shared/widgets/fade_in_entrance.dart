import 'package:flutter/material.dart';

class FadeInEntrance extends StatelessWidget {
  const FadeInEntrance({
    required this.child,
    required this.index,
    this.delayOffsetMs = 80,
    super.key,
  });

  final Widget child;
  final int index;
  final int delayOffsetMs;

  @override
  Widget build(BuildContext context) {
    final startDelay = Duration(milliseconds: index * delayOffsetMs);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, childWidget) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1.0 - value)),
            child: childWidget,
          ),
        );
      },
      // Simulate delay by waiting before triggering animation using a FutureBuilder
      child: FutureBuilder(
        future: Future.delayed(startDelay),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return child;
          }
          return const Opacity(
            opacity: 0,
            child: SizedBox(),
          );
        },
      ),
    );
  }
}
