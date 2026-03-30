# Phase 1: Environment Setup & Component Testing

**Duration:** Week 1-2  
**Goal:** Verify all components work independently before integration

---

## 1.1 Software Environment Setup

### Install PlatformIO

```bash
# Install VSCode (if not already installed)
# https://code.visualstudio.com/

# Then install PlatformIO extension
# Open VSCode → Extensions → search "PlatformIO" → Install
```

### Create PlatformIO Project

```bash
cd /home/ubuntu/.openclaw/workspace/esp32-moving-head-light/firmware

# Initialize PlatformIO project (already done, but verify)
pio project init --board esp32dev --framework arduino
```

### Install Required Libraries

```bash
# Add to platformio.ini under [env:esp32dev]:
lib_deps =
    adafruit/Adafruit NeoPixel@^1.11.3
    ESP32Servo@^0.13.0
```

**Or install via CLI:**
```bash
pio lib install "Adafruit NeoPixel" "ESP32Servo"
```

---

## 1.2 Hardware Setup: Breadboard Testing

### Wiring Diagram (Breadboard Layout)

```
ESP32 DevKit Pinout:
GND ────────────────┐
                    │
5V (from USB) ──────┤
                    │
GPIO 2 ──── LED (WS2812B) ────────── GND
GPIO 4 ──── Servo 1 (Pan) ────────── GND
GPIO 5 ──── Servo 2 (Tilt) ───────── GND
GPIO 18 ──── Servo 3 (Roll) ────────── GND

Servo Power Rail (separate from ESP32):
5V (BEC Module) ────┬─────────────── Servo Power
                    │
GND ────────────────┴─────────────── Servo GND
```

### Step 1: Prepare Breadboard

1. Place ESP32 DevKit in center
2. Create two power rails: 3.3V (for ESP32 logic) and 5V (for servos/LED)
3. Create multiple GND rails
4. Add 100µF capacitor across 5V and GND (servo power stability)

### Step 2: Connect USB Power

- USB-C module 5V → 5V power rail
- USB-C module GND → GND rail
- ESP32 5V input → 5V power rail
- ESP32 GND → GND rail

### Step 3: Test Power

```bash
# Plug in USB and verify:
# - ESP32 LED lights up
# - No burning smell or smoke
# - USB-C module shows stable 5V output
```

---

## 1.3 Test 1: Servo Control

### Code: Basic Servo Test

Create `firmware/src/servo_test.cpp`:

```cpp
#include <Arduino.h>
#include <ESP32Servo.h>

// Servo pins
#define SERVO_PIN_PAN 4
#define SERVO_PIN_TILT 5
#define SERVO_PIN_ROLL 18

Servo servoPan, servoTilt, servoRoll;

void setup() {
  Serial.begin(115200);
  delay(2000);
  
  Serial.println("Servo Test Starting...");
  
  // Attach servos
  servoPan.attach(SERVO_PIN_PAN);
  servoTilt.attach(SERVO_PIN_TILT);
  servoRoll.attach(SERVO_PIN_ROLL);
  
  // Move to center (90 degrees)
  servoPan.write(90);
  servoTilt.write(90);
  servoRoll.write(90);
  
  Serial.println("Servos initialized to 90°");
}

void loop() {
  // Sweep pan servo
  for (int angle = 0; angle <= 180; angle += 5) {
    servoPan.write(angle);
    Serial.print("Pan: ");
    Serial.println(angle);
    delay(100);
  }
  
  for (int angle = 180; angle >= 0; angle -= 5) {
    servoPan.write(angle);
    Serial.print("Pan: ");
    Serial.println(angle);
    delay(100);
  }
  
  delay(500);
}
```

### Upload & Test

```bash
cd firmware
pio run -t upload -e esp32dev

# Open serial monitor
pio device monitor --baud 115200
```

### Expected Results

✅ **Success:**
- Serial output shows "Servo Test Starting..."
- Pan servo sweeps left-right smoothly
- No jittering or stuttering

❌ **If Servo Doesn't Move:**
1. Check pin connections (GPIO 4 specifically)
2. Verify servo power supply (5V rail should be stable)
3. Test with a different servo
4. Check that ESP32Servo library is installed

---

## 1.4 Test 2: RGB LED Control

### Code: WS2812B LED Test

Create `firmware/src/led_test.cpp`:

