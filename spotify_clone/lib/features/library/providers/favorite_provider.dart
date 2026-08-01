import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spotify_clone/shared/models/track_model.dart';
import 'package:spotify_clone/shared/repositories/music_repository.dart';


class FavoriteProvider extends ChangeNotifier {
  final MusicRepository _musicRepository = MusicRepository();
  
  // Trỏ thẳng vào cái hộp đã mở ở main.dart
  final Box<String> _box = Hive.box<String>('favorites_box');

  // Danh sách các bài hát chi tiết đã tải về để hiển thị lên UI Thư viện
  List<Track> _favoriteTracks = [];
  bool _isLoading = false;

  List<Track> get favoriteTracks => _favoriteTracks;
  bool get isLoading => _isLoading;

  // Lấy ra danh sách ID (Siêu nhanh, không cần await)
  List<String> get favoriteIds => _box.values.toList();

  // Thả tim hoặc Hủy tim
  Future<void> toggleFavorite(String trackId) async {
    if (_box.containsKey(trackId)) {
      await _box.delete(trackId); // Hủy tim
    } else {
      await _box.put(trackId, trackId); // Thả tim
    }
    
    // Sau khi thay đổi trạng thái tim, tự động cập nhật lại danh sách bài hát yêu thích
    await fetchFavoriteTracks();
    notifyListeners();
  }

  bool isFavorite(String trackId) {
    return _box.containsKey(trackId);
  }

  // Gọi Repository để tải toàn bộ thông tin chi tiết các bài hát từ danh sách ID trong Hive
  Future<void> fetchFavoriteTracks() async {
    final ids = favoriteIds;
    if (ids.isEmpty) {
      _favoriteTracks = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Gọi hàm lấy nhiều bài hát bằng danh sách ID mà chúng ta đã viết ở MusicRepository
      _favoriteTracks = await _musicRepository.getTracksByIds(ids);
    } catch (e) {
      print("Lỗi tải danh sách yêu thích: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}