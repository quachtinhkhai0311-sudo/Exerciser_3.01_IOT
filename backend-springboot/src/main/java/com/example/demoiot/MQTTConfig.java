package com.example.demoiot;

import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.integration.channel.DirectChannel;
import org.springframework.integration.mqtt.core.DefaultMqttPahoClientFactory;
import org.springframework.integration.mqtt.core.MqttPahoClientFactory;
import org.springframework.integration.mqtt.outbound.MqttPahoMessageHandler;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.MessageHandler;

@Configuration
public class MQTTConfig {

    // Đọc các giá trị từ file application.properties
    // Sửa các dòng @Value ở đây

    @Value("${mqtt.server.uri}") // Đổi từ mqtt.broker.url
    private String serverUri; // Đổi tên biến cho rõ nghĩa

    @Value("${mqtt.client.id}")
    private String clientId;

    @Value("${mqtt.server.username}") // Đổi từ mqtt.broker.username
    private String username;

    @Value("${mqtt.server.password}") // Đổi từ mqtt.broker.password
    private String password;

    // --- Cấu hình Client Factory ---
    // Đây là nơi thiết lập thông tin kết nối (URL, username, password)
    // --- Cấu hình Client Factory ---
    // Đây là nơi thiết lập thông tin kết nối (URL, username, password)
    @Bean
    public MqttPahoClientFactory mqttClientFactory() {
        // Tạo một đối tượng để chứa các tùy chọn kết nối
        MqttConnectOptions options = new MqttConnectOptions();

        // Đặt URL của broker. Lưu ý: nó cần một mảng String[]
        options.setServerURIs(new String[] { serverUri });
        options.setUserName(username);
        // Đặt mật khẩu. Lưu ý: nó cần một mảng char[] vì lý do bảo mật
        options.setPassword(password.toCharArray());
        options.setCleanSession(true); // Bắt đầu một session sạch mỗi lần kết nối

        // Tạo Client Factory
        DefaultMqttPahoClientFactory factory = new DefaultMqttPahoClientFactory();
        // Đưa toàn bộ đối tượng options vào factory
        factory.setConnectionOptions(options);

        return factory;
    }

    // --- Cấu hình luồng gửi tin nhắn đi ---
    @Bean
    public MessageChannel mqttOutboundChannel() {
        return new DirectChannel();
    }

    // --- Cấu hình Message Handler cho việc gửi tin nhắn ---
    // Nó sẽ lắng nghe các tin nhắn trên "mqttOutboundChannel" và gửi chúng đến
    // broker
    @Bean
    @ServiceActivator(inputChannel = "mqttOutboundChannel")
    public MessageHandler mqttOutbound() {
        MqttPahoMessageHandler messageHandler = new MqttPahoMessageHandler(clientId, mqttClientFactory());
        messageHandler.setAsync(true);
        messageHandler.setDefaultTopic("default/topic"); // Một topic mặc định, chúng ta sẽ ghi đè sau
        return messageHandler;
    }
}