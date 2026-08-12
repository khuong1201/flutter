import 'package:course/core/error/failures.dart';
import 'package:course/features/characters/domain/entities/character_entity.dart';
import 'package:course/features/characters/domain/repositories/character_repository.dart';
import 'package:dartz/dartz.dart';

class GetCharacterUseCase {
  final CharacterRepository repository;

  GetCharacterUseCase(this.repository);

  Future<Either<Failure, CharacterEntity>> call(int id) async {
    return await repository.getCharacter(id);
  }
}
