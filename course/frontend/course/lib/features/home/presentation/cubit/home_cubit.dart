import 'package:course/features/home/domain/usecases/get_progress_stats_usecase.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/home/domain/entities/progress_stats_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetProgressStatsUseCase getProgressStatsUseCase;

  HomeCubit({
    required this.getProgressStatsUseCase,
  }) : super(HomeInitial());

  Future<void> loadData() async {
    emit(HomeLoading());
    
    final result = await getProgressStatsUseCase();
    
    result.fold(
      (failure) => emit(HomeError(failure)),
      (stats) => emit(HomeLoaded(stats)),
    );
  }
}

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final ProgressStatsEntity stats;

  const HomeLoaded(this.stats);

  @override
  List<Object> get props => [stats];
}

class HomeError extends HomeState {
  final Failure failure;

  const HomeError(this.failure);

  @override
  List<Object> get props => [failure];
}
