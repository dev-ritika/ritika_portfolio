import 'package:flutter/material.dart';
import '../models/portfolio_models.dart';
import '../../core/constants/app_colors.dart';

class PortfolioRepository {
  static List<SkillCategory> getSkillCategories() {
    return const [
      SkillCategory(
        title: 'Core Flutter & Dart',
        color: AppColors.skillCore,
        icon: Icons.phone_android,
        skills: [
          'Flutter 3.x',
          'Dart 3.x',
          'iOS Development',
          'Android Development',
          'Cross-Platform',
          'Android SDK',
          'iOS SDK',
          'Flutter Web',
          'Modular Architecture',
        ],
      ),
      SkillCategory(
        title: 'Architecture & Patterns',
        color: AppColors.skillState,
        icon: Icons.architecture,
        skills: [
          'Clean Architecture',
          'MVVM',
          'MVC',
          'Design Patterns',
          'Scalable Systems',
          'SDLC',
          'Agile / Scrum',
        ],
      ),
      SkillCategory(
        title: 'State Management',
        color: Color(0xFFA855F7),
        icon: Icons.tune,
        skills: ['Bloc', 'Provider', 'Async Programming'],
      ),
      SkillCategory(
        title: 'Firebase & Cloud',
        color: AppColors.skillFirebase,
        icon: Icons.cloud,
        skills: [
          'Firebase Auth',
          'Firestore',
          'Cloud Messaging',
          'Push Notifications',
          'Analytics',
          'Remote Config',
          'Crashlytics',
        ],
      ),
      SkillCategory(
        title: 'Backend & APIs',
        color: AppColors.skillBackend,
        icon: Icons.api,
        skills: [
          'RESTful APIs',
          'JSON',
          'WebSockets',
          'React JS',
          'JavaScript',
          'HTML / CSS',
          'SQL',
          'Third-Party SDKs',
        ],
      ),
      SkillCategory(
        title: 'Testing & Quality',
        color: AppColors.skillTesting,
        icon: Icons.bug_report,
        skills: [
          'Unit Testing',
          'Widget Testing',
          'Integration Testing',
          'Flutter DevTools',
          'Linting',
          'Code Review',
          'Sentry',
        ],
      ),
      SkillCategory(
        title: 'DevOps & Tools',
        color: AppColors.skillDevOps,
        icon: Icons.settings,
        skills: [
          'Git',
          'GitHub Actions',
          'CI/CD Pipelines',
          'Bash Scripting',
          'Postman',
          'Play Store Deploy',
          'App Store Deploy',
        ],
      ),
    ];
  }

  static List<ExperienceModel> getExperiences() {
    return const [
      ExperienceModel(
        role: 'Senior Flutter Developer',
        company: 'REX-TONE DIGITAL Pvt Ltd',
        period: 'Aug 2022 – Present',
        location: 'Mumbai, India',
        type: 'Associate Manager, Flutter Team',
        isCurrent: true,
        techStack: [
          'Flutter',
          'Dart',
          'Bloc',
          'Firebase',
          'Clean Architecture',
          'GitHub Actions',
          'Sentry',
        ],
        highlights: [
          'Spearheaded end-to-end architecture of 3 production apps: B2C live app, Kiosk system & internal tooling platform',
          'Slashed app load time by 35% and cut memory footprint by 25% via Flutter DevTools profiling',
          'Engineered modular Clean Architecture with reusable widget libraries — compressed feature delivery by 30%',
          'Delivered full Firebase integration: Auth, Firestore, Cloud Messaging & Analytics',
          'Drove 4x code reuse across applications through shared core modules and component libraries',
          'Mentored 4 junior developers through weekly code reviews, pair programming & technical workshops',
          'Recovered 100% of manual release effort via Bash automation scripts and CI/CD pipelines',
          'Raised codebase maintainability with linting rules, Sentry monitoring & test coverage',
        ],
      ),
      ExperienceModel(
        role: 'Instructor, App Development (Flutterflow)',
        company: 'Whitehat Education Technology Pvt. Ltd.',
        period: 'May 2020 – Jul 2022',
        location: 'Mumbai, India',
        type: 'Full-time Educator',
        techStack: [
          'FlutterFlow',
          'Flutter',
          'Mobile Development',
          'Curriculum Design',
        ],
        highlights: [
          'Drove 99%+ project completion rate across a cohort of 100+ students',
          'Designed outcome-focused mobile development curriculum spanning architecture through deployment',
          'Generated 50+ functional mobile apps by guiding students through real-world project cycles',
          'Enabled beginners to build apps up to 3x faster using FlutterFlow\'s visual environment',
          'Boosted student assessment scores by up to 30% within a 3-month cycle via personalized pacing',
        ],
      ),
      ExperienceModel(
        role: 'Web Development Intern',
        company: 'Stallions Tech Labs Pvt. Ltd.',
        period: 'Oct 2019 – Mar 2020',
        location: 'Mumbai, India',
        type: 'Internship',
        techStack: [
          'ASP.NET MVC',
          'SQL Server',
          'Razor Views',
          'REST APIs',
          'HTML',
          'CSS',
          'JavaScript',
        ],
        highlights: [
          'Improved application load times by up to 30% by refactoring ASP.NET MVC backend logic',
          'Engineered 3 end-to-end MVC web modules reducing manual data entry by ~40%',
          'Reduced post-deployment defect rates through structured debugging and test-driven workflows',
        ],
      ),
    ];
  }

