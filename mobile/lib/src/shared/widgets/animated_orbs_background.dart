import 'dart:ui';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AnimatedOrbsBackground extends StatefulWidget {
  const AnimatedOrbsBackground({required this.child, super.key});

  final Widget child;

  @override
  State<AnimatedOrbsBackground> createState() => _AnimatedOrbsBackgroundState();
}

class _AnimatedOrbsBackgroundState extends State<AnimatedOrbsBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Static surface background color
        Container(color: AppColors.surface),

        // Drifting Orbs
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = _controller.value;

            // Calculate drifting positions
            final orb1X = size.width * (0.1 + 0.3 * t);
            final orb1Y = size.height * (0.2 + 0.2 * (1.0 - t));

            final orb2X = size.width * (0.6 - 0.4 * t);
            final orb2Y = size.height * (0.6 + 0.25 * t);

            return Stack(
              children: [
                // Orb 1 (Soft Gold/Amber)
                Positioned(
                  left: orb1X,
                  top: orb1Y,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold.withValues(alpha: .15),
                    ),
                  ),
                ),
                // Orb 2 (Soft Emerald)
                Positioned(
                  left: orb2X,
                  top: orb2Y,
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.emerald.withValues(alpha: .12),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        // Glassmorphism high blur overlay
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
            child: Container(color: Colors.transparent),
          ),
        ),

        // Core Child Content
        Positioned.fill(child: widget.child),
      ],
    );
  }
}
