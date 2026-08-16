import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'animated_orbs_background.dart';

class BrokerPage extends StatelessWidget {
  const BrokerPage({
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.md,
      AppSpacing.lg,
      AppSpacing.xl,
    ),
    super.key,
  });

  final List<Widget> children;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedOrbsBackground(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: padding,
              sliver: SliverList.separated(
                itemBuilder: (context, index) => children[index],
                separatorBuilder: (_, index) =>
                    const SizedBox(height: AppSpacing.md),
                itemCount: children.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
