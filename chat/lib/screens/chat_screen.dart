import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import '../services/chat_service.dart';
import '../services/auth_service.dart';
import '../models/message_model.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      await _chatService.sendMessage(
        currentUserId: currentUser.uid,
        currentUserEmail: currentUser.email ?? 'Unknown',
        message: _messageController.text,
      );
      _messageController.clear(); // Xóa khung nhập sau khi gửi
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = _authService.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace Chat'),
        actions: [
          // Nút đăng xuất
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authService.signOut(),
          )
        ],
      ),
      body: Column(
        children: [
          // 1. Vùng hiển thị tin nhắn (Chiếm tối đa diện tích)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getMessagesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(child: Text('Hãy gửi tin nhắn đầu tiên!'));
                }

                return ListView.builder(
                  reverse: true, // Vuốt ngược từ dưới lên
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final message = MessageModel.fromDocument(docs[index]);
                    final isMe = message.senderId == currentUserId;

                    return MessageBubble(
                      text: message.text,
                      senderEmail: message.senderEmail,
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),
          
          // 2. Vùng nhập tin nhắn
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}