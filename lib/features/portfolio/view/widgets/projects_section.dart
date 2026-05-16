import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../data/models/portfolio_models.dart';
import '../../viewmodel/portfolio_viewmodel.dart';
import 'animated_section_wrapper.dart';
import 'section_background.dart';
import 'section_header.dart';

class ProjectsSection extends StatelessWidget {
  final List<ProjectModel> projects;
  final PortfolioViewModel? viewModel;
  final int? hoveredIndex;

  const ProjectsSection({
    super.key,
    required this.projects,
    this.viewModel,
    this.hoveredIndex,
  });

  @override
  Widget build(BuildContext context) {
    final hPad = ResponsiveUtils.getHorizontalPadding(context);
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final crossAxis = isMobile ? 1 : (isTablet ? 2 : 2);

    return SectionBackground(
      style: SectionBgStyle.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: hPad,
          vertical: ResponsiveUtils.sectionVPadding(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              label: 'PORTFOLIO',
              title: AppStrings.projectsTitle,
              subtitle: AppStrings.projectsSubtitle,
            ),
            const SizedBox(height: 20),
            // Flip hint
            Row(
              children: [
                Icon(Icons.flip, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text(
                  'Hover / Tap a card to flip it and explore the project',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 28.0;
                final itemWidth =
                    (constraints.maxWidth - spacing * (crossAxis - 1)) /
                    crossAxis;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: List.generate(projects.length, (i) {
                    return SizedBox(
                      width: itemWidth,
                      height: ResponsiveUtils.isMobile(context) ? 420 : 480,
                      child: ScrollAnimatedWidget(
                        delay: Duration(milliseconds: 100 + i * 80),
                        child: _FlipProjectCard(project: projects[i]),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// FLIP CARD
// ══════════════════════════════════════════════════════════════════════════════
class _FlipProjectCard extends StatefulWidget {
  final ProjectModel project;
  const _FlipProjectCard({required this.project});

  @override
  State<_FlipProjectCard> createState() => _FlipProjectCardState();
}

class _FlipProjectCardState extends State<_FlipProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _flipped = false;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _anim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool hovered) {
    setState(() => _hovered = hovered);
    if (hovered && !_flipped) {
      _ctrl.forward();
      _flipped = true;
    } else if (!hovered && _flipped) {
      _ctrl.reverse();
      _flipped = false;
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_flipped) {
          _ctrl.forward();
          setState(() => _flipped = true);
        } else {
          _ctrl.reverse();
          setState(() => _flipped = false);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _onHoverChanged(true),
        onExit: (_) => _onHoverChanged(false),
        child: AnimatedBuilder(
          animation: _anim,
          builder: (_, __) {
            // 0..0.5 = front face visible, 0.5..1 = back face visible
            final angle = _anim.value * math.pi;
            final showFront = _anim.value < 0.5;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: showFront
                  ? _FrontFace(project: widget.project, hovered: _hovered)
                  : Transform(
                      // counter-rotate so back isn't mirrored
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: _BackFace(
                        project: widget.project,
                        onLaunch: _launchUrl,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}

// ── FRONT FACE ─────────────────────────────────────────────────────────────────
class _FrontFace extends StatelessWidget {
  final ProjectModel project;
  final bool hovered;
  const _FrontFace({required this.project, required this.hovered});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            project.accentColor.withOpacity(hovered ? 0.14 : 0.08),
            AppColors.card,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: project.accentColor.withOpacity(hovered ? 0.55 : 0.25),
          width: hovered ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: hovered
            ? [
                BoxShadow(
                  color: project.accentColor.withOpacity(0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 12),
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Project image banner ───────────────────────────────────────
            Expanded(
              flex: 5,
              child: _ProjectImageBanner(project: project, hovered: hovered),
            ),
            // ── Info strip ────────────────────────────────────────────────
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.subtitle,
                      style: GoogleFonts.dmMono(
                        fontSize: 11,
                        color: project.accentColor,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      project.title,
                      style: GoogleFonts.sora(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      project.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const Spacer(),
                    // Hover hint
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: hovered ? 16 : 8,
                          height: 2,
                          decoration: BoxDecoration(
                            color: project.accentColor,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          hovered ? 'Flipping…' : 'Hover to explore',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: project.accentColor.withOpacity(0.7),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.flip,
                          size: 14,
                          color: project.accentColor.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Project Image Banner ────────────────────────────────────────────────────────
class _ProjectImageBanner extends StatelessWidget {
  final ProjectModel project;
  final bool hovered;
  const _ProjectImageBanner({required this.project, required this.hovered});

  @override
  Widget build(BuildContext context) {
    // Placeholder — replace project.imagePath with actual image when available
    // e.g. Image.asset(project.imagePath, fit: BoxFit.cover)
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradient placeholder background
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(project.image ?? ""),
              fit: BoxFit.cover,
            ),
            gradient: LinearGradient(
              colors: [
                project.accentColor.withOpacity(hovered ? 0.3 : 0.15),
                AppColors.surface,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // Geometric decorations
        CustomPaint(
          painter: _CardBannerPainter(
            color: project.accentColor,
            hovered: hovered,
          ),
        ),

        // Large icon centrepiece
        // Center(
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       AnimatedContainer(
        //         duration: const Duration(milliseconds: 300),
        //         padding: const EdgeInsets.all(20),
        //         decoration: BoxDecoration(
        //           color: project.accentColor.withOpacity(hovered ? 0.25 : 0.14),
        //           shape: BoxShape.circle,
        //           border: Border.all(
        //             color: project.accentColor.withOpacity(hovered ? 0.6 : 0.3),
        //             width: 2,
        //           ),
        //           boxShadow: hovered
        //               ? [
        //                   BoxShadow(
        //                     color: project.accentColor.withOpacity(0.4),
        //                     blurRadius: 30,
        //                   ),
        //                 ]
        //               : [],
        //         ),
        //         child: Icon(project.icon, color: project.accentColor, size: 40),
        //       ),
        //       const SizedBox(height: 10),

        //       // Image placeholder tag
        //       // Container(
        //       //   padding: const EdgeInsets.symmetric(
        //       //     horizontal: 10,
        //       //     vertical: 4,
        //       //   ),
        //       //   decoration: BoxDecoration(
        //       //     color: AppColors.surface.withOpacity(0.7),
        //       //     borderRadius: BorderRadius.circular(20),
        //       //     border: Border.all(
        //       //       color: project.accentColor.withOpacity(0.3),
        //       //     ),
        //       //   ),
        //       //   child: Row(
        //       //     mainAxisSize: MainAxisSize.min,
        //       //     children: [
        //       //       Icon(
        //       //         Icons.add_photo_alternate_outlined,
        //       //         size: 12,
        //       //         color: project.accentColor.withOpacity(0.7),
        //       //       ),
        //       //       const SizedBox(width: 4),
        //       //       Text(
        //       //         'Add screenshot',
        //       //         style: GoogleFonts.dmMono(
        //       //           fontSize: 10,
        //       //           color: project.accentColor.withOpacity(0.7),
        //       //         ),
        //       //       ),
        //       //     ],
        //       //   ),
        //       // ),
        //     ],
        //   ),
        // ),

        // Tech stack strip at bottom of banner
        Positioned(
          bottom: 12,
          left: 12,
          right: 12,
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: project.techStack
                .take(4)
                .map(
                  (t) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.8),
                      border: Border.all(
                        color: project.accentColor.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      t,
                      style: GoogleFonts.dmMono(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: project.accentColor,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _CardBannerPainter extends CustomPainter {
  final Color color;
  final bool hovered;
  _CardBannerPainter({required this.color, required this.hovered});

  @override
  void paint(Canvas canvas, Size size) {
    // Decorative circles
    final paint = Paint()
      ..color = color.withOpacity(hovered ? 0.1 : 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.2), 60, paint);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.8), 40, paint);

    paint.color = color.withOpacity(hovered ? 0.06 : 0.03);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.2), 100, paint);

    // Diagonal accent line
    paint
      ..color = color.withOpacity(0.08)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    for (double i = -50; i < size.width + size.height; i += 30) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_CardBannerPainter o) => o.hovered != hovered;
}

// ── BACK FACE ─────────────────────────────────────────────────────────────────
class _BackFace extends StatelessWidget {
  final ProjectModel project;
  final Future<void> Function(String) onLaunch;

  const _BackFace({required this.project, required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.card, project.accentColor.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: project.accentColor.withOpacity(0.5),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: project.accentColor.withOpacity(0.2),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: project.accentColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: project.accentColor.withOpacity(0.4),
                    ),
                  ),
                  child: Icon(
                    project.icon,
                    color: project.accentColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.subtitle,
                        style: GoogleFonts.dmMono(
                          fontSize: 10,
                          color: project.accentColor,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        project.title,
                        style: GoogleFonts.sora(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: project.accentColor.withOpacity(0.2), height: 1),
            const SizedBox(height: 16),

            // Highlights
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KEY HIGHLIGHTS',
                      style: GoogleFonts.dmMono(
                        fontSize: 10,
                        color: project.accentColor,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...project.highlights.map(
                      (h) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: project.accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                h,
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.55,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'TECH STACK',
                      style: GoogleFonts.dmMono(
                        fontSize: 10,
                        color: project.accentColor,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: project.techStack.map((t) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: project.accentColor.withOpacity(0.08),
                            border: Border.all(
                              color: project.accentColor.withOpacity(0.25),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            t,
                            style: GoogleFonts.dmMono(
                              fontSize: 10,
                              color: project.accentColor.withOpacity(0.9),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            // Actions row
            GestureDetector(
              onTap:
                  () {}, // absorbs tap so it doesn't bubble up to flip toggle
              behavior: HitTestBehavior.opaque,
              child: _BackActions(project: project, onLaunch: onLaunch),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackActions extends StatelessWidget {
  final ProjectModel project;
  final Future<void> Function(String) onLaunch;
  const _BackActions({required this.project, required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (project.liveUrl != null)
          Expanded(
            child: _GradientActionBtn(
              icon: Icons.open_in_new_rounded,
              label: 'Live Demo',
              color: project.accentColor,
              onTap: () => onLaunch(project.liveUrl!),
            ),
          ),
        if (project.githubUrl != null) ...[
          if (project.liveUrl != null) const SizedBox(width: 10),
          Expanded(
            child: _OutlinedActionBtn(
              icon: Icons.link_rounded,
              label: 'View Link',
              color: project.accentColor,
              onTap: () => onLaunch(project.githubUrl!),
            ),
          ),
        ],
      ],
    );
  }
}

class _GradientActionBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _GradientActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  @override
  State<_GradientActionBtn> createState() => _GradientActionBtnState();
}

class _GradientActionBtnState extends State<_GradientActionBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.color, widget.color.withBlue(200)],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: _h
                ? [
                    BoxShadow(
                      color: widget.color.withOpacity(0.4),
                      blurRadius: 14,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 14, color: Colors.black87),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: GoogleFonts.sora(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlinedActionBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _OutlinedActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  @override
  State<_OutlinedActionBtn> createState() => _OutlinedActionBtnState();
}

class _OutlinedActionBtnState extends State<_OutlinedActionBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: _h ? widget.color.withOpacity(0.1) : Colors.transparent,
            border: Border.all(
              color: widget.color.withOpacity(_h ? 0.6 : 0.35),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 14,
                color: _h ? widget.color : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: GoogleFonts.sora(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _h ? widget.color : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
