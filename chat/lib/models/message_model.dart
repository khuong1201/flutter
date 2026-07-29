import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String senderEmail;
  final String text;
  final DateTime? timestamp;

  MessageModel({
    required this.senderId,
    required this.senderEmail,
    required this.text,
    this.timestamp,
  });

  // Chuyển đổi dữ liệu từ Firestore Document thành Object Dart
  factory MessageModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return MessageModel(
      senderId: data['senderId'] ?? '',
      senderEmail: data['senderEmail'] ?? '',
      text: data['text'] ?? '',
      // Xử lý an toàn timestamp vì khi vừa gửi lên, Firebase có thể trả về null một tích tắc
      timestamp: data['timestamp'] != null 
          ? (data['timestamp'] as Timestamp).toDate() 
          : DateTime.now(), 
    );
  }
}