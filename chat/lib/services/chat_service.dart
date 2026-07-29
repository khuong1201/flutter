import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  // Khởi tạo instance của Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'messages';

  // HÀM GỬI TIN NHẮN (WRITE)
  Future<void> sendMessage({
    required String currentUserId,
    required String currentUserEmail,
    required String message,
  }) async {
    try {
      // Tạo một document mới trong collection 'messages'
      await _firestore.collection(_collectionPath).add({
        'senderId': currentUserId,
        'senderEmail': currentUserEmail,
        'text': message,
        'timestamp': FieldValue.serverTimestamp(), 
      });
    } catch (e) {
      throw Exception('Không thể gửi tin nhắn. Lỗi: $e');
    }
  }

  // HÀM LẮNG NGHE TIN NHẮN (READ - REALTIME)
  Stream<QuerySnapshot> getMessagesStream() {
    return _firestore
        .collection(_collectionPath)
        .orderBy('timestamp', descending: true)
        .snapshots(); // Mở kết nối thời gian thực
  }
}