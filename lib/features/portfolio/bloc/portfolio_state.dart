import 'package:equatable/equatable.dart';
import '../../../data/models/portfolio_models.dart';

enum PortfolioStatus { initial, loading, loaded, error }

class PortfolioState extends Equatable {
  final PortfolioStatus status;
  final int activeSection;
  final bool isNavMenuOpen;
  final int? hoveredProjectIndex;
  final List<SkillCategory> skillCategories;
  final List<ExperienceModel> experiences;
  final List<ProjectModel> projects;
  final List<StatModel> stats;
  final List<CertificationModel> certifications;
  final String? errorMessage;

  const PortfolioState({
    this.status = PortfolioStatus.initial,
    this.activeSection = 0,
    this.isNavMenuOpen = false,
    this.hoveredProjectIndex,
    this.skillCategories = const [],
    this.experiences = const [],
    this.projects = const [],
    this.stats = const [],
    this.certifications = const [],
    this.errorMessage,
  });

  PortfolioState copyWith({
    PortfolioStatus? status,
    int? activeSection,
    bool? isNavMenuOpen,
    int? hoveredProjectIndex,
    bool clearHoveredProject = false,
    List<SkillCategory>? skillCategories,
    List<ExperienceModel>? experiences,
    List<ProjectModel>? projects,
    List<StatModel>? stats,
    List<CertificationModel>? certifications,
    String? errorMessage,
  }) {
    return PortfolioState(
      status: status ?? this.status,
      activeSection: activeSection ?? this.activeSection,
      isNavMenuOpen: isNavMenuOpen ?? this.isNavMenuOpen,
      hoveredProjectIndex:
          clearHoveredProject ? null : (hoveredProjectIndex ?? this.hoveredProjectIndex),
      skillCategories: skillCategories ?? this.skillCategories,
      experiences: experiences ?? this.experiences,
      projects: projects ?? this.projects,
      stats: stats ?? this.stats,
      certifications: certifications ?? this.certifications,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        activeSection,
        isNavMenuOpen,
        hoveredProjectIndex,
        skillCategories,
        experiences,
        projects,
        stats,
        certifications,
        errorMessage,
      ];
}
