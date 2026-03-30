# Phase 2: Firmware Architecture & Web Interface

**Duration:** Week 3-4  
**Goal:** Integrate all components into a unified firmware with WiFi control

---

## 2.1 Firmware Architecture Overview

```
┌─────────────────────────────────────────────┐
│         Main Application Loop               │
│  (setup/loop in main.cpp)                   │
└────────────────────┬────────────────────────┘
                     │
        ┌────────────┴────────────┬───────────┬──────────┐
        │                         │           │          │
   ┌────▼────┐          ┌────────▼───┐  ┌───▼──────┐  ┌──▼────────┐
   │ WiFi    │          │ Servo      │  │ LED      │  │ Web       │
   │Manager  │          │Controller  │  │Control   │  │ Server    │
   └────┬────┘          └────┬───────┘  └───┬──────┘  └──┬────────┘
        │                    │              │          │
        │              ┌─────┴─────┐        │          │
        │              │ PWM Pins  │        │          │
        │              │ 4,5,18    │        │          │
        │              └───────────┘        │          │
        │                                   │          │
        └────────────────────────────────────┼──────────┤
                                             │          │
                                       ┌─────▼──┐   ┌──▼────────┐
                                       │ GPIO 2 │   │ HTTP API  │
                                       │ (LED)  │   │ /api/*    │
                                       └────────┘   └───────────┘
```

### Module Structure

```
firmware/src/
├── main.cpp                 # Entry point, event loop
├── config.h                 # Constants, pins, WiFi config
│
├── WiFiManager.h/.cpp       # WiFi connection, OTA updates
├── WebServer.h/.cpp         # HTTP REST API, Web dashboard
│
├── ServoController.h/.cpp   # Pan/Tilt/Roll servo control
├── RGBController.h/.cpp     # WS2812B LED control
├── PowerManager.h/.cpp      # USB/Battery detection & switching
│
└── animations.h/.cpp        # Built-in light patterns
```

---

## 2.2 Core Module: Servo Controller

### `firmware/src/ServoController.h`

```cpp
#ifndef SERVO_CONTROLLER_H
#define SERVO_CONTROLLER_H

#include <ESP32Servo.h>

class ServoController {
private:
  Servo servoPan, servoTilt, servoRoll;
  
  // Current positions (0-180)
  int currentPan = 90;
  int currentTilt = 90;
  int currentRoll = 90;
  
  // Speed control (milliseconds per degree)
  int speed = 20;
  
public:
  // Initialize servos
  void begin(int pinPan, int pinTilt, int pinRoll);
  
  // Set angles (with interpolation)
  void setPan(int angle, bool smooth = true);
  void setTilt(int angle, bool smooth = true);
  void setRoll(int angle, bool smooth = true);
  
  // Get current positions
  int getPan() { return currentPan; }
  int getTilt() { return currentTilt; }
  int getRoll() { return currentRoll; }
  
  // Set speed (degrees per second)
  void setSpeed(int degreesPerSecond);
  
  // Preset positions
  void center() { setPan(90); setTilt(90); setRoll(90); }
  void home() { center(); }
};

#endif
```

### `firmware/src/ServoController.cpp`

```cpp
#include "ServoController.h"
#include <Arduino.h>

void ServoController::begin(int pinPan, int pinTilt, int pinRoll) {
  servoPan.attach(pinPan);
  servoTilt.attach(pinTilt);
  servoRoll.attach(pinRoll);
  
  // Initialize to center
  servoPan.write(90);
  servoTilt.write(90);
  servoRoll.write(90);
  
  Serial.println("[ServoController] Initialized");
}

void ServoController::setPan(int angle, bool smooth) {
  if (smooth) {
    // Smooth interpolation
    int step = (angle > currentPan) ? 1 : -1;
    for (int pos = currentPan; pos != angle; pos += step) {
      servoPan.write(pos);
      delay(speed);
    }
  }
  servoPan.write(angle);
  currentPan = angle;
}

void ServoController::setTilt(int angle, bool smooth) {
  if (smooth) {
    int step = (angle > currentTilt) ? 1 : -1;
    for (int pos = currentTilt; pos != angle; pos += step) {
      servoTilt.write(pos);
      delay(speed);
    }
  }
  servoTilt.write(angle);
  currentTilt = angle;
}

void ServoController::setRoll(int angle, bool smooth) {
  if (smooth) {
    int step = (angle > currentRoll) ? 1 : -1;
    for (int pos = currentRoll; pos != angle; pos += step) {
      servoRoll.write(pos);
      delay(speed);
    }
  }
  servoRoll.write(angle);
  currentRoll = angle;
}

void ServoController::setSpeed(int degreesPerSecond) {
  speed = max(1, 1000 / degreesPerSecond);  // Convert to milliseconds per degree
}
```

