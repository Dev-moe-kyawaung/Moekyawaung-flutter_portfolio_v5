import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/helpers/responsive.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/state/portfolio_state.dart';
import '../../../../data/models/models.dart';

class SkillsSection extends ConsumerWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills     = ref.watch(skillsProvider);
    final filter     = ref.watch(skillCategoryProvider);
    final filtered   = ref.watch(filteredSkillsProvider);
    final pad        = Responsive.padding(context);
    final categories = ['All', 'Android', 'Mobile', 'Backend', 'DevOps', 'Web', 'Security', 'AI'];

    return Container(
      color: AppColors.bgDeep,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(eyebrow: '// Tech Stack', title: 'Skills & Technologies')
              .animate().fadeIn().slideY(begin: 0.2),
          const SizedBox(height: 40),

          // Category filter chips
          Wrap(
            spacing: 8, runSpacing: 8,
            children: categories.map((c) => _FilterChip(
              label: c,
              isActive: filter == c,
              onTap: () => ref.read(skillCategoryProvider.notifier).state = c,
            )).toList(),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 48),

          // Progress bars grid
          LayoutBuilder(builder: (ctx, constraints) {
            final isMobile = constraints.maxWidth < 600;
            return isMobile
                ? Column(children: filtered.map((s) => NeonProgressBar(
                    label: s.name, value: s.level, emoji: s.emoji,
                  )).toList())
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(children: filtered.take((filtered.length / 2).ceil()).map((s) =>
                          NeonProgressBar(label: s.name, value: s.level, emoji: s.emoji)
                        ).toList()),
                      ),
                      const SizedBox(width: 48),
                      Expanded(
                        child: Column(children: filtered.skip((filtered.length / 2).ceil()).map((s) =>
                          NeonProgressBar(label: s.name, value: s.level, emoji: s.emoji, color: AppColors.neonPurple)
                        ).toList()),
                      ),
                    ],
                  );
          }).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 64),

          // Tech chip cloud
          SectionTitle(eyebrow: '// Ecosystem', title: 'Full Tech Ecosystem'),
          const SizedBox(height: 32),
          _TechCloud().animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.neonCyan.withOpacity(0.15) : AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? AppColors.neonCyan : AppColors.silverMuted.withOpacity(0.2),
        ),
      ),
      child: Text(label, style: AppTextStyles.bodySM.copyWith(
        color: isActive ? AppColors.neonCyan : AppColors.silverDim,
      )),
    ),
  );
}

class _TechCloud extends StatelessWidget {
  final chips = const [
    '🎯 Kotlin', '🦋 Flutter', '🤖 Android', '📱 Jetpack Compose',
    '🧹 Clean Architecture', '🔥 Firebase', '🌐 REST APIs', '📡 Retrofit',
    '⚡ Coroutines', '🌊 Kotlin Flow', '🏗️ MVVM', '🎭 MVI',
    '⚙️ GitHub Actions', '☁️ Azure DevOps', '🚀 Fastlane', '🐳 Docker',
    '⚛️ React', '▲ Next.js', '🟨 JavaScript', '🔷 TypeScript',
    '🐍 Python', '🐘 PostgreSQL', '🍃 MongoDB', '⚡ Redis',
    '🔐 Ethical Hacking', '🐧 Linux / Kali', '🤖 Claude API',
    '🧠 TensorFlow Lite', '⛓️ Blockchain', '🎨 Figma',
    '📊 Grafana', '🔗 Git', '🧪 JUnit / MockK', '☕ Java',
    '🎯 Dart', '🌐 HTML/CSS', '📦 Node.js', '💚 Vue.js',
  ];

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 10, runSpacing: 10,
    children: chips.map((c) => _TechChip(label: c)).toList(),
  );
}

class _TechChip extends StatefulWidget {
  final String label;
  const _TechChip({required this.label});

  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit:  (_) => setState(() => _hovered = false),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _hovered ? AppColors.neonCyan.withOpacity(0.1) : AppColors.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _hovered ? AppColors.neonCyan.withOpacity(0.5) : AppColors.silverMuted.withOpacity(0.15),
        ),
        boxShadow: _hovered ? [BoxShadow(color: AppColors.neonCyan.withOpacity(0.15), blurRadius: 12)] : [],
      ),
      child: Text(widget.label, style: AppTextStyles.bodySM.copyWith(
        color: _hovered ? AppColors.silver : AppColors.silverDim,
      )),
    ),
  );
}
