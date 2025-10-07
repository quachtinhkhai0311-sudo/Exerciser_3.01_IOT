package com.example.demoiot;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DeviceRepository extends JpaRepository<Device, Long> {
    // Spring Data JPA sẽ tự động cung cấp các hàm như save(), findById(), findAll()...
}