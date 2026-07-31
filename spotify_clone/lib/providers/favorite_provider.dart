import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteProvider extends ChangeNotifier {
  // Trỏ thẳng vào cái hộp đã mở ở main.dart
  final Box<String> _box = Hive.box<String>('favorites_box');

  // Lấy ra danh sách ID (Siêu nhanh, không cần await)
  List<String> get favoriteIds => _box.values.toList();

  void toggleFavorite(String trackId) {
    if (_box.containsKey(trackId)) {
      _box.delete(trackId); // Hủy tim
    } else {
      _box.put(trackId, trackId); // Thả tim (Dùng trackId làm key & value luôn)
    }
    notifyListeners();
  }

  bool isFavorite(String trackId) {
    return _box.containsKey(trackId);
  }
}