import 'package:flutter/material.dart';
import 'package:ritika_portfolio/presentation/widgets/sections/hero_section.dart';
import 'package:ritika_portfolio/presentation/widgets/sections/about_section.dart';
import 'package:ritika_portfolio/presentation/widgets/sections/skills_section.dart';
import 'package:ritika_portfolio/presentation/widgets/sections/projects_section.dart';
import 'package:ritika_portfolio/presentation/widgets/sections/experience_section.dart';
import 'package:ritika_portfolio/presentation/widgets/sections/contact_section.dart';
import 'package:ritika_portfolio/presentation/widgets/navbar/navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: const [
                HeroSection(),

                AboutSection(),
                SkillsSection(),
                ProjectsSection(),
                ExperienceSection(),
                ContactSection(),
              ],
            ),
          ),
          const Navbar(),
        ],
      ),
    );
  }
}
