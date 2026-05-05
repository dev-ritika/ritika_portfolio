import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../data/models/portfolio_models.dart';
import 'animated_section_wrapper.dart';
import 'section_background.dart';
import 'section_header.dart';

class ExperienceSection extends StatelessWidget {
  final List<ExperienceModel> experiences;

  const ExperienceSection({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    final hPad = ResponsiveUtils.getHorizontalPadding(context);

    return SectionBackground(
      style: SectionBgStyle.dark,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            label: 'WORK HISTORY',
            title: AppStrings.experienceTitle,
            subtitle: AppStrings.experienceSubtitle,
          ),
          const SizedBox(height: 64),
          ...List.generate(experiences.length, (i) {
            return ScrollAnimatedWidget(
              delay: Duration(milliseconds: 100 + i * 120),
              child: _ExperienceCard(
                experience: experiences[i],
                isLast: i == experiences.length - 1,
                index: i,
              ),
            );
          }),
        ],
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final ExperienceModel experience;
  final bool isLast;
  final int index;

  const _ExperienceCard({
    required this.experience,
    required this.isLast,
    required this.index,
  });

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _expanded = false;
  late AnimationController _expandController;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _expanded = widget.index == 0; // First one expanded by default
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: widget.index == 0 ? 1 : 0,
    );
    _expandAnim = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  Color get _accentColor {
    switch (widget.index) {
      case 0:
        return AppColors.primary;
      case 1:
        return AppColors.secondaryLight;
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline column
          SizedBox(
            width: isMobile ? 40 : 60,
            child: Column(
              children: [
                // Dot
                Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: widget.experience.isCurrent
                        ? _accentColor
                        : AppColors.border,
                    shape: BoxShape.circle,
                    boxShadow: widget.experience.isCurrent
                        ? [
                            BoxShadow(
                              color: _accentColor.withOpacity(0.5),
                              blurRadius: 8,
                            )
                          ]
                        : [],
                    border: Border.all(
                      color: _accentColor.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                ),
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _accentColor.withOpacity(0.4),
                            AppColors.border.withOpacity(0.2),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: widget.isLast ? 0 : 32,
                left: isMobile ? 8 : 16,
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.basic,
                onEnter: (_) => setState(() => _hovered = true),
                onExit: (_) => setState(() => _hovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    color: _hovered ? AppColors.cardHover : AppColors.card,
                    border: Border.all(
                      color: _hovered
                          ? _accentColor.withOpacity(0.3)
                          : AppColors.border,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _hovered
                        ? [
                            BoxShadow(
                              color: _accentColor.withOpacity(0.08),
                              blurRadius: 20,
                            )
                          ]
                        : [],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      InkWell(
                        onTap: _toggle,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (widget.experience.isCurrent)
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 8),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  _accentColor.withOpacity(0.1),
                                              border: Border.all(
                                                  color: _accentColor
                                                      .withOpacity(0.4)),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 5,
                                                  height: 5,
                                                  decoration: BoxDecoration(
                                                    color: _accentColor,
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: _accentColor
                                                            .withOpacity(0.8),
                                                        blurRadius: 4,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'Current',
                                                  style: GoogleFonts.sora(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: _accentColor,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        Text(
                                          widget.experience.role,
                                          style: GoogleFonts.sora(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.experience.company,
                                          style: GoogleFonts.sora(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: _accentColor,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 4,
                                          children: [
                                            _MetaPill(
                                              icon: Icons.calendar_today,
                                              label: widget.experience.period,
                                            ),
                                            _MetaPill(
                                              icon: Icons.location_on_outlined,
                                              label:
                                                  widget.experience.location,
                                            ),
                                            _MetaPill(
                                              icon: Icons.work_outline,
                                              label: widget.experience.type,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedRotation(
                                    turns: _expanded ? 0.25 : 0,
                                    duration:
                                        const Duration(milliseconds: 300),
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: AppColors.textMuted,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Expandable content
                      SizeTransition(
                        sizeFactor: _expandAnim,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(color: AppColors.border, height: 1),
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Highlights
                                  Text(
                                    'KEY ACHIEVEMENTS',
                                    style: GoogleFonts.sora(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _accentColor,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ...widget.experience.highlights.map(
                                    (h) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            margin: const EdgeInsets.only(
                                              top: 7,
                                              right: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _accentColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              h,
                                              style: GoogleFonts.dmSans(
                                                fontSize: 14,
                                                color: AppColors.textSecondary,
                                                height: 1.6,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Tech stack
                                  Text(
                                    'TECH STACK',
                                    style: GoogleFonts.sora(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _accentColor,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: widget.experience.techStack
                                        .map(
                                          (t) => Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  _accentColor.withOpacity(0.07),
                                              border: Border.all(
                                                color: _accentColor
                                                    .withOpacity(0.25),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              t,
                                              style: GoogleFonts.dmMono(
                                                fontSize: 12,
                                                color: _accentColor
                                                    .withOpacity(0.9),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
