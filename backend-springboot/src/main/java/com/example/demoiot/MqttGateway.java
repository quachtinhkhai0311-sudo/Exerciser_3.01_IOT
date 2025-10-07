package com.example.demoiot;

import org.springframework.integration.annotation.MessagingGateway;
import org.springframework.integration.mqtt.support.MqttHeaders;
import org.springframework.messaging.handler.annotation.Header;

// Định nghĩa một cổng giao tiếp với kênh "mqttOutboundChannel" đã tạo ở MQTTConfig
@MessagingGateway(defaultRequestChannel = "mqttOutboundChannel")
public interface MqttGateway {

    // Định nghĩa một hàm: sendToMqtt
    // Khi gọi hàm này, nó sẽ gửi `payload` đến `topic` được chỉ định
    void sendToMqtt(String payload, @Header(MqttHeaders.TOPIC) String topic);

}