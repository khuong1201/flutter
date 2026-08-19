import 'package:course/core/error/failures.dart';
import 'package:course/features/characters/domain/entities/character_entity.dart';
import 'package:course/features/characters/domain/usecases/get_character_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CharacterState extends Equatable {
  const CharacterState();

  @override
  List<Object?> get props => [];
}

class CharacterInitial extends CharacterState {}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final CharacterEntity character;

  const CharacterLoaded(this.character);

  @override
  List<Object?> get props => [character];
}

class CharacterError extends CharacterState {
  final Failure failure;

  const CharacterError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class CharacterCubit extends Cubit<CharacterState> {
  final GetCharacterUseCase getCharacterUseCase;

  CharacterCubit({required this.getCharacterUseCase}) : super(CharacterInitial());

  Future<void> loadCharacter(int id, {dynamic initialData}) async {
    if (initialData != null) {
      try {
        final partialCharacter = CharacterEntity(
          id: initialData.id,
          charText: initialData.charText,
          language: initialData.language,
          meaning: initialData.meaning,
          audioKey: initialData.audioKey,
          strokes: initialData.strokeData ?? [],
          radicals: const [],
          readings: const [],
          vocabularies: const [],
        );
        emit(CharacterLoaded(partialCharacter));
      } catch (_) {
        emit(CharacterLoading());
      }
    } else {
      emit(CharacterLoading());
    }

    final result = await getCharacterUseCase(id);
    result.fold(
      (failure) {
        if (initialData == null) {
          emit(CharacterError(failure));
        }
      },
      (character) => emit(CharacterLoaded(character)),
    );
  }
}
