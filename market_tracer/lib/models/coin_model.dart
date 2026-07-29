class CoinModel {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final double currentPrice;
  final double priceChangePercentage24h;
  final int marketCapRank;

  CoinModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.marketCapRank,
  });

  // Factory constructor để map dữ liệu JSON từ API thành Object Dart
  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id']?.toString() ?? 'unknown',
      name: json['name']?.toString() ?? 'N/A',
      symbol: json['symbol']?.toString().toUpperCase() ?? 'N/A',
      imageUrl: json['image']?.toString() ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
      marketCapRank: json['market_cap_rank'] as int? ?? 999,
    );
  }
}