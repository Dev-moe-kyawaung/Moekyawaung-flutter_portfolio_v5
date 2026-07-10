import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../data/state/portfolio_state.dart';

class ScrollProgressGlow extends ConsumerWidget {
  const ScrollProgressGlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(scrollProgressProvider);
    return Container(
      height: 2,
      child: FractionallySizedBox(
        widthFactor: progress,
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.cyanPurple,
            boxShadow: [
              BoxShadow(color: AppColors.neonCyan.withOpacity(0.8), blurRadius: 8),
            ],
          ),
        ),
      ),
    );
  }
}
