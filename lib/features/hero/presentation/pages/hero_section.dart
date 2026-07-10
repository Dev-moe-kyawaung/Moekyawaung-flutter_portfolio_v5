import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_links.dart';
import '../../../../core/helpers/responsive.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/state/portfolio_state.dart';

class HeroSection extends ConsumerStatefulWidget {
  final void Function(String) onScrollTo;
  const HeroSection({super.key, required this.onScrollTo});

  @override
  ConsumerState<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _typeCtrl;
  late AnimationController _rotateCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _particleCtrl;

  int _roleIndex = 0;
  String _displayText = '';
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();

    _rotateCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 12),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _particleCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 8),
    )..repeat();

    _typeCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 120),
    )..addStatusListener(_onTypeTick);
    _typeCtrl.forward();
  }

  void _onTypeTick(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      final target = AppStrings.heroRoles[_roleIndex];
      if (!_isDeleting && _displayText == target) {
        Future.delayed(const Duration(milliseconds: 1800), () {
          if (mounted) setState(() => _isDeleting = true);
          if (mounted) _typeCtrl.forward(from: 0);
        });
        return;
      }
      setState(() {
        if (_isDeleting) {
          if (_displayText.isNotEmpty) {
            _displayText = _displayText.substring(0, _displayText.length - 1);
          } else {
            _isDeleting = false;
            _roleIndex = (_roleIndex + 1) % AppStrings.heroRoles.length;
          }
        } else {
          _displayText = target.substring(0, _displayText.length + 1);
        }
      });
      _typeCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _typeCtrl.dispose();
    _rotateCtrl.dispose();
    _pulseCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final pad = Responsive.padding(context);

    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      decoration: const BoxDecoration(gradient: AppColors.heroBg),
      child: Stack(
        children: [
          // Particle field
          Positioned.fill(child: _ParticleField(controller: _particleCtrl)),

          // Glow orbs
          Positioned(top: -100, right: -100,
            child: _GlowOrb(color: AppColors.neonPurple, size: 500, controller: _pulseCtrl)),
          Positioned(bottom: -50, left: -80,
            child: _GlowOrb(color: AppColors.neonCyan, size: 350, controller: _pulseCtrl)),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: pad, vertical: 80),
            child: isMobile
                ? _buildMobileLayout()
                : _buildDesktopLayout(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(flex: 6, child: _buildText()),
      const SizedBox(width: 64),
      Expanded(flex: 4, child: _buildAvatar()),
    ],
  );

  Widget _buildMobileLayout() => Column(
    children: [
      _buildAvatar(size: 220),
      const SizedBox(height: 40),
      _buildText(),
    ],
  );

  Widget _buildText() {
    final isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Eyebrow
        Text('// SENIOR DEVELOPER', style: AppTextStyles.labelLG)
            .animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),

        const SizedBox(height: 16),

        // Name — gradient
        ShaderMask(
          shaderCallback: (b) => AppColors.cyanPurple.createShader(b),
          child: Text(
            AppStrings.name,
            style: (isMobile ? AppTextStyles.heroNameMobile : AppTextStyles.heroName)
                .copyWith(color: Colors.white),
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),

        const SizedBox(height: 4),

        // Myanmar name
        Text(AppStrings.nameMyanmar,
            style: AppTextStyles.bodyMD.copyWith(color: AppColors.neonCyan.withOpacity(0.7)))
            .animate().fadeIn(delay: 500.ms),

        const SizedBox(height: 20),

        // Typing role
        Row(
          children: [
            Text(_displayText,
              style: AppTextStyles.displayMD.copyWith(
                color: AppColors.silver, fontSize: isMobile ? 20 : 28,
              ),
            ),
            AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (_, __) => AnimatedOpacity(
                opacity: _pulseCtrl.value > 0.5 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  width: 2, height: isMobile ? 24 : 32,
                  color: AppColors.neonCyan,
                  margin: const EdgeInsets.only(left: 2),
                ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 600.ms),

        const SizedBox(height: 16),

        // Location
        Row(children: [
          const Icon(Icons.location_on_outlined, size: 16, color: AppColors.neonPurple),
          const SizedBox(width: 6),
          Text(AppStrings.location, style: AppTextStyles.bodySM.copyWith(color: AppColors.silverDim)),
        ]).animate().fadeIn(delay: 700.ms),

        const SizedBox(height: 32),

        // Stats row
        Wrap(
          spacing: 24, runSpacing: 16,
          children: [
            _StatBadge(value: AppStrings.stat1Val, label: AppStrings.stat1Lbl),
            _StatBadge(value: AppStrings.stat2Val, label: AppStrings.stat2Lbl),
            _StatBadge(value: AppStrings.stat3Val, label: AppStrings.stat3Lbl),
            _StatBadge(value: AppStrings.stat4Val, label: AppStrings.stat4Lbl),
            _StatBadge(value: AppStrings.stat5Val, label: AppStrings.stat5Lbl),
          ],
        ).animate().fadeIn(delay: 800.ms),

        const SizedBox(height: 40),

        // CTA Buttons
        Wrap(
          spacing: 16, runSpacing: 12,
          children: [
            NeonButton(
              label: AppStrings.heroCTA,
              icon: Icons.arrow_downward_rounded,
              onPressed: () => widget.onScrollTo('projects'),
            ),
            NeonButton(
              label: AppStrings.heroContact,
              outline: true,
              color: AppColors.neonPurple,
              onPressed: () => widget.onScrollTo('contact'),
            ),
            NeonButton(
              label: AppStrings.heroDownloadCV,
              outline: true,
              icon: Icons.download_rounded,
              onPressed: () => launchUrl(Uri.parse(AppLinks.githubMain)),
            ),
          ],
        ).animate().fadeIn(delay: 900.ms),

        const SizedBox(height: 40),

        // Social icons row
        _SocialRow().animate().fadeIn(delay: 1000.ms),
      ],
    );
  }

  Widget _buildAvatar({double size = 340}) {
    return Center(
      child: SizedBox(
        width: size, height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer rotating ring
            AnimatedBuilder(
              animation: _rotateCtrl,
              builder: (_, child) => Transform.rotate(
                angle: _rotateCtrl.value * 2 * math.pi,
                child: child,
              ),
              child: Container(
                width: size, height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(colors: [
                    AppColors.neonCyan, AppColors.neonPurple,
                    AppColors.neonGreen, AppColors.neonCyan,
                  ]),
                ),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.bgDeep,
                  ),
                ),
              ),
            ),

            // Inner static ring
            AnimatedBuilder(
              animation: _rotateCtrl,
              builder: (_, child) => Transform.rotate(
                angle: -_rotateCtrl.value * 2 * math.pi * 0.5,
                child: child,
              ),
              child: Container(
                width: size - 40, height: size - 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.neonPurple.withOpacity(0.3), width: 1,
                  ),
                ),
              ),
            ),

            // Avatar image
            Container(
              width: size - 60, height: size - 60,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: AppLinks.profileMain,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.bgCard,
                  child: const Icon(Icons.person, size: 80, color: AppColors.neonCyan),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.bgCard,
                  child: const Icon(Icons.person, size: 80, color: AppColors.neonCyan),
                ),
              ),
            ),

            // Pulse glow
            AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (_, __) => Container(
                width: size + 20 + _pulseCtrl.value * 20,
                height: size + 20 + _pulseCtrl.value * 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.neonCyan.withOpacity(0.1 * (1 - _pulseCtrl.value)),
                    width: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.8, 0.8));
  }
}

