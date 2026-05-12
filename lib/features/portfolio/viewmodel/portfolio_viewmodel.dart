import 'package:flutter/material.dart';
import '../bloc/portfolio_bloc.dart';
import '../bloc/portfolio_event.dart';

class PortfolioViewModel {
  final PortfolioBloc bloc;
  final ScrollController scrollController;
  final List<GlobalKey> sectionKeys;

  PortfolioViewModel({
    required this.bloc,
    required this.scrollController,
    required this.sectionKeys,
  });

  void loadData() {
    bloc.add(const LoadPortfolioData());
  }

  void navigateToSection(int index) {
    bloc.add(NavigateToSection(index));
    _scrollToSection(index);
  }

  void _scrollToSection(int index) {
    if (index < 0 || index >= sectionKeys.length) return;
    final key = sectionKeys[index];
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void updateActiveSection(int index) {
    bloc.add(UpdateActiveSection(index));
  }

  void toggleNavMenu() {
    bloc.add(const ToggleNavMenu());
  }

  void closeNavMenu() {
    bloc.add(const CloseNavMenu());
  }

  void hoverProject(int? index) {
    bloc.add(HoverProject(index));
  }

  void dispose() {
    scrollController.dispose();
  }
}
