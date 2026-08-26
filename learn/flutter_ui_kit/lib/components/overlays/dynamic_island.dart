import 'package:flutter/material.dart';

class DynamicIsland extends StatefulWidget {
  const DynamicIsland({super.key});

  @override
  State<DynamicIsland> createState() => _DynamicIslandState();
}

class _DynamicIslandState extends State<DynamicIsland> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.elasticOut,
        width: _isExpanded ? MediaQuery.of(context).size.width * 0.9 : 150,
        height: _isExpanded ? 150 : 35,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(_isExpanded ? 30 : 20),
        ),
        child: _isExpanded
            ? _buildExpandedContent()
            : _buildCollapsedContent(),
      ),
    );
  }

  Widget _buildCollapsedContent() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.music_note, color: Colors.greenAccent, size: 16),
        SizedBox(width: 8),
        Text("Đang phát nhạc...", style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildExpandedContent() {
    // Ẩn nội dung cũ, hiện nội dung mới bằng AnimatedOpacity
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isExpanded ? 1.0 : 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                  )
                ),
                child: const Icon(Icons.music_note, color: Colors.white),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bật Tình Yêu Lên", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text("Hòa Minzy, Tăng Duy Tân", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.skip_previous, color: Colors.white, size: 32),
              const Icon(Icons.pause_circle_filled, color: Colors.white, size: 40),
              const Icon(Icons.skip_next, color: Colors.white, size: 32),
            ],
          )
        ],
      ),
    );
  }
}
