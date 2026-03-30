# ESP32 Moving Head Light - Design Specification

**Project:** Miniature 3-Axis RGB Moving Head Light  
**Status:** Concept/Design Phase  
**Target:** Prototype (proof of concept)  
**Date:** 2026-03-30

---

## 1. Product Overview

A miniature moving head light with 3-axis motion control (pan, tilt, roll) featuring an RGB LED. Controlled via WiFi or physical interface. Powered by USB or battery. Roughly tennis ball sized (~6-8cm).

### Use Cases
- Stage/event lighting prototype
- Photography/video accent lighting
- Educational/maker project
- Demonstration of 3-axis motion control

---

## 2. Motion System (3-Axis)

### Axis Definitions
| Axis | Motion | Range | Purpose |
|------|--------|-------|---------|
| **Pan** | Horizontal (side-to-side) | 0-360° continuous or 180° limited | Left/right sweep |
| **Tilt** | Vertical (up-down) | 0-180° or 90° limited | Up/down tilt |
| **Roll** | Rotation (spin on LED axis) | 0-360° continuous or limited | Light effect rotation |

### Motor Selection (Low-Cost Criteria)

**Recommended:** SG90 Servo Motors (Pan & Tilt) + Optional Roll
- **Why:** Cheap ($3-5 each), readily available, low power, simple control
- **Spec:** 9g, 3.7V, 4.8V or 6V
- **Torque:** ~1.7 kg·cm (sufficient for miniature design)
- **Speed:** ~0.12 sec/60° at 5V
- **Control:** Standard PWM (ESP32 native)

**Alternative for Roll:** 
- Continuous rotation servo (~$5-8)
- Small brushless motor with ESC (~$8-12)
- **Decision:** Start with servo, evaluate if roll is necessary

### Mechanical Design
- **Pan Base:** Rotating platform using servo horn or custom bracket
- **Tilt Assembly:** Servo on pan platform, LED head attached to tilt servo
- **Roll (Optional):** Third servo or brushless motor on tilt servo arm
- **Frame:** 3D printed PLA/PETG support structure

---

## 3. Optical System (RGB LED)

### LED Module Selection
**Recommended:** WS2812B RGB LED Module or Common Cathode RGB LED

| Option | Type | Cost | Pros | Cons |
|--------|------|------|------|------|
| **WS2812B** | Addressable RGB LED | $1-2 | Individual brightness control, chainable, color precise | More complex code |
| **Common Cathode RGB** | Standard RGB LED | $0.50 | Simple PWM control, easy to use | Need resistors/transistors |
| **RGB LED Module** | Pre-built with resistors | $2-3 | Ready to use, just PWM | Less flexible |

**Recommendation:** WS2812B (or WS2811 variant) - easiest for color control, good brightness

### Specifications
- **Brightness:** ~800-1200 lumens (RGB combined)
- **Color:** Full RGB spectrum
- **Power Draw:** ~60mA at full brightness white
- **Voltage:** 5V DC

### Optical Housing
- Reflector cone (3D printed or off-the-shelf)
- Lens/diffuser for beam shaping
- Heat dissipation: Small aluminum heatsink (optional)

---

## 4. Electronics & Power

### Main Components

| Component | Part Number/Type | Cost | Notes |
|-----------|------------------|------|-------|
| **Microcontroller** | ESP32 DevKit | $8-12 | WiFi, Bluetooth, PWM capable |
| **Servo Motors (x3)** | SG90 or MG90S | $4-5 each | $12-15 total |
| **RGB LED** | WS2812B or similar | $2 | Addressable RGB LED module |
| **USB-C PD Module** | USB-C PD to 5V converter | $3-5 | Powers device via USB |
| **Battery (optional)** | 18650 Li-ion cell | $3-5 | 3.7V, ~2600mAh |
| **Battery Charger (optional)** | TP4056 module | $1-2 | USB micro charging |
| **Power Switch** | Toggle or slide switch | $0.50 | Mode: USB/Battery |
| **Servo Power Module** | BEC or 5V regulator | $3-5 | Stabilizes servo power |
| **Capacitors/Resistors** | Assorted | $2 | Filtering, protection |
| **PCB** | Custom or protoboard | $5-10 | Initial: protoboard OK |
| **Connectors** | USB-C, micro servo, etc. | $3 | Modularity |
| **Misc (wires, heatshrink)** | — | $2-3 | Assembly consumables |

**Total BOM Cost (Prototype):** ~$50-70

### Power Distribution

```
USB-C Input (5V)
    ↓
USB-C PD Module → 5V Rail
    ↓
    ├→ ESP32 (5V → 3.3V via onboard regulator)
    ├→ Servo Power Rail (5V, protected)
    ├→ RGB LED (5V)
    └→ Battery Charger (if installed)

Battery Path (Optional):
18650 → TP4056 Charger → 5V Boost Module → 5V Rail
```

### PCB Strategy

**Phase 1 (Prototype):** Breadboard/Protoboard
- Fast iteration
- Easy debugging
- Minimal cost

**Phase 2 (Refined):** Custom PCB
- Compact form factor
- Professional appearance
- Better power distribution

---

## 5. Control Interface

### WiFi Control (Primary)
- **Protocol:** HTTP REST API or WebSocket
- **Mobile App:** Simple web interface (HTML/CSS/JS)
- **Commands:**
  - Set RGB color (hex or RGB values)
  - Set pan angle (0-360°)
  - Set tilt angle (0-180°)
  - Set roll angle (0-360°)
  - Preset scenes/animations
  - Speed/acceleration controls