// ─── Stat Badge ───────────────────────────────────────────────────────────────
class _StatBadge extends StatelessWidget {
  final String value;
  final String label;
  const _StatBadge({required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShaderMask(
        shaderCallback: (b) => AppColors.cyanGreen.createShader(b),
        child: Text(value, style: const TextStyle(
          fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white,
        )),
      ),
      Text(label, style: AppTextStyles.bodySM),
    ],
  );
}

// ─── Social Row ───────────────────────────────────────────────────────────────
class _SocialRow extends StatelessWidget {
  final socials = const [
    {'icon': '🐙', 'url': AppLinks.githubMain,  'tip': 'GitHub'},
    {'icon': '💼', 'url': AppLinks.linkedin,    'tip': 'LinkedIn'},
    {'icon': '▶️', 'url': AppLinks.youtube,     'tip': 'YouTube'},
    {'icon': '🦋', 'url': AppLinks.bluesky,     'tip': 'Bluesky'},
    {'icon': '📸', 'url': AppLinks.flickr,      'tip': 'Flickr'},
    {'icon': '🎬', 'url': AppLinks.vimeo,       'tip': 'Vimeo'},
    {'icon': '📝', 'url': AppLinks.tumblr,      'tip': 'Tumblr'},
  ];

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 12, runSpacing: 8,
    children: socials.map((s) => _SocialChip(
      emoji: s['icon']!, url: s['url']!, tooltip: s['tip']!,
    )).toList(),
  );
}

