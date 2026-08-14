import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/transfer_step.dart';

class TransferTimeline extends StatelessWidget {
  const TransferTimeline({super.key});

  static const _steps = [
    TransferStep(
      titleKey: 'transfer.docs.title',
      bodyKey: 'transfer.docs.body',
    ),
    TransferStep(
      titleKey: 'transfer.match.title',
      bodyKey: 'transfer.match.body',
    ),
    TransferStep(
      titleKey: 'transfer.close.title',
      bodyKey: 'transfer.close.body',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < _steps.length; index++)
          _TimelineItem(
            index: index,
            step: _steps[index],
            isLast: index == _steps.length - 1,
          ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.index,
    required this.step,
    required this.isLast,
  });

  final int index;
  final TransferStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: AppColors.ink,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: AppColors.paper,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.titleKey.tr, style: theme.titleMedium),
                  const SizedBox(height: 4),
                  Text(step.bodyKey.tr, style: theme.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
