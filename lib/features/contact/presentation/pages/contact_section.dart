import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_links.dart';
import '../../../../core/helpers/responsive.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/state/portfolio_state.dart';

class ContactSection extends ConsumerStatefulWidget {
  const ContactSection({super.key});

  @override
  ConsumerState<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends ConsumerState<ContactSection> {
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _msgCtrl     = TextEditingController();
  bool _sending = false;
  bool _sent    = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _subjectCtrl.dispose(); _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _msgCtrl.text.isEmpty) {
      setState(() => _error = 'Please fill in all required fields.');
      return;
    }
    setState(() { _sending = true; _error = null; });
    await Future.delayed(const Duration(seconds: 2));
    // In production: integrate EmailJS / Firebase Cloud Function
    setState(() { _sending = false; _sent = true; });
  }

  @override
  Widget build(BuildContext context) {
    final pad      = Responsive.padding(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      color: AppColors.bgDeep,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 96),
      child: Column(
        children: [
          SectionTitle(
            eyebrow: '// Contact',
            title: AppStrings.contactTitle,
            subtitle: AppStrings.contactSubtitle,
            alignment: CrossAxisAlignment.center,
          ).animate().fadeIn().slideY(begin: 0.2),

          const SizedBox(height: 64),

          isMobile
              ? Column(children: [
                  _buildContactInfo(),
                  const SizedBox(height: 40),
                  _buildForm(),
                ])
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: _buildContactInfo()),
                    const SizedBox(width: 48),
                    Expanded(flex: 6, child: _buildForm()),
                  ],
                ),

          const SizedBox(height: 80),

          // Email collection
          _EmailCollection(),

          const SizedBox(height: 80),

          // Social grid
          _SocialGrid(),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        Center(
          child: Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.neonCyan.withOpacity(0.5), width: 2),
              boxShadow: AppColors.neonCyanGlow,
              image: const DecorationImage(
                image: NetworkImage(AppLinks.profileMain),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Contact cards
        for (final item in [
          {'icon': '📞', 'label': 'Phone 1', 'value': AppStrings.phone1, 'action': 'tel:+959889000889'},
          {'icon': '📱', 'label': 'Phone 2', 'value': AppStrings.phone2, 'action': 'tel:+959666000050'},
          {'icon': '✉️', 'label': 'Primary Email', 'value': AppStrings.email1, 'action': 'mailto:${AppStrings.email1}'},
          {'icon': '✉️', 'label': 'Alt Email', 'value': AppStrings.email2, 'action': 'mailto:${AppStrings.email2}'},
          {'icon': '📍', 'label': 'Location', 'value': AppStrings.location, 'action': ''},
          {'icon': '🔗', 'label': 'GitHub', 'value': 'Dev-moe-kyawaung', 'action': AppLinks.githubMain},
          {'icon': '💼', 'label': 'LinkedIn', 'value': 'moe-kyaw-aung', 'action': AppLinks.linkedin},
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ContactInfoRow(
              icon: item['icon']!,
              label: item['label']!,
              value: item['value']!,
              action: item['action']!,
            ),
          ),

        const SizedBox(height: 24),

        // Status
        GlowCard(
          glowColor: AppColors.neonGreen,
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 10, height: 10,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.neonGreen),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Open to Work', style: AppTextStyles.labelMD.copyWith(color: AppColors.neonGreen)),
                Text('Available for full-time, freelance & collaborations',
                  style: AppTextStyles.bodySM),
              ],
            )),
          ]),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1);
  }

  Widget _buildForm() {
    if (_sent) {
      return GlowCard(
        glowColor: AppColors.neonGreen,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('✅', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text('Message Sent!', style: AppTextStyles.displayMD.copyWith(color: AppColors.neonGreen)),
            const SizedBox(height: 8),
            Text("I'll get back to you soon. ✨",
              style: AppTextStyles.bodyMD, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            NeonButton(
              label: 'Send Another',
              outline: true,
              onPressed: () => setState(() { _sent = false; _nameCtrl.clear(); _emailCtrl.clear(); _subjectCtrl.clear(); _msgCtrl.clear(); }),
            ),
          ],
        ),
      );
    }

    return GlowCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Send a Message', style: AppTextStyles.bodyMD.copyWith(
            fontWeight: FontWeight.w700, color: AppColors.silver, fontSize: 20)),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: _Field(ctrl: _nameCtrl, label: 'Your Name *', hint: 'John Doe')),
            const SizedBox(width: 16),
            Expanded(child: _Field(ctrl: _emailCtrl, label: 'Email *', hint: 'you@example.com')),
          ]),
          const SizedBox(height: 16),
          _Field(ctrl: _subjectCtrl, label: 'Subject', hint: 'Project inquiry / Collaboration / etc.'),
          const SizedBox(height: 16),
          _Field(ctrl: _msgCtrl, label: 'Message *', hint: 'Tell me about your project...', maxLines: 5),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: AppColors.glitchRed, fontSize: 12)),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: _sending
                ? const Center(child: CircularProgressIndicator(color: AppColors.neonCyan, strokeWidth: 2))
                : NeonButton(
                    label: 'Send Message',
                    icon: Icons.send_rounded,
                    onPressed: _submit,
                  ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1);
  }
}

