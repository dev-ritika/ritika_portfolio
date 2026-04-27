import 'package:flutter/material.dart';
import 'package:ritika_portfolio/core/utils/scroll_controller.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/scroll_controller.dart';
import '../../blocs/portfolio_cubit.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 24,
      left: 0,
      right: 0,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: 900,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_logo(), _navItems(context)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= LOGO =================
  Widget _logo() {
    return const Text(
      "Ritika",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
    );
  }

  // ================= NAV ITEMS =================
  Widget _navItems(BuildContext context) {
    final items = [
      ("Home", 0),
      ("About", 700),
      ("Projects", 1400),
      ("Experience", 2000),
      ("Contact", 2600),
    ];

    return BlocBuilder<PortfolioCubit, PortfolioState>(
      builder: (context, activeIndex) {
        return Row(
          children: List.generate(items.length, (index) {
            final item = items[index];

            return _NavItem(
              title: item.$1,
              isActive: activeIndex.index == index,
              onTap: () {
                context.read<PortfolioCubit>().changeSection(index);
                ScrollService.scrollTo(item.$2.toDouble());
              },
            );
          }),
        );
      },
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive
        ? Colors.white
        : hover
        ? Colors.white
        : Colors.white70;

    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.title, style: TextStyle(fontSize: 14, color: color)),

              const SizedBox(height: 6),

              // underline animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 2,
                width: widget.isActive || hover ? 20 : 0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