  static List<ProjectModel> getProjects() {
    return const [
      ProjectModel(
        image: 'assets/images/elred_image.png',
        title: 'elRed - B2C App',
        subtitle: 'iOS & Android Consumer App',
        description:
            'Customer-facing B2C app for iOS and Android delivering a high-performance, responsive experience aligned with product and design requirements.',
        techStack: [
          'Flutter',
          'Dart',
          'Firebase Auth',
          'Firestore',
          'Cloud Messaging',
          'REST APIs',
          'Sentry',
        ],
        highlights: [
          'Led end-to-end mobile app development for iOS & Android',
          'Enhanced UI responsiveness via widget-level optimizations & lazy loading',
          'Firebase Cloud Messaging for targeted push notifications',
          'Sentry error monitoring for proactive production issue resolution',
        ],
        accentColor: AppColors.secondaryLight,
        icon: Icons.phone_iphone,
        // githubUrl: 'https://github.com/dev-ritika',
        liveUrl:
            "https://play.google.com/store/apps/details?id=com.elredmod.one&pcampaignid=web_share",
      ),

      ProjectModel(
        image: 'assets/images/kiosk_image.png',
        title: 'elRed - Kiosk App',
        subtitle: 'Kiosk Management Application',
        description:
            'Production-grade Kiosk application deployed at Awfis co-working spaces, enabling seamless self-service workflows for on-site users across multiple locations.',
        techStack: [
          'Flutter',
          'Dart',
          'Firebase',
          'Clean Architecture',
          'Bloc',
          'REST APIs',
        ],
        highlights: [
          'Deployed at Awfis co-working spaces across multiple locations',
          'Optimized app size by 20% via code splitting & asset compression',
          'Clean Architecture + Bloc for highly maintainable, scalable codebase',
          'Firebase Analytics for real-time user engagement monitoring',
        ],
        accentColor: AppColors.primary,
        icon: Icons.tablet_android,
        // githubUrl: 'https://github.com/dev-ritika',
        liveUrl:
            "https://drive.google.com/file/d/1jVtaVUTVbufzjQKoWGmVSdmK16S0IHtS/view?usp=sharing",
      ),

      ProjectModel(
        image: 'assets/images/stallions_image.png',
        title: 'Stallions Tech Labs Website',
        subtitle: 'Corporate Website',
        description:
            'Official corporate website for a Mumbai-based software consultancy covering web, mobile, SEO, QA, and BPO services.',
        techStack: [
          'ASP.NET MVC',
          'SQL Server',
          'Razor Views',
          'C#',
          'HTML',
          'CSS',
          'JavaScript',
          'REST APIs',
        ],
        highlights: [
          'Responsive data-driven Razor views with MVC controllers',
          'SEO-friendly page structure for improved search visibility',
          'Dynamic content rendering and streamlined content management',
        ],
        accentColor: AppColors.accent,
        icon: Icons.web,
        liveUrl: 'http://stallionssoftwares.com/',
      ),
      ProjectModel(
        image: 'assets/images/fitness_image.png',
        title: 'Fitness Fanatic Gym Website',
        subtitle: 'Business Website',
        description:
            'Full business website for a Mumbai-based fitness centre featuring memberships, class schedules, trainer profiles, and contact/enquiry functionality.',
        techStack: [
          'ASP.NET MVC',
          'SQL Server',
          'Razor Views',
          'C#',
          'HTML',
          'CSS',
          'JavaScript',
        ],
        highlights: [
          'Enquiry and contact management module using MVC + SQL Server',
          'Mobile-responsive UI ensuring consistent cross-device experience',
          'Lead capture system without third-party tools',
        ],
        accentColor: AppColors.skillBackend,
        icon: Icons.fitness_center,
        liveUrl: 'https://fitnessfanaticsgym.com/',
      ),
    ];
  }

  static List<StatModel> getStats() {
    return const [
      StatModel(
        value: '6+',
        label: 'Years Experience',
        icon: Icons.workspace_premium,
        color: AppColors.primary,
      ),
      StatModel(
        value: '3+',
        label: 'Production Apps',
        icon: Icons.apps,
        color: AppColors.secondaryLight,
      ),
      StatModel(
        value: '35%',
        label: 'Performance Gain',
        icon: Icons.speed,
        color: AppColors.accent,
      ),
      StatModel(
        value: '100+',
        label: 'Students Trained',
        icon: Icons.school,
        color: AppColors.skillBackend,
      ),
    ];
  }

  static List<CertificationModel> getCertifications() {
    return const [
      CertificationModel(
        title: 'The Ultimate Hands-On Flutter & MVVM',
        description:
            'Deep dive into MVVM architecture, scalable app structure, and real-world implementation',
      ),
      CertificationModel(
        title: 'Flutter & Dart: The Complete Guide',
        description:
            'Comprehensive coverage of Flutter fundamentals, state management, and production practices',
      ),
    ];
  }
}
