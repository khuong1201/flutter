import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_clone/services/deezer_api.dart';
import 'package:spotify_clone/shared/models/track_model.dart';

class MusicRepository {
  // 1. Tìm kiếm bài hát theo từ khóa
  Future<List<Track>> searchTracks(String query) async {
    if (query.isEmpty) return [];
    try {
      final url = Uri.parse(DeezerApi.searchTrack(query));
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> list = data['data'] ?? [];
        return list.map((json) => Track.fromJson(json)).toList();
      }
    } catch (e) {
      print('Lỗi gọi Deezer API search: $e');
    }
    return [];
  }

  // 2. Lấy danh sách Top bài hát cho trang chủ
  Future<List<Track>> getTopTracks() async {
    try {
      final url = Uri.parse(DeezerApi.topTracks());
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> list = data['data'] ?? [];
        return list.map((json) => Track.fromJson(json)).toList();
      }
    } catch (e) {
      print('Lỗi gọi Deezer API topTracks: $e');
    }
    return [];
  }

  // 3. Lấy chi tiết bài hát theo ID (dùng cho Thư viện Hive khi tải bài đã thích)
  Future<List<Track>> getTracksByIds(List<String> ids) async {
    List<Track> tracks = [];
    for (String id in ids) {
      try {
        final url = Uri.parse(DeezerApi.track(int.parse(id)));
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          tracks.add(Track.fromJson(jsonData));
        }
      } catch (e) {
        print('Lỗi lấy track theo ID $id: $e');
      }
    }
    return tracks;
  }

  // 4. Lấy danh sách bài hát thuộc một Album cụ thể
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
      print('Lỗi lấy danh sách bài hát của album: $e');
    }
    return [];
  }

  // 5. Lấy danh sách thể loại nhạc từ Deezer API (Thay thế cho mock categories)
  Future<List<dynamic>> getCategories() async {
    try {
      final url = Uri.parse(DeezerApi.genres());
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> list = data['data'] ?? [];
        
        // Loại bỏ thể loại có id = 0 (thường là "All" không có hình ảnh)
        final filteredList = list.where((g) => g['id'] != 0).toList();

        // Chuyển đổi dữ liệu sang dạng map tương thích với UI grid view hiện tại
        return filteredList.map((genre) {
          return {
            'title': genre['name'] ?? 'Genre',
            'color': _getRandomColorHex(genre['id']),
            'cover': genre['picture_medium'] ?? '',
          };
        }).toList();
      }
    } catch (e) {
      print('Lỗi gọi Deezer API genres: $e');
    }
    return [];
  }

  // Hàm phụ trợ tạo màu ngẫu nhiên cho danh mục thể loại
  String _getRandomColorHex(int id) {
    const colors = [
      '#E91E63', '#9C27B0', '#673AB7', '#3F51B5', 
      '#2196F3', '#009688', '#4CAF50', '#FF9800', 
      '#FF5722', '#795548', '#607D8B'
    ];
    return colors[id % colors.length];
  }
}