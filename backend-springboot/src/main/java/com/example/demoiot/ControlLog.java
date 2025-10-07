package com.example.demoiot;

import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;
import java.time.LocalDateTime;

@Entity
@Data
public class ControlLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String action; // Sẽ lưu "ON" hoặc "OFF"

    @CreationTimestamp // Tự động điền thời gian hiện tại khi một log được tạo
    private LocalDateTime timestamp;

    // Thiết lập mối quan hệ: Nhiều log thuộc về một thiết bị
    @ManyToOne
    @JoinColumn(name = "device_id")
    private Device device;
}