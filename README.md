# ESP32 Moving Head Light

A hardware project built around the ESP32 microcontroller, combining custom PCB design, 3D-printed mechanical enclosure, and embedded firmware for a miniature 3-axis RGB moving head light.

**Quick Stats:**
- 🎛️ **3-Axis Motion:** Pan, Tilt, Roll (SG90 servos)
- 🌈 **RGB LED:** 16 million colors (WS2812B addressable)
- 📡 **WiFi Control:** REST API + web dashboard
- 🔋 **Power:** USB-C + optional 18650 battery
- 📏 **Size:** Tennis ball (~6.5cm diameter)
- 💰 **Cost:** ~$70/unit
- ⏱️ **Timeline:** 4-5 weeks from start to working prototype

---

## 📋 Project Structure

```
esp32-moving-head-light/
├── firmware/                # ESP32 firmware (PlatformIO)
│   ├── src/
│   │   ├── main.cpp
│   │   ├── config.h
│   │   ├── ServoController.h/.cpp
│   │   ├── RGBController.h/.cpp
│   │   ├── WiFiManager.h/.cpp
│   │   └── WebServer.h/.cpp
│   └── platformio.ini
│
├── hardware/                # PCB schematics, layouts, BOM
│   ├── bom.csv             # Bill of Materials (~$70)
│   ├── schematics/
│   └── pcb/
│
├── mechanical/              # CAD and 3D print files
│   ├── cad/               # Fusion 360 / FreeCAD files
│   └── 3d-prints/         # STL files ready for printing
│
├── docs/                    # Design documentation & guides
│   ├── design-spec.md       # Complete technical specification
│   ├── phase1-setup.md      # Environment setup & component testing
│   ├── phase2-firmware.md   # Firmware architecture & web interface
│   ├── phase3-mechanical.md # CAD design & 3D printing
│   └── phase4-integration.md # System testing & integration
│
└── README.md               # This file
```

---

## 📖 Complete Documentation

### Getting Started
- **[Design Specification](docs/design-spec.md)** - Full technical spec, component selection, architecture overview
- **[Bill of Materials](hardware/bom.csv)** - All 25+ components with suppliers and costs

### Development Phases (4-5 weeks)

#### [Phase 1: Environment Setup & Component Testing](docs/phase1-setup.md)
**Duration:** Week 1-2 | **Goal:** Verify all components work independently
- Install PlatformIO development environment
- Set up ESP32 breadboard with servos, LED, power
- Test servo control (pan, tilt, roll independently)
- Test RGB LED color control
- Test power detection (USB/battery switching)
- ✅ **Outcome:** Each component validated and working

#### [Phase 2: Firmware Architecture & Web Interface](docs/phase2-firmware.md)
**Duration:** Week 3-4 | **Goal:** Integrate all components into unified WiFi-controlled system
- Modular firmware design (ServoController, RGBController, WiFiManager)
- WiFi connectivity with auto-reconnect
- REST API for control: `/api/position`, `/api/color`, `/api/status`
- Web dashboard with color picker and position sliders
- OTA (over-the-air) firmware updates
- ✅ **Outcome:** Fully functional WiFi-controlled moving head light

#### [Phase 3: Mechanical Design & 3D Printing](docs/phase3-mechanical.md)
**Duration:** Week 2-4 (parallel) | **Goal:** Design and manufacture custom 3D enclosure
- CAD design of tennis-ball-sized housing
- Servo mounting strategy (pan base, tilt arm, roll motor)
- LED reflector/housing design
- 3D print settings and material selection (PLA)
- Assembly instructions with clips and inserts
- Post-print finishing and testing
- ✅ **Outcome:** Fully assembled mechanical package

#### [Phase 4: Final Integration & Testing](docs/phase4-integration.md)
**Duration:** Week 4-5 | **Goal:** Complete system validation and manufacturing readiness
- Full system integration (electronics + mechanical)
- Burn-in testing (1+ hour continuous operation)
- Performance metrics (response time, servo precision, WiFi range)
- Environmental testing (temperature, vibration, dust)
- User manual and developer guide
- Manufacturing readiness assessment
- ✅ **Outcome:** Production-ready prototype

---

## 🎯 Key Features

### Hardware
- **ESP32-WROOM-32D** - WiFi/Bluetooth microcontroller
- **3× SG90 Servos** - Smooth 3-axis motion control
- **WS2812B RGB LED** - Addressable full-spectrum LED
- **USB-C Power** - Modern power delivery with optional 18650 battery backup
- **Custom 3D-Printed Enclosure** - Tennis ball sized, modular assembly

### Firmware
- **Modular Architecture** - ServoController, RGBController, WiFiManager
- **REST API** - Full HTTP control interface
- **Web Dashboard** - Intuitive browser-based UI
- **OTA Updates** - Wireless firmware updates without USB
- **WiFi Auto-Connect** - Resilient network handling

### Control Interface
**Web Dashboard:**
- Color picker (full RGB spectrum)
- Pan/Tilt/Roll sliders (0-180° range)
- Real-time status display
- Preset animations (optional)

**API Endpoints:**
- `GET /api/status` - Get current position & color
- `POST /api/color?color=#RRGGBB` - Set LED color
- `POST /api/position?pan=X&tilt=Y&roll=Z` - Set servo positions

---

## 💡 Design Highlights

### Motion System
- **Pan (Horizontal):** 180°+ rotation via bottom servo
- **Tilt (Vertical):** 0-180° via side servo on pan arm
- **Roll (Spin):** 0-180° via servo on tilt arm

