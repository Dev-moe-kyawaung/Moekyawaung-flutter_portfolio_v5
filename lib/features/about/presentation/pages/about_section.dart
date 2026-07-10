import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_links.dart';
import '../../../../core/helpers/responsive.dart';
import '../../../../core/widgets/widgets.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final pad = Responsive.padding(context);

    return Container(
      color: AppColors.bgSurface,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 96),
      child: Column(
        children: [
          SectionTitle(
            eyebrow: '// About Me',
            title: 'The Developer\nBehind the Code',
          ).animate().fadeIn().slideY(begin: 0.2),
          const SizedBox(height: 64),
          isMobile
              ? _buildMobile(context)
              : _buildDesktop(context),
          const SizedBox(height: 64),
          _buildInfoGrid(),
          const SizedBox(height: 64),
          _buildTimeline(),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(flex: 5, child: _buildImages()),
      const SizedBox(width: 64),
      Expanded(flex: 6, child: _buildText()),
    ],
  );

  Widget _buildMobile(BuildContext context) => Column(
    children: [
      _buildImages(compact: true),
      const SizedBox(height: 40),
      _buildText(),
    ],
  );

  Widget _buildImages({bool compact = false}) {
    final size = compact ? 180.0 : 260.0;
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main image
          CyberFrame(
            width: size, height: size,
            child: CachedNetworkImage(
              imageUrl: AppLinks.profileAlt2,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                color: AppColors.bgCard,
                child: const Icon(Icons.person, color: AppColors.neonCyan, size: 60),
              ),
            ),
          ),
          if (!compact)
          // Offset secondary
          Positioned(
            right: -40, bottom: -40,
            child: CyberFrame(
              width: 160, height: 160,
              child: CachedNetworkImage(
                imageUrl: AppLinks.profileAlt6,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(color: AppColors.bgCard),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildText() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(AppStrings.aboutP1, style: AppTextStyles.bodyLG)
          .animate().fadeIn(delay: 200.ms).slideX(begin: 0.2),
      const SizedBox(height: 20),
      Text(AppStrings.aboutP2, style: AppTextStyles.bodyMD)
          .animate().fadeIn(delay: 300.ms).slideX(begin: 0.2),
      const SizedBox(height: 20),
      Text(AppStrings.aboutP3, style: AppTextStyles.bodyMD)
          .animate().fadeIn(delay: 400.ms).slideX(begin: 0.2),
      const SizedBox(height: 24),
      // Currently building
      GlowCard(
        padding: const EdgeInsets.all(16),
        glowColor: AppColors.neonGreen,
        child: Row(
          children: [
            const Text('🚀', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Currently Building', style: AppTextStyles.labelMD.copyWith(color: AppColors.neonGreen)),
                  const SizedBox(height: 4),
                  Text(AppStrings.currentProject, style: AppTextStyles.bodyMD),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 500.ms),
    ],
  );

  Widget _buildInfoGrid() => Wrap(
    spacing: 16, runSpacing: 16,
    children: const [
      _InfoChip(icon: '👤', label: 'Full Name', value: 'Moe Kyaw Aung'),
      _InfoChip(icon: '📍', label: 'Location', value: 'Tachileik, Myanmar ↔ Bangkok, TH'),
      _InfoChip(icon: '🎯', label: 'Role', value: 'Senior Android Developer'),
      _InfoChip(icon: '📅', label: 'Experience', value: '~12 Years'),
      _InfoChip(icon: '🟢', label: 'Status', value: 'Open to Work'),
      _InfoChip(icon: '🗣️', label: 'Languages', value: 'Burmese · English · Kotlin'),
    ],
  );

  Widget _buildTimeline() {
    final items = [
      {'year': '2013', 'title': 'Started Android Development', 'desc': 'First steps with Android SDK and Java'},
      {'year': '2016', 'title': 'Kotlin Adoption', 'desc': 'Transitioned to Kotlin, embraced modern Android patterns'},
      {'year': '2019', 'title': 'Senior Developer Role', 'desc': 'Clean Architecture, MVVM, multi-module apps at scale'},
      {'year': '2021', 'title': 'Firebase & CI/CD Mastery', 'desc': 'Full Firebase stack, GitHub Actions, Azure DevOps pipelines'},
      {'year': '2023', 'title': 'Expanded to Flutter & AI', 'desc': 'Cross-platform development, Claude API integration, TFLite'},
      {'year': '2026', 'title': 'Building MoekyawTranslator', 'desc': 'AI-powered translation app — current flagship project'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(eyebrow: '// Journey', title: 'Career Timeline'),
        const SizedBox(height: 40),
        for (int i = 0; i < items.length; i++)
          _TimelineItem(
            year: items[i]['year']!,
            title: items[i]['title']!,
            desc: items[i]['desc']!,
            isLast: i == items.length - 1,
            index: i,
          ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  const _InfoChip({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => GlowCard(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$icon $label', style: AppTextStyles.labelMD),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyMD.copyWith(color: AppColors.silver)),
      ],
    ),
  );
}

class _TimelineItem extends StatelessWidget {
  final String year;
  final String title;
  final String desc;
  final bool isLast;
  final int index;
  const _TimelineItem({required this.year, required this.title, required this.desc, required this.isLast, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Year column
        SizedBox(
          width: 60,
          child: Text(year, style: AppTextStyles.labelMD.copyWith(color: AppColors.neonPurple)),
        ),
        // Line and dot
        Column(children: [
          Container(
            width: 12, height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.neonCyan,
              boxShadow: AppColors.neonCyanGlow,
            ),
          ),
          if (!isLast) Container(
            width: 1, height: 60,
            color: AppColors.neonCyan.withOpacity(0.2),
          ),
        ]),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMD.copyWith(
                  fontWeight: FontWeight.w700, color: AppColors.silver)),
                const SizedBox(height: 4),
                Text(desc, style: AppTextStyles.bodySM),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideX(begin: -0.1);
  }
}

