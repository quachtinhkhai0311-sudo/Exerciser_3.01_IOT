package com.example.demoiot; // Hãy chắc chắn package này đúng với dự án của bạn

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ControlLogRepository extends JpaRepository<ControlLog, Long> {
    // Để trống phần thân interface này.
    // Spring Data JPA sẽ tự động cung cấp các hàm cần thiết như save(), findAll()...
}