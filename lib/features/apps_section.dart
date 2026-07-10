import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/helpers/responsive.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/state/portfolio_state.dart';
import '../../../../data/models/models.dart';

class AppsSection extends ConsumerWidget {
  const AppsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps     = ref.watch(appsProvider);
    final lovable  = ref.watch(lovableAppsProvider);
    final pad      = Responsive.padding(context);

    return Container(
      color: AppColors.bgSurface,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            eyebrow: '// App Collection',
            title: '16 Apps Built',
            subtitle: 'From dashboards to games — production-quality web applications.',
          ).animate().fadeIn().slideY(begin: 0.2),

          const SizedBox(height: 64),

          // App cards grid
          LayoutBuilder(builder: (ctx, constraints) {
            final crossCount = constraints.maxWidth > 1100
                ? 4
                : constraints.maxWidth > 700
                    ? 3
                    : constraints.maxWidth > 480
                        ? 2
                        : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: apps.length,
              itemBuilder: (ctx, i) => _AppCard(app: apps[i], index: i),
            );
          }),

          const SizedBox(height: 80),

          // Lovable PWA collection
          _LovablePWASection(links: lovable),
        ],
      ),
    );
  }
}

// ─── App Card ─────────────────────────────────────────────────────────────────
class _AppCard extends StatefulWidget {
  final AppModel app;
  final int index;
  const _AppCard({required this.app, required this.index});

  @override
  State<_AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<_AppCard> {
  bool _hovered = false;

  static const _accentColors = [
    AppColors.neonCyan,
    AppColors.neonPurple,
    AppColors.neonGreen,
    AppColors.neonCyan,
    AppColors.neonPurple,
    AppColors.neonGreen,
  ];

  @override
  Widget build(BuildContext context) {
    final c = _accentColors[widget.index % _accentColors.length];

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.app.url != null
            ? () => launchUrl(Uri.parse(widget.app.url!))
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.bgElevated : AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? c.withOpacity(0.6) : AppColors.silverMuted.withOpacity(0.1),
              width: _hovered ? 1.5 : 1,
            ),
            boxShadow: _hovered
                ? [BoxShadow(color: c.withOpacity(0.2), blurRadius: 24, spreadRadius: 0)]
                : AppColors.cardGlow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: c.withOpacity(_hovered ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.app.emoji,
                      style: TextStyle(fontSize: _hovered ? 30 : 28),
                    ),
                  ),
                  const Spacer(),
                  if (widget.app.url != null)
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 16,
                      color: _hovered ? c : AppColors.silverMuted,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.app.title,
                style: AppTextStyles.bodyMD.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _hovered ? AppColors.silver : AppColors.silverDim,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.app.description,
                style: AppTextStyles.bodySM.copyWith(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              // Action row
              Row(
                children: [
                  if (widget.app.url != null)
                    _MiniBtn(
                      label: 'Live',
                      icon: Icons.rocket_launch_rounded,
                      color: c,
                      onTap: () => launchUrl(Uri.parse(widget.app.url!)),
                    ),
                  if (widget.app.url != null && widget.app.githubUrl != null)
                    const SizedBox(width: 6),
                  if (widget.app.githubUrl != null)
                    _MiniBtn(
                      label: 'Code',
                      icon: Icons.code_rounded,
                      color: AppColors.silverDim,
                      onTap: () => launchUrl(Uri.parse(widget.app.githubUrl!)),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 60 * widget.index)).slideY(begin: 0.15);
  }
}

class _MiniBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _MiniBtn({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    ),
  );
}

// ─── Lovable PWA Section ──────────────────────────────────────────────────────
class _LovablePWASection extends StatefulWidget {
  final List<String> links;
  const _LovablePWASection({required this.links});

  @override
  State<_LovablePWASection> createState() => _LovablePWASectionState();
}

class _LovablePWASectionState extends State<_LovablePWASection> {
  bool _expanded = false;

  List<String> get _unique =>
      widget.links.toSet().toList()..sort();

  @override
  Widget build(BuildContext context) {
    final all    = _unique;
    final shown  = _expanded ? all : all.take(12).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('// LIVE PWAS', style: AppTextStyles.labelLG),
                const SizedBox(height: 8),
                Text(
                  '38+ Lovable PWA Deployments',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 28),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.neonGreen.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.neonGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('All Live', style: AppTextStyles.labelMD.copyWith(
                    color: AppColors.neonGreen)),
                ],
              ),
            ),
          ],
        ).animate().fadeIn().slideY(begin: 0.2),

        const SizedBox(height: 16),
        Text(
          'Progressive Web Apps deployed on Lovable — instantly accessible from any browser.',
          style: AppTextStyles.bodyMD,
        ).animate().fadeIn(delay: 200.ms),

        const SizedBox(height: 32),

        // PWA link grid
        LayoutBuilder(builder: (ctx, constraints) {
          final crossCount = constraints.maxWidth > 1000
              ? 4
              : constraints.maxWidth > 680
                  ? 3
                  : constraints.maxWidth > 440
                      ? 2
                      : 1;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.8,
            ),
            itemCount: shown.length,
            itemBuilder: (ctx, i) => _PwaLink(url: shown[i], index: i),
          );
        }).animate().fadeIn(delay: 300.ms),

        if (all.length > 12) ...[
          const SizedBox(height: 20),
          Center(
            child: NeonButton(
              label: _expanded ? 'Show Less' : 'Show All ${all.length} PWAs',
              outline: true,
              icon: _expanded ? Icons.expand_less : Icons.expand_more,
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
          ),
        ],
      ],
    );
  }
}

class _PwaLink extends StatefulWidget {
  final String url;
  final int index;
  const _PwaLink({required this.url, required this.index});

  @override
  State<_PwaLink> createState() => _PwaLinkState();
}

class _PwaLinkState extends State<_PwaLink> {
  bool _hovered = false;

  String get _label {
    final u = widget.url
        .replaceAll('https://', '')
        .replaceAll('.lovable.app', '')
        .replaceAll('/', '');
    return u;
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit:  (_) => setState(() => _hovered = false),
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () => launchUrl(Uri.parse(widget.url)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.neonCyan.withOpacity(0.08) : AppColors.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered
                ? AppColors.neonCyan.withOpacity(0.5)
                : AppColors.silverMuted.withOpacity(0.12),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.public_rounded,
              size: 13,
              color: _hovered ? AppColors.neonCyan : AppColors.silverMuted,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _label,
                style: AppTextStyles.bodySM.copyWith(
                  fontSize: 12,
                  color: _hovered ? AppColors.neonCyan : AppColors.silverDim,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (_hovered)
              const Icon(Icons.open_in_new_rounded, size: 11, color: AppColors.neonCyan),
          ],
        ),
      ),
    ),
  ).animate().fadeIn(delay: Duration(milliseconds: 30 * widget.index));
}
