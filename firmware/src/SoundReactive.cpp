// Sound Reactive Controller Implementation

#include "SoundReactive.h"
#include <math.h>

// Helper function: map float range
float mapFloat(float x, float in_min, float in_max, float out_min, float out_max) {
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

// Helper: HSV to RGB conversion
void hsv2rgb(float h, float s, float v, uint8_t& r, uint8_t& g, uint8_t& b) {
    if (s == 0) {
        r = g = b = (uint8_t)(v * 255);
        return;
    }
    
    float c = v * s;
    float x = c * (1 - fabs(fmod(h / 60, 2) - 1));
    float m = v - c;
    
    float rf, gf, bf;
    if (h < 60) { rf = c; gf = x; bf = 0; }
    else if (h < 120) { rf = x; gf = c; bf = 0; }
    else if (h < 180) { rf = 0; gf = c; bf = x; }
    else if (h < 240) { rf = 0; gf = x; bf = c; }
    else if (h < 300) { rf = x; gf = 0; bf = c; }
    else { rf = c; gf = 0; bf = x; }
    
    r = (uint8_t)((rf + m) * 255);
    g = (uint8_t)((gf + m) * 255);
    b = (uint8_t)((bf + m) * 255);
}

SoundReactiveController::SoundReactiveController(AudioProcessor* audio) 
    : audioProc(audio), currentMode(MODE_SYNCHRONIZED),
      panTarget(90), tiltTarget(90), rollTarget(0),
      colorHue(0), colorSat(1.0f), colorBri(1.0f),
      motionSensitivity(1.0f), colorSensitivity(1.0f), beatSensitivity(1.0f),
      animationPhase(0), animationProgress(0), beatTempo(120) {
}

SoundReactiveController::~SoundReactiveController() {
}

void SoundReactiveController::setMode(SoundReactiveMode mode) {
    currentMode = mode;
}

void SoundReactiveController::update() {
    // Analyze frequency bands
    audioProc->analyzeFrequencies();
    
    // Detect beats
    bool beatDetected = audioProc->detectBeat();
    if (beatDetected) {
        lastBeatTime = millis();
    }
    
    // Update animation phase
    animationPhase = (animationPhase + 1) % 360;
    animationProgress = fmod(animationPhase / 360.0f, 1.0f);
    
    // Execute current mode
    switch (currentMode) {
        case MODE_BEAT_PAN:
            handleBeatPan();
            break;
        case MODE_BEAT_COLOR:
            handleBeatColor();
            break;
        case MODE_FREQUENCY_MOTION:
            handleFrequencyMotion();
            break;
        case MODE_FREQUENCY_COLOR:
            handleFrequencyColor();
            break;
        case MODE_SYNCHRONIZED:
            handleSynchronized();
            break;
        case MODE_STROBE:
            handleStrobe();
            break;
        case MODE_CHASE:
            handleChase();
            break;
    }
}

void SoundReactiveController::handleBeatPan() {
    // Pan sweeps left-right with beat
    float beatStrength = audioProc->getBeatStrength();
    
    // Alternate pan positions on beat
    if (beatStrength > beatSensitivity) {
        panTarget = (animationPhase % 2 == 0) ? 0 : 180;
    } else {
        panTarget = 90;  // Center
    }
    
    // Color intensity follows audio level
    float level = audioProc->getSmoothedLevel();
    colorBri = constrain(level * 2.0f, 0, 1);
}

void SoundReactiveController::handleBeatColor() {
    // Color pulses with beat
    float beatStrength = audioProc->getBeatStrength();
    
    // Hue cycles through spectrum
    colorHue = animationPhase * 1.0f;  // 0-360°
    
    // Saturation and brightness follow beat
    if (beatStrength > beatSensitivity) {
        colorSat = 1.0f;
        colorBri = 1.0f;
    } else {
        colorSat = 0.5f;
        colorBri = 0.3f;
    }
    
    // Pan/Tilt slightly move with beat
    panTarget = 90 + (beatStrength * 20 * sin(millis() / 500.0f));
    tiltTarget = 90 + (beatStrength * 15 * cos(millis() / 600.0f));
}

void SoundReactiveController::handleFrequencyMotion() {
    // Motion reacts to frequency bands
    // Bass -> Pan, Mids -> Tilt, Treble -> Roll
    
    float bassEnergy = audioProc->getSmoothedBandEnergy(0) * motionSensitivity;
    float midEnergy = audioProc->getSmoothedBandEnergy(3) * motionSensitivity;
    float trebleEnergy = audioProc->getSmoothedBandEnergy(7) * motionSensitivity;
    
    // Map frequencies to motion
    panTarget = mapFloat(bassEnergy, 0, 1, 45, 135);
    tiltTarget = mapFloat(midEnergy, 0, 1, 45, 135);
    rollTarget = mapFloat(trebleEnergy, 0, 1, 0, 180);
    
    // Constant color cycling
    colorHue = animationPhase * 0.5f;
    colorSat = 0.8f;
    colorBri = constrain(audioProc->getSmoothedLevel() * 2.0f, 0.3f, 1.0f);
}

void SoundReactiveController::handleFrequencyColor() {
    // Color reacts to frequency bands
    // Bass -> Red, Mids -> Green, Treble -> Blue
    
    float bassEnergy = audioProc->getSmoothedBandEnergy(0);
    float midEnergy = audioProc->getSmoothedBandEnergy(3);
    float trebleEnergy = audioProc->getSmoothedBandEnergy(7);
    
    // Hue follows dominant frequency
    if (bassEnergy > midEnergy && bassEnergy > trebleEnergy) {
        colorHue = 0;  // Red
    } else if (midEnergy > bassEnergy && midEnergy > trebleEnergy) {
        colorHue = 120;  // Green
    } else {
        colorHue = 240;  // Blue
    }
    
    // Brightness follows overall level
    colorBri = constrain(audioProc->getSmoothedLevel() * 2.0f, 0.3f, 1.0f);
    colorSat = 0.9f;
    
    // Smooth pan/tilt movement
    panTarget = 90 + (sin(millis() / 1000.0f) * 30);
    tiltTarget = 90 + (cos(millis() / 1500.0f) * 30);
}

void SoundReactiveController::handleSynchronized() {
    // Both motion and color fully synchronized to audio
    
    float level = audioProc->getSmoothedLevel();
    float beatStrength = audioProc->getBeatStrength();
    
    // Frequency-based motion
    float bassEnergy = audioProc->getSmoothedBandEnergy(0);
    float midEnergy = audioProc->getSmoothedBandEnergy(3);
    float trebleEnergy = audioProc->getSmoothedBandEnergy(7);
    
    // Pan follows bass
    panTarget = mapFloat(bassEnergy, 0, 1, 30, 150);
    
    // Tilt follows mids
    tiltTarget = mapFloat(midEnergy, 0, 1, 30, 150);
    
    // Roll follows treble
    rollTarget = mapFloat(trebleEnergy, 0, 1, 0, 180);
    
    // Color hue cycles with beat
    colorHue = animationPhase * 0.5f;
    
    // Saturation follows beat
    colorSat = constrain(0.5f + (beatStrength * 0.5f), 0, 1);
    
    // Brightness follows overall level
    colorBri = constrain(level * 2.5f, 0.2f, 1.0f);
}

void SoundReactiveController::handleStrobe() {
    // Stroboscopic effect on beat
    
    float beatStrength = audioProc->getBeatStrength();
    bool strobe = (beatStrength > beatSensitivity) && 
                  ((millis() / 50) % 2 == 0);  // 50ms strobe period
    
    if (strobe) {
        colorBri = 1.0f;
        colorSat = 1.0f;
    } else {
        colorBri = 0.1f;
        colorSat = 0.5f;
    }
    
    // Subtle pan movement
    panTarget = 90 + (sin(millis() / 2000.0f) * 20);
    
    // Constant hue
    colorHue = animationPhase * 0.2f;
}

void SoundReactiveController::handleChase() {
    // Color chase pattern synchronized to tempo
    
    float level = audioProc->getSmoothedLevel();
    
    // Chase speed follows tempo
    float chaseSpeed = 1.0f + (level * 2.0f);
    colorHue = fmod(animationPhase * chaseSpeed, 360.0f);
    
    // Pan slowly sweeps during chase
    panTarget = mapFloat(sin(animationPhase / 180.0f * PI), -1, 1, 30, 150);
    
    // Tilt bounces
    tiltTarget = 90 + (cos(animationPhase / 90.0f * PI) * 40);
    
    // Roll spins faster with louder music
    rollTarget = fmod(animationPhase * (0.5f + level), 360.0f);
    
    // Color brightness pulses
    colorBri = constrain(0.5f + (level * 0.5f), 0.3f, 1.0f);
    colorSat = 0.85f;
}

void SoundReactiveController::getMotionTargets(float& pan, float& tilt, float& roll) {
    pan = panTarget;
    tilt = tiltTarget;
    roll = rollTarget;
}

void SoundReactiveController::getColorRGB(uint8_t& r, uint8_t& g, uint8_t& b) {
    hsv2rgb(colorHue, colorSat, colorBri, r, g, b);
}

void SoundReactiveController::getColorHSV(float& h, float& s, float& v) {
    h = colorHue;
    s = colorSat;
    v = colorBri;
}

void SoundReactiveController::setMotionSensitivity(float sens) {
    motionSensitivity = constrain(sens, 0.1f, 5.0f);
}

void SoundReactiveController::setColorSensitivity(float sens) {
    colorSensitivity = constrain(sens, 0.1f, 5.0f);
}

void SoundReactiveController::setBeatSensitivity(float sens) {
    beatSensitivity = constrain(sens, 0.5f, 3.0f);
}

void SoundReactiveController::printStatus() {
    Serial.printf("[SoundReactive] Mode: %d | Pan: %.1f° | Tilt: %.1f° | Roll: %.1f° | Hue: %.1f°\n",
                  currentMode, panTarget, tiltTarget, rollTarget, colorHue);
}
