import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // =======================================================================
  // === CỰC KỲ QUAN TRỌNG: SỬA ĐỊA CHỈ IP Ở ĐÂY ===
  //
  // 1. NẾU BẠN DÙNG MÁY ẢO ANDROID:
  //    Giữ nguyên là 'http://10.0.2.2:8080'
  //    (10.0.2.2 là địa chỉ IP đặc biệt để máy ảo "nhìn thấy" localhost của máy tính)
  //
  // 2. NẾU BẠN DÙNG ĐIỆN THOẠI THẬT:
  //    a. Đảm bảo điện thoại và máy tính đang kết nối CÙNG MỘT MẠNG WIFI.
  //    b. Mở Command Prompt (cmd) trên máy tính, gõ lệnh `ipconfig` và tìm địa chỉ
  //       "IPv4 Address" của bạn (ví dụ: 192.168.1.10).
  //    c. Thay thế '10.0.2.2' bằng địa chỉ IP đó. Ví dụ: 'http://192.168.1.10:8080'
  //
  // =======================================================================
  static const String _baseUrl = 'http://localhost:8080/api/device';

  // Hàm lấy danh sách thiết bị từ API
  static Future<List<dynamic>> fetchDevices() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      // Nếu thành công, chuyển đổi JSON thành một List
      return jsonDecode(response.body);
    } else {
      // Nếu có lỗi, ném ra một exception
      throw Exception('Lỗi khi tải danh sách thiết bị');
    }
  }

  // Hàm đăng ký thiết bị mới
  static Future<void> registerDevice(String name) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode != 200) {
      throw Exception('Lỗi khi đăng ký thiết bị');
    }
  }

  // Hàm gửi lệnh điều khiển ON/OFF
  static Future<void> controlDevice(int deviceId, String command) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$deviceId/control'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'command': command}),
    );
     if (response.statusCode != 200) {
      throw Exception('Lỗi khi gửi lệnh điều khiển');
    }
  }
}



// import 'dart:convert';
// import 'package:flutter/foundation.dart'; // Import thư viện foundation
// import 'package.http/http.dart' as http;

// class ApiService {
//   // --- PHẦN NÂNG CẤP: TỰ ĐỘNG CHỌN ĐỊA CHỈ IP ---
//   static String getBaseUrl() {
//     // kIsWeb là một hằng số đặc biệt:
//     // - Nó sẽ là `true` nếu code đang chạy trên nền tảng Web.
//     // - Nó sẽ là `false` nếu code đang chạy trên các nền tảng khác (Android, iOS...).
//     if (kIsWeb) {
//       // Nếu là web, dùng localhost
//       return 'http://localhost:8080/api/device';
//     } else {
//       // Nếu là Android (hoặc iOS), dùng địa chỉ IP thật của máy tính.
//       // HÃY THAY THẾ BẰNG ĐỊA CHỈ IP THẬT CỦA MÁY TÍNH BẠN.
//       return 'http://192.168.1.10:8080/api/device'; 
//     }
//   }
//   // --------------------------------------------------

//   // Hàm lấy danh sách thiết bị
//   static Future<List<dynamic>> fetchDevices() async {
//     final baseUrl = getBaseUrl(); // Lấy URL động
//     final response = await http.get(Uri.parse(baseUrl));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load devices');
//     }
//   }

//   // Hàm đăng ký thiết bị mới
//   static Future<void> registerDevice(String name) async {
//     final baseUrl = getBaseUrl(); // Lấy URL động
//     await http.post(
//       Uri.parse('$baseUrl/register'),
//       headers: {'Content-Type': 'application/json; charset=UTF-8'},
//       body: jsonEncode({'name': name}),
//     );
//   }

//   // Hàm gửi lệnh điều khiển
//   static Future<void> controlDevice(int deviceId, String command) async {
//     final baseUrl = getBaseUrl(); // Lấy URL động
//     await http.post(
//       Uri.parse('$baseUrl/$deviceId/control'),
//       headers: {'Content-Type': 'application/json; charset=UTF-8'},
//       body: jsonEncode({'command': command}),
//     );
//   }
// }