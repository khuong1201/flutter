import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart'; 
import '../models/coin_model.dart';

class CoinCard extends StatelessWidget {
  final CoinModel coin;

  const CoinCard({Key? key, required this.coin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Định dạng tiền tệ USD: $68,456.12
    final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    
    // Định dạng phần trăm: 2.15%
    final percentFormatter = NumberFormat.decimalPattern('en_US');

    // Xác định màu sắc (Xanh nếu tăng, Đỏ nếu giảm)
    final bool isProfit = coin.priceChangePercentage24h > 0;
    final Color priceColor = isProfit ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Cột 1: Logo và Số hạng
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CachedNetworkImage(
                imageUrl: coin.imageUrl,
                height: 50,
                width: 50,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.money_off),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                child: Text(
                  '${coin.marketCapRank}',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Cột 2: Tên và Ký hiệu
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  coin.symbol,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),

          // Cột 3: Giá và Biến động 24h
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormatter.format(coin.currentPrice),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      isProfit ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: priceColor,
                      size: 20,
                    ),
                    Text(
                      '${percentFormatter.format(coin.priceChangePercentage24h)}%',
                      style: TextStyle(color: priceColor, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}