import 'package:flutter/material.dart';
import '../common/section_wrapper.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: const Text(
        "Senior Flutter Developer with 3.8+ years of experience in Flutter & 6+ years in SDLC. "
        "Expert in Clean Architecture, Bloc, Firebase, and scalable mobile systems.",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
