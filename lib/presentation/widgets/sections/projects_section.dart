import 'package:flutter/material.dart';
import 'package:ritika_portfolio/presentation/widgets/common/project_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ProjectCard(
          title: "elRed.io Kiosk App",
          description:
              "Self-service kiosk system deployed at Awfis spaces with Clean Architecture and Bloc.",
        ),
        ProjectCard(
          title: "elRed.io B2C App",
          description:
              "High-performance Flutter app with Firebase Auth, FCM & analytics.",
        ),
      ],
    );
  }
}
