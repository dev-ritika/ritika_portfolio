import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'section_background.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final hPad = ResponsiveUtils.getHorizontalPadding(context);
    final isMobile = ResponsiveUtils.isMobile(context);

    return SectionBackground(
      style: SectionBgStyle.surface,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 40),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: isMobile ? _buildMobile() : _buildDesktop(),
      ),
    );
  }

  Widget _buildDesktop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBranding(),
        _buildSocials(),
        _buildCopy(),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      children: [
        _buildBranding(),
        const SizedBox(height: 20),
        _buildSocials(),
        const SizedBox(height: 16),
        _buildCopy(),
      ],
    );
  }

  Widget _buildBranding() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
          child: Text(
            'RS',
            style: GoogleFonts.sora(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.footerSub,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildSocials() {
    final socials = [
      (Icons.code, 'GitHub', AppStrings.githubUrl),
      (Icons.mail_outline, 'Email', 'mailto:${AppStrings.email}'),
      (Icons.phone_outlined, 'Phone', 'tel:${AppStrings.phone}'),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: socials
          .map((s) => _SocialIconBtn(icon: s.$1, tooltip: s.$2, url: s.$3))
          .toList(),
    );
  }

  Widget _buildCopy() {
    return Text(
      AppStrings.footerText,
      style: GoogleFonts.dmSans(
        fontSize: 12,
        color: AppColors.textMuted,
      ),
    );
  }
}

class _SocialIconBtn extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final String url;

  const _SocialIconBtn({required this.icon, required this.tooltip, required this.url});

  @override
  State<_SocialIconBtn> createState() => _SocialIconBtnState();
}

class _SocialIconBtnState extends State<_SocialIconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _hovered ? AppColors.primary.withOpacity(0.15) : AppColors.card,
              shape: BoxShape.circle,
              border: Border.all(
                color: _hovered ? AppColors.primary.withOpacity(0.5) : AppColors.border,
              ),
            ),
            child: Icon(
              widget.icon,
              size: 16,
              color: _hovered ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
