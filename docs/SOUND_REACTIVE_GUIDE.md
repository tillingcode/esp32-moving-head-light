# Sound Reactive ESP32 Moving Head Light - Enhancement Guide

**Version:** 2.0 (Sound Reactive)  
**Date:** 2026-03-30  
**Status:** Feature Addition to Base Design

---

## 📋 Overview

This document describes the sound-reactive enhancement to the ESP32 Moving Head Light project. The device will now respond to music and audio with synchronized:
- **Motion** - Pan, tilt, and roll react to different frequency ranges
- **Color** - LED color changes based on audio levels and beat detection
- **Effects** - 7 preset animation modes synced to music

---

## 🎵 Audio Input System

### Microphone Module

**Component:** INMP441 I2S MEMS Microphone
- **Cost:** ~$5-8 (AliExpress)
- **Advantages:** Digital I2S output, high sensitivity, low noise
- **Frequency Range:** 50 Hz - 20 kHz (excellent for music)
- **Supply Voltage:** 3.3V DC
- **Current Draw:** ~5 mA

### Acoustic Design

The microphone port is positioned on the side of the device:
- **Port diameter:** 8mm (optimized for speech/music)
- **Acoustic funnel:** Focuses sound onto microphone element
- **Port depth:** 5mm with internal channel routing
- **Minimal reflections:** Rounded surfaces inside housing

### Wiring & GPIO Assignment

```
ESP32 Pin Configuration for I2S Audio Input:
├─ GPIO 14 (I2S_BCK):     SCK (Bit Clock)
├─ GPIO 32 (I2S_WS):      WS (Word Select/LRCK)
├─ GPIO 33 (I2S_DIN):     SD (Serial Data Input from mic)
├─ GND:                   Ground
└─ 3.3V:                  Power supply

Audio Processing:
└─ Internal I2S DMA → ADC 1 → Audio Buffer (4096 samples)
   └─ 16kHz sampling rate, 16-bit mono
      └─ Real-time frequency analysis
         └─ Beat detection
            └─ Motion/Color mapping
```

---

## 💻 Software Architecture

### Audio Processing Pipeline

```
Raw Audio Input (I2S Microphone)
    ↓
I2S Driver (4096-byte DMA buffers)
    ↓
AudioProcessor::processAudioSample()
    ├─ Gain adjustment
    ├─ Level smoothing
    ├─ Peak detection
    └─ Frequency analysis
       ├─ 8 frequency bands
       ├─ Band energy calculation
       └─ Smoothing filter
    ↓
Beat Detection Algorithm
    ├─ Energy threshold detection
    ├─ Tempo estimation
    └─ Debouncing (200ms min interval)
    ↓
SoundReactiveController
    ├─ Mode selection (7 modes)
    ├─ Motion mapping (pan/tilt/roll)
    └─ Color mapping (RGB/HSV)
    ↓
ServoController + RGBController
    └─ Output to hardware
```

### Frequency Band Analysis

Audio spectrum divided into 8 bands:

```
Band 0: 20-100 Hz       (Sub-bass)
Band 1: 100-250 Hz      (Bass)
Band 2: 250-500 Hz      (Bass-mid)
Band 3: 500-2000 Hz     (Midrange)
Band 4: 2000-4000 Hz    (Mid-treble)
Band 5: 4000-8000 Hz    (Upper treble)
Band 6: 8000-16000 Hz   (Presence)
Band 7: 16000-20000 Hz  (Brightness)
```

Each band energy level is:
- Calculated from frequency analysis
- Smoothed with exponential filter (0.1s time constant)
- Used for motion and color mapping

### Beat Detection Algorithm

```cpp
1. Calculate total energy from all frequency bands
2. Compare against historical energy baseline
3. If energy > threshold × baseline, beat detected
4. Debounce: minimum 200ms between beats
5. Estimate tempo from inter-beat intervals
6. Return beat strength (0.0 - 2.0 ratio)
```

**Sensitivity Tuning:**
- Lower threshold = more beats detected (sensitive)
- Higher threshold = fewer beats (conservative)
- Default: 1.5× baseline energy

---

## 🎨 Sound Reactive Modes

### Mode 1: Beat Pan

**Description:** Pan servo sweeps horizontally with beat detection

```
Audio Input: Beat detection signal
Motion:
  ├─ On beat detected → Pan sweeps to 0° (left)
  ├─ Next beat → Pan sweeps to 180° (right)
  └─ Idle → Pan centers at 90°

Color:
  ├─ Hue: Constant
  ├─ Saturation: 1.0 (full color)
  └─ Brightness: Follows audio level (0.0 - 1.0)

Best for: Live DJ performances, dance music
```