// ─── Field ────────────────────────────────────────────────────────────────────
class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final int maxLines;
  const _Field({required this.ctrl, required this.label, required this.hint, this.maxLines = 1});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: AppTextStyles.labelMD),
      const SizedBox(height: 8),
      TextField(
        controller: ctrl,
        maxLines: maxLines,
        style: AppTextStyles.bodyMD.copyWith(color: AppColors.silver),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodySM,
          filled: true,
          fillColor: AppColors.bgElevated,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.silverMuted.withOpacity(0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.silverMuted.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.neonCyan, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    ],
  );
}

// ─── Contact Info Row ─────────────────────────────────────────────────────────
class _ContactInfoRow extends StatefulWidget {
  final String icon;
  final String label;
  final String value;
  final String action;
  const _ContactInfoRow({required this.icon, required this.label, required this.value, required this.action});

  @override
  State<_ContactInfoRow> createState() => _ContactInfoRowState();
}

class _ContactInfoRowState extends State<_ContactInfoRow> {
  bool _hovered = false;
  bool _copied  = false;

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.value));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit:  (_) => setState(() => _hovered = false),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _hovered ? AppColors.bgElevated : AppColors.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _hovered ? AppColors.neonCyan.withOpacity(0.3) : AppColors.silverMuted.withOpacity(0.1),
        ),
      ),
      child: Row(children: [
        Text(widget.icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label, style: AppTextStyles.bodySM.copyWith(color: AppColors.silverMuted)),
            Text(widget.value, style: AppTextStyles.bodySM.copyWith(color: AppColors.silver, fontSize: 13),
              overflow: TextOverflow.ellipsis),
          ],
        )),
        if (_hovered) ...[
          if (widget.action.isNotEmpty)
            GestureDetector(
              onTap: () => launchUrl(Uri.parse(widget.action)),
              child: const Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.neonCyan),
            ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: _copyToClipboard,
            child: Icon(
              _copied ? Icons.check_rounded : Icons.copy_rounded,
              size: 14,
              color: _copied ? AppColors.neonGreen : AppColors.silverDim,
            ),
          ),
        ],
      ]),
    ),
  );
}

// ─── Email Collection ─────────────────────────────────────────────────────────
class _EmailCollection extends StatefulWidget {
  @override
  State<_EmailCollection> createState() => _EmailCollectionState();
}

class _EmailCollectionState extends State<_EmailCollection> {
  String? _copiedEmail;

