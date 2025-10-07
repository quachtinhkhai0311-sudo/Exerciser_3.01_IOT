package com.example.demoiot;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;

@Entity // Đánh dấu đây là một Entity, tương ứng với một bảng trong DB
@Data   // Lombok tự tạo getter, setter, toString...
public class Device {

    @Id // Đánh dấu đây là khóa chính
    @GeneratedValue(strategy = GenerationType.IDENTITY) // ID sẽ tự động tăng
    private Long id;

    private String name;

    // Thêm các thuộc tính khác nếu bạn muốn, ví dụ: location, status...
}