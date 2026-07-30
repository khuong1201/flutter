import 'package:flutter/material.dart';
import '../services/hardware_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final HardwareService _hardwareService = HardwareService();
  
  String _deviceModel = 'Đang kiểm tra...';
  bool _isFlashOn = false;
  String _wifiStatus = 'Đang kiểm tra...';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // Tải dữ liệu hệ thống ngay khi mở màn hình
  Future<void> _loadInitialData() async {
    final model = await _hardwareService.getDeviceModel();
    final isWifiOn = await _hardwareService.checkWifiStatus();
    
    setState(() {
      _deviceModel = model;
      _wifiStatus = isWifiOn ? 'Đang bật / Đã kết nối' : 'Đang tắt / Không có mạng';
    });
  }

  // Hàm xử lý nút bấm Flash
  Future<void> _toggleFlash() async {
    bool newState = !_isFlashOn;
    bool success = await _hardwareService.toggleFlashlight(newState);
    
    if (success) {
      setState(() {
        _isFlashOn = newState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bảng điều khiển Phần cứng')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(Icons.phone_android, 'Dòng máy', _deviceModel),
            const SizedBox(height: 16),
            _buildInfoCard(Icons.wifi, 'Trạng thái Wifi', _wifiStatus),
            const SizedBox(height: 32),
            
            // Nút bật tắt đèn pin
            ElevatedButton.icon(
              onPressed: _toggleFlash,
              icon: Icon(_isFlashOn ? Icons.highlight : Icons.lightbulb_outline),
              label: Text(_isFlashOn ? 'TẮT ĐÈN FLASH' : 'BẬT ĐÈN FLASH'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: _isFlashOn ? Colors.red : Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadInitialData,
              icon: const Icon(Icons.refresh),
              label: const Text('LÀM MỚI DỮ LIỆU'),
            )
          ],
        ),
      ),
    );
  }

  // Hàm tạo giao diện Card hiển thị thông tin
  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.blue),
        title: Text(title, style: const TextStyle(color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
    );
  }
}