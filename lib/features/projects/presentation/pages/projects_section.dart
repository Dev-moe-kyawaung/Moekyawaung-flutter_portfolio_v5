import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/helpers/responsive.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/state/portfolio_state.dart';
import '../../../../data/models/models.dart';

class ProjectsSection extends ConsumerWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(filteredProjectsProvider);
    final filter   = ref.watch(projectFilterProvider);
    final pad      = Responsive.padding(context);
    final categories = ['All', 'Android', 'Web', 'Mobile', 'Games'];
    final featured = projects.where((p) => p.isFeatured).toList();
    final rest     = projects.where((p) => !p.isFeatured).toList();

    return Container(
      color: AppColors.bgDeep,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            eyebrow: '// Portfolio',
            title: 'Featured Projects',
            subtitle: 'Real-world applications built with production-quality architecture.',
          ).animate().fadeIn().slideY(begin: 0.2),

          const SizedBox(height: 32),

          // Filter
          Wrap(
            spacing: 8, runSpacing: 8,
            children: categories.map((c) => GestureDetector(
              onTap: () => ref.read(projectFilterProvider.notifier).state = c,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: filter == c ? AppColors.neonCyan.withOpacity(0.15) : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: filter == c ? AppColors.neonCyan : AppColors.silverMuted.withOpacity(0.2),
                  ),
                ),
                child: Text(c, style: AppTextStyles.bodySM.copyWith(
                  color: filter == c ? AppColors.neonCyan : AppColors.silverDim,
                )),
              ),
            )).toList(),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 48),

          // Featured row
          if (featured.isNotEmpty) ...[
            Text('⭐ Featured', style: AppTextStyles.labelLG),
            const SizedBox(height: 24),
            LayoutBuilder(builder: (ctx, constraints) {
              final isMobile = constraints.maxWidth < 700;
              return isMobile
                  ? Column(children: featured.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _FeaturedCard(project: p),
                    )).toList())
                  : Row(
                      children: featured.take(2).map((p) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: _FeaturedCard(project: p),
                        ),
                      )).toList(),
                    );
            }),
            const SizedBox(height: 48),
          ],

          // Other projects grid
          if (rest.isNotEmpty) ...[
            Text('📁 All Projects', style: AppTextStyles.labelLG),
            const SizedBox(height: 24),
            LayoutBuilder(builder: (ctx, constraints) {
              final crossCount = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: rest.length,
                itemBuilder: (ctx, i) => _ProjectCard(project: rest[i], index: i),
              );
            }),
          ],

          const SizedBox(height: 48),

          // GitHub accounts section
          _GitHubAccountsGrid().animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatefulWidget {
  final ProjectModel project;
  const _FeaturedCard({required this.project});

  @override
  State<_FeaturedCard> createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<_FeaturedCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? AppColors.neonCyan.withOpacity(0.6) : AppColors.silverMuted.withOpacity(0.1),
          ),
          boxShadow: _hovered ? AppColors.neonCyanGlow : AppColors.cardGlow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (widget.project.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: widget.project.imageUrl!,
                  height: 200, width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    height: 200, color: AppColors.bgElevated,
                    child: const Icon(Icons.code, size: 48, color: AppColors.neonCyan),
                  ),
                ),
              )
            else
              Container(
                height: 160, decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: AppColors.heroBg,
                ),
                child: const Center(child: Text('🚀', style: TextStyle(fontSize: 48))),
              ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.neonCyan.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.neonCyan.withOpacity(0.3)),
                      ),
                      child: Text(widget.project.category,
                        style: AppTextStyles.labelMD.copyWith(fontSize: 10)),
                    ),
                    const Spacer(),
                    const Icon(Icons.star_rounded, color: AppColors.neonCyan, size: 16),
                    const Text(' Featured', style: TextStyle(color: AppColors.neonCyan, fontSize: 12)),
                  ]),
                  const SizedBox(height: 12),
                  Text(widget.project.title, style: AppTextStyles.bodyMD.copyWith(
                    fontWeight: FontWeight.w700, color: AppColors.silver, fontSize: 18,
                  )),
                  const SizedBox(height: 8),
                  Text(widget.project.description, style: AppTextStyles.bodySM, maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 16),
                  Wrap(spacing: 6, runSpacing: 6,
                    children: widget.project.tags.take(4).map((t) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.bgElevated,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(t, style: AppTextStyles.bodySM.copyWith(fontSize: 11)),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    NeonButton(
                      label: 'GitHub',
                      icon: Icons.code,
                      small: true,
                      outline: true,
                      onPressed: () => launchUrl(Uri.parse(widget.project.githubUrl)),
                    ),
                    if (widget.project.liveUrl != null) ...[
                      const SizedBox(width: 8),
                      NeonButton(
                        label: 'Live',
                        icon: Icons.open_in_new,
                        small: true,
                        onPressed: () => launchUrl(Uri.parse(widget.project.liveUrl!)),
                      ),
                    ],
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final int index;
  const _ProjectCard({required this.project, required this.index});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered ? AppColors.neonPurple.withOpacity(0.5) : AppColors.silverMuted.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(_getCategoryEmoji(widget.project.category), style: const TextStyle(fontSize: 28)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.open_in_new, size: 16, color: AppColors.silverDim),
                onPressed: () => launchUrl(Uri.parse(widget.project.githubUrl)),
              ),
            ]),
            const SizedBox(height: 12),
            Text(widget.project.title, style: AppTextStyles.bodyMD.copyWith(
              fontWeight: FontWeight.w700, color: AppColors.silver,
            )),
            const SizedBox(height: 6),
            Text(widget.project.description, style: AppTextStyles.bodySM, maxLines: 2, overflow: TextOverflow.ellipsis),
            const Spacer(),
            Wrap(spacing: 4, runSpacing: 4,
              children: widget.project.tags.take(3).map((t) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(t, style: AppTextStyles.bodySM.copyWith(fontSize: 10)),
              )).toList(),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 80 * widget.index)).slideY(begin: 0.15);
  }

  String _getCategoryEmoji(String cat) {
    switch (cat) {
      case 'Android': return '🤖';
      case 'Web':     return '🌐';
      case 'Mobile':  return '📱';
      case 'Games':   return '🎮';
      default:        return '💻';
    }
  }
}

