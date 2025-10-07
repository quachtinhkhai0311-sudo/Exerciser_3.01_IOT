#include <WiFi.h>
#include <WiFiManager.h>
#include <PubSubClient.h>

// THÊM THƯ VIỆN VÀ ĐỊNH NGHĨA NEOPIXEL
#include <Adafruit_NeoPixel.h>
#define LED_PIN    48
#define LED_COUNT  1
Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);


// --- Cấu hình MQTT (giữ nguyên) ---
const char* mqtt_server = "v16c1ee6.ala.eu-central-1.emqxsl.com";
const int mqtt_port = 8883;
const char* mqtt_user = "esp32_user";
const char* mqtt_password = "esp32_user";
const char* control_topic = "esp32/control";

#include <WiFiClientSecure.h>
WiFiClientSecure espClient;
PubSubClient client(espClient);


void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  String message = "";
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  Serial.println(message);

  if (String(topic) == control_topic) {
    if (message == "ON") {
      // Bật đèn màu XANH LÁ
      strip.setPixelColor(0, strip.Color(0, 255, 0));
      strip.show();
    } else if (message == "OFF") {
      // Tắt đèn (màu ĐEN)
      strip.setPixelColor(0, strip.Color(0, 0, 0));
      strip.show();
    }
  }
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    if (client.connect("ESP32Client", mqtt_user, mqtt_password)) {
      Serial.println("connected");
      client.subscribe(control_topic);
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void setup() {
  Serial.begin(115200);
  
  // KHỞI ĐỘNG NEOPIXEL
  strip.begin();
  strip.show();
  strip.setBrightness(50);
  
  // --- PHẦN KẾT NỐI WIFI DÙNG WIFIMANAGER ---
  WiFiManager wm;
  if (!wm.autoConnect("AutoConnectAP", "password")) {
    Serial.println("Failed to connect and hit timeout");
    ESP.restart();
  }
  Serial.println("WiFi connected!");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  espClient.setInsecure();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
}