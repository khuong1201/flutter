import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class MorphingScreen extends StatelessWidget {
  const MorphingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 700),
      closedElevation: 5,
      closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      closedColor: Colors.deepPurple,
      openColor: Colors.white,
      middleColor: Colors.purpleAccent,
      // Khi thẻ đóng (Trạng thái bình thường)
      closedBuilder: (context, action) {
        return InkWell(
          onTap: action, // Bấm để kích hoạt biến hình
          child: Container(
            height: 150,
            width: double.infinity,
            alignment: Alignment.center,
            child: const Text(
              "Bấm để Biến Hình",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
      // Khi thẻ mở tung ra thành màn hình lớn
      openBuilder: (context, action) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Đã Biến Hình!"),
            backgroundColor: Colors.deepPurple,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: action, // Bấm để thu nhỏ lại thành thẻ
            ),
          ),
          body: const Center(
            child: Text(
              "Thẻ bài đã nở tung ra thành màn hình này mà không hề có sự gián đoạn nào (Seamless Transition).",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      },
    );
  }
}
