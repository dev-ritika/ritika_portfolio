import 'package:flutter/material.dart';
import 'package:ritika_portfolio/presentation/widgets/sections/about_section.dart';
import 'package:ritika_portfolio/presentation/widgets/sections/experience_section.dart';
import 'package:ritika_portfolio/presentation/widgets/sections/skills_section.dart';
import '../../../../core/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<GlobalKey> _sectionKeys;

  @override
  void initState() {
    super.initState();
    _sectionKeys = List.generate(7, (_) => GlobalKey());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                // About
                SizedBox(
                  key: _sectionKeys[1],
                  child: AboutSection(stats: []),
                ),

                // Skills
                SizedBox(
                  key: _sectionKeys[2],
                  child: SkillsSection(categories: []),
                ),

                // Experience
                SizedBox(
                  key: _sectionKeys[3],
                  child: ExperienceSection(experiences: []),
                ),
              ],
            ),
          ),

          // Sticky NavBar
        ],
      ),
    );
  }
}
