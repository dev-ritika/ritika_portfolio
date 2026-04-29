import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../data/models/portfolio_models.dart';
import 'animated_section_wrapper.dart';
import 'section_header.dart';

class AboutSection extends StatelessWidget {
  final List<StatModel> stats;

  const AboutSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final hPad = ResponsiveUtils.getHorizontalPadding(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            label: 'WHO I AM',
            title: AppStrings.aboutTitle,
            subtitle: AppStrings.aboutSubtitle,
          ),
          const SizedBox(height: 64),
          isMobile
              ? _buildMobileLayout(context)
              : _buildDesktopLayout(context),
          const SizedBox(height: 80),
          _buildStatsRow(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: _buildTextContent(context),
        ),
        const SizedBox(width: 80),
        Expanded(
          flex: 5,
          child: _buildSkillsHighlight(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextContent(context),
        const SizedBox(height: 48),
        _buildSkillsHighlight(context),
      ],
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return ScrollAnimatedWidget(
      delay: const Duration(milliseconds: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.aboutDescription,
            style: GoogleFonts.dmSans(
              fontSize: 17,
              color: AppColors.textSecondary,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'I specialize in architecting production-grade Flutter apps with Clean Architecture '
            'and advanced state management. Beyond code — I mentor developers, drive performance '
            'optimization, and build for real users at scale.',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              color: AppColors.textSecondary.withOpacity(0.8),
              height: 1.8,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _InfoPill(icon: Icons.location_on_outlined, label: AppStrings.location),
              _InfoPill(icon: Icons.mail_outline, label: AppStrings.email),
              _InfoPill(icon: Icons.code, label: AppStrings.github),
            ],
          ),
          const SizedBox(height: 40),
          _buildCertifications(),
        ],
      ),
    );
  }

  Widget _buildCertifications() {
    final certs = [
      'The Ultimate Hands-On Flutter & MVVM',
      'Flutter & Dart: The Complete Guide',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CERTIFICATIONS',
          style: GoogleFonts.sora(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        ...certs.map((cert) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.verified, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  cert,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildSkillsHighlight(BuildContext context) {
    final coreSkills = [
      ('Flutter & Dart', 0.95, AppColors.primary),
      ('Clean Architecture', 0.92, AppColors.secondaryLight),
      ('BLoC / Provider', 0.9, AppColors.accent),
      ('Firebase', 0.88, AppColors.skillFirebase),
      ('iOS & Android Dev', 0.92, AppColors.skillBackend),
      ('CI/CD & DevOps', 0.78, AppColors.skillDevOps),
    ];

    return ScrollAnimatedWidget(
      delay: const Duration(milliseconds: 200),
      slideFrom: const Offset(40, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXPERTISE LEVEL',
            style: GoogleFonts.sora(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          ...coreSkills.map((skill) {
            final (label, level, color) = skill;
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _SkillBar(
                label: label,
                level: level,
                color: color,
              ),
            );
          }),
          const SizedBox(height: 24),
          _buildLanguages(),
        ],
      ),
    );
  }

  Widget _buildLanguages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LANGUAGES',
          style: GoogleFonts.sora(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _LangBadge(lang: 'English', level: 'Professional', color: AppColors.primary),
            const SizedBox(width: 12),
            _LangBadge(lang: 'Hindi', level: 'Native', color: AppColors.secondaryLight),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, bool isMobile) {
    return ScrollAnimatedWidget(
      delay: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: isMobile
            ? Wrap(
                spacing: 20,
                runSpacing: 28,
                children: stats.map((s) => SizedBox(
                  width: (MediaQuery.of(context).size.width - 104) / 2,
                  child: _StatCard(stat: s),
                )).toList(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: stats
                    .map((s) => Expanded(child: _StatCard(stat: s)))
                    .toList(),
              ),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final StatModel stat;
  const _StatCard({required this.stat});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.stat.color.withOpacity(_hovered ? 0.15 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.stat.icon, color: widget.stat.color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              widget.stat.value,
              style: GoogleFonts.sora(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: _hovered ? widget.stat.color : AppColors.textPrimary,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.stat.label,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillBar extends StatefulWidget {
  final String label;
  final double level;
  final Color color;

  const _SkillBar({
    required this.label,
    required this.level,
    required this.color,
  });

  @override
  State<_SkillBar> createState() => _SkillBarState();
}

class _SkillBarState extends State<_SkillBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _anim = Tween<double>(begin: 0, end: widget.level).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            AnimatedBuilder(
              animation: _anim,
              builder: (ctx, _) => Text(
                '${(_anim.value * 100).round()}%',
                style: GoogleFonts.dmMono(
                  fontSize: 12,
                  color: widget.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(2),
          ),
          child: AnimatedBuilder(
            animation: _anim,
            builder: (ctx, _) => FractionallySizedBox(
              widthFactor: _anim.value,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [widget.color, widget.color.withOpacity(0.6)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LangBadge extends StatelessWidget {
  final String lang;
  final String level;
  final Color color;

  const _LangBadge({
    required this.lang,
    required this.level,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang,
            style: GoogleFonts.sora(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            level,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}


