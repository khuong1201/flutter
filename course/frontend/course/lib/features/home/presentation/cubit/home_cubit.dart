import 'package:course/features/home/domain/usecases/get_contributions_usecase.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/home/domain/entities/contribution_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetContributionsUseCase getContributionsUseCase;

  HomeCubit({
    required this.getContributionsUseCase,
  }) : super(HomeInitial());

  Future<void> loadData() async {
    emit(HomeLoading());
    final year = DateTime.now().year;
    
    final result = await getContributionsUseCase(year);
    
    result.fold(
      (failure) => emit(HomeError(failure)),
      (contributions) => emit(HomeLoaded(contributions)),
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
  final List<ContributionEntity> contributions;

  const HomeLoaded(this.contributions);

  @override
  List<Object> get props => [contributions];
}

class HomeError extends HomeState {
  final Failure failure;

  const HomeError(this.failure);

  @override
  List<Object> get props => [failure];
}
