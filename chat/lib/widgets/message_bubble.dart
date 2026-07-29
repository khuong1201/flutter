import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String senderEmail;
  final bool isMe; // Biến cờ quyết định tin nhắn nằm bên trái hay phải

  const MessageBubble({
    Key? key,
    required this.text,
    required this.senderEmail,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          // Bo góc thông minh: Tin nhắn của mình thì góc nhọn bên phải dưới
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chỉ hiển thị email người gửi nếu không phải là mình
            if (!isMe) 
              Text(
                senderEmail,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            if (!isMe) const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isMe ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}