---

## 2.3 Core Module: RGB Controller

### `firmware/src/RGBController.h`

```cpp
#ifndef RGB_CONTROLLER_H
#define RGB_CONTROLLER_H

#include <Adafruit_NeoPixel.h>

class RGBController {
private:
  Adafruit_NeoPixel strip;
  
  // Current color
  uint8_t r, g, b;
  
  // Brightness (0-255)
  uint8_t brightness = 255;
  
public:
  RGBController(int pin, int count);
  
  // Initialize LED
  void begin();
  
  // Set color
  void setColor(uint8_t red, uint8_t green, uint8_t blue);
  void setColor(uint32_t rgb);  // Hex color
  void setColor(const char* hexColor);  // "#FF00FF" format
  
  // Get current color
  void getColor(uint8_t& red, uint8_t& green, uint8_t& blue);
  uint32_t getColorHex();
  
  // Brightness control
  void setBrightness(uint8_t level);  // 0-255
  uint8_t getBrightness() { return brightness; }
  
  // Special effects
  void pulse(int duration);
  void strobe(int duration, int flashCount);
  void rainbow(int duration);
  void off();
  
  // Show/update
  void show();
};

#endif
```

### `firmware/src/RGBController.cpp`

```cpp
#include "RGBController.h"
#include <Arduino.h>

RGBController::RGBController(int pin, int count) 
  : strip(count, pin, NEO_GRB + NEO_KHZ800), r(255), g(255), b(255) {}

void RGBController::begin() {
  strip.begin();
  strip.show();
  Serial.println("[RGBController] Initialized");
}

void RGBController::setColor(uint8_t red, uint8_t green, uint8_t blue) {
  r = red;
  g = green;
  b = blue;
  strip.setPixelColor(0, strip.Color(r, g, b));
  strip.show();
}

void RGBController::setColor(const char* hexColor) {
  // Parse hex string like "#FF00FF"
  if (hexColor[0] == '#') {
    uint32_t hex = strtol(&hexColor[1], NULL, 16);
    r = (hex >> 16) & 0xFF;
    g = (hex >> 8) & 0xFF;
    b = hex & 0xFF;
    strip.setPixelColor(0, strip.Color(r, g, b));
    strip.show();
  }
}

void RGBController::setBrightness(uint8_t level) {
  brightness = level;
  strip.setBrightness(brightness);
  strip.show();
}

void RGBController::pulse(int duration) {
  int steps = 20;
  for (int i = 0; i < steps; i++) {
    strip.setBrightness((i * 255) / steps);
    strip.show();
    delay(duration / steps);
  }
  for (int i = steps; i > 0; i--) {
    strip.setBrightness((i * 255) / steps);
    strip.show();
    delay(duration / steps);
  }
}

void RGBController::off() {
  setColor(0, 0, 0);
}
```

---

## 2.4 Core Module: WiFi Manager

### `firmware/src/WiFiManager.h`

```cpp
#ifndef WIFI_MANAGER_H
#define WIFI_MANAGER_H

#include <WiFi.h>
#include <ArduinoOTA.h>

class WiFiManager {
private:
  const char* ssid;
  const char* password;
  const char* hostname;
  
  bool connected = false;
  
public:
  WiFiManager(const char* ssid, const char* password, const char* hostname);
  
  // Connect to WiFi
  bool connect();
  
  // Check connection status
  bool isConnected() { return WiFi.status() == WL_CONNECTED; }
  
  // Get IP address
  String getIP() { return WiFi.localIP().toString(); }
  
  // OTA update setup
  void setupOTA();
  
  // Handle events
  void update();
};

#endif
```

### `firmware/src/WiFiManager.cpp`