```cpp
#include <Arduino.h>
#include <Adafruit_NeoPixel.h>

// LED pin and count
#define LED_PIN 2
#define LED_COUNT 1  // Single LED module

Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(115200);
  delay(2000);
  
  Serial.println("RGB LED Test Starting...");
  
  // Initialize NeoPixel
  strip.begin();
  strip.show();
  
  Serial.println("LED initialized");
}

void loop() {
  // Red
  strip.setPixelColor(0, strip.Color(255, 0, 0));
  strip.show();
  Serial.println("Red");
  delay(1000);
  
  // Green
  strip.setPixelColor(0, strip.Color(0, 255, 0));
  strip.show();
  Serial.println("Green");
  delay(1000);
  
  // Blue
  strip.setPixelColor(0, strip.Color(0, 0, 255));
  strip.show();
  Serial.println("Blue");
  delay(1000);
  
  // White (full brightness)
  strip.setPixelColor(0, strip.Color(255, 255, 255));
  strip.show();
  Serial.println("White");
  delay(1000);
  
  // Off
  strip.setPixelColor(0, strip.Color(0, 0, 0));
  strip.show();
  Serial.println("Off");
  delay(1000);
}
```

### Upload & Test

```bash
# Switch to LED test (or create separate project)
pio run -t upload -e esp32dev
pio device monitor --baud 115200
```

### Expected Results

✅ **Success:**
- LED cycles through red → green → blue → white → off
- Colors are bright and distinct
- Serial monitor shows color names

❌ **If LED Doesn't Light:**
1. Check pin connection (GPIO 2)
2. Verify 5V power to LED module
3. Check data line continuity
4. Try reducing brightness in code (change 255 → 128)

---

## 1.5 Test 3: Power Management

### Code: Power Detection & Switching

Create `firmware/src/power_test.cpp`:

```cpp
#include <Arduino.h>

#define USB_DETECT_PIN 33  // GPIO33 connected to USB-C presence pin
#define BATTERY_ADC_PIN 34  // GPIO34 reads battery voltage

void setup() {
  Serial.begin(115200);
  delay(2000);
  
  Serial.println("Power Management Test Starting...");
  
  pinMode(USB_DETECT_PIN, INPUT);
  analogSetAttenuation(ADC_11db);  // Full range 0-3.3V
}

void loop() {
  // Check USB power
  bool usbConnected = digitalRead(USB_DETECT_PIN);
  
  // Read battery voltage (if installed)
  int rawBattery = analogRead(BATTERY_ADC_PIN);
  float batteryVoltage = (rawBattery / 4095.0) * 3.3 * 2;  // Convert to voltage
  
  Serial.print("USB Connected: ");
  Serial.println(usbConnected ? "YES" : "NO");
  
  Serial.print("Battery Voltage: ");
  Serial.print(batteryVoltage);
  Serial.println("V");
  
  Serial.println("---");
  delay(2000);
}
```

### Expected Results

✅ **Success:**
- USB Connected shows YES when plugged in
- Battery voltage reads around 3.7V (if 18650 installed)
- Values update every 2 seconds

---

## 1.6 Integration Checklist

By end of Phase 1, verify:

- [ ] PlatformIO environment installed and working
- [ ] ESP32 uploads code successfully
- [ ] Serial monitor communicates at 115200 baud
- [ ] Servo 1 (Pan) sweeps smoothly
- [ ] Servo 2 (Tilt) sweeps smoothly
- [ ] Servo 3 (Roll) sweeps smoothly
- [ ] RGB LED cycles through all colors
- [ ] No power brownout issues
- [ ] All components respond to commands
- [ ] USB power detected correctly
- [ ] Battery voltage readable (if installed)

---

## 1.7 Troubleshooting Reference

| Issue | Cause | Solution |
|-------|-------|----------|
| ESP32 won't upload | Driver missing | Install CH340 driver |
| Servo doesn't move | Wrong pin | Verify GPIO pin in code matches breadboard |
| Servo moves but stutters | Power unstable | Add 100µF capacitor across servo power |
| LED won't light | Wrong library | Reinstall Adafruit NeoPixel via pio lib |
| Serial port not found | USB connection | Try different USB cable, restart IDE |
| Brownout error on upload | Power glitch | Use better USB cable, external power |

---

## 1.8 Parts Checklist

Before starting Phase 1, ensure you have:

- [ ] ESP32 DevKit
- [ ] 3× SG90 Servo motors
- [ ] WS2812B RGB LED module
- [ ] USB-C power module
- [ ] Breadboard
- [ ] Jumper wires (male-male)
- [ ] 100µF capacitor
- [ ] USB-C cable
- [ ] Computer with VSCode + PlatformIO

---

**Next Phase:** [Phase 2: Firmware Architecture & Web Interface](./phase2-firmware.md)
