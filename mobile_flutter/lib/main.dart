import 'package:flutter/material.dart';
import 'services/api_service.dart'; // Import file service chúng ta vừa tạo

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Control',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF282C34),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const DeviceControlScreen(),
    );
  }
}

class DeviceControlScreen extends StatefulWidget {
  const DeviceControlScreen({super.key});

  @override
  State<DeviceControlScreen> createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  // Các biến để lưu trạng thái
  List<dynamic> _devices = [];
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = true;

  // initState được gọi 1 lần khi màn hình được tạo
  @override
  void initState() {
    super.initState();
    _fetchDevices(); // Gọi hàm lấy danh sách thiết bị ngay từ đầu
  }

  // Hàm gọi API để lấy danh sách thiết bị
  Future<void> _fetchDevices() async {
    setState(() { _isLoading = true; });
    try {
      final devices = await ApiService.fetchDevices();
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  // Hàm gọi API để đăng ký thiết bị
  Future<void> _registerDevice() async {
    if (_nameController.text.isEmpty) return;
    try {
      await ApiService.registerDevice(_nameController.text);
      _nameController.clear();
      FocusScope.of(context).unfocus(); // Ẩn bàn phím
      _fetchDevices(); // Tải lại danh sách
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  // Hàm gọi API để điều khiển đèn
  Future<void> _controlDevice(int deviceId, String command) async {
    try {
      await ApiService.controlDevice(deviceId, command);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã gửi lệnh $command!'), duration: const Duration(seconds: 1)),
      );
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }
  
  // Hàm hiển thị thông báo lỗi
  void _showErrorSnackBar(String message) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng điều khiển thiết bị IoT'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form đăng ký
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên thiết bị mới',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _registerDevice,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Danh sách thiết bị
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _fetchDevices,
                      child: ListView.builder(
                        itemCount: _devices.length,
                        itemBuilder: (context, index) {
                          final device = _devices[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${device['name']} (ID: ${device['id']})',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => _controlDevice(device['id'], 'ON'),
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                        child: const Text('BẬT'),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () => _controlDevice(device['id'], 'OFF'),
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                        child: const Text('TẮT'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}