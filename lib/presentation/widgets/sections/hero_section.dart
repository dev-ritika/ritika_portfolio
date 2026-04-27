import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ritika_portfolio/core/responsive/responsive.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/responsive/responsive.dart';
import '../common/hover_button.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile ? _mobileLayout() : _desktopLayout(),
        ),
      ),
    );
  }

  // ================= DESKTOP =================
  Widget _desktopLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 6, child: _leftContent()),
        const SizedBox(width: 40),
        Expanded(flex: 5, child: _rightImage()),
      ],
    );
  }

  // ================= MOBILE =================
  Widget _mobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _leftContent(center: true),
        const SizedBox(height: 40),
        _rightImage(),
      ],
    );
  }

  // ================= LEFT CONTENT =================
  Widget _leftContent({bool center = false}) {
    return Column(
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 👋 Small intro
        Text(
          "Hi, I'm",
          style: TextStyle(fontSize: 18, color: AppColors.secondary),
        ),

        const SizedBox(height: 12),

        // 🔥 BIG NAME (main hero text)
        Text(
          "Ritika Sharma",
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w700,
            height: 1.1,
            letterSpacing: -1.5,
          ),
        ),

        const SizedBox(height: 16),

        // 💼 Subtitle
        Text(
          "Senior Flutter Developer\nBuilding scalable cross-platform apps",
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: const TextStyle(fontSize: 18, height: 1.6, color: Colors.grey),
        ),

        const SizedBox(height: 32),

        // 🎯 CTA Buttons
        Wrap(
          alignment: center ? WrapAlignment.center : WrapAlignment.start,
          spacing: 16,
          children: [
            HoverButton(text: "View Projects"),
            _outlineButton("Contact Me"),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, duration: 600.ms);
  }

  // ================= RIGHT IMAGE =================
  Widget _rightImage() {
    return Align(
      alignment: Alignment.center,
      child: Image.asset(
        "assets/images/profile.png",
        width: 380,
      ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8)),
    );
  }

  // ================= OUTLINE BUTTON =================
  Widget _outlineButton(String text) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool hover = false;

        return MouseRegion(
          onEnter: (_) => setState(() => hover = true),
          onExit: (_) => setState(() => hover = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: hover ? Colors.white : Colors.white24),
            ),
            child: Text(
              text,
              style: TextStyle(color: hover ? Colors.white : Colors.white70),
            ),
          ),
        );
      },
    );
  }
}
