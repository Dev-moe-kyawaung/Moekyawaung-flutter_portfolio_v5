import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/helpers/responsive.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/state/portfolio_state.dart';
import '../../../../data/models/models.dart';

class ServicesSection extends ConsumerWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(servicesProvider);
    final pad      = Responsive.padding(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      color: AppColors.bgSurface,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 96),
      child: Column(
        children: [
          SectionTitle(
            eyebrow: '// Services',
            title: 'What I Build',
            subtitle: 'End-to-end mobile and web solutions, from architecture to deployment.',
            alignment: CrossAxisAlignment.center,
          ).animate().fadeIn().slideY(begin: 0.2),

          const SizedBox(height: 64),

          LayoutBuilder(builder: (ctx, constraints) {
            final crossCount = constraints.maxWidth > 1000 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: crossCount == 1 ? 1.4 : (crossCount == 2 ? 1.0 : 0.85),
              ),
              itemCount: services.length,
              itemBuilder: (ctx, i) => _ServiceCard(service: services[i], index: i),
            );
          }),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final ServiceModel service;
  final int index;
  const _ServiceCard({required this.service, required this.index});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.neonCyan, AppColors.neonPurple, AppColors.neonGreen,
      AppColors.neonCyan, AppColors.neonPurple, AppColors.neonGreen,
    ];
    final c = colors[widget.index % colors.length];

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.bgElevated : AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? c.withOpacity(0.5) : AppColors.silverMuted.withOpacity(0.1),
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: c.withOpacity(0.2), blurRadius: 30)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.service.icon, style: const TextStyle(fontSize: 36)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: c.withOpacity(0.3)),
                  ),
                  child: Text(widget.service.badge,
                    style: AppTextStyles.labelMD.copyWith(color: c, fontSize: 10)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(widget.service.title, style: AppTextStyles.bodyMD.copyWith(
              fontWeight: FontWeight.w700, color: AppColors.silver, fontSize: 18,
            )),
            const SizedBox(height: 8),
            Text(widget.service.description, style: AppTextStyles.bodySM),
            const Spacer(),
            const SizedBox(height: 16),
            Wrap(
              spacing: 6, runSpacing: 6,
              children: widget.service.features.map((f) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bgDeep,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('✓ $f', style: AppTextStyles.bodySM.copyWith(
                  fontSize: 11, color: AppColors.silverDim)),
              )).toList(),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 100 * widget.index)).slideY(begin: 0.2);
  }
}
