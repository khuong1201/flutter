import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Lấy thông tin user hiện tại
  User? get currentUser => _auth.currentUser;

  // Mở một "đường ống" (Stream) để lắng nghe sự thay đổi trạng thái.
  // Nhờ luồng này, nếu token hết hạn hoặc người dùng đăng xuất, 
  // app sẽ tự động văng ra màn hình Login mà không cần code chuyển trang thủ công.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Đăng nhập bằng Email & Password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
    } on FirebaseAuthException catch (e) {
      // Xử lý các mã lỗi đặc thù từ Firebase để báo cho UI
      if (e.code == 'user-not-found') {
        throw Exception('Không tìm thấy tài khoản với email này.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Sai mật khẩu.');
      }
      throw Exception('Lỗi đăng nhập: ${e.message}');
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }
}