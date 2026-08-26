import 'package:flutter/material.dart';

class StackedAvatars extends StatelessWidget {
  final List<String> imageUrls;
  final double size;

  const StackedAvatars({
    super.key,
    required this.imageUrls,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    // Giới hạn hiển thị tối đa 4 avatar, còn lại hiện số +X
    final displayUrls = imageUrls.take(4).toList();
    final remainingCount = imageUrls.length - displayUrls.length;

    return SizedBox(
      height: size,
      // Cần tính toán Width vì các avatar xếp đè lên nhau (Mỗi cái dịch đi size * 0.7)
      width: size + (displayUrls.length * (size * 0.7)) + (remainingCount > 0 ? size * 0.7 : 0),
      child: Stack(
        children: [
          for (int i = 0; i < displayUrls.length; i++)
            Positioned(
              left: i * (size * 0.7),
              child: _buildAvatar(displayUrls[i]),
            ),
          if (remainingCount > 0)
            Positioned(
              left: displayUrls.length * (size * 0.7),
              child: _buildRemainingAvatar(remainingCount),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String url) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: const Icon(Icons.person, color: Colors.white),
    );
  }

  Widget _buildRemainingAvatar(int count) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
      ),
      child: Text(
        '+$count',
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}
