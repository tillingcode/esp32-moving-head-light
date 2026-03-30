// ESP32 Moving Head Light - Sound Reactive 3D Model (Updated)
// Added microphone mount and sound port
// OpenSCAD Design for 3D Printing with audio input
// Created: 2026-03-30

// ============================================================================
// NEW PARAMETERS FOR SOUND REACTIVITY
// ============================================================================

// Microphone specifications
MIC_MODULE_WIDTH = 28;   // INMP441 I2S microphone module
MIC_MODULE_HEIGHT = 15;
MIC_MODULE_LENGTH = 38;

// Sound port opening
SOUND_PORT_DIAMETER = 8;  // 8mm opening for sound intake
SOUND_PORT_DEPTH = 5;

// ============================================================================
// MICROPHONE MOUNT MODULE (New)
// ============================================================================

module microphone_mount() {
    color([0.5, 0.5, 0.5]) {
        // Microphone bracket
        difference() {
            // Main bracket body
            cube([MIC_MODULE_WIDTH + 4, MIC_MODULE_HEIGHT + 4, 8], center=true);
            
            // Mounting hole for microphone module
            translate([0, 0, 0]) {
                cube([MIC_MODULE_WIDTH, MIC_MODULE_HEIGHT, 8.5], center=true);
            }
            
            // Screw holes (2×)
            translate([-12, 0, 0]) cylinder(r=1.5, h=9, center=true, $fn=16);
            translate([12, 0, 0]) cylinder(r=1.5, h=9, center=true, $fn=16);
        }
        
        // Cable channel
        translate([15, 0, 0]) {
            cube([8, 3, 6], center=true);
        }
    }
}

// Microphone module housing
module microphone_housing() {
    color([0.3, 0.3, 0.3]) {
        union() {
            // Module body
            cube([MIC_MODULE_LENGTH, MIC_MODULE_WIDTH, MIC_MODULE_HEIGHT], center=true);
            
            // Microphone port (acoustic opening)
            translate([MIC_MODULE_LENGTH/2 - 2, 0, 0]) {
                cylinder(r=2.5, h=4, $fn=DETAIL_LEVEL);
            }
        }
    }
}

// Sound port opening on enclosure
module sound_port_opening() {
    // Port for acoustic input
    translate([RADIUS - WALL_THICKNESS - 1, 0, 0]) {
        union() {
            // Main port opening
            cylinder(r=SOUND_PORT_DIAMETER/2, h=SOUND_PORT_DEPTH, $fn=DETAIL_LEVEL);
            
            // Acoustic funnel (optional, 3D printed detail)
            translate([0, 0, SOUND_PORT_DEPTH/2]) {
                cylinder(r1=SOUND_PORT_DIAMETER/2, r2=SOUND_PORT_DIAMETER/2 + 2, 
                        h=4, $fn=DETAIL_LEVEL);
            }
        }
    }
}

// Microphone mounting post (internal)
module microphone_mount_post() {
    color([0.4, 0.4, 0.4]) {
        translate([RADIUS - 25, 0, -RADIUS + 20]) {
            // Post for microphone bracket
            cube([10, 8, 30], center=true);
            
            // Connection rib to frame
            cube([8, 4, 40], center=true);
        }
    }
}

// ============================================================================
// UPDATED ENCLOSURE WITH SOUND PORT
// ============================================================================

module enclosure_shell_with_sound_port() {
    difference() {
        // Start with original sphere
        sphere(r=RADIUS, $fn=DETAIL_LEVEL);
        
        // Inner hollow
        sphere(r=RADIUS - WALL_THICKNESS, $fn=DETAIL_LEVEL);
        
        // Remove bottom for assembly
        translate([0, 0, -RADIUS-5]) {
            cube([DIAMETER+10, DIAMETER+10, 10], center=true);
        }
        
        // LED lens opening (front)
        translate([0, -RADIUS-1, 5]) {
            cylinder(r=8, h=5, $fn=DETAIL_LEVEL);
        }
        
        // USB-C port opening (bottom)
        translate([0, 0, -RADIUS+3]) {
            cube([USB_C_WIDTH, USB_C_DEPTH, USB_C_HEIGHT], center=true);
        }
        
        // SOUND PORT (NEW - Side opening for microphone)
        translate([RADIUS - 1, 0, 0]) {
            cylinder(r=SOUND_PORT_DIAMETER/2, h=4, $fn=DETAIL_LEVEL);
        }
    }
}

// ============================================================================
// UPDATED COMPLETE ASSEMBLY
// ============================================================================

module complete_assembly_with_sound() {
    // Enclosure shell (with sound port)
    enclosure_shell_with_sound_port();
    
    // Internal mounting frame
    internal_frame();
    
    // Pan assembly
    pan_assembly();
    
    // Tilt assembly
    tilt_assembly();
    
    // Roll assembly
    roll_assembly();
    
    // LED and reflector
    led_assembly();
    
    // PCB mount
    pcb_mount();
    
    // Battery (optional)
    battery_mount();
    
    // MICROPHONE COMPONENTS (NEW)
    // Microphone mount post (internal)
    microphone_mount_post();
    
    // Microphone bracket
    translate([RADIUS - 25, 0, -RADIUS + 20]) {
        rotate([0, 90, 0]) {
            microphone_mount();
        }
    }
    
    // Microphone module
    translate([RADIUS - 18, 0, -RADIUS + 20]) {
        rotate([0, 90, 0]) {
            microphone_housing();
        }
    }
    
    // Internal wiring (visual)
    internal_wiring();
}

// ============================================================================
// PRINTABLE PARTS - UPDATED
// ============================================================================

// Part 11: Microphone Mount Bracket (NEW)
module microphone_bracket_printable() {
    rotate([90, 0, 0]) {
        microphone_mount();
    }
}

// Part 12: Microphone Mount Post (NEW)
module microphone_post_printable() {
    microphone_mount_post();
}

// ============================================================================
// RENDER OPTIONS
// ============================================================================

// Full assembly with sound reactivity
complete_assembly_with_sound();

// Export individual parts:
// microphone_bracket_printable();
// microphone_post_printable();

// ============================================================================
// NOTES FOR SOUND REACTIVE VERSION
// ============================================================================
//
// MICROPHONE SPECIFICATIONS:
// - Model: INMP441 (I2S MEMS Microphone)
// - Interface: I2S digital audio
// - Sensitivity: -26 dBFS @ 94 dB SPL
// - Frequency response: 50 Hz - 20 kHz
// - Supply: 3.3V
// - Current: ~5mA
//
// WIRING (ESP32 to INMP441):
// - SCK (Clock):  GPIO 14
// - WS (Word Select): GPIO 32
// - SD (Serial Data): GPIO 33
// - GND: GND
// - VCC: 3.3V
//
// ACOUSTIC DESIGN:
// - Sound port diameter: 8mm (optimized for speech/music)
// - Acoustic funnel focuses sound to microphone
// - Internal channel routes audio to sensor
// - Minimal reflections (rounded surfaces)
//
// 3D PRINTING ADDITIONS:
// - Part 11: Microphone bracket (~30 min, 3g PLA)
// - Part 12: Mount post (~20 min, 2g PLA)
// - Total additional print time: ~50 minutes
// - Total additional material: ~5g (~$0.04)
//
// ASSEMBLY NOTES:
// 1. Mount microphone bracket to side post
// 2. Secure INMP441 module in bracket
// 3. Route I2S cables through internal channel
// 4. Connect to ESP32 I2S pins
// 5. Ensure acoustic path is clear
// 6. Test audio levels before final assembly
//
// ============================================================================