class _SocialChip extends StatefulWidget {
  final String emoji;
  final String url;
  final String tooltip;
  const _SocialChip({required this.emoji, required this.url, required this.tooltip});

  @override
  State<_SocialChip> createState() => _SocialChipState();
}

class _SocialChipState extends State<_SocialChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit:  (_) => setState(() => _hovered = false),
    cursor: SystemMouseCursors.click,
    child: Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.neonCyan.withOpacity(0.1) : AppColors.bgCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered ? AppColors.neonCyan.withOpacity(0.6) : AppColors.silverMuted.withOpacity(0.2),
            ),
          ),
          child: Text('${widget.emoji} ${widget.tooltip}',
            style: const TextStyle(fontSize: 13, color: AppColors.silverDim)),
        ),
      ),
    ),
  );
}

// ─── Particles ────────────────────────────────────────────────────────────────
class _ParticleField extends StatelessWidget {
  final AnimationController controller;
  const _ParticleField({required this.controller});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (_, __) => CustomPaint(
      painter: _ParticlePainter(controller.value),
    ),
  );
}

class _ParticlePainter extends CustomPainter {
  final double t;
  static final _rng = math.Random(42);
  static final List<_Particle> _particles = List.generate(
    60, (i) => _Particle(_rng),
  );

  _ParticlePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final x = (p.x * size.width + t * p.speed * size.width * 0.1) % size.width;
      final y = (p.y * size.height + t * p.speed * 0.03 * size.height) % size.height;
      canvas.drawCircle(
        Offset(x, y),
        p.radius,
        Paint()..color = AppColors.neonCyan.withOpacity(p.opacity * (0.5 + 0.5 * math.sin(t * 6 + p.phase))),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.t != t;
}

class _Particle {
  final double x, y, speed, radius, opacity, phase;
  _Particle(math.Random rng)
      : x = rng.nextDouble(),
        y = rng.nextDouble(),
        speed = 0.3 + rng.nextDouble() * 0.7,
        radius = 0.5 + rng.nextDouble() * 1.5,
        opacity = 0.05 + rng.nextDouble() * 0.25,
        phase = rng.nextDouble() * math.pi * 2;
}

// ─── Glow Orb ─────────────────────────────────────────────────────────────────
class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  final AnimationController controller;
  const _GlowOrb({required this.color, required this.size, required this.controller});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (_, __) => Container(
      width: size + controller.value * 30,
      height: size + controller.value * 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.08 + controller.value * 0.04),
            color.withOpacity(0),
          ],
        ),
      ),
    ),
  );
}
