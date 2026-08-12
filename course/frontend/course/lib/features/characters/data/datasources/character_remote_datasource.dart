import 'package:course/features/characters/data/models/character_model.dart';
import 'package:dio/dio.dart';

abstract class CharacterRemoteDataSource {
  Future<CharacterModel> getCharacter(int id);
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSourceImpl({required this.dio});

  @override
  Future<CharacterModel> getCharacter(int id) async {
    final response = await dio.get('/characters/$id');
    return CharacterModel.fromJson(response.data);
  }
}
