package com.example.demoiot; // Phải cùng package với DeviceController

public class ControlRequest {

    // Tên thuộc tính này ("command") phải khớp chính xác với
    // key trong JSON mà curl gửi lên: {"command":"ON"}
    private String command;

    // Spring Boot cần các hàm getter và setter để hoạt động
    public String getCommand() {
        return command;
    }

    public void setCommand(String command) {
        this.command = command;
    }
       // --- THÊM HÀM NÀY VÀO ---
    @Override
    public String toString() {
        return "ControlRequest{" +
                "command='" + command + '\'' +
                '}';
    }
    // -------------------------
}