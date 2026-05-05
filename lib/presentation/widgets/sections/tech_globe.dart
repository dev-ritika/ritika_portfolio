import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

// ══════════════════════════════════════════════════════════════════════════════
// Animated 3-D Tech Globe
// ══════════════════════════════════════════════════════════════════════════════

class TechGlobe extends StatefulWidget {
  const TechGlobe({super.key});

  @override
  State<TechGlobe> createState() => _TechGlobeState();
}

class _TechGlobeState extends State<TechGlobe>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final List<_TechNode> _nodes = [];
  int _hoveredIndex = -1;

  static const _techs = [
    ('Flutter', AppColors.primary),
    ('Dart', AppColors.secondary),
    ('Firebase', Color(0xFFFF6B2B)),
    ('BLoC', AppColors.accent),
    ('Provider', Color(0xFF10B981)),
    ('Riverpod', Color(0xFF6366F1)),
    ('Clean Arch', AppColors.primary),
    ('MVVM', AppColors.secondary),
    ('REST APIs', Color(0xFF14B8A6)),
    ('Git', Color(0xFFF59E0B)),
    ('GitHub Actions', AppColors.accent),
    ('CI/CD', Color(0xFF10B981)),
    ('Sentry', Color(0xFF6366F1)),
    ('Firestore', Color(0xFFFF6B2B)),
    ('Unit Testing', AppColors.primary),
    ('Postman', Color(0xFFF97316)),
    ('React JS', Color(0xFF06B6D4)),
    ('SQL', Color(0xFF8B5CF6)),
    ('iOS SDK', AppColors.secondary),
    ('Android SDK', Color(0xFF10B981)),
    ('WebSockets', AppColors.primary),
    ('Crashlytics', Color(0xFFF59E0B)),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    // Distribute nodes on sphere surface using Fibonacci spiral
    final n = _techs.length;
    final golden = math.pi * (3 - math.sqrt(5));
    for (int i = 0; i < n; i++) {
      final y = 1 - (i / (n - 1)) * 2;
      final r = math.sqrt(1 - y * y);
      final theta = golden * i;
      _nodes.add(_TechNode(
        theta: theta,
        phi: math.asin(y),
        label: _techs[i].$1,
        color: _techs[i].$2,
      ));
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final globeSize = isMobile ? 300.0 : 420.0;

    return Column(
      children: [
        // Globe
        SizedBox(
          width: globeSize,
          height: globeSize,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) {
              final rot = _ctrl.value * math.pi * 2;
              // Project all nodes
              final projected = _nodes.asMap().entries.map((e) {
                final i = e.key;
                final node = e.value;
                // Rotate around Y axis
                final x3d = math.cos(node.theta + rot) *
                    math.cos(node.phi);
                final y3d = math.sin(node.phi);
                final z3d = math.sin(node.theta + rot) *
                    math.cos(node.phi);
                // Perspective project
                final scale = globeSize / 2;
                final fov = 2.0;
                final pz = z3d + fov;
                final px = (x3d / pz) * scale + globeSize / 2;
                final py = (-y3d / pz) * scale + globeSize / 2;
                // Depth for opacity / size
                final depth = (z3d + 1) / 2; // 0 = back, 1 = front
                return _ProjectedNode(
                  index: i,
                  x: px,
                  y: py,
                  depth: depth,
                  node: node,
                );
              }).toList()
                ..sort((a, b) => a.depth.compareTo(b.depth));

              return Stack(
                children: [
                  // Globe wireframe
                  CustomPaint(
                    size: Size(globeSize, globeSize),
                    painter: _GlobeWireframePainter(rot),
                  ),
                  // Nodes
                  ...projected.map((p) {
                    final isHovered = _hoveredIndex == p.index;
                    final nodeSize = 6.0 + p.depth * 10 +
                        (isHovered ? 8 : 0);
                    final opacity = 0.3 + p.depth * 0.7;

                    return Positioned(
                      left: p.x - nodeSize / 2,
                      top: p.y - nodeSize / 2,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) =>
                            setState(() => _hoveredIndex = p.index),
                        onExit: (_) =>
                            setState(() => _hoveredIndex = -1),
                        child: GestureDetector(
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 200),
                            width: nodeSize,
                            height: nodeSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: p.node.color
                                  .withOpacity(opacity * 0.9),
                              boxShadow: [
                                BoxShadow(
                                  color: p.node.color.withOpacity(
                                      opacity * 0.5),
                                  blurRadius:
                                      isHovered ? 16 : 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  // Label for hovered / front nodes
                  ...projected
                      .where((p) =>
                          p.depth > 0.72 ||
                          _hoveredIndex == p.index)
                      .map((p) {
                    final isHovered = _hoveredIndex == p.index;
                    return Positioned(
                      left: p.x + 10,
                      top: p.y - 10,
                      child: IgnorePointer(
                        child: AnimatedOpacity(
                          duration:
                              const Duration(milliseconds: 200),
                          opacity: isHovered
                              ? 1.0
                              : (p.depth - 0.72) / 0.28,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isHovered
                                  ? p.node.color.withOpacity(0.2)
                                  : AppColors.surface
                                      .withOpacity(0.85),
                              border: Border.all(
                                color: p.node.color
                                    .withOpacity(0.5),
                              ),
                              borderRadius:
                                  BorderRadius.circular(20),
                              boxShadow: isHovered
                                  ? [
                                      BoxShadow(
                                        color: p.node.color
                                            .withOpacity(0.3),
                                        blurRadius: 10,
                                      )
                                    ]
                                  : [],
                            ),
                            child: Text(
                              p.node.label,
                              style: GoogleFonts.dmMono(
                                fontSize: 10,
                                color: isHovered
                                    ? p.node.color
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 16),
        Text(
          'Hover the globe — 22+ technologies',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _TechNode {
  final double theta;
  final double phi;
  final String label;
  final Color color;
  _TechNode({
    required this.theta,
    required this.phi,
    required this.label,
    required this.color,
  });
}

class _ProjectedNode {
  final int index;
  final double x, y, depth;
  final _TechNode node;
  _ProjectedNode({
    required this.index,
    required this.x,
    required this.y,
    required this.depth,
    required this.node,
  });
}

class _GlobeWireframePainter extends CustomPainter {
  final double rotation;
  _GlobeWireframePainter(this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 10;

    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Latitude lines
    for (int i = 1; i < 6; i++) {
      final phi = (i / 6) * math.pi - math.pi / 2;
      final yr = r * math.cos(phi);
      final yOffset = -r * math.sin(phi);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, cy + yOffset),
          width: yr * 2,
          height: yr * 0.4,
        ),
        paint,
      );
    }

    // Longitude lines (rotating)
    for (int i = 0; i < 8; i++) {
      final theta = (i / 8) * math.pi * 2 + rotation;
      final path = Path();
      for (int j = 0; j <= 60; j++) {
        final phi = (j / 60) * math.pi * 2 - math.pi;
        final x3 = math.cos(theta) * math.cos(phi);
        final y3 = math.sin(phi);
        final z3 = math.sin(theta) * math.cos(phi);
        final fov = 2.0;
        final pz = z3 + fov;
        final px = (x3 / pz) * r + cx;
        final py = (-y3 / pz) * r + cy;
        final opacity = (z3 + 1) / 2;
        if (j == 0) {
          path.moveTo(px, py);
        } else {
          path.lineTo(px, py);
        }
      }
      canvas.drawPath(path, paint);
    }

    // Equator highlight
    final eqPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: r * 2,
        height: r * 0.4,
      ),
      eqPaint,
    );

    // Outer glow ring
    final glowPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(cx, cy), r, glowPaint);

    // Crisp outer circle
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      paint..color = AppColors.primary.withOpacity(0.12),
    );
  }

  @override
  bool shouldRepaint(_GlobeWireframePainter o) =>
      o.rotation != rotation;
}