// ─── GitHub Accounts Grid ────────────────────────────────────────────────────
class _GitHubAccountsGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(githubAccountsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(eyebrow: '// Network', title: '43 GitHub Accounts'),
        const SizedBox(height: 8),
        Text('A multi-account GitHub presence spanning specializations from Android to cybersecurity.',
          style: AppTextStyles.bodyMD),
        const SizedBox(height: 32),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: accounts.asMap().entries.map((e) => _GithubChip(
            url: e.value, index: e.key + 1,
          )).toList(),
        ),
      ],
    );
  }
}

class _GithubChip extends StatefulWidget {
  final String url;
  final int index;
  const _GithubChip({required this.url, required this.index});

  @override
  State<_GithubChip> createState() => _GithubChipState();
}

class _GithubChipState extends State<_GithubChip> {
  bool _hovered = false;
  String get _label {
    final u = widget.url.replaceAll('https://', '').replaceAll('.github.io/', '');
    return '#${widget.index} $u';
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.neonCyan.withOpacity(0.1) : AppColors.bgCard,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: _hovered ? AppColors.neonCyan.withOpacity(0.4) : AppColors.silverMuted.withOpacity(0.15),
          ),
        ),
        child: Text(_label, style: AppTextStyles.bodySM.copyWith(
          fontSize: 11,
          color: _hovered ? AppColors.neonCyan : AppColors.silverDim,
        )),
      ),
    ),
  );
}