### Physical Interface (Secondary - Optional)
- **3x Buttons:** Mode, Pan+, Tilt+
- **Rotary Encoder:** Fine control
- **OLED Display:** Show current state (optional)

### Firmware Architecture
- **ESP32 Firmware:** C++ (Arduino framework or ESP-IDF)
- **WiFi Stack:** WiFi library (embedded)
- **Web Interface:** Hosted on ESP32 (SPIFFS filesystem)
- **OTA Updates:** Enabled for wireless firmware updates

---

## 6. Mechanical Design

### Enclosure (Tennis Ball Sized)
- **Diameter:** ~6.5 cm (tennis ball ~6.7 cm)
- **Material:** 3D printed PLA or PETG
- **Parts:**
  1. Main body (hemisphere)
  2. LED barrel/lens assembly
  3. Pan motor mount base
  4. Tilt motor arm
  5. Roll motor assembly (optional)
  6. Cable management covers
  7. Bottom access panel (battery/programming)

### Assembly Approach
- Modular: Servo arms, LED module easily replaceable
- Ball joint concept: Center pivot for aesthetics
- Internal frame supports servo motors in compact layout

### 3D Print Specifications
- **Resolution:** 0.2mm layer height (standard quality)
- **Infill:** 15-20% (strong enough for servos)
- **Support:** Needed for overhangs
- **Print Time:** ~8-12 hours total per unit
- **Post-Processing:** Minimal (remove supports, light sanding)

---

## 7. Firmware Structure

```
firmware/
├── src/
│   ├── main.cpp              # Entry point, setup/loop
│   ├── config.h              # Pin definitions, constants
│   ├── WiFiManager.h/.cpp    # WiFi connection & OTA
│   ├── ServoController.h/.cpp # Pan/Tilt/Roll servo control
│   ├── RGBController.h/.cpp   # RGB LED control (WS2812B)
│   ├── WebServer.h/.cpp       # REST API & web interface
│   ├── PowerManager.h/.cpp    # Battery/USB power switching
│   └── animations.h/.cpp      # Built-in light patterns
└── lib/
    ├── Adafruit_NeoPixel/     # RGB LED library
    └── ServoESP32/            # Servo library
```

### Key Features
- WiFi auto-reconnect
- Web dashboard (local IP access)
- Preset animations (pulse, strobe, rainbow, etc.)
- Pan/Tilt/Roll interpolation for smooth movement
- Power mode detection (USB vs battery)
- OTA firmware updates

---

## 8. Development Timeline

| Phase | Milestone | Duration | Status |
|-------|-----------|----------|--------|
| **1** | Spec & Parts sourcing | 1-2 weeks | → In Progress |
| **2** | Breadboard prototype | 2-3 weeks | Pending |
| **3** | Servo control test | 1 week | Pending |
| **4** | RGB LED integration | 1 week | Pending |
| **5** | WiFi & web interface | 2 weeks | Pending |
| **6** | Mechanical design & print | 2-3 weeks | Pending |
| **7** | Assembly & testing | 1-2 weeks | Pending |
| **8** | Refinement & documentation | 1 week | Pending |

**Total:** ~3-4 months for first working prototype

---

## 9. Cost Breakdown

| Category | Qty | Unit Cost | Total |
|----------|-----|-----------|-------|
| ESP32 DevKit | 1 | $10 | $10 |
| SG90 Servo | 3 | $4 | $12 |
| WS2812B RGB LED | 1 | $2 | $2 |
| 5V Power Module | 1 | $4 | $4 |
| 18650 Battery (opt) | 1 | $4 | $4 |
| TP4056 Charger (opt) | 1 | $1.50 | $1.50 |
| PCB/Protoboard | 1 | $5 | $5 |
| Resistors/Caps/Misc | — | — | $3 |
| 3D Print (materials) | 1 set | $10 | $10 |
| Connectors/Cables | — | — | $3 |
| **Total** | | | **~$55** |

---

## 10. Success Criteria

- [ ] All three axes move smoothly and controllably
- [ ] RGB LED produces full color range
- [ ] WiFi connectivity stable (30 ft range)
- [ ] Web interface responsive and intuitive
- [ ] Fits within tennis ball volume (~200 cm³)
- [ ] Runs on USB power
- [ ] Battery runtime: 2+ hours
- [ ] Assembly time: <2 hours
- [ ] No excessive heat generation

---

## 11. Next Actions

1. **Order Components** (Week 1)
   - ESP32, servos, LED, power modules
   - Breadboard & jumpers for prototyping

2. **Set Up Development Environment** (Week 1)
   - Install PlatformIO
   - Configure ESP32 board support
   - Basic GPIO/PWM test

3. **Servo Control Testing** (Week 2)
   - Test each servo independently
   - Calibrate angles and speeds
   - Develop motion smoothing

4. **RGB LED Integration** (Week 2-3)
   - Integrate WS2812B library
   - Test color control
   - Brightness management

5. **Firmware Development** (Week 3-4)
   - WiFi connectivity
   - Web server setup
   - REST API endpoints
   - Animation library

6. **Mechanical Design** (Parallel)
   - CAD enclosure design
   - Servo mounting strategy
   - LED housing design
   - 3D print test pieces

---

## 12. References & Resources

- **ESP32 Documentation:** https://docs.espressif.com/projects/esp-idf/
- **Adafruit NeoPixel Guide:** https://learn.adafruit.com/adafruit-neopixel-uberguide/
- **SG90 Servo Datasheet:** [Standard SG90 docs]
- **PlatformIO:** https://platformio.org/
- **Arduino IDE Alternative:** https://www.arduino.cc/

---

**Document Version:** 1.0  
**Last Updated:** 2026-03-30  
**Author:** tillingcode
