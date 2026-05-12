import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/portfolio/bloc/portfolio_bloc.dart';
import 'features/portfolio/bloc/portfolio_event.dart';
import 'features/portfolio/view/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RitikaPortfolioApp());
}

class RitikaPortfolioApp extends StatelessWidget {
  const RitikaPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PortfolioBloc()..add(const LoadPortfolioData()),
      child: MaterialApp(
        title: 'Ritika Sharma — Senior Flutter Developer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
        scrollBehavior: const _WebScrollBehavior(),
      ),
    );
  }
}

class _WebScrollBehavior extends ScrollBehavior {
  const _WebScrollBehavior();

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
