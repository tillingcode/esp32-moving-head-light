#include <Arduino.h>
#include "config.h"

void setup() {
  Serial.begin(115200);
  delay(2000); // Give serial monitor time to connect
  
  Serial.println("\n\nESP32 Moving Head Light - Starting up");
  Serial.print("Device: ");
  Serial.println(DEVICE_NAME);
  Serial.print("Version: ");
  Serial.println(DEVICE_VERSION);
  
  // Initialize pins
  pinMode(PIN_MOTOR_X, OUTPUT);
  pinMode(PIN_MOTOR_Y, OUTPUT);
  pinMode(PIN_LED_RED, OUTPUT);
  pinMode(PIN_LED_GREEN, OUTPUT);
  pinMode(PIN_LED_BLUE, OUTPUT);
  
  Serial.println("Initialization complete!");
}

void loop() {
  // Main application loop
  Serial.println("Device running...");
  delay(1000);
}
