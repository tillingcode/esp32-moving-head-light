// Audio Processor Implementation
// Sound reactive processing for ESP32 Moving Head Light

#include "AudioProcessor.h"
#include <math.h>
#include <string.h>

// Simple FFT implementation (Cooley-Tukey)
void simpleFFT(float* real, float* imag, int size) {
    if (size <= 1) return;
    
    // Bit reversal
    for (int i = 1, j = 0; i < size; i++) {
        int bit = size >> 1;
        for (; j & bit; bit >>= 1) j ^= bit;
        j ^= bit;
        
        if (i < j) {
            swap(real[i], real[j]);
            swap(imag[i], imag[j]);
        }
    }
    
    // FFT computation
    for (int len = 2; len <= size; len <<= 1) {
        float ang = 2 * PI / len;
        for (int i = 0; i < size; i += len) {
            for (int j = 0; j < len / 2; j++) {
                float w_real = cos(j * ang);
                float w_imag = -sin(j * ang);
                
                int idx1 = i + j;
                int idx2 = i + j + len / 2;
                
                float t_real = w_real * real[idx2] - w_imag * imag[idx2];
                float t_imag = w_real * imag[idx2] + w_imag * real[idx2];
                
                real[idx2] = real[idx1] - t_real;
                imag[idx2] = imag[idx1] - t_imag;
                
                real[idx1] += t_real;
                imag[idx1] += t_imag;
            }
        }
    }
}

AudioProcessor::AudioProcessor() : initialized(false), audioGain(1.0f), 
                                     smoothingFactor(0.1f), beatThreshold(1.5f),
                                     instantLevel(0), smoothedLevel(0), peakLevel(0),
                                     energyHistoryIdx(0), lastBeatTime(0) {
    memset(audioBuffer, 0, sizeof(audioBuffer));
    memset(fftOutput, 0, sizeof(fftOutput));
    memset(bandEnergy, 0, sizeof(bandEnergy));
    memset(smoothedBandEnergy, 0, sizeof(smoothedBandEnergy));
    memset(energyHistory, 0, sizeof(energyHistory));
}

AudioProcessor::~AudioProcessor() {
    // Cleanup if needed
}

bool AudioProcessor::init() {
    Serial.println("[AudioProcessor] Initializing audio system...");
    
    // Configure ADC
    adc1_config_channel_atten(MIC_ADC_CHANNEL, ADC_ATTEN_DB_11);
    adc1_config_width(ADC_WIDTH_BIT_12);
    
    // Configure I2S (alternative: use I2S for better quality)
    i2s_config_t i2s_config = {
        .mode = (i2s_mode_t)(I2S_MODE_MASTER | I2S_MODE_RX | I2S_MODE_ADC_BUILT_IN),
        .sample_rate = SAMPLE_RATE,
        .bits_per_sample = I2S_BITS_PER_SAMPLE_16BIT,
        .channel_format = I2S_CHANNEL_FMT_ONLY_LEFT,
        .communication_format = I2S_COMM_FORMAT_STAND_I2S,
        .intr_alloc_flags = ESP_INTR_FLAG_LEVEL1,
        .dma_buf_count = 4,
        .dma_buf_len = 1024,
        .use_apll = false
    };
    
    i2s_driver_install(MIC_I2S_PORT, &i2s_config, 0, NULL);
    i2s_adc_enable(MIC_I2S_PORT);
    adc1_i2s_channel_acquire(MIC_ADC_CHANNEL);
    
    Serial.println("[AudioProcessor] Audio system initialized successfully!");
    initialized = true;
    return true;
}

void AudioProcessor::processAudioSample(int16_t sample) {
    // Apply gain
    float processedSample = (float)sample * audioGain / 32768.0f;
    
    // Calculate instantaneous level
    instantLevel = fabs(processedSample);
    
    // Smooth the level
    smoothedLevel = smoothedLevel * (1.0f - smoothingFactor) + 
                    instantLevel * smoothingFactor;
    
    // Track peak
    if (smoothedLevel > peakLevel) {
        peakLevel = smoothedLevel * 1.1f;  // Slight boost
    } else {
        peakLevel *= 0.995f;  // Decay
    }
    
    // Store energy history for beat detection
    energyHistory[energyHistoryIdx] = smoothedLevel;
    energyHistoryIdx = (energyHistoryIdx + 1) % 100;
}