All servos controlled independently with smooth interpolation for professional motion.

### Optical System
- **WS2812B Addressable RGB LED** - 16 million colors
- **Parabolic/Conical Reflector** - Focuses or diffuses light beam
- **Adjustable Brightness** - 0-100% power control

### Power Management
- **USB-C Input:** Direct 5V power (modern, reversible connector)
- **Optional Battery:** 18650 Li-ion with TP4056 charger module
- **Voltage Regulation:** Separate 5V rails for servos and logic
- **Runtime:** 2+ hours on battery

---

## 📊 Cost Breakdown

| Category | Qty | Cost/Unit | Total |
|----------|-----|-----------|-------|
| ESP32 DevKit | 1 | $10 | $10 |
| SG90 Servos | 3 | $4 | $12 |
| WS2812B LED | 1 | $2 | $2 |
| Power Modules | 2 | $4 | $8 |
| Battery & Charger | 1 | $6 | $6 |
| PCB/Breadboard | 1 | $5 | $5 |
| 3D Print Material | - | - | $10 |
| Connectors/Misc | - | - | $7 |
| **TOTAL** | | | **~$60-70** |

---

## 🛠️ Technology Stack

**Hardware:**
- ESP32-WROOM-32D (WiFi/Bluetooth SoC)
- SG90 servo motors (3×)
- WS2812B addressable RGB LED

**Firmware:**
- Arduino framework (C++)
- PlatformIO (build system)
- ESP32 core libraries
- Adafruit NeoPixel (LED control)
- ESP32Servo (motor control)

**Development Tools:**
- VSCode + PlatformIO extension
- FreeCAD or Fusion 360 (CAD design)
- Cura or Prusaslicer (3D print slicing)
- Git/GitHub (version control)

---

## 🚀 Quick Start

### Prerequisites
- Computer with USB port
- USB-C cable
- PlatformIO installed in VSCode
- Basic soldering skills (optional - can use breadboard)

### Step 1: Order Components (Week 1)
👉 Use [Bill of Materials](hardware/bom.csv) - components available from Amazon/AliExpress

### Step 2: Follow Development Phases
1. **Phase 1 (Week 1-2):** [Environment Setup](docs/phase1-setup.md) - test components
2. **Phase 2 (Week 3-4):** [Firmware Development](docs/phase2-firmware.md) - build WiFi control
3. **Phase 3 (Week 2-4):** [Mechanical Design](docs/phase3-mechanical.md) - CAD & 3D print
4. **Phase 4 (Week 4-5):** [Integration & Testing](docs/phase4-integration.md) - validate system

### Step 3: Access Web Interface
```
1. Power on device via USB-C
2. Connect to WiFi network (SSID: "moving-head-light")
3. Open browser: http://192.168.1.XXX
4. Use color picker & sliders to control
```

---

## 📈 Project Timeline

| Phase | Task | Duration | Status |
|-------|------|----------|--------|
| 0 | Design & Specification | 1 week | ✅ Complete |
| 1 | Component Testing | 2 weeks | ⏳ Pending |
| 2 | Firmware Development | 2 weeks | ⏳ Pending |
| 3 | Mechanical Design | 2 weeks | ⏳ Pending |
| 4 | System Integration | 2 weeks | ⏳ Pending |
| **Total** | | **4-5 weeks** | **In Progress** |

---

## 📚 Documentation Checklist

- [x] Design specification (technical details, component selection)
- [x] Bill of Materials (suppliers, costs, quantities)
- [x] Phase 1 guide (environment setup, component testing)
- [x] Phase 2 guide (firmware architecture, web server)
- [x] Phase 3 guide (CAD design, 3D printing)
- [x] Phase 4 guide (integration, testing, manufacturing)
- [x] This README

---

## 🎓 Learning Outcomes

After completing this project, you'll have experience with:

**Hardware Design:**
- ESP32 microcontroller programming
- Servo motor control (PWM)
- Addressable LED (WS2812B) control
- Power management (USB, battery, voltage regulation)
- Electrical debugging and troubleshooting

**Firmware Development:**
- Modular C++ architecture
- WiFi connectivity and OTA updates
- REST API design
- Web server implementation
- Embedded systems optimization

**Mechanical Design:**
- CAD modeling (Fusion 360/FreeCAD)
- 3D printing workflow
- Component integration
- Assembly design

**Project Management:**
- Requirements specification
- Design documentation
- Testing and validation
- Iterative development

---

## 🔗 Resources

- **ESP32 Documentation:** https://docs.espressif.com/
- **Arduino Framework:** https://www.arduino.cc/
- **PlatformIO:** https://platformio.org/
- **Adafruit Tutorials:** https://learn.adafruit.com/
- **FreeCAD:** https://www.freecadweb.org/
- **Fusion 360:** https://www.autodesk.com/products/fusion-360/

---

## 📝 License

MIT License - Feel free to use, modify, and distribute for personal or commercial purposes.

---

## 👤 Author

**tillingcode** - Full design, firmware, and documentation  
Project started: 2026-03-30

---

## 🤝 Contributing

Want to improve this project? 
- Fork the repository
- Make improvements
- Submit a pull request
- Share feedback and suggestions

---

## 📞 Support

For questions or issues:
1. Check the relevant phase documentation
2. Review [Design Specification](docs/design-spec.md)
3. Open a GitHub issue
4. Check existing GitHub issues for solutions

---

**Last Updated:** 2026-03-30  
**Version:** 1.0.0 - Alpha (Concept & Design Phase Complete)
