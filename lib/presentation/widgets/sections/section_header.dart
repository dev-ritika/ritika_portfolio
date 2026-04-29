import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';

class SectionHeader extends StatelessWidget {
  final String label;
  final String title;
  final String subtitle;
  final CrossAxisAlignment alignment;

  const SectionHeader({
    super.key,
    required this.label,
    required this.title,
    required this.subtitle,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isCenter = alignment == CrossAxisAlignment.center;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          textAlign: isCenter ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.dmMono(
            fontSize: 12,
            color: AppColors.primary,
            letterSpacing: 2.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        ShaderMask(
          shaderCallback: (bounds) => AppColors.heroGradient.createShader(bounds),
          child: Text(
            title,
            textAlign: isCenter ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.sora(
              fontSize: isMobile ? 30 : 44,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1.2,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          subtitle,
          textAlign: isCenter ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.dmSans(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 56,
          height: 3,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
