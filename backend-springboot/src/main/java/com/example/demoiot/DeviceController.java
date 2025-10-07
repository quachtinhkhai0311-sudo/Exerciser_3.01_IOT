package com.example.demoiot;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*") // Dấu "*" có nghĩa là cho phép TẤT CẢ các nguồn
@RestController
@RequestMapping("/api/device")
public class DeviceController {

    @Autowired
    private MqttGateway mqttGateway;

    // Tiêm các repository để làm việc với DB
    @Autowired
    private DeviceRepository deviceRepository;

    @Autowired
    private ControlLogRepository controlLogRepository;

    // --- API 1: Đăng ký một thiết bị mới ---
    @PostMapping("/register")
    public ResponseEntity<Device> registerDevice(@RequestBody Device newDevice) {
        Device savedDevice = deviceRepository.save(newDevice);
        return ResponseEntity.ok(savedDevice);
    }

    // --- API 2: Lấy danh sách tất cả các thiết bị ---
    @GetMapping
    public ResponseEntity<List<Device>> getAllDevices() {
        List<Device> devices = deviceRepository.findAll();
        return ResponseEntity.ok(devices);
    }

    // --- API 3: Điều khiển đèn VÀ LƯU LẠI LOG ---
    @PostMapping("/{deviceId}/control")
    public ResponseEntity<?> controlDevice(@PathVariable Long deviceId, @RequestBody ControlRequest request) {
        // 1. Tìm xem thiết bị có tồn tại trong DB không
        Optional<Device> deviceOptional = deviceRepository.findById(deviceId);
        if (deviceOptional.isEmpty()) {
            return ResponseEntity.status(404).body("Device not found with id: " + deviceId);
        }
        
        // 2. Nếu thiết bị tồn tại, gửi lệnh MQTT
        try {
            String command = request.getCommand().toUpperCase();
            mqttGateway.sendToMqtt(command, "esp32/control");

            // 3. TẠO VÀ LƯU LOG VÀO DATABASE
            ControlLog newLog = new ControlLog();
            newLog.setAction(command);
            newLog.setDevice(deviceOptional.get()); // Gán log này cho thiết bị vừa tìm được
            controlLogRepository.save(newLog);

            return ResponseEntity.ok("Command '" + command + "' sent and logged successfully!");

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Failed to send command: " + e.getMessage());
        }
    }
}