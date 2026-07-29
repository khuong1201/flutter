import 'package:flutter/material.dart';
import '../models/coin_model.dart';
import '../services/api_service.dart';

class MarketProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Danh sách coin
  List<CoinModel> _coins = [];
  List<CoinModel> get coins => _coins;

  // Trạng thái loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Lỗi (nếu có)
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Quản lý trang hiện tại để làm tính năng Load More (Pagination)
  int _currentPage = 1;

  // Hàm gọi API, có tham số isRefresh để phân biệt giữa việc tải lần đầu và kéo để làm mới
  Future<void> fetchMarketData({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _errorMessage = '';
      // Khi pull-to-refresh, không set isLoading = true để UI không bị giật
    } else if (_coins.isEmpty) {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();
    }

    try {
      final newCoins = await _apiService.fetchCoins(_currentPage);
      
      if (isRefresh) {
        _coins = newCoins; // Ghi đè danh sách mới nếu là refresh
      } else {
        _coins.addAll(newCoins); // Nối thêm vào cuối danh sách nếu là load more
      }
      _currentPage++;
      
    } catch (e) {
      // Chỉ hiển thị lỗi toàn màn hình nếu danh sách đang trống
      if (_coins.isEmpty) {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      }
    } finally {
      _isLoading = false;
      notifyListeners(); // Thông báo cho UI cập nhật
    }
  }
}