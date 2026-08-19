import 'package:course/core/error/failures.dart';
import 'package:course/features/characters/domain/entities/character_entity.dart';
import 'package:course/features/characters/domain/repositories/character_repository.dart';
import 'package:dartz/dartz.dart';

class SearchCharactersUseCase {
  final CharacterRepository repository;

  SearchCharactersUseCase(this.repository);

  Future<Either<Failure, List<CharacterEntity>>> call({String? q, int? limit, String? lang}) async {
    return await repository.searchCharacters(q: q, limit: limit, lang: lang);
  }
}
