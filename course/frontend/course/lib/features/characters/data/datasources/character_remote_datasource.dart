import 'package:course/features/characters/data/models/character_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

List<CharacterModel> _parseCharacterList(dynamic data) {
  return (data as List).map((json) => CharacterModel.fromJson(json)).toList();
}

abstract class CharacterRemoteDataSource {
  Future<CharacterModel> getCharacter(int id);
  Future<List<CharacterModel>> searchCharacters({String? q, int? limit, String? lang});
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSourceImpl({required this.dio});

  @override
  Future<CharacterModel> getCharacter(int id) async {
    final response = await dio.get('/characters/$id');
    return CharacterModel.fromJson(response.data);
  }

  @override
  Future<List<CharacterModel>> searchCharacters({String? q, int? limit, String? lang}) async {
    final queryParameters = <String, dynamic>{};
    if (q != null && q.isNotEmpty) queryParameters['q'] = q;
    if (limit != null) queryParameters['limit'] = limit;
    if (lang != null && lang.isNotEmpty) queryParameters['lang'] = lang;

    final response = await dio.get('/characters', queryParameters: queryParameters);
    
    return await compute(_parseCharacterList, response.data);
  }
}
