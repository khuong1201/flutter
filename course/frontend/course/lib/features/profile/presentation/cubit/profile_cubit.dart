import 'package:course/core/error/failures.dart';
import 'package:course/features/profile/domain/entities/profile_entity.dart';
import 'package:course/features/profile/domain/entities/progress_stats_entity.dart';
import 'package:course/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:course/features/profile/domain/usecases/get_progress_stats_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final GetProgressStatsUseCase getProgressStatsUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.getProgressStatsUseCase,
  }) : super(ProfileInitial());

  Future<void> loadProfileData() async {
    emit(ProfileLoading());

    final profileResult = await getProfileUseCase();
    
    profileResult.fold(
      (failure) => emit(ProfileError(failure)),
      (profile) async {
        final statsResult = await getProgressStatsUseCase();
        
        statsResult.fold(
          (failure) => emit(ProfileError(failure)),
          (stats) => emit(ProfileLoaded(profile, stats)),
        );
      },
    );
  }
}

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  final ProgressStatsEntity stats;

  const ProfileLoaded(this.profile, this.stats);

  @override
  List<Object> get props => [profile, stats];
}

class ProfileError extends ProfileState {
  final Failure failure;

  const ProfileError(this.failure);

  @override
  List<Object> get props => [failure];
}
