import 'package:course/core/error/failures.dart';
import 'package:course/core/network/dio_exception_extension.dart';
import 'package:course/features/characters/data/datasources/character_remote_datasource.dart';
import 'package:course/features/characters/domain/entities/character_entity.dart';
import 'package:course/features/characters/domain/repositories/character_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;

  CharacterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CharacterEntity>> getCharacter(int id) async {
    try {
      final character = await remoteDataSource.getCharacter(id);
      return Right(character);
    } on DioException catch (e) {
      return Left(ServerFailure(e.apiCode ?? 'errorUnknown'));
    } catch (e) {
      return Left(ServerFailure('errorUnknown'));
    }
  }
}
