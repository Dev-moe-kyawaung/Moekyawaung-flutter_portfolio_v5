import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../data/state/portfolio_state.dart';

class StickyNavbar extends ConsumerStatefulWidget {
  final void Function(String) onScrollTo;
  const StickyNavbar({super.key, required this.onScrollTo});

  @override
  ConsumerState<StickyNavbar> createState() => _StickyNavbarState();
}

class _StickyNavbarState extends ConsumerState<StickyNavbar> {
  bool _scrolled = false;

  @override
  Widget build(BuildContext context) {
    final active   = ref.watch(activeSectionProvider);
    final isDark   = ref.watch(themeProvider) == ThemeMode.dark;
    final isEn     = ref.watch(languageProvider) == 'en';
    final isMobile = MediaQuery.of(context).size.width < 768;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.bgDeep.withOpacity(0.92),
        border: Border(
          bottom: BorderSide(color: AppColors.neonCyan.withOpacity(0.1), width: 1),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: const ColorFilter.mode(Colors.transparent, BlendMode.srcOver),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                // Logo
                ShaderMask(
                  shaderCallback: (b) => AppColors.cyanPurple.createShader(b),
                  child: const Text('MKA',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900,
                        color: Colors.white, letterSpacing: 3),
                  ),
                ),

                const Spacer(),

                if (!isMobile) ...[
                  // Nav items
                  for (final item in _navItems)
                    _NavItem(
                      label: item['label']!,
                      section: item['section']!,
                      isActive: active == item['section'],
                      onTap: () => widget.onScrollTo(item['section']!),
                    ),
                  const SizedBox(width: 16),
                ],

                // Dark mode toggle
                _IconToggle(
                  icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: AppColors.neonCyan,
                  onTap: () => ref.read(themeProvider.notifier).toggle(),
                  tooltip: isDark ? 'Light Mode' : 'Dark Mode',
                ),
                const SizedBox(width: 8),

                // Language toggle
                _LangToggle(
                  isEn: isEn,
                  onTap: () => ref.read(languageProvider.notifier).toggle(),
                ),

                if (isMobile) ...[
                  const SizedBox(width: 8),
                  _IconToggle(
                    icon: Icons.menu_rounded,
                    color: AppColors.silver,
                    onTap: () => _openMobileMenu(context),
                    tooltip: 'Menu',
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _MobileMenu(onScrollTo: widget.onScrollTo),
    );
  }
}

const _navItems = [
  {'label': 'About',    'section': 'about'},
  {'label': 'Skills',   'section': 'skills'},
  {'label': 'Services', 'section': 'services'},
  {'label': 'Projects', 'section': 'projects'},
  {'label': 'Apps',     'section': 'apps'},
  {'label': 'Contact',  'section': 'contact'},
];

class _NavItem extends StatefulWidget {
  final String label;
  final String section;
  final bool isActive;
  final VoidCallback onTap;
  const _NavItem({required this.label, required this.section, required this.isActive, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.isActive || _hovered ? AppColors.neonCyan : AppColors.silverDim;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.label, style: AppTextStyles.navItem.copyWith(color: c)),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: widget.isActive ? 20 : 0,
                decoration: BoxDecoration(
                  color: AppColors.neonCyan,
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [BoxShadow(color: AppColors.neonCyan.withOpacity(0.8), blurRadius: 4)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconToggle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;
  const _IconToggle({required this.icon, required this.color, required this.onTap, required this.tooltip});

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: color, size: 20),
      ),
    ),
  );
}

class _LangToggle extends StatelessWidget {
  final bool isEn;
  final VoidCallback onTap;
  const _LangToggle({required this.isEn, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neonPurple.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isEn ? '🇲🇲 MY' : '🌐 EN',
        style: const TextStyle(fontSize: 11, color: AppColors.silverDim, letterSpacing: 1),
      ),
    ),
  );
}

class _MobileMenu extends StatelessWidget {
  final void Function(String) onScrollTo;
  const _MobileMenu({required this.onScrollTo});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.silverMuted, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            for (final item in _navItems)
              ListTile(
                leading: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.neonCyan),
                title: Text(item['label']!, style: AppTextStyles.bodyMD.copyWith(color: AppColors.silver)),
                onTap: () {
                  Navigator.pop(context);
                  onScrollTo(item['section']!);
                },
              ),
          ],
        ),
      ),
    );
  }
}