```cpp
#include "WiFiManager.h"
#include <Arduino.h>

WiFiManager::WiFiManager(const char* ssid, const char* password, const char* hostname)
  : ssid(ssid), password(password), hostname(hostname) {}

bool WiFiManager::connect() {
  Serial.print("[WiFi] Connecting to ");
  Serial.println(ssid);
  
  WiFi.mode(WIFI_STA);
  WiFi.setHostname(hostname);
  WiFi.begin(ssid, password);
  
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 20) {
    delay(500);
    Serial.print(".");
    attempts++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\n[WiFi] Connected!");
    Serial.print("[WiFi] IP: ");
    Serial.println(getIP());
    connected = true;
    return true;
  } else {
    Serial.println("\n[WiFi] Connection failed!");
    return false;
  }
}

void WiFiManager::setupOTA() {
  ArduinoOTA.setHostname(hostname);
  ArduinoOTA.begin();
  Serial.println("[OTA] Enabled");
}

void WiFiManager::update() {
  if (isConnected()) {
    ArduinoOTA.handle();
  }
}
```

---

## 2.5 Web Server & REST API

### `firmware/src/WebServer.h`

```cpp
#ifndef WEB_SERVER_H
#define WEB_SERVER_H

#include <WebServer.h>
#include "ServoController.h"
#include "RGBController.h"

class WebServerManager {
private:
  WebServer server;
  ServoController* servo;
  RGBController* rgb;
  
  // API endpoints
  void handleGetStatus();
  void handleSetColor();
  void handleSetPosition();
  void handleGetControl();
  
public:
  WebServerManager(int port = 80);
  
  void setControllers(ServoController* s, RGBController* r) {
    servo = s;
    rgb = r;
  }
  
  void begin();
  void handleClient();
};

#endif
```

### `firmware/src/WebServer.cpp`

```cpp
#include "WebServer.h"
#include <Arduino.h>

WebServerManager::WebServerManager(int port) : server(port) {}

void WebServerManager::begin() {
  // REST API endpoints
  server.on("/api/status", HTTP_GET, [this]() { handleGetStatus(); });
  server.on("/api/color", HTTP_POST, [this]() { handleSetColor(); });
  server.on("/api/position", HTTP_POST, [this]() { handleSetPosition(); });
  server.on("/", HTTP_GET, [this]() { handleGetControl(); });
  
  server.begin();
  Serial.println("[WebServer] Started on port 80");
}

void WebServerManager::handleGetStatus() {
  // Return current state as JSON
  String json = "{";
  json += "\"pan\":" + String(servo->getPan()) + ",";
  json += "\"tilt\":" + String(servo->getTilt()) + ",";
  json += "\"roll\":" + String(servo->getRoll());
  json += "}";
  
  server.send(200, "application/json", json);
}

void WebServerManager::handleSetColor() {
  if (server.hasArg("color")) {
    String color = server.arg("color");  // Expected format: "#FF00FF"
    rgb->setColor(color.c_str());
    server.send(200, "application/json", "{\"status\":\"ok\"}");
  } else {
    server.send(400, "application/json", "{\"error\":\"Missing color param\"}");
  }
}

void WebServerManager::handleSetPosition() {
  bool ok = true;
  if (server.hasArg("pan")) {
    servo->setPan(server.arg("pan").toInt());
  }
  if (server.hasArg("tilt")) {
    servo->setTilt(server.arg("tilt").toInt());
  }
  if (server.hasArg("roll")) {
    servo->setRoll(server.arg("roll").toInt());
  }
  
  server.send(200, "application/json", "{\"status\":\"ok\"}");
}

void WebServerManager::handleGetControl() {
  String html = R"(
    <!DOCTYPE html>
    <html>
    <head>
      <title>ESP32 Moving Head</title>
      <style>
        body { font-family: Arial; margin: 20px; }
        .control { margin: 10px 0; }
        button { padding: 10px 20px; font-size: 16px; }
        input { padding: 5px; width: 100px; }
      </style>
    </head>
    <body>
      <h1>ESP32 Moving Head Light</h1>
      
      <div class="control">
        <h3>Color Control</h3>
        <input type="color" id="colorPicker" value="#FF0000">
        <button onclick="setColor()">Set Color</button>
      </div>
      
      <div class="control">
        <h3>Position Control</h3>
        <label>Pan: <input type="range" id="pan" min="0" max="180" value="90"></label><br>
        <label>Tilt: <input type="range" id="tilt" min="0" max="180" value="90"></label><br>
        <label>Roll: <input type="range" id="roll" min="0" max="180" value="90"></label><br>
        <button onclick="setPosition()">Update Position</button>
      </div>
      
      <script>
        function setColor() {
          let color = document.getElementById('colorPicker').value;
          fetch('/api/color?color=' + color);
        }
        
        function setPosition() {
          let pan = document.getElementById('pan').value;
          let tilt = document.getElementById('tilt').value;
          let roll = document.getElementById('roll').value;
          fetch('/api/position?pan=' + pan + '&tilt=' + tilt + '&roll=' + roll);
        }
      </script>
    </body>
    </html>
  )";
  
  server.send(200, "text/html", html);
}

void WebServerManager::handleClient() {
  server.handleClient();
}
```

