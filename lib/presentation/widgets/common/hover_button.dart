import 'package:flutter/material.dart';
import 'package:ritika_portfolio/core/constants/app_colors.dart';

class HoverButton extends StatefulWidget {
  final String text;

  const HoverButton({super.key, required this.text});

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: hover ? AppColors.accent : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          widget.text,
          style: TextStyle(color: hover ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
