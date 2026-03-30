// Sound Reactive Audio Processing Module
// ESP32 Moving Head Light - Sound Reactive Version
// Processes microphone input and generates motion/color patterns
// Created: 2026-03-30

#ifndef AUDIO_PROCESSOR_H
#define AUDIO_PROCESSOR_H

#include <Arduino.h>
#include <driver/i2s.h>
#include <driver/adc.h>

// Audio Processing Constants
#define SAMPLE_RATE 16000        // 16kHz sampling rate
#define SAMPLE_BUFFER_SIZE 512   // Samples per buffer
#define FFT_SIZE 256             // FFT analysis size
#define FREQ_BANDS 8             // Number of frequency bands for visualization

// Frequency band ranges (Hz)
#define BASS_LOW 20
#define BASS_HIGH 250            // Low bass
#define MID_LOW 250
#define MID_HIGH 2000            // Midrange
#define TREBLE_LOW 2000
#define TREBLE_HIGH 20000        // High treble

// Microphone Configuration
#define MIC_ADC_CHANNEL ADC1_CHANNEL_6  // GPIO34 (ADC pin)
#define MIC_I2S_PORT I2S_NUM_0
#define MIC_BUFFER_SIZE 4096

class AudioProcessor {
private:
    // Audio buffers
    int16_t audioBuffer[SAMPLE_BUFFER_SIZE];
    float fftOutput[FFT_SIZE];
    
    // Frequency band energy levels
    float bandEnergy[FREQ_BANDS];
    float smoothedBandEnergy[FREQ_BANDS];
    
    // Beat detection
    float beatThreshold;
    float beatEnergy;
    float prevBeatEnergy;
    bool beatDetected;
    unsigned long lastBeatTime;
    
    // Audio levels
    float instantLevel;
    float smoothedLevel;
    float peakLevel;
    float energyHistory[100];
    int energyHistoryIdx;
    
    // Configuration
    bool initialized;
    float audioGain;
    float smoothingFactor;

public:
    AudioProcessor();
    ~AudioProcessor();
    
    // Initialize audio processing
    bool init();
    
    // Process audio sample
    void processAudioSample(int16_t sample);
    
    // Get frequency band energies
    float getBandEnergy(int band);
    
    // Get smoothed band energy
    float getSmoothedBandEnergy(int band);
    
    // Beat detection
    bool detectBeat();
    float getBeatStrength();
    
    // Audio level information
    float getInstantLevel();
    float getSmoothedLevel();
    float getPeakLevel();
    
    // Frequency analysis
    void analyzeFrequencies();
    
    // Utility functions
    void setAudioGain(float gain);
    void setSmoothing(float factor);
    void reset();
    void printDebugInfo();
};

#endif // AUDIO_PROCESSOR_H
