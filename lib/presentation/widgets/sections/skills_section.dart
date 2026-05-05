import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../data/models/portfolio_models.dart';
import 'animated_section_wrapper.dart';
import 'section_background.dart';
import 'section_header.dart';
import 'tech_globe.dart';

class SkillsSection extends StatelessWidget {
  final List<SkillCategory> categories;

  const SkillsSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final hPad = ResponsiveUtils.getHorizontalPadding(context);
    final isMobile = ResponsiveUtils.isMobile(context);
    final crossAxisCount = isMobile ? 1 : (ResponsiveUtils.isTablet(context) ? 2 : 3);

    return SectionBackground(
      style: SectionBgStyle.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            label: 'WHAT I KNOW',
            title: AppStrings.skillsTitle,
            subtitle: AppStrings.skillsSubtitle,
          ),
          const SizedBox(height: 64),
          // Grid
          _buildGrid(context, crossAxisCount),
          const SizedBox(height: 60),
          // Full stack row
          _buildFullStackRow(context),
        ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, int crossAxisCount) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 20.0;
        final itemWidth =
            (constraints.maxWidth - spacing * (crossAxisCount - 1)) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(categories.length, (i) {
            return SizedBox(
              width: itemWidth,
              child: ScrollAnimatedWidget(
                delay: Duration(milliseconds: 100 + i * 60),
                child: _SkillCategoryCard(category: categories[i]),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildFullStackRow(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    return ScrollAnimatedWidget(
      delay: const Duration(milliseconds: 200),
      child: Column(
        children: [
          // Section divider
          Container(
            margin: const EdgeInsets.only(bottom: 48),
            child: Row(
              children: [
                Expanded(
                    child: Divider(color: AppColors.border, thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ShaderMask(
                    shaderCallback: (b) =>
                        AppColors.primaryGradient.createShader(b),
                    child: Text(
                      'FULL TECH STACK — INTERACTIVE GLOBE',
                      style: GoogleFonts.dmMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Divider(color: AppColors.border, thickness: 1)),
              ],
            ),
          ),

          // Globe
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.07)),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withOpacity(0.10), blurRadius: 50, offset: const Offset(0, 10)),
                BoxShadow(color: AppColors.secondary.withOpacity(0.06), blurRadius: 30, offset: const Offset(0, 4)),
              ],
            ),
            child: isMobile
                ? Column(children: [
                    _buildGlobeHint(),
                    const SizedBox(height: 24),
                    const TechGlobe(),
                  ])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 4, child: _buildGlobeInfo()),
                      Expanded(
                          flex: 6,
                          child: const Center(child: TechGlobe())),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobeHint() {
    return Text(
      'Hover any node to see the technology',
      style: GoogleFonts.dmSans(
        fontSize: 13,
        color: AppColors.textMuted,
        letterSpacing: 0.3,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildGlobeInfo() {
    final highlights = [
      ('22+', 'Technologies', AppColors.primary),
      ('3.8+', 'Yrs Flutter', AppColors.secondary),
      ('6+', 'Yrs SDLC', AppColors.accent),
      ('3', 'Production Apps', AppColors.skillFirebase),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (b) => AppColors.heroGradient.createShader(b),
          child: Text(
            'My Tech\nUniverse',
            style: GoogleFonts.sora(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Every technology I use, visualised as a living, spinning 3D globe. Hover a node to learn more.',
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: highlights.map((h) {
            final (val, lbl, col) = h;
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: col.withOpacity(0.08),
                border: Border.all(color: col.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    val,
                    style: GoogleFonts.sora(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: col,
                    ),
                  ),
                  Text(
                    lbl,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SkillCategoryCard extends StatefulWidget {
  final SkillCategory category;
  const _SkillCategoryCard({required this.category});

  @override
  State<_SkillCategoryCard> createState() => _SkillCategoryCardState();
}

class _SkillCategoryCardState extends State<_SkillCategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: _hovered
              ? LinearGradient(
                  colors: [
                    widget.category.color.withOpacity(0.1),
                    AppColors.card,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : AppColors.cardGradient,
          border: Border.all(
            color: _hovered
                ? widget.category.color.withOpacity(0.5)
                : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: widget.category.color.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.category.color
                        .withOpacity(_hovered ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    widget.category.icon,
                    color: widget.category.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.category.title,
                    style: GoogleFonts.sora(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _hovered
                          ? widget.category.color
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.category.skills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: widget.category.color.withOpacity(0.07),
                    border: Border.all(
                      color: widget.category.color.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    skill,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TechPill extends StatefulWidget {
  final String label;
  const _TechPill({required this.label});

  @override
  State<_TechPill> createState() => _TechPillState();
}

class _TechPillState extends State<_TechPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.card,
          border: Border.all(
            color: _hovered
                ? AppColors.primary.withOpacity(0.4)
                : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.dmMono(
            fontSize: 12,
            color: _hovered ? AppColors.primary : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
