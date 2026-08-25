import 'dart:ui';
import 'package:flutter/material.dart';

void showModernBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    backgroundColor: Colors.transparent, // Kính trong suốt
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5, // Chiếm 50%
        minChildSize: 0.3,
        maxChildSize: 0.9,     // Chiếm 90% khi vuốt
        builder: (BuildContext context, ScrollController scrollController) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  border: Border(
                    top: BorderSide(color: Colors.white.withOpacity(0.5), width: 1.5),
                  )
                ),
                child: Column(
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 20),
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const Text("Thông Báo Của Bạn", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: 15,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.notifications_active, color: Colors.blue),
                            ),
                            title: Text('Thông báo số ${index + 1}', style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: const Text('Ứng dụng Flutter UI Kit vừa được cập nhật UI mới nhất.'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
