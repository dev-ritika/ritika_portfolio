import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PortfolioState extends Equatable {
  final bool loading;
  final int index;

  const PortfolioState({this.loading = false, this.index = 0});

  @override
  List<Object?> get props => [loading, index];
}

class PortfolioCubit extends Cubit<PortfolioState> {
  PortfolioCubit() : super(const PortfolioState());

  void loadData() {
    emit(const PortfolioState(loading: true));

    Future.delayed(const Duration(seconds: 1), () {
      emit(const PortfolioState(loading: false));
    });
  }

  void changeSection(int index) => emit(PortfolioState(index: index));
}
