import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

// ─── GlowCard ────────────────────────────────────────────────────────────────
class GlowCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? glowColor;
  final double borderRadius;
  final VoidCallback? onTap;

  const GlowCard({
    super.key,
    required this.child,
    this.padding,
    this.glowColor,
    this.borderRadius = 16,
    this.onTap,
  });

  @override
  State<GlowCard> createState() => _GlowCardState();
}

class _GlowCardState extends State<GlowCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final glow = widget.glowColor ?? AppColors.neonCyan;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: widget.padding ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _hovered ? glow.withOpacity(0.7) : AppColors.silverMuted.withOpacity(0.15),
              width: _hovered ? 1.5 : 1,
            ),
            boxShadow: _hovered
                ? [BoxShadow(color: glow.withOpacity(0.25), blurRadius: 30, spreadRadius: 0)]
                : AppColors.cardGlow,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ─── NeonButton ───────────────────────────────────────────────────────────────
class NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool outline;
  final Color? color;
  final IconData? icon;
  final bool small;

  const NeonButton({
    super.key,
    required this.label,
    this.onPressed,
    this.outline = false,
    this.color,
    this.icon,
    this.small = false,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.color ?? AppColors.neonCyan;
    final py = widget.small ? 10.0 : 14.0;
    final px = widget.small ? 20.0 : 28.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: px, vertical: py),
          decoration: BoxDecoration(
            color: widget.outline
                ? (_hovered ? c.withOpacity(0.12) : Colors.transparent)
                : (_hovered ? c : c.withOpacity(0.85)),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: c, width: 1.5),
            boxShadow: _hovered
                ? [BoxShadow(color: c.withOpacity(0.4), blurRadius: 20, spreadRadius: 0)]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: widget.small ? 14 : 16,
                    color: widget.outline ? c : AppColors.bgDeep),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: AppTextStyles.labelMD.copyWith(
                  color: widget.outline ? c : AppColors.bgDeep,
                  fontSize: widget.small ? 11 : 13,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── SectionTitle ─────────────────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  final CrossAxisAlignment alignment;

  const SectionTitle({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(eyebrow.toUpperCase(), style: AppTextStyles.labelLG),
        const SizedBox(height: 12),
        Text(title, style: AppTextStyles.sectionTitle),
        if (subtitle != null) ...[
          const SizedBox(height: 16),
          Text(subtitle!, style: AppTextStyles.bodyLG),
        ],
      ],
    );
  }
}

// ─── CyberFrame ───────────────────────────────────────────────────────────────
class CyberFrame extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  const CyberFrame({super.key, required this.child, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.neonCyan.withOpacity(0.3)),
            ),
            child: child,
          ),
          // Corner accents
          Positioned(top: 0, left: 0, child: _corner()),
          Positioned(top: 0, right: 0, child: Transform.scale(scaleX: -1, child: _corner())),
          Positioned(bottom: 0, left: 0, child: Transform.scale(scaleY: -1, child: _corner())),
          Positioned(bottom: 0, right: 0, child: Transform.scale(scaleX: -1, scaleY: -1, child: _corner())),
        ],
      ),
    );
  }

  Widget _corner() => SizedBox(
    width: 16, height: 16,
    child: CustomPaint(painter: _CornerPainter()),
  );
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonCyan
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(size.width, 0), paint);
    canvas.drawLine(Offset.zero, Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── ProgressBar ─────────────────────────────────────────────────────────────
class NeonProgressBar extends StatefulWidget {
  final String label;
  final double value;
  final Color? color;
  final String emoji;

  const NeonProgressBar({
    super.key,
    required this.label,
    required this.value,
    this.color,
    required this.emoji,
  });

  @override
  State<NeonProgressBar> createState() => _NeonProgressBarState();
}

class _NeonProgressBarState extends State<NeonProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _anim = Tween<double>(begin: 0, end: widget.value)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.color ?? AppColors.neonCyan;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.emoji} ${widget.label}', style: AppTextStyles.bodyMD),
              AnimatedBuilder(
                animation: _anim,
                builder: (_, __) => Text(
                  '${(_anim.value * 100).round()}%',
                  style: AppTextStyles.labelMD.copyWith(color: c),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(2),
            ),
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => FractionallySizedBox(
                widthFactor: _anim.value,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [c, c.withOpacity(0.6)]),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [BoxShadow(color: c.withOpacity(0.6), blurRadius: 6)],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── BackToTopButton ──────────────────────────────────────────────────────────
class BackToTopButton extends StatelessWidget {
  final VoidCallback onTap;
  const BackToTopButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32, right: 32,
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.neonCyan.withOpacity(0.5)),
              boxShadow: AppColors.neonCyanGlow,
            ),
            child: const Icon(Icons.keyboard_arrow_up_rounded,
                color: AppColors.neonCyan, size: 24),
          ),
        ),
      ),
    );
  }
}
