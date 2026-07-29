import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coin_model.dart';

class ApiService {
  // Đặt baseUrl ra một biến riêng để dễ quản lý và thay đổi sau này
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<CoinModel>> fetchCoins(int page) async {
    try {
      final url = Uri.parse('$_baseUrl/coins/markets?vs_currency=usd&per_page=20&page=$page');
      
      // Giới hạn thời gian chờ là 10 giây
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => CoinModel.fromJson(item)).toList();
      } else if (response.statusCode == 429) {
        throw Exception('Server đang quá tải (Lỗi 429). Vui lòng thử lại sau ít phút.');
      } else {
        throw Exception('Lỗi hệ thống: ${response.statusCode}');
      }
    } catch (e) {
      // Bắt mọi lỗi từ mất mạng, sai URL, đến Timeout
      throw Exception('Không thể tải dữ liệu. Vui lòng kiểm tra kết nối mạng của bạn.');
    }
  }
}