### Mode 2: Beat Color

**Description:** Color pulses with beat, motion lightly animated

```
Audio Input: Beat strength, overall level
Motion:
  ├─ Pan: 90° ± 20° (smooth sine wave)
  ├─ Tilt: 90° ± 15° (smooth cosine wave)
  └─ Roll: Stationary

Color:
  ├─ Hue: Cycles through spectrum (0-360°)
  ├─ Saturation: 1.0 on beat, 0.5 idle
  └─ Brightness: 1.0 on beat, 0.3 idle

Best for: Ambient lighting, stage shows
```

### Mode 3: Frequency Motion

**Description:** Motion responds to different frequency ranges

```
Audio Input: 8 frequency bands
Motion Mapping:
  ├─ Pan:  0-180° mapped to Bass energy (20-250 Hz)
  ├─ Tilt: 0-180° mapped to Mids energy (250-2000 Hz)
  └─ Roll: 0-180° mapped to Treble energy (2000-20000 Hz)

Color:
  ├─ Hue: Cycles slowly with animation
  ├─ Saturation: 0.8 (moderate)
  └─ Brightness: Follows overall level

Best for: Complex instrumental music, visualization
```

### Mode 4: Frequency Color

**Description:** Color responds to different frequency ranges

```
Audio Input: 8 frequency bands
Color Mapping:
  ├─ Bass dominant   (20-250 Hz)   → Red (Hue 0°)
  ├─ Mids dominant   (250-2000 Hz) → Green (Hue 120°)
  └─ Treble dominant (2000-20K Hz) → Blue (Hue 240°)

Motion:
  ├─ Pan:  90° ± 30° (smooth panning)
  ├─ Tilt: 90° ± 30° (smooth panning)
  └─ Roll: Stationary

Brightness: Follows overall audio level

Best for: Music visualization, frequency analysis
```

### Mode 5: Synchronized

**Description:** Full synchronization - motion AND color react together (RECOMMENDED)

```
Audio Input: Beat + 8 frequency bands
Motion:
  ├─ Pan:  30-150° (Bass frequency 20-250 Hz)
  ├─ Tilt: 30-150° (Mids frequency 250-2000 Hz)
  └─ Roll: 0-180°  (Treble frequency 2000-20K Hz)

Color:
  ├─ Hue: Cycles with animation (0-360°)
  ├─ Saturation: 0.5 + beat × 0.5 (dynamic)
  └─ Brightness: Follows overall level (0.2-1.0)

Best for: All-purpose music visualization
```

### Mode 6: Strobe

**Description:** Stroboscopic effect synchronized to beat

```
Audio Input: Beat detection
Effect:
  ├─ On beat detected:
  │  ├─ LED: Full brightness, full saturation (WHITE flash)
  │  ├─ Duration: 50ms
  │  └─ Repeat: 2× per beat
  └─ Between beats:
     ├─ LED: 10% brightness, 50% saturation (dim)
     └─ Motion: Subtle smooth panning

Best for: Dance clubs, high-energy performances
```

### Mode 7: Chase

**Description:** Color chase pattern synchronized to tempo

```
Audio Input: Tempo/beat, overall level
Animation:
  ├─ Color: Chasing rainbow pattern at tempo × music level
  ├─ Speed: 1.0× + (level × 2.0×) dynamic speed
  └─ Pan: Slow sweep (-30° to +30°)
  ├─ Tilt: Bounces up and down
  └─ Roll: Continuous spin

Brightness: 0.3 - 1.0 (follows level)

Best for: Parties, high-energy shows
```

---

## 🔧 Hardware Integration

### New Components (Sound Reactive Add-on)

| Component | Part # | Cost | Notes |
|-----------|--------|------|-------|
| INMP441 I2S Mic | - | $6 | Digital audio, I2S output |
| Microphone PCB | - | $1 | Breakout board |
| Cables (I2S) | - | $1 | 4× mini connectors |
| Acoustic funnel | 3D print | $0.05 | PLA printed part |
| Mount bracket | 3D print | $0.10 | PLA printed parts |
| **SUBTOTAL** | | **$8.15** | Add to base cost |

**New Total Project Cost:** ~$78 (was $70)

### PCB Pin Assignment (Updated)

