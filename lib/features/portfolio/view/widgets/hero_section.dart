import 'dart:math' as math;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'animated_section_wrapper.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onContactTap;
  final VoidCallback onProjectsTap;
  const HeroSection({
    super.key,
    required this.onContactTap,
    required this.onProjectsTap,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _bgCtrl, _floatCtrl, _emojiCtrl;
  late Animation<double> _bgAnim, _floatAnim, _emojiAnim;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _bgAnim = Tween<double>(begin: 0, end: 1).animate(_bgCtrl);
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _emojiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _emojiAnim = Tween<double>(
      begin: -0.15,
      end: 0.15,
    ).animate(CurvedAnimation(parent: _emojiCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _floatCtrl.dispose();
    _emojiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final screenH = MediaQuery.of(context).size.height;
    final hPad = ResponsiveUtils.getHorizontalPadding(context);
    final vPad = ResponsiveUtils.sectionVPadding(context);

    return Stack(
      children: [
        // Backgrounds — Positioned.fill so CustomPaint always has finite bounds
        Positioned.fill(child: IgnorePointer(child: _buildGradientBg())),
        Positioned.fill(child: IgnorePointer(child: _buildAuroraBg())),
        Positioned.fill(child: IgnorePointer(child: _buildGridOverlay())),

        // Content — NON-POSITIONED: drives Stack height, renders on top
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenH),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(hPad, vPad + 60, hPad, vPad + 80),
                child: isMobile
                    ? _buildMobileLayout(context, isTablet)
                    : _buildDesktopLayout(context, isTablet),
              ),
            ],
          ),
        ),

        // Scroll indicator
        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          child: _buildScrollIndicator(),
        ),
      ],
    );
  }

  Widget _buildGradientBg() {
    return AnimatedBuilder(
      animation: _bgAnim,
      builder: (_, __) {
        final v = _bgAnim.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.0 + v * 0.4, -1.0),
              end: Alignment(1.0 - v * 0.2, 1.0),
              colors: [
                const Color(0xFF04050F),
                Color.lerp(
                  const Color(0xFF080B1A),
                  AppColors.secondary,
                  0.14 + v * 0.06,
                )!,
                Color.lerp(
                  const Color(0xFF060D18),
                  AppColors.primary,
                  0.10 + v * 0.05,
                )!,
                Color.lerp(
                  const Color(0xFF0A0618),
                  AppColors.accent,
                  0.08 + v * 0.04,
                )!,
                const Color(0xFF030408),
              ],
              stops: const [0.0, 0.25, 0.55, 0.78, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAuroraBg() {
    return AnimatedBuilder(
      animation: _bgAnim,
      builder: (_, __) => CustomPaint(painter: _HeroBgPainter(_bgAnim.value)),
    );
  }

  Widget _buildGridOverlay() =>
      Opacity(opacity: 0.03, child: CustomPaint(painter: _GridPainter()));

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    final w = MediaQuery.of(context).size.width;
    // On narrow desktop (1024–1200) reduce avatar to avoid overflow
    final avatarSize = isTablet ? 220.0 : (w < 1300 ? 280.0 : 340.0);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 6, child: _buildTextContent(context, isTablet)),
        SizedBox(width: isTablet ? 32 : 60),
        SizedBox(
          width: avatarSize + 80,
          child: _buildAvatarCard(size: avatarSize),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isTablet) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTextContent(context, isTablet, centered: true),
        const SizedBox(height: 40),
        _buildAvatarCard(size: 200),
      ],
    );
  }

  Widget _buildTextContent(
    BuildContext context,
    bool isTablet, {
    bool centered = false,
  }) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final w = MediaQuery.of(context).size.width;
    final align = centered ? TextAlign.center : TextAlign.start;
    final crossA = centered
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    final wrapA = centered ? WrapAlignment.center : WrapAlignment.start;

    // Fluid font sizes
    final nameFontSize = isMobile
        ? 36.0
        : (isTablet ? 48.0 : (w < 1300 ? 60.0 : 72.0));
    final roleFontSize = isMobile ? 18.0 : (isTablet ? 22.0 : 26.0);
    final greetFontSize = isMobile ? 15.0 : (isTablet ? 17.0 : 20.0);

    return Column(
      crossAxisAlignment: crossA,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Status badge
        ScrollAnimatedWidget(
          delay: const Duration(milliseconds: 100),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(20),
              color: AppColors.primary.withOpacity(0.07),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.8),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Available for opportunities',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Greeting + waving emoji
        ScrollAnimatedWidget(
          delay: const Duration(milliseconds: 150),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: centered
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              AnimatedBuilder(
                animation: _emojiAnim,
                builder: (_, __) => Transform.rotate(
                  angle: _emojiAnim.value,
                  child: Text(
                    '👋',
                    style: TextStyle(fontSize: isMobile ? 20 : 26),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [
                      Color(0xFF00D9FF),
                      Color(0xFFA855F7),
                      Color(0xFFEC4899),
                    ],
                  ).createShader(b),
                  child: Text(
                    "Hey there, I'm",
                    style: GoogleFonts.sora(
                      fontSize: greetFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Name with shimmer
        ScrollAnimatedWidget(
          delay: const Duration(milliseconds: 200),
          child: _GlassNameWidget(
            name: AppStrings.name,
            fontSize: nameFontSize,
            textAlign: align,
          ),
        ),
        const SizedBox(height: 10),

        // Animated role
        ScrollAnimatedWidget(
          delay: const Duration(milliseconds: 350),
          child: ShaderMask(
            shaderCallback: (b) => AppColors.heroGradient.createShader(b),
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: AppStrings.animatedRoles
                  .map(
                    (role) => TypewriterAnimatedText(
                      role,
                      textStyle: GoogleFonts.sora(
                        fontSize: roleFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                      speed: const Duration(milliseconds: 60),
                      cursor: '|',
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Description — constrained width
        ScrollAnimatedWidget(
          delay: const Duration(milliseconds: 450),
          child: Text(
            AppStrings.heroDescription,
            textAlign: align,
            style: GoogleFonts.dmSans(
              fontSize: isMobile ? 14 : 15,
              color: AppColors.textSecondary,
              height: 1.75,
            ),
          ),
        ),
        const SizedBox(height: 12),

        ScrollAnimatedWidget(
          delay: const Duration(milliseconds: 500),
          child: Text(
            AppStrings.heroSubtitle,
            textAlign: align,
            style: GoogleFonts.dmMono(
              fontSize: 12,
              color: AppColors.textMuted,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: 36),

        // CTA buttons — Wrap prevents overflow on narrow screens
        ScrollAnimatedWidget(
          delay: const Duration(milliseconds: 600),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: wrapA,
            children: [
              _HeroPrimaryBtn(
                label: 'View Projects',
                onTap: widget.onProjectsTap,
              ),
              _HeroSecondaryBtn(
                label: 'Get In Touch',
                onTap: widget.onContactTap,
              ),
              const _DownloadCvBtn(),
            ],
          ),
        ),
        const SizedBox(height: 36),

        // Tech chips
        ScrollAnimatedWidget(
          delay: const Duration(milliseconds: 700),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: wrapA,
            children: [
              'Flutter 3.x',
              'Dart 3.x',
              'Bloc',
              'Firebase',
              'iOS & Android',
              'Clean Arch',
            ].map((t) => _TechChip(label: t)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarCard({double size = 340}) {
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, _floatAnim.value),
        child: child,
      ),
      child: ScrollAnimatedWidget(
        delay: const Duration(milliseconds: 400),
        slideFrom: const Offset(40, 0),
        child: Center(
          child: _SwirlPhotoFrame(size: size, rotationAnimation: _bgAnim),
        ),
      ),
    );
  }

  Widget _buildScrollIndicator() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Scroll to explore',
          style: GoogleFonts.dmSans(
            fontSize: 11,
            color: AppColors.textMuted,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        const _ScrollIndicatorAnimation(),
      ],
    );
  }
}

// ── Glass name shimmer ─────────────────────────────────────────────────────────
class _GlassNameWidget extends StatefulWidget {
  final String name;
  final double fontSize;
  final TextAlign textAlign;
  const _GlassNameWidget({
    required this.name,
    required this.fontSize,
    this.textAlign = TextAlign.start,
  });

  @override
  State<_GlassNameWidget> createState() => _GlassNameWidgetState();
}

class _GlassNameWidgetState extends State<_GlassNameWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _s;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
    _s = Tween<double>(
      begin: -1.5,
      end: 2.5,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _s,
    builder: (_, __) => ShaderMask(
      shaderCallback: (b) => LinearGradient(
        begin: Alignment(_s.value - 0.8, 0),
        end: Alignment(_s.value + 0.4, 0),
        colors: const [
          Color(0xFFF1F5F9),
          Colors.white,
          Color(0xFF00D9FF),
          Colors.white,
          Color(0xFFF1F5F9),
        ],
        stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
      ).createShader(b),
      child: Text(
        widget.name,
        textAlign: widget.textAlign,
        style: GoogleFonts.sora(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: -2,
          height: 1.05,
          shadows: [
            Shadow(
              color: AppColors.primary.withOpacity(0.45),
              blurRadius: 28,
              offset: const Offset(0, 4),
            ),
            Shadow(
              color: AppColors.secondary.withOpacity(0.25),
              blurRadius: 50,
              offset: const Offset(4, 8),
            ),
          ],
        ),
      ),
    ),
  );
}

// ── Download CV button ─────────────────────────────────────────────────────────
class _DownloadCvBtn extends StatefulWidget {
  const _DownloadCvBtn();

  @override
  State<_DownloadCvBtn> createState() => _DownloadCvBtnState();
}

class _DownloadCvBtnState extends State<_DownloadCvBtn>
    with SingleTickerProviderStateMixin {
  bool _h = false;
  late AnimationController _p;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _p = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 0.97,
      end: 1.03,
    ).animate(CurvedAnimation(parent: _p, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _p.dispose();
    super.dispose();
  }

  Future<void> _download() async {
    final uri = Uri.parse(AppStrings.cvDownloadUrl);
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _pulse,
    builder: (_, __) => Transform.scale(
      scale: _h ? 1.05 : _pulse.value,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: GestureDetector(
          onTap: _download,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _h
                    ? [AppColors.accent, AppColors.secondary]
                    : [
                        AppColors.accent.withOpacity(0.12),
                        AppColors.secondary.withOpacity(0.12),
                      ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _h
                    ? AppColors.accent
                    : AppColors.accent.withOpacity(0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(_h ? 0.45 : 0.12),
                  blurRadius: _h ? 24 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.download_rounded,
                  size: 15,
                  color: _h ? Colors.white : AppColors.accent,
                ),
                const SizedBox(width: 7),
                Text(
                  'Download CV',
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _h ? Colors.white : AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// ── Scroll indicator ───────────────────────────────────────────────────────────
class _ScrollIndicatorAnimation extends StatefulWidget {
  const _ScrollIndicatorAnimation();

  @override
  State<_ScrollIndicatorAnimation> createState() =>
      _ScrollIndicatorAnimationState();
}

class _ScrollIndicatorAnimationState extends State<_ScrollIndicatorAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _a = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _a,
    builder: (_, __) => Container(
      width: 24,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration.zero,
              width: 3,
              height: 8,
              margin: EdgeInsets.only(top: _a.value * 16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.6),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ── Buttons ────────────────────────────────────────────────────────────────────
class _HeroPrimaryBtn extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _HeroPrimaryBtn({required this.label, required this.onTap});

  @override
  State<_HeroPrimaryBtn> createState() => _HeroPrimaryBtnState();
}

class _HeroPrimaryBtnState extends State<_HeroPrimaryBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _h = true),
    onExit: (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(_h ? 0.5 : 0.25),
              blurRadius: _h ? 24 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.translationValues(_h ? 4 : 0, 0, 0),
              child: const Icon(
                Icons.arrow_forward,
                size: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _HeroSecondaryBtn extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _HeroSecondaryBtn({required this.label, required this.onTap});

  @override
  State<_HeroSecondaryBtn> createState() => _HeroSecondaryBtnState();
}

class _HeroSecondaryBtnState extends State<_HeroSecondaryBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _h = true),
    onExit: (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        decoration: BoxDecoration(
          color: _h ? AppColors.border : Colors.transparent,
          border: Border.all(
            color: _h ? AppColors.primary.withOpacity(0.5) : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.mail_outline,
              size: 15,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 7),
            Text(
              widget.label,
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _TechChip extends StatefulWidget {
  final String label;
  const _TechChip({required this.label});

  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _h = true),
    onExit: (_) => setState(() => _h = false),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _h ? AppColors.primary.withOpacity(0.12) : AppColors.surface,
        border: Border.all(
          color: _h ? AppColors.primary.withOpacity(0.4) : AppColors.border,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "label",
        style: GoogleFonts.dmMono(
          fontSize: 11,
          color: _h ? AppColors.primary : AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

// ── Hero BG Painter ───────────────────────────────────────────────────────────
class _HeroBgPainter extends CustomPainter {
  final double progress;
  _HeroBgPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final s = math.sin(progress * math.pi * 2);
    final co = math.cos(progress * math.pi * 2);
    final w = size.width;
    final h = size.height;

    // Aurora bands
    void band(Alignment a, Alignment b, List<Color> c, double blur) {
      final rect = Rect.fromLTWH(0, 0, w, h);
      canvas.drawRect(
        rect,
        Paint()
          ..shader = LinearGradient(
            begin: a,
            end: b,
            colors: c,
          ).createShader(rect)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur),
      );
    }

    band(Alignment(-1 + s * .15, -.8), Alignment(.6 + co * .1, .9), [
      AppColors.secondary.withOpacity(.10 + s * .02),
      Colors.transparent,
      AppColors.primary.withOpacity(.06 + co * .015),
      Colors.transparent,
    ], 60);
    band(Alignment(1 - co * .1, .5), Alignment(-.5 + s * .1, 1.2), [
      Colors.transparent,
      AppColors.accent.withOpacity(.07 + s * .015),
      Colors.transparent,
    ], 80);

    // Nebula orbs
    void orb(double cx, double cy, double r, Color c, double op) {
      final center = Offset(cx * w, cy * h);
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [
              c.withOpacity(op),
              c.withOpacity(op * .3),
              Colors.transparent,
            ],
            stops: const [0, .4, 1],
          ).createShader(Rect.fromCircle(center: center, radius: r))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
      );
    }

    orb(.10 + s * .04, .15 + co * .05, w * .45, AppColors.secondary, .18);
    orb(.88 - co * .04, .55 + s * .05, w * .40, AppColors.primary, .15);
    orb(.50 + s * .03, .88 - co * .04, w * .32, AppColors.accent, .12);
    orb(.20 + co * .03, .72 + s * .03, w * .25, AppColors.primary, .10);
    orb(.78 - s * .03, .08 + co * .04, w * .30, AppColors.secondary, .13);

    // Stars
    final rng = math.Random(42);
    for (int i = 0; i < 80; i++) {
      final sx = rng.nextDouble() * w;
      final sy = rng.nextDouble() * h;
      final sr = rng.nextDouble() * 1.2 + 0.3;
      final twinkle =
          math.sin(progress * math.pi * 2 * (1 + rng.nextDouble()) + i) * .3 +
          .7;
      canvas.drawCircle(
        Offset(sx, sy),
        sr,
        Paint()..color = Colors.white.withOpacity(.45 * twinkle),
      );
    }

    // Floating bubbles (all use percentage-of-width sizing — fully responsive)
    final bubbles = [
      (0.02, 0.08, w * .045, 0.14, 0, AppColors.primary),
      (0.06, 0.28, w * .025, 0.12, 0, AppColors.secondary),
      (0.00, 0.46, w * .018, 0.16, 1, AppColors.accent),
      (0.05, 0.64, w * .035, 0.11, 0, AppColors.primary),
      (0.10, 0.80, w * .024, 0.13, 0, AppColors.secondary),
      (0.03, 0.92, w * .014, 0.17, 3, AppColors.primary),
      (0.08, 0.38, w * .010, 0.22, 2, AppColors.accent),
      (0.13, 0.55, w * .007, 0.24, 2, AppColors.secondary),
      (0.96, 0.06, w * .042, 0.13, 0, AppColors.secondary),
      (0.90, 0.22, w * .030, 0.12, 0, AppColors.primary),
      (0.98, 0.40, w * .020, 0.15, 3, AppColors.accent),
      (0.92, 0.58, w * .036, 0.11, 0, AppColors.secondary),
      (0.86, 0.76, w * .025, 0.13, 0, AppColors.primary),
      (0.95, 0.88, w * .018, 0.16, 3, AppColors.secondary),
      (0.88, 0.42, w * .009, 0.24, 2, AppColors.primary),
      (0.93, 0.65, w * .007, 0.22, 2, AppColors.accent),
      (0.40, 0.03, w * .017, 0.15, 0, AppColors.primary),
      (0.55, 0.05, w * .023, 0.12, 0, AppColors.secondary),
      (0.48, 0.97, w * .016, 0.15, 3, AppColors.accent),
      (0.62, 0.95, w * .020, 0.13, 0, AppColors.primary),
      (0.50, 0.02, w * .009, 0.22, 2, AppColors.accent),
      (0.30, 0.50, w * .005, 0.18, 2, AppColors.primary),
      (0.70, 0.48, w * .005, 0.18, 2, AppColors.secondary),
    ];

    for (final b in bubbles) {
      final (bx, by, br, op, type, col) = b;
      final phase = (bx + by) * math.pi;
      final dy = math.sin(progress * math.pi * 2 + phase) * 14;
      final dx = math.cos(progress * math.pi * 2 + phase) * 7;
      final c = Offset(bx * w + dx, by * h + dy);
      switch (type) {
        case 0:
          canvas.drawCircle(
            c,
            br,
            Paint()
              ..color = col.withOpacity(op)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.2,
          );
          canvas.drawCircle(c, br, Paint()..color = col.withOpacity(op * .10));
        case 1:
          canvas.drawCircle(c, br, Paint()..color = col.withOpacity(op));
        case 2:
          canvas.drawCircle(
            c,
            br * 2.5,
            Paint()
              ..color = col.withOpacity(op * .18)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
          );
          canvas.drawCircle(c, br, Paint()..color = col.withOpacity(op));
        case 3:
          final rect = Rect.fromCircle(center: c, radius: br);
          canvas.drawCircle(
            c,
            br,
            Paint()
              ..shader = RadialGradient(
                colors: [
                  col.withOpacity(op * 1.4),
                  col.withOpacity(op * .3),
                  Colors.transparent,
                ],
              ).createShader(rect),
          );
          canvas.drawCircle(
            c,
            br,
            Paint()
              ..color = col.withOpacity(op * .5)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.0,
          );
        default:
          break;
      }
    }
  }

  @override
  bool shouldRepaint(_HeroBgPainter o) => o.progress != progress;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.primary.withOpacity(.04)
      ..strokeWidth = .5;
    const sp = 60.0;
    for (double x = 0; x < size.width; x += sp)
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    for (double y = 0; y < size.height; y += sp)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    final dp = Paint()..color = AppColors.primary.withOpacity(.07);
    for (double x = 0; x < size.width; x += sp)
      for (double y = 0; y < size.height; y += sp)
        canvas.drawCircle(Offset(x, y), 1.5, dp);
  }

  @override
  bool shouldRepaint(_GridPainter _) => false;
}

// ── Swirl photo frame ──────────────────────────────────────────────────────────
class _SwirlPhotoFrame extends StatefulWidget {
  final double size;
  final Animation<double> rotationAnimation;
  const _SwirlPhotoFrame({required this.size, required this.rotationAnimation});

  @override
  State<_SwirlPhotoFrame> createState() => _SwirlPhotoFrameState();
}

class _SwirlPhotoFrameState extends State<_SwirlPhotoFrame>
    with TickerProviderStateMixin {
  late AnimationController _r1, _r2, _r3, _sparkle, _scale;
  late Animation<double> _scaleAnim;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _r1 = AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat();
    _r2 = AnimationController(vsync: this, duration: const Duration(seconds: 9))
      ..repeat();
    _r3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);
    _sparkle = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _scale = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _scale, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _r1.dispose();
    _r2.dispose();
    _r3.dispose();
    _sparkle.dispose();
    _scale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        _scale.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _scale.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: SizedBox(
          width: s + 80,
          height: s + 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: s + (_hovered ? 90 : 70),
                height: s + (_hovered ? 90 : 70),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(
                        _hovered ? .35 : .18,
                      ),
                      blurRadius: _hovered ? 80 : 50,
                      spreadRadius: _hovered ? 10 : 0,
                    ),
                    BoxShadow(
                      color: AppColors.secondary.withOpacity(
                        _hovered ? .25 : .12,
                      ),
                      blurRadius: _hovered ? 60 : 40,
                      offset: const Offset(20, 20),
                    ),
                  ],
                ),
              ),
              // Rings
              AnimatedBuilder(
                animation: _r3,
                builder: (_, __) => Transform.rotate(
                  angle: _r3.value * math.pi * 2,
                  child: CustomPaint(
                    size: Size(s + 60, s + 60),
                    painter: _DashedRingPainter(
                      radius: (s + 60) / 2 - 4,
                      color: AppColors.secondary.withOpacity(.25),
                      dashCount: 24,
                      strokeWidth: 1.5,
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _r2,
                builder: (_, __) => Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, .001)
                    ..rotateX(.5)
                    ..rotateZ(_r2.value * math.pi * 2),
                  child: CustomPaint(
                    size: Size(s + 30, s + 30),
                    painter: _GlowRingPainter(
                      radius: (s + 30) / 2 - 4,
                      colorA: AppColors.primary,
                      colorB: AppColors.secondary,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _r1,
                builder: (_, __) => Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, .001)
                    ..rotateY(.4)
                    ..rotateZ(-_r1.value * math.pi * 2),
                  child: CustomPaint(
                    size: Size(s + 8, s + 8),
                    painter: _GlowRingPainter(
                      radius: (s + 8) / 2 - 3,
                      colorA: AppColors.accent,
                      colorB: AppColors.primary,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
              // Sparkles
              AnimatedBuilder(
                animation: _sparkle,
                builder: (_, __) => CustomPaint(
                  size: Size(s + 70, s + 70),
                  painter: _OrbitSparklesPainter(
                    progress: _sparkle.value,
                    radius: (s + 70) / 2 - 6,
                    primaryColor: AppColors.primary,
                    accentColor: AppColors.secondary,
                  ),
                ),
              ),
              // Photo circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: s,
                height: s,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A2236), Color(0xFF0D1117)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(_hovered ? .5 : .2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(_hovered ? .2 : .08),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(.08),
                              AppColors.secondary.withOpacity(.06),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: s * .4,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(.06),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_rounded,
                            size: s * .35,
                            color: AppColors.primary.withOpacity(.3),
                          ),
                          const SizedBox(height: 8),
                          ShaderMask(
                            shaderCallback: (b) =>
                                AppColors.heroGradient.createShader(b),
                            child: Text(
                              'RS',
                              style: GoogleFonts.sora(
                                fontSize: s * .18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Add photo →',
                            style: GoogleFonts.dmMono(
                              fontSize: 11,
                              color: AppColors.textMuted,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Floating badges — hidden on very small sizes
              if (s >= 200) ..._buildFloatingBadges(s),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFloatingBadges(double s) {
    final badges = [
      ('Flutter', AppColors.primary, -math.pi / 4),
      ('Dart', AppColors.secondary, math.pi / 4),
      ('Firebase', AppColors.skillFirebase, 3 * math.pi / 4),
      ('BLoC', AppColors.accent, -3 * math.pi / 4),
    ];
    return badges.map((b) {
      final (label, color, angle) = b;
      final orbR = s / 2 + 36;
      final dx = math.cos(angle) * orbR;
      final dy = math.sin(angle) * orbR;
      return AnimatedBuilder(
        animation: _r1,
        builder: (_, child) => Transform.translate(
          offset: Offset(
            dx,
            dy + math.sin(_r1.value * math.pi * 2 + angle) * 4,
          ),
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(_hovered ? .2 : .12),
            border: Border.all(color: color.withOpacity(_hovered ? .6 : .35)),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(_hovered ? .3 : .1),
                blurRadius: 10,
              ),
            ],
          ),
          child: Text(
            label,
            style: GoogleFonts.dmMono(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.w600,
              letterSpacing: .5,
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _DashedRingPainter extends CustomPainter {
  final double radius, strokeWidth;
  final Color color;
  final int dashCount;
  const _DashedRingPainter({
    required this.radius,
    required this.color,
    required this.dashCount,
    required this.strokeWidth,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final step = (math.pi * 2) / dashCount;
    for (int i = 0; i < dashCount; i++) {
      final st = i * step;
      final en = st + .08;
      canvas.drawPath(
        Path()
          ..moveTo(cx + radius * math.cos(st), cy + radius * math.sin(st))
          ..lineTo(cx + radius * math.cos(en), cy + radius * math.sin(en)),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedRingPainter _) => false;
}

class _GlowRingPainter extends CustomPainter {
  final double radius, strokeWidth;
  final Color colorA, colorB;
  const _GlowRingPainter({
    required this.radius,
    required this.colorA,
    required this.colorB,
    required this.strokeWidth,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);
    canvas.drawCircle(
      Offset(cx, cy),
      radius,
      Paint()
        ..shader = SweepGradient(
          colors: [colorA, colorB, colorA.withOpacity(.3), colorB, colorA],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
  }

  @override
  bool shouldRepaint(_GlowRingPainter _) => false;
}

class _OrbitSparklesPainter extends CustomPainter {
  final double progress, radius;
  final Color primaryColor, accentColor;
  const _OrbitSparklesPainter({
    required this.progress,
    required this.radius,
    required this.primaryColor,
    required this.accentColor,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final sp = [
      (0.0, primaryColor, 4.0),
      (math.pi * .4, accentColor, 3.0),
      (math.pi * .8, primaryColor, 2.5),
      (math.pi * 1.2, accentColor, 3.5),
      (math.pi * 1.6, primaryColor, 2.0),
      (math.pi * .2, accentColor, 2.0),
      (math.pi * 1.0, primaryColor, 2.5),
    ];
    for (final (base, color, r) in sp) {
      final angle = base + progress * math.pi * 2;
      final x = cx + radius * math.cos(angle);
      final y = cy + radius * math.sin(angle);
      canvas.drawCircle(
        Offset(x, y),
        r * 2,
        Paint()
          ..color = color.withOpacity(.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      canvas.drawCircle(Offset(x, y), r, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_OrbitSparklesPainter o) => o.progress != progress;
}
