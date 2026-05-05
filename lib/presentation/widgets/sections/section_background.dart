import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Reusable gradient + animated-bubbles background for every section.
/// Intentionally DARKER than the hero so the hero stands out clearly.
class SectionBackground extends StatefulWidget {
  final Widget child;
  final SectionBgStyle style;

  const SectionBackground({
    super.key,
    required this.child,
    this.style = SectionBgStyle.dark,
  });

  @override
  State<SectionBackground> createState() => _SectionBackgroundState();
}

enum SectionBgStyle { dark, surface, accent }

class _SectionBackgroundState extends State<SectionBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // Very dark bases — noticeably darker than the hero
  Color get _baseColor => switch (widget.style) {
        SectionBgStyle.dark    => const Color(0xFF020406), // near-black
        SectionBgStyle.surface => const Color(0xFF05080E), // slightly less dark
        SectionBgStyle.accent  => const Color(0xFF030508), // deepest dark
      };

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient — Positioned.fill so CustomPaint always has finite bounds
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _baseColor,
                  Color.lerp(_baseColor, AppColors.primary,   0.025)!,
                  Color.lerp(_baseColor, AppColors.secondary, 0.020)!,
                  _baseColor,
                ],
                stops: const [0.0, 0.35, 0.70, 1.0],
              ),
            ),
          ),
        ),

        // Animated subtle bubbles
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => CustomPaint(
              painter: _SectionBubblePainter(_ctrl.value),
            ),
          ),
        ),

        // Content on top
        widget.child,
      ],
    );
  }
}

// ── Bubble painter — kept intentionally dim / muted ────────────────────────────
class _SectionBubblePainter extends CustomPainter {
  final double t;
  _SectionBubblePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final s1 = math.sin(t * math.pi * 2);
    final c1 = math.cos(t * math.pi * 2);

    // Very faint glow orbs — lower opacity than hero
    void glowOrb(double cx, double cy, double r, Color col) {
      final center = Offset(cx * size.width, cy * size.height);
      canvas.drawCircle(
        center, r,
        Paint()
          ..shader = RadialGradient(colors: [col, Colors.transparent])
              .createShader(Rect.fromCircle(center: center, radius: r)),
      );
    }

    glowOrb(0.05 + s1 * 0.03, 0.20 + c1 * 0.04, size.width * 0.22, AppColors.primary.withOpacity(0.030));
    glowOrb(0.92 - c1 * 0.04, 0.50 + s1 * 0.05, size.width * 0.18, AppColors.secondary.withOpacity(0.025));
    glowOrb(0.50 + s1 * 0.03, 0.85 - c1 * 0.04, size.width * 0.16, AppColors.accent.withOpacity(0.020));
    glowOrb(0.28 + c1 * 0.03, 0.65 + s1 * 0.03, size.width * 0.12, AppColors.primary.withOpacity(0.018));
    glowOrb(0.72 - s1 * 0.03, 0.15 + c1 * 0.03, size.width * 0.14, AppColors.secondary.withOpacity(0.022));

    // Bubbles — very low opacity to keep sections dark
    const bubbles = [
      // LEFT
      (0.02, 0.10, 45.0, 0.07, 0),
      (0.06, 0.38, 28.0, 0.06, 0),
      (0.00, 0.62, 20.0, 0.08, 1),
      (0.08, 0.82, 35.0, 0.05, 0),
      (0.03, 0.50, 12.0, 0.12, 2),
      (0.12, 0.22,  8.0, 0.13, 2),
      (0.04, 0.72,  6.0, 0.10, 1),
      // RIGHT
      (0.95, 0.08, 50.0, 0.06, 0),
      (0.90, 0.35, 30.0, 0.06, 3),
      (0.97, 0.55, 22.0, 0.07, 0),
      (0.88, 0.72, 40.0, 0.05, 0),
      (0.93, 0.88, 15.0, 0.09, 2),
      (0.85, 0.18,  9.0, 0.11, 1),
      (0.98, 0.42,  7.0, 0.10, 2),
      // CENTER
      (0.42, 0.05, 18.0, 0.08, 0),
      (0.58, 0.08, 25.0, 0.06, 3),
      (0.35, 0.92, 22.0, 0.07, 0),
      (0.65, 0.90, 17.0, 0.08, 1),
      (0.50, 0.96, 10.0, 0.10, 2),
      (0.45, 0.15,  7.0, 0.12, 2),
      (0.55, 0.85,  8.0, 0.11, 1),
    ];

    final colors = [
      AppColors.primary, AppColors.secondary, AppColors.accent,
      AppColors.primary, AppColors.secondary, AppColors.primary, AppColors.accent,
      AppColors.secondary, AppColors.primary, AppColors.accent,
      AppColors.primary, AppColors.secondary, AppColors.primary, AppColors.accent,
      AppColors.primary, AppColors.secondary, AppColors.accent,
      AppColors.primary, AppColors.secondary, AppColors.primary, AppColors.accent,
    ];

    for (int i = 0; i < bubbles.length; i++) {
      final (bx, by, br, op, type) = bubbles[i];
      final col = colors[i % colors.length];
      final phase = (bx + by) * math.pi;
      final dy = math.sin(t * math.pi * 2 + phase) * 8;
      final dx = math.cos(t * math.pi * 2 + phase) * 4;
      final center = Offset(bx * size.width + dx, by * size.height + dy);

      switch (type) {
        case 0:
          canvas.drawCircle(center, br, Paint()
            ..color = col.withOpacity(op)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0);
          canvas.drawCircle(center, br, Paint()..color = col.withOpacity(op * 0.07));
        case 1:
          canvas.drawCircle(center, br, Paint()..color = col.withOpacity(op));
        case 2:
          canvas.drawCircle(center, br * 2.2, Paint()
            ..color = col.withOpacity(op * 0.15)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
          canvas.drawCircle(center, br, Paint()..color = col.withOpacity(op * 0.8));
        case 3:
          final rect = Rect.fromCircle(center: center, radius: br);
          canvas.drawCircle(center, br, Paint()
            ..shader = RadialGradient(colors: [
              col.withOpacity(op * 1.2),
              col.withOpacity(op * 0.2),
              Colors.transparent,
            ]).createShader(rect));
        default:
          break;
      }
    }
  }

  @override
  bool shouldRepaint(_SectionBubblePainter o) => o.t != t;
}
