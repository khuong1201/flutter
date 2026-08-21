# Bài 5: WebSockets và Thời Gian Thực (Realtime)

Trong các ứng dụng thông thường (như tin tức, bán hàng), bạn dùng giao thức HTTP RESTful (App hỏi -> Server trả lời).
Nhưng trong các ứng dụng như **Chat**, **App chứng khoán**, hay **App đặt xe (Grab)**, server phải TỰ ĐỘNG gửi dữ liệu về app mà app không cần hỏi. Lúc đó ta dùng **WebSockets**.

Khác với HTTP (gọi xong rồi ngắt kết nối), WebSocket duy trì một đường ống ngầm liên tục (Persistent connection) giữa App và Server.

## 1. Cài đặt thư viện
```yaml
dependencies:
  web_socket_channel: ^2.4.0
```

## 2. Kết nối tới Server WebSocket
Ví dụ ta kết nối tới một server test công cộng (Echo server: Gửi gì nó trả lại y chang).

```dart
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Khởi tạo kênh kết nối (Ký hiệu ws:// hoặc wss://)
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );

  final TextEditingController _controller = TextEditingController();

  // Gửi tin nhắn đi (Puslish)
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text); // sink.add = Gửi đi
      _controller.clear();
    }
  }

  @override
  void dispose() {
    // QUAN TRỌNG: Bắt buộc phải đóng kết nối khi thoát màn hình để không ngốn pin và Ram
    channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebSocket Demo')),
      body: Column(
        children: [
          Expanded(
            // Lắng nghe dữ liệu server gửi về (Subscribe) thông qua StreamBuilder
            child: StreamBuilder(
              stream: channel.stream, // Dữ liệu chảy về liên tục qua stream
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Lỗi kết nối');
                }
                if (snapshot.hasData) {
                  return Text('Server phản hồi: ${snapshot.data}', 
                              style: TextStyle(fontSize: 24));
                }
                return Text('Đang chờ tin nhắn...');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Nhập tin nhắn...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
```

## 3. Kiến thức mở rộng
- **Socket.io**: Nếu server của bạn dùng Node.js Socket.io, bạn KHÔNG ĐƯỢC dùng thư viện `web_socket_channel` ở trên. Bạn phải dùng thư viện `socket_io_client`.
- **Firebase Realtime Database / Firestore**: Bản chất bên dưới của Firebase cũng sử dụng cơ chế Websocket để đồng bộ dữ liệu thời gian thực.
- Khi app bị đẩy xuống nền (Background), kết nối Websocket thường bị Hệ điều hành (Android/iOS) cắt đứt để tiết kiệm pin. Bạn cần phải xử lý kết nối lại (Re-connect) khi App được mở lại (Foreground).
