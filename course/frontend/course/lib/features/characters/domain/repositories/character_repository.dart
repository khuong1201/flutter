import 'package:course/core/error/failures.dart';
import 'package:course/features/characters/domain/entities/character_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CharacterRepository {
  Future<Either<Failure, CharacterEntity>> getCharacter(int id);
}
