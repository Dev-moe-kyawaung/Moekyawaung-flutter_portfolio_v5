import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/state/portfolio_state.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/sticky_navbar.dart';
import '../widgets/scroll_progress_glow.dart';
import '../../hero/presentation/pages/hero_section.dart';
import '../../about/presentation/pages/about_section.dart';
import '../../skills/presentation/pages/skills_section.dart';
import '../../services/presentation/pages/services_section.dart';
import '../../projects/presentation/pages/projects_section.dart';
import '../../apps/presentation/pages/apps_section.dart';
import '../../contact/presentation/pages/contact_section.dart';

class PortfolioShellPage extends ConsumerStatefulWidget {
  final String? initialSection;
  const PortfolioShellPage({super.key, this.initialSection});

  @override
  ConsumerState<PortfolioShellPage> createState() => _PortfolioShellPageState();
}

class _PortfolioShellPageState extends ConsumerState<PortfolioShellPage> {
  final _scrollCtrl = ScrollController();

  final Map<String, GlobalKey> _keys = {
    'hero':     GlobalKey(),
    'about':    GlobalKey(),
    'skills':   GlobalKey(),
    'services': GlobalKey(),
    'projects': GlobalKey(),
    'apps':     GlobalKey(),
    'contact':  GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollCtrl.position.maxScrollExtent;
    final current   = _scrollCtrl.offset;
    if (maxScroll > 0) {
      ref.read(scrollProgressProvider.notifier).state = current / maxScroll;
    }

    // Update active section
    for (final entry in _keys.entries) {
      final ctx = entry.value.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox?;
        if (box != null) {
          final pos = box.localToGlobal(Offset.zero);
          if (pos.dy <= 200 && pos.dy > -box.size.height + 200) {
            ref.read(activeSectionProvider.notifier).state = entry.key;
          }
        }
      }
    }
  }

  void scrollTo(String section) {
    final ctx = _keys[section]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
        alignment: 0.0,
      );
    }
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Animated background grid
          const _CyberpunkGridBg(),

          // Main scroll content
          SingleChildScrollView(
            controller: _scrollCtrl,
            child: Column(
              children: [
                const SizedBox(height: 72), // nav height offset
                HeroSection(key: _keys['hero'], onScrollTo: scrollTo),
                AboutSection(key: _keys['about']),
                SkillsSection(key: _keys['skills']),
                ServicesSection(key: _keys['services']),
                ProjectsSection(key: _keys['projects']),
                AppsSection(key: _keys['apps']),
                ContactSection(key: _keys['contact']),
                _Footer(onScrollTo: scrollTo),
              ],
            ),
          ),

          // Sticky navbar
          Positioned(
            top: 0, left: 0, right: 0,
            child: StickyNavbar(onScrollTo: scrollTo),
          ),

          // Scroll progress bar
          Positioned(
            top: 0, left: 0, right: 0,
            child: const ScrollProgressGlow(),
          ),

          // Back to top
          Consumer(builder: (ctx, ref, _) {
            final progress = ref.watch(scrollProgressProvider);
            return AnimatedOpacity(
              opacity: progress > 0.2 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: BackToTopButton(
                onTap: () => _scrollCtrl.animateTo(
                  0,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOutCubic,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// â”€â”€â”€ Cyberpunk Grid Background â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _CyberpunkGridBg extends StatelessWidget {
  const _CyberpunkGridBg();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _GridPainter(),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonCyan.withOpacity(0.03)
      ..strokeWidth = 1;

    const spacing = 60.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// â”€â”€â”€ Footer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _Footer extends StatelessWidget {
  final void Function(String) onScrollTo;
  const _Footer({required this.onScrollTo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.silverMuted.withOpacity(0.1))),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (b) => AppColors.cyanPurple.createShader(b),
            child: const Text('MKA', style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w900,
              color: Colors.white, letterSpacing: 4,
            )),
          ),
          const SizedBox(height: 8),
          Text(
            'Â© 2026 Moe Kyaw Aung. Built with Flutter Web.',
            style: TextStyle(color: AppColors.silverMuted, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'Code with culture. Build with purpose. ðŸ‡²ðŸ‡²',
            style: TextStyle(color: AppColors.neonCyan.withOpacity(0.7), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
