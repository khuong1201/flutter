import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';
import '../widgets/coin_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  void initState() {
    super.initState();
    // Gọi API lần đầu tiên khi màn hình được tạo
    // Chú ý: dùng Future.microtask để tránh lỗi calling notifyListeners during build
    Future.microtask(() =>
      context.read<MarketProvider>().fetchMarketData()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thị trường Crypto', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      // Sử dụng Consumer để lắng nghe trạng thái từ Provider
      body: Consumer<MarketProvider>(
        builder: (context, marketProvider, child) {
          
          // Trạng thái 1: Đang tải lần đầu
          if (marketProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Trạng thái 2: Có lỗi (ví dụ: mất mạng)
          if (marketProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(marketProvider.errorMessage, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => marketProvider.fetchMarketData(isRefresh: true),
                    child: const Text('Thử lại ngay'),
                  ),
                ],
              ),
            );
          }

          // Trạng thái 3: Tải thành công, hiển thị danh sách
          return RefreshIndicator(
            onRefresh: () => marketProvider.fetchMarketData(isRefresh: true),
            child: ListView.builder(
              itemCount: marketProvider.coins.length,
              itemBuilder: (context, index) {
                final coin = marketProvider.coins[index];
                return CoinCard(coin: coin);
              },
            ),
          );
        },
      ),
    );
  }
}