import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SkillCategory {
  final String title;
  final Color color;
  final IconData icon;
  final List<String> skills;

  const SkillCategory({
    required this.title,
    required this.color,
    required this.icon,
    required this.skills,
  });
}

class ExperienceModel {
  final String role;
  final String company;
  final String period;
  final String location;
  final String type; // Full-time, Part-time, Intern
  final List<String> highlights;
  final List<String> techStack;
  final bool isCurrent;

  const ExperienceModel({
    required this.role,
    required this.company,
    required this.period,
    required this.location,
    required this.type,
    required this.highlights,
    required this.techStack,
    this.isCurrent = false,
  });
}

class ProjectModel {
  final String title;
  final String subtitle;
  final String description;
  final List<String> techStack;
  final List<String> highlights;
  final String? githubUrl;
  final String? liveUrl;
  final Color accentColor;
  final IconData icon;

  const ProjectModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.techStack,
    required this.highlights,
    this.githubUrl,
    this.liveUrl,
    required this.accentColor,
    required this.icon,
  });
}

class StatModel {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const StatModel({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });
}

class CertificationModel {
  final String title;
  final String description;

  const CertificationModel({
    required this.title,
    required this.description,
  });
}
