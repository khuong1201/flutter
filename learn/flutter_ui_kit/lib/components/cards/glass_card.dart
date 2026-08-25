import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final String title;
  final String amount;
  final String cardNumber;

  const GlassCard({
    super.key,
    required this.title,
    required this.amount,
    required this.cardNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        // Nền Gradient loang lổ bên dưới thẻ kính
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6750A4), Color(0xFF381E72)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6750A4).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Stack(
        children: [
          // Các họa tiết loang lổ (Mesh Effect giả lập)
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pinkAccent.withOpacity(0.2),
              ),
            ),
          ),
          
          // Lớp Kính Mờ (Glassmorphism)
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                        const Icon(Icons.wifi, color: Colors.white, size: 28), // Mô phỏng icon chạm thanh toán
                      ],
                    ),
                    Text(
                      amount,
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(cardNumber, style: const TextStyle(color: Colors.white70, fontSize: 18, letterSpacing: 2)),
                        // Hai vòng tròn mô phỏng logo Mastercard
                        SizedBox(
                          width: 40,
                          child: Stack(
                            children: [
                              Container(width: 24, height: 24, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.withOpacity(0.8))),
                              Positioned(right: 0, child: Container(width: 24, height: 24, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orange.withOpacity(0.8)))),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
