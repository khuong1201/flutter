import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_clone/services/deezer_api.dart';
import 'package:spotify_clone/shared/models/album_model.dart';
import 'package:spotify_clone/shared/models/track_model.dart';


class AlbumRepository {
  // Lấy chi tiết thông tin của 1 Album
  Future<Album?> getAlbumDetail(int albumId) async {
    try {
      final url = Uri.parse(DeezerApi.album(albumId));
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Album.fromJson(data);
      }
    } catch (e) {
      print('Lỗi gọi API lấy chi tiết album: $e');
    }
    return null;
  }

  // Lấy danh sách bài hát thuộc Album đó
  Future<List<Track>> getAlbumTracks(int albumId) async {
    try {
      final url = Uri.parse(DeezerApi.albumTracks(albumId));
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> list = data['data'] ?? [];
        return list.map((json) => Track.fromJson(json)).toList();
      }
    } catch (e) {
      print('Lỗi gọi API lấy bài hát của album: $e');
    }
    return [];
  }

  // Tìm kiếm Album theo từ khóa (dùng cho màn Search tab Albums)
  Future<List<Album>> searchAlbums(String query) async {
    if (query.isEmpty) return [];
    try {
      final url = Uri.parse(DeezerApi.searchAlbum(query));
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> list = data['data'] ?? [];
        return list.map((json) => Album.fromJson(json)).toList();
      }
    } catch (e) {
      print('Lỗi tìm kiếm album: $e');
    }
    return [];
  }
  Future<List<Album>> getAlbums() async {
    try {
      final url = Uri.parse(DeezerApi.searchAlbum('pop'));
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> list = data['data'] ?? [];
        return list.map((json) => Album.fromJson(json)).toList();
      }
    } catch (e) {
      print('Lỗi lấy danh sách album: $e');
    }
    return [];
  }
}