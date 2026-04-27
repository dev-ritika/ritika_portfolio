import 'package:flutter/material.dart';

class SectionWrapper extends StatelessWidget {
  final Widget child;

  const SectionWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1200,
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: child,
    );
  }
}
