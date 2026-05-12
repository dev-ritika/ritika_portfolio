import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../bloc/portfolio_bloc.dart';
import '../../bloc/portfolio_state.dart';
import '../../viewmodel/portfolio_viewmodel.dart';
import '../widgets/nav_bar_widget.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PortfolioViewModel _viewModel;
  late List<GlobalKey> _sectionKeys;

  @override
  void initState() {
    super.initState();
    _sectionKeys = List.generate(7, (_) => GlobalKey());
    _viewModel = PortfolioViewModel(
      bloc: context.read<PortfolioBloc>(),
      scrollController: ScrollController(),
      sectionKeys: _sectionKeys,
    );
    _viewModel.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    for (int i = 0; i < _sectionKeys.length; i++) {
      final ctx = _sectionKeys[i].currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox?;
        if (box != null) {
          final pos = box.localToGlobal(Offset.zero);
          if (pos.dy >= -100 && pos.dy < MediaQuery.of(context).size.height * 0.5) {
            _viewModel.updateActiveSection(i);
            break;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _viewModel.scrollController.removeListener(_onScroll);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Main scrollable content
              SingleChildScrollView(
                controller: _viewModel.scrollController,
                child: Column(
                  children: [
                    // Hero
                    SizedBox(
                      key: _sectionKeys[0],
                      child: HeroSection(
                        onContactTap: () => _viewModel.navigateToSection(6),
                        onProjectsTap: () => _viewModel.navigateToSection(5),
                      ),
                    ),

                    // About
                    SizedBox(
                      key: _sectionKeys[1],
                      child: AboutSection(stats: state.stats),
                    ),

                    // Skills
                    SizedBox(
                      key: _sectionKeys[2],
                      child: SkillsSection(categories: state.skillCategories),
                    ),

                    // Experience
                    SizedBox(
                      key: _sectionKeys[3],
                      child: ExperienceSection(experiences: state.experiences),
                    ),

                    // Projects
                    SizedBox(
                      key: _sectionKeys[4],
                      child: ProjectsSection(
                        projects: state.projects,
                        viewModel: _viewModel,
                        hoveredIndex: state.hoveredProjectIndex,
                      ),
                    ),

                    // Contact
                    SizedBox(
                      key: _sectionKeys[5],
                      child: const ContactSection(),
                    ),

                    // Footer
                    SizedBox(
                      key: _sectionKeys[6],
                      child: const FooterWidget(),
                    ),
                  ],
                ),
              ),

              // Sticky NavBar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: NavBarWidget(viewModel: _viewModel),
              ),
            ],
          ),
        );
      },
    );
  }
}