  void _copy(String email) {
    Clipboard.setData(ClipboardData(text: email));
    setState(() => _copiedEmail = email);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copiedEmail = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final emails = AppLinks.emails;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          SectionTitle(eyebrow: '// Reach Out', title: '21 Email Addresses'),
          const Spacer(),
          Text('Tap to copy', style: AppTextStyles.bodySM.copyWith(color: AppColors.silverMuted)),
        ]),
        const SizedBox(height: 32),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: emails.map((e) {
            final copied = _copiedEmail == e;
            return GestureDetector(
              onTap: () => _copy(e),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: copied ? AppColors.neonGreen.withOpacity(0.1) : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: copied
                        ? AppColors.neonGreen.withOpacity(0.5)
                        : AppColors.silverMuted.withOpacity(0.15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      copied ? Icons.check_rounded : Icons.alternate_email_rounded,
                      size: 13,
                      color: copied ? AppColors.neonGreen : AppColors.silverMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(e, style: AppTextStyles.bodySM.copyWith(
                      fontSize: 12,
                      color: copied ? AppColors.neonGreen : AppColors.silverDim,
                    )),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }
}

// ─── Social Grid ──────────────────────────────────────────────────────────────
class _SocialGrid extends StatelessWidget {
  static const _socials = [
    {'emoji': '🐙', 'name': 'GitHub (Main)', 'handle': '@Dev-moe-kyawaung', 'url': AppLinks.githubMain},
    {'emoji': '💼', 'name': 'LinkedIn', 'handle': 'moe-kyaw-aung', 'url': AppLinks.linkedin},
    {'emoji': '▶️', 'name': 'YouTube', 'handle': 'MKA Channel', 'url': AppLinks.youtube},
    {'emoji': '🦋', 'name': 'Bluesky', 'handle': '@moekyawaung96', 'url': AppLinks.bluesky},
    {'emoji': '📸', 'name': 'Flickr', 'handle': '204037451@N06', 'url': AppLinks.flickr},
    {'emoji': '🎬', 'name': 'Vimeo', 'handle': 'user252414232', 'url': AppLinks.vimeo},
    {'emoji': '📝', 'name': 'Tumblr', 'handle': '@moekyawaung', 'url': AppLinks.tumblr},
    {'emoji': '🌐', 'name': 'Gravatar', 'handle': 'moekyawaung2026', 'url': AppLinks.gravatar},
    {'emoji': '💬', 'name': 'Slack', 'handle': 'moekyawaung', 'url': AppLinks.slack},
    {'emoji': '🌟', 'name': 'Strikingly', 'handle': 'moekyawaung2026', 'url': AppLinks.strikingly},
  ];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionTitle(eyebrow: '// Social', title: 'Find Me Online'),
      const SizedBox(height: 32),
      LayoutBuilder(builder: (ctx, constraints) {
        final crossCount = constraints.maxWidth > 900
            ? 5
            : constraints.maxWidth > 600
                ? 3
                : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: _socials.length,
          itemBuilder: (ctx, i) => _SocialCard(data: _socials[i], index: i),
        );
      }),
    ],
  ).animate().fadeIn(delay: 300.ms);
}

class _SocialCard extends StatefulWidget {
  final Map<String, String> data;
  final int index;
  const _SocialCard({required this.data, required this.index});

  @override
  State<_SocialCard> createState() => _SocialCardState();
}

class _SocialCardState extends State<_SocialCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit:  (_) => setState(() => _hovered = false),
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () => launchUrl(Uri.parse(widget.data['url']!)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.bgElevated : AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered
                ? AppColors.neonPurple.withOpacity(0.5)
                : AppColors.silverMuted.withOpacity(0.1),
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: AppColors.neonPurple.withOpacity(0.15), blurRadius: 20)]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.data['emoji']!, style: TextStyle(fontSize: _hovered ? 30 : 26)),
            const SizedBox(height: 8),
            Text(widget.data['name']!,
              style: AppTextStyles.bodySM.copyWith(
                color: _hovered ? AppColors.silver : AppColors.silverDim,
                fontWeight: FontWeight.w600, fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(widget.data['handle']!,
              style: AppTextStyles.bodySM.copyWith(
                fontSize: 10, color: AppColors.silverMuted,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  ).animate().fadeIn(delay: Duration(milliseconds: 60 * widget.index)).slideY(begin: 0.1);
}
