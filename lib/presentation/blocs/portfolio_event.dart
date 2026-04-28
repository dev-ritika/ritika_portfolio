import 'package:equatable/equatable.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object?> get props => [];
}

class LoadPortfolioData extends PortfolioEvent {
  const LoadPortfolioData();
}

class NavigateToSection extends PortfolioEvent {
  final int sectionIndex;
  const NavigateToSection(this.sectionIndex);

  @override
  List<Object?> get props => [sectionIndex];
}

class UpdateActiveSection extends PortfolioEvent {
  final int sectionIndex;
  const UpdateActiveSection(this.sectionIndex);

  @override
  List<Object?> get props => [sectionIndex];
}

class ToggleNavMenu extends PortfolioEvent {
  const ToggleNavMenu();
}

class CloseNavMenu extends PortfolioEvent {
  const CloseNavMenu();
}

class HoverProject extends PortfolioEvent {
  final int? projectIndex;
  const HoverProject(this.projectIndex);

  @override
  List<Object?> get props => [projectIndex];
}