---

## 2.6 Main Application

### `firmware/src/main.cpp` (Updated)

```cpp
#include <Arduino.h>
#include "config.h"
#include "WiFiManager.h"
#include "WebServer.h"
#include "ServoController.h"
#include "RGBController.h"

// Global objects
WiFiManager wifiManager(WIFI_SSID, WIFI_PASSWORD, "moving-head-light");
ServoController servoController;
RGBController rgbController(PIN_LED, 1);
WebServerManager webServer(80);

void setup() {
  Serial.begin(115200);
  delay(2000);
  
  Serial.println("\n\n=== ESP32 Moving Head Light ===");
  Serial.println("Version: 1.0.0");
  
  // Initialize servo controller
  servoController.begin(PIN_SERVO_PAN, PIN_SERVO_TILT, PIN_SERVO_ROLL);
  servoController.center();
  
  // Initialize RGB controller
  rgbController.begin();
  rgbController.setColor(0, 255, 0);  // Start with green
  
  // Connect to WiFi
  if (wifiManager.connect()) {
    // Setup OTA updates
    wifiManager.setupOTA();
    
    // Setup web server
    webServer.setControllers(&servoController, &rgbController);
    webServer.begin();
    
    Serial.print("Access web interface at: http://");
    Serial.println(wifiManager.getIP());
  } else {
    Serial.println("WiFi failed - running in offline mode");
  }
  
  Serial.println("=== Setup Complete ===\n");
}

void loop() {
  // Handle OTA updates
  if (wifiManager.isConnected()) {
    wifiManager.update();
  }
  
  // Handle web requests
  if (wifiManager.isConnected()) {
    webServer.handleClient();
  }
  
  // Keep alive
  delay(10);
}
```

---

## 2.7 Configuration File

### `firmware/src/config.h` (Updated)

```cpp
#ifndef CONFIG_H
#define CONFIG_H

// WiFi Configuration
#define WIFI_SSID "YourSSID"
#define WIFI_PASSWORD "YourPassword"

// Device Configuration
#define DEVICE_NAME "ESP32-MovingHeadLight"
#define DEVICE_VERSION "1.0.0"

// Pin Assignments
#define PIN_SERVO_PAN 4
#define PIN_SERVO_TILT 5
#define PIN_SERVO_ROLL 18
#define PIN_LED 2

#endif
```

---

## 2.8 Build & Deploy

### Compile

```bash
cd firmware
pio run -e esp32dev
```

### Upload

```bash
pio run -t upload -e esp32dev
```

### Monitor

```bash
pio device monitor --baud 115200
```

### Access Web Interface

1. Open browser
2. Go to `http://192.168.X.X` (replace with ESP32's IP)
3. Use color picker and sliders to control light

---

## 2.9 API Reference

| Endpoint | Method | Parameters | Description |
|----------|--------|------------|-------------|
| `/` | GET | — | Web control dashboard |
| `/api/status` | GET | — | Get current position/color |
| `/api/color` | POST | `color=#RRGGBB` | Set LED color |
| `/api/position` | POST | `pan=0-180&tilt=0-180&roll=0-180` | Set servo positions |

---

## 2.10 Phase 2 Checklist

By end of Phase 2, verify:

- [ ] Servo controller compiles and moves servos
- [ ] RGB controller compiles and changes colors
- [ ] WiFi manager connects to network
- [ ] Web server responds at http://ESP_IP/
- [ ] Color picker updates LED
- [ ] Position sliders move servos
- [ ] JSON API endpoints working
- [ ] OTA updates enabled
- [ ] No memory leaks or crashes after 1 hour

---

**Next Phase:** [Phase 3: Mechanical Design & 3D Printing](./phase3-mechanical.md)