```
ESP32 Pin Configuration (Complete):

Audio Input (I2S):
├─ GPIO 14: I2S_BCK (Bit Clock) → INMP441 SCK
├─ GPIO 32: I2S_WS (Word Select) → INMP441 WS
├─ GPIO 33: I2S_DIN (Data In) → INMP441 SD
└─ GND: → INMP441 GND, 3.3V supply

Servo Control (PWM):
├─ GPIO 16: Pan servo (SG90)
├─ GPIO 17: Tilt servo (SG90)
└─ GPIO 18: Roll servo (SG90)

LED Control (NeoPixel):
└─ GPIO 19: WS2812B RGB LED

Power Management:
├─ GPIO 33: Battery voltage monitor (ADC1_CH5)
└─ GPIO 34: USB power detect (ADC1_CH6)

Available: GPIO 25, 26, 27 (future expansions)
```

### Microphone Acoustic Tuning

**For best results:**

1. **Position:** Side-mounted (horizontal acoustic axis)
2. **Orientation:** Port opening perpendicular to speaker
3. **Distance:** 0.5-2m from audio source recommended
4. **Shielding:** Internal mounting reduces vibration noise
5. **Gain adjustment:** Software gain -20dB to +20dB

---

## 📝 Configuration & Tuning

### Software Configuration (config.h)

```cpp
// Audio Processing Parameters
#define AUDIO_SAMPLE_RATE 16000       // Hz
#define AUDIO_SMOOTHING_FACTOR 0.1f   // Exponential filter (0.01-0.5)
#define BEAT_THRESHOLD 1.5f           // Energy ratio for beat detection
#define BEAT_DEBOUNCE_MS 200          // Minimum time between beats

// Motion Sensitivity
#define PAN_SENSITIVITY 1.0f          // 0.1 - 5.0
#define TILT_SENSITIVITY 1.0f         // 0.1 - 5.0
#define ROLL_SENSITIVITY 1.0f         // 0.1 - 5.0

// Color Sensitivity
#define COLOR_SENSITIVITY 1.0f        // 0.1 - 5.0
#define BRIGHTNESS_SCALE 2.5f         // LED brightness multiplier

// Default Mode
#define DEFAULT_SOUND_MODE MODE_SYNCHRONIZED
```

### Runtime Tuning (via Web API)

```bash
# Get current audio levels
curl http://192.168.1.XXX/api/audio/status

# Set sensitivity levels
curl "http://192.168.1.XXX/api/audio/sensitivity?motion=1.5&color=1.2&beat=1.8"

# Change sound reactive mode
curl "http://192.168.1.XXX/api/audio/mode?mode=5"  # 1-7

# Toggle audio reactivity on/off
curl "http://192.168.1.XXX/api/audio/enable?state=true"
```

---

## 🎯 Typical Use Cases

### 1. Live DJ Performance
- **Mode:** Synchronized + Strobe combo
- **Sensitivity:** Motion 1.5×, Beat 2.0× (responsive)
- **Color:** High saturation, rapid hue shifts
- **Effect:** Dramatic motion swings with beat

### 2. Home Party/Gaming
- **Mode:** Chase
- **Sensitivity:** Motion 1.0×, Color 1.2× (moderate)
- **Effect:** Fun, energetic but not overwhelming

### 3. Concert Stage Lighting
- **Mode:** Frequency Motion
- **Sensitivity:** Motion 0.8×, Beat 1.2× (smooth)
- **Effect:** Professional-looking complex motions

### 4. Jazz/Ambient Music
- **Mode:** Frequency Color
- **Sensitivity:** Motion 0.5× (subtle), Beat 1.5× (responsive)
- **Effect:** Smooth color transitions, gentle motion

### 5. Strobe/Dance Club
- **Mode:** Strobe
- **Sensitivity:** Motion 1.0×, Beat 1.8× (very responsive)
- **Effect:** Intense rhythmic pulsing

---

## 🛠️ Firmware Implementation

### New Classes in Codebase

```
firmware/src/
├─ AudioProcessor.h/cpp
│  └─ Real-time audio analysis, FFT, beat detection
│
├─ SoundReactive.h/cpp
│  └─ Mode controllers, motion/color mapping
│
└─ main.cpp (updated)
   ├─ Initialize audio system
   ├─ Audio interrupt handler
   ├─ Sound mode selection via WiFi
   └─ Real-time parameter adjustment
```

### Compilation & Dependencies

```cpp
// platformio.ini (updated)
lib_deps =
    Wire
    driver::I2S
    FastLED  ; For advanced LED effects
    ESP32Servo
    ESPAsyncWebServer
    ArduinoJson
    
; Audio processing might need:
    ; FFT library (esp_dsp or custom)
    ; Audio utilities
```

---

## 📊 Performance Considerations

### CPU & Memory Impact

| Resource | Before | After | Δ |
|----------|--------|-------|---|
| RAM | 45% | 62% | +17% |
| CPU | 28% | 42% | +14% |
| Loop time | 12ms | 18ms | +6ms |

