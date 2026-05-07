import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Full-page subtle background — dots grid + noise shimmer + floating blobs.
/// Wrap the entire Scaffold body with this.
class PageBackground extends StatefulWidget {
  final Widget child;
  const PageBackground({super.key, required this.child});

  @override
  State<PageBackground> createState() => _PageBackgroundState();
}

class _PageBackgroundState extends State<PageBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base background colour
        Container(color: AppColors.background),
        // Dot grid pattern
        CustomPaint(
          painter: _DotGridPainter(),
          size: Size.infinite,
        ),
        // Slow-moving gradient blobs
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => CustomPaint(
            painter: _BlobPainter(_ctrl.value),
            size: Size.infinite,
          ),
        ),
        // Diagonal scan line texture
        CustomPaint(
          painter: _ScanLinePainter(),
          size: Size.infinite,
        ),
        widget.child,
      ],
    );
  }
}

// ── Dot grid ──────────────────────────────────────────────────────────────────
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.07)
      ..style = PaintingStyle.fill;

    const spacing = 36.0;
    const r = 1.2;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // Slight brightness pulse based on distance from centre
        final dist = math.sqrt(math.pow(x - size.width / 2, 2) +
            math.pow(y - size.height / 2, 2));
        final fade = (1 - (dist / (size.width * 0.9)).clamp(0, 1));
        paint.color =
            AppColors.primary.withOpacity(0.035 + fade * 0.04);
        canvas.drawCircle(Offset(x, y), r, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter _) => false;
}

// ── Blobs ─────────────────────────────────────────────────────────────────────
class _BlobPainter extends CustomPainter {
  final double t;
  _BlobPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    void blob(double cx, double cy, double r, Color c) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [c, Colors.transparent],
        ).createShader(Rect.fromCircle(
            center: Offset(cx * size.width, cy * size.height), radius: r));
      canvas.drawCircle(
          Offset(cx * size.width, cy * size.height), r, paint);
    }

    final s1 = math.sin(t * math.pi * 2);
    final c1 = math.cos(t * math.pi * 2);

    blob(0.1 + s1 * 0.06, 0.15 + c1 * 0.05, size.width * 0.28,
        AppColors.primary.withOpacity(0.055));
    blob(0.88 - c1 * 0.05, 0.25 + s1 * 0.04, size.width * 0.22,
        AppColors.secondary.withOpacity(0.045));
    blob(0.5 + s1 * 0.04, 0.72 - c1 * 0.06, size.width * 0.26,
        AppColors.accent.withOpacity(0.035));
    blob(0.2 - s1 * 0.03, 0.55 + c1 * 0.04, size.width * 0.18,
        AppColors.primary.withOpacity(0.03));
    blob(0.75 + c1 * 0.04, 0.8 + s1 * 0.03, size.width * 0.2,
        AppColors.secondary.withOpacity(0.04));
  }

  @override
  bool shouldRepaint(_BlobPainter old) => old.t != t;
}

// ── Diagonal scan lines ────────────────────────────────────────────────────────
class _ScanLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.012)
      ..strokeWidth = 1;

    const gap = 80.0;
    for (double i = -size.height; i < size.width + size.height; i += gap) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_ScanLinePainter _) => false;
}