void AudioProcessor::analyzeFrequencies() {
    // Simple energy calculation for frequency bands
    // Divide audio spectrum into 8 bands
    
    // Calculate average energy in each band
    // Band 1: 20-250 Hz (Bass)
    // Band 2: 250-2000 Hz (Midrange)
    // Band 3: 2000-20000 Hz (Treble)
    // ... etc
    
    // For now, use simplified band detection
    for (int i = 0; i < FREQ_BANDS; i++) {
        // Simulate frequency band energy (in real implementation, use FFT)
        float bandWeight = 1.0f - (i * 0.1f);  // Higher bands have lower energy
        bandEnergy[i] = smoothedLevel * bandWeight * (0.5f + 0.5f * sin(millis() / 1000.0f + i));
        
        // Smooth band energy
        smoothedBandEnergy[i] = smoothedBandEnergy[i] * (1.0f - smoothingFactor) + 
                                 bandEnergy[i] * smoothingFactor;
    }
}

bool AudioProcessor::detectBeat() {
    // Calculate energy from frequency bands
    float totalEnergy = 0;
    for (int i = 0; i < FREQ_BANDS; i++) {
        totalEnergy += smoothedBandEnergy[i];
    }
    
    beatEnergy = totalEnergy / FREQ_BANDS;
    
    // Beat detected if energy spike exceeds threshold
    bool beat = (beatEnergy > beatThreshold * prevBeatEnergy) && 
                (millis() - lastBeatTime > 200);  // Debounce
    
    if (beat) {
        lastBeatTime = millis();
        beatDetected = true;
    } else {
        beatDetected = false;
    }
    
    prevBeatEnergy = beatEnergy * 0.95f + prevBeatEnergy * 0.05f;
    return beat;
}

float AudioProcessor::getBandEnergy(int band) {
    if (band < 0 || band >= FREQ_BANDS) return 0;
    return bandEnergy[band];
}

float AudioProcessor::getSmoothedBandEnergy(int band) {
    if (band < 0 || band >= FREQ_BANDS) return 0;
    return smoothedBandEnergy[band];
}

float AudioProcessor::getInstantLevel() {
    return instantLevel;
}

float AudioProcessor::getSmoothedLevel() {
    return smoothedLevel;
}

float AudioProcessor::getPeakLevel() {
    return peakLevel;
}

float AudioProcessor::getBeatStrength() {
    if (prevBeatEnergy == 0) return 0;
    return beatEnergy / prevBeatEnergy;
}

void AudioProcessor::setAudioGain(float gain) {
    audioGain = constrain(gain, 0.1f, 5.0f);
}

void AudioProcessor::setSmoothing(float factor) {
    smoothingFactor = constrain(factor, 0.01f, 0.5f);
}

void AudioProcessor::reset() {
    memset(bandEnergy, 0, sizeof(bandEnergy));
    memset(smoothedBandEnergy, 0, sizeof(smoothedBandEnergy));
    instantLevel = 0;
    smoothedLevel = 0;
    peakLevel = 0;
    beatEnergy = 0;
    prevBeatEnergy = 0;
}

void AudioProcessor::printDebugInfo() {
    Serial.printf("[Audio] Level: %.3f | Smoothed: %.3f | Peak: %.3f | Beat: %s\n",
                  instantLevel, smoothedLevel, peakLevel, 
                  beatDetected ? "YES" : "no");
    
    Serial.print("[Audio] Band Energy: ");
    for (int i = 0; i < FREQ_BANDS; i++) {
        Serial.printf("%.2f ", smoothedBandEnergy[i]);
    }
    Serial.println();
}
