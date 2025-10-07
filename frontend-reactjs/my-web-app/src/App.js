import React, { useState, useEffect } from 'react';
import './App.css';

// URL của backend Spring Boot
const API_URL = 'http://localhost:8080/api/device';

function App() {
  const [devices, setDevices] = useState([]);
  const [newDeviceName, setNewDeviceName] = useState('');

  // Hàm để lấy danh sách thiết bị từ backend
  const fetchDevices = async () => {
    try {
      const response = await fetch(API_URL);
      const data = await response.json();
      setDevices(data);
    } catch (error) {
      console.error('Lỗi khi lấy danh sách thiết bị:', error);
    }
  };

  // useEffect sẽ chạy một lần khi component được render lần đầu
  useEffect(() => {
    fetchDevices();
  }, []);

  // Hàm để gửi lệnh điều khiển (ON/OFF)
  const handleControl = async (deviceId, command) => {
    try {
      await fetch(`${API_URL}/${deviceId}/control`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ command: command }),
      });
      console.log(`Đã gửi lệnh ${command} tới thiết bị ${deviceId}`);
      // Không cần làm gì thêm, vì đèn LED thật đã thay đổi
    } catch (error) {
      console.error('Lỗi khi gửi lệnh điều khiển:', error);
    }
  };

  // Hàm để đăng ký thiết bị mới
  const handleRegister = async (e) => {
    e.preventDefault(); // Ngăn form reload lại trang
    if (!newDeviceName) return;

    try {
      await fetch(`${API_URL}/register`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: newDeviceName }),
      });
      setNewDeviceName(''); // Xóa nội dung trong ô input
      fetchDevices(); // Lấy lại danh sách thiết bị để cập nhật giao diện
    } catch (error) {
      console.error('Lỗi khi đăng ký thiết bị:', error);
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>Bảng điều khiển thiết bị IoT</h1>

        {/* Form đăng ký thiết bị mới */}
        <form onSubmit={handleRegister} className="register-form">
          <input
            type="text"
            value={newDeviceName}
            onChange={(e) => setNewDeviceName(e.target.value)}
            placeholder="Tên thiết bị mới"
          />
          <button type="submit">Đăng ký</button>
        </form>

        {/* Danh sách các thiết bị */}
        <div className="device-list">
          {devices.map((device) => (
            <div key={device.id} className="device-card">
              <h2>{device.name} (ID: {device.id})</h2>
              <div className="button-group">
                <button className="on-button" onClick={() => handleControl(device.id, 'ON')}>
                  BẬT
                </button>
                <button className="off-button" onClick={() => handleControl(device.id, 'OFF')}>
                  TẮT
                </button>
              </div>
            </div>
          ))}
        </div>
      </header>
    </div>
  );
}

export default App;