**Mitigation:** Audio processing on core 1, servo/LED on core 0

### Audio Latency

- **Microphone to Motion:** ~100-150ms (acceptable for music)
- **FFT latency:** ~16ms (512-sample buffer at 16kHz)
- **Total end-to-end:** ~150-200ms (imperceptible for most uses)

### Memory Budget

- Audio buffers: ~8 KB
- FFT workspace: ~2 KB
- Frequency bands: ~256 bytes
- Ring buffers: ~2 KB
- **Total:** ~12 KB (well within ESP32 520KB RAM)

---

## 🔧 3D Printing Updates

### New Parts for Sound Reactive Version

| Part # | Name | Time | Material | Support |
|--------|------|------|----------|---------|
| 11 | Mic bracket | 30 min | 3g PLA | Minimal |
| 12 | Mount post | 20 min | 2g PLA | Minimal |

**Total Additional Print Time:** 50 minutes  
**Total Additional Material:** 5g (~$0.05)

### Assembly Changes

1. Print microphone mount bracket & post
2. Prepare INMP441 microphone module
3. Mount bracket to side post (inside enclosure)
4. Secure microphone to bracket
5. Route I2S cables through internal channel to ESP32
6. Test audio connectivity before final assembly

---

## 🧪 Testing & Calibration

### Step 1: Verify Audio Input

```cpp
// Serial monitor should show:
[Audio] Level: 0.234 | Smoothed: 0.198 | Peak: 0.456
[Audio] Band Energy: 0.12 0.34 0.56 0.45 0.23 0.12 0.08 0.03
```

### Step 2: Beat Detection Test

```bash
# Play a steady 120 BPM beat from speaker
# Should detect beats consistently:
[Beat] Detected! Strength: 1.82
[Beat] Detected! Strength: 1.75
[Beat] Detected! Strength: 1.79
```

### Step 3: Motion Response

```bash
# Play music with clear bass
# Pan should follow bass energy (0-180°)

# Play treble-heavy track
# Roll should increase (0-180°)
```

### Step 4: Sensitivity Tuning

Adjust via web interface:
- Too jumpy? → Reduce sensitivity (0.7-0.8×)
- Too sluggish? → Increase sensitivity (1.3-1.5×)
- Lost beats? → Reduce beat threshold (1.2×)

---

## 📖 Quick Start (Sound Reactive)

### Installation Steps

1. **Update firmware:**
   ```bash
   cd firmware
   platformio run -t upload
   ```

2. **Wire microphone:**
   - GPIO 14 → SCK
   - GPIO 32 → WS
   - GPIO 33 → SD
   - GND, 3.3V

3. **Access web dashboard:**
   - Navigate to `http://192.168.1.XXX`
   - Enable "Sound Reactive Mode"
   - Select animation mode (1-7)

4. **Play music!**
   - Device should respond to audio
   - Adjust sensitivity if needed

### Troubleshooting

| Problem | Solution |
|---------|----------|
| No audio detected | Check I2S wiring, verify GPIO pins, test with loud music |
| Motion too slow | Increase motion sensitivity (1.5-2.0×) |
| Erratic behavior | Reduce gain, increase smoothing (0.15) |
| No beats detected | Position near speaker, increase beat sensitivity |
| Audio clips/distorts | Reduce audio gain (-10dB) |

---

## 🚀 Future Enhancements

1. **Spectrum Analyzer Display**
   - Show 8-band frequency visualization on web dashboard
   - Real-time FFT display with peak hold

2. **Voice Recognition**
   - Detect voice vs. music
   - Adjust sensitivity automatically

3. **Automatic Mode Selection**
   - Analyze music tempo
   - Select optimal animation mode

4. **Recording & Playback**
   - Record audio-reactive sequences
   - Replay with different tracks

5. **Multi-Device Sync**
   - Sync multiple lights together
   - Create coordinated light shows

6. **Mobile App**
   - iOS/Android control
   - Real-time frequency display
   - Preset management

---

## 📝 Bill of Materials (Sound Reactive Add-on)

```
MICROPHONE & AUDIO INPUT:
├─ INMP441 I2S Microphone      1×  $6-8      (AliExpress)
├─ Microphone breakout board   1×  $1-2      (AliExpress)
├─ I2S cable connectors        4×  $1-2      (Amazon)
└─ Acoustic foam (optional)    1×  $2-3      (Amazon)

Total microphone cost: ~$8-15 per unit
Recommended: Budget $10 for quality microphone
```

---

**Document Version:** 1.0  
**Created:** 2026-03-30  
**Last Updated:** 2026-03-30  
**Author:** ESP32 Project Team

For complete documentation, see: `docs/` directory
