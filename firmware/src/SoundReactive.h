// Sound Reactive Controller Module
// Maps audio frequencies to motion and color effects

#ifndef SOUND_REACTIVE_H
#define SOUND_REACTIVE_H

#include <Arduino.h>
#include "AudioProcessor.h"

// Reaction modes
enum SoundReactiveMode {
    MODE_BEAT_PAN,          // Pan sweeps with beat
    MODE_BEAT_COLOR,        // Color pulses with beat
    MODE_FREQUENCY_MOTION,  // Motion reacts to frequencies
    MODE_FREQUENCY_COLOR,   // Color reacts to frequencies
    MODE_SYNCHRONIZED,      // Both motion and color react
    MODE_STROBE,            // Stroboscopic effect on beat
    MODE_CHASE              // Color chase pattern synced to tempo
};

class SoundReactiveController {
private:
    AudioProcessor* audioProc;
    SoundReactiveMode currentMode;
    
    // State tracking
    float panTarget, tiltTarget, rollTarget;
    float colorHue, colorSat, colorBri;
    unsigned long lastBeatTime;
    float beatTempo;  // Estimated BPM
    
    // Sensitivity controls
    float motionSensitivity;
    float colorSensitivity;
    float beatSensitivity;
    
    // Animation state
    int animationPhase;
    float animationProgress;

public:
    SoundReactiveController(AudioProcessor* audio);
    ~SoundReactiveController();
    
    // Set operating mode
    void setMode(SoundReactiveMode mode);
    
    // Get motion targets based on audio
    void getMotionTargets(float& pan, float& tilt, float& roll);
    
    // Get color based on audio
    void getColorRGB(uint8_t& r, uint8_t& g, uint8_t& b);
    
    // Get color in HSV
    void getColorHSV(float& h, float& s, float& v);
    
    // Update with latest audio data
    void update();
    
    // Sensitivity controls
    void setMotionSensitivity(float sens);
    void setColorSensitivity(float sens);
    void setBeatSensitivity(float sens);
    
    // Mode-specific effects
    void handleBeatPan();
    void handleBeatColor();
    void handleFrequencyMotion();
    void handleFrequencyColor();
    void handleSynchronized();
    void handleStrobe();
    void handleChase();
    
    // Utility
    void printStatus();
};

#endif // SOUND_REACTIVE_H
