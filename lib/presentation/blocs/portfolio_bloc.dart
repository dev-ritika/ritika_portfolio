import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/portfolio_repository.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  PortfolioBloc() : super(const PortfolioState()) {
    on<LoadPortfolioData>(_onLoadPortfolioData);
    on<NavigateToSection>(_onNavigateToSection);
    on<UpdateActiveSection>(_onUpdateActiveSection);
    on<ToggleNavMenu>(_onToggleNavMenu);
    on<CloseNavMenu>(_onCloseNavMenu);
    on<HoverProject>(_onHoverProject);
  }

  Future<void> _onLoadPortfolioData(
    LoadPortfolioData event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(status: PortfolioStatus.loading));
    try {
      final skills = PortfolioRepository.getSkillCategories();
      final experiences = PortfolioRepository.getExperiences();
      final projects = PortfolioRepository.getProjects();
      final stats = PortfolioRepository.getStats();
      final certifications = PortfolioRepository.getCertifications();

      emit(state.copyWith(
        status: PortfolioStatus.loaded,
        skillCategories: skills,
        experiences: experiences,
        projects: projects,
        stats: stats,
        certifications: certifications,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PortfolioStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onNavigateToSection(
    NavigateToSection event,
    Emitter<PortfolioState> emit,
  ) {
    emit(state.copyWith(
      activeSection: event.sectionIndex,
      isNavMenuOpen: false,
    ));
  }

  void _onUpdateActiveSection(
    UpdateActiveSection event,
    Emitter<PortfolioState> emit,
  ) {
    if (state.activeSection != event.sectionIndex) {
      emit(state.copyWith(activeSection: event.sectionIndex));
    }
  }

  void _onToggleNavMenu(
    ToggleNavMenu event,
    Emitter<PortfolioState> emit,
  ) {
    emit(state.copyWith(isNavMenuOpen: !state.isNavMenuOpen));
  }

  void _onCloseNavMenu(
    CloseNavMenu event,
    Emitter<PortfolioState> emit,
  ) {
    emit(state.copyWith(isNavMenuOpen: false));
  }

  void _onHoverProject(
    HoverProject event,
    Emitter<PortfolioState> emit,
  ) {
    if (event.projectIndex == null) {
      emit(state.copyWith(clearHoveredProject: true));
    } else {
      emit(state.copyWith(hoveredProjectIndex: event.projectIndex));
    }
  }
}
