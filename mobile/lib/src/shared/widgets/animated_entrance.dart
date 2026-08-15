import 'package:flutter/material.dart';

class AnimatedEntrance extends StatelessWidget {
  const AnimatedEntrance({
    required this.child,
    this.delay = const Duration(milliseconds: 0),
    this.duration = const Duration(milliseconds: 600),
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        final isDelayedDone = snapshot.connectionState == ConnectionState.done;

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: isDelayedDone ? 1.0 : 0.0),
          duration: duration,
          curve: Curves.easeOutQuart,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 16 * (1.0 - value)),
                child: child,
              ),
            );
          },
          child: child,
        );
      },
    );
  }
}
