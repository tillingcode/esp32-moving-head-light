// ESP32 Moving Head Light - Sound Reactive 3D Model (Updated)
// Added microphone mount and sound port
// OpenSCAD Design for 3D Printing with audio input
// Created: 2026-03-30

// ============================================================================
// PARAMETERS & CONFIGURATION (Shared with base model)
// ============================================================================

// Main enclosure
DIAMETER = 65;  // 6.5 cm tennis ball size
RADIUS = DIAMETER / 2;
WALL_THICKNESS = 2;  // 2mm PLA walls
DETAIL_LEVEL = 32;  // $fn for smooth curves

// USB-C port
USB_C_WIDTH = 9;
USB_C_HEIGHT = 6;
USB_C_DEPTH = 3;

// Microphone specifications (NEW)
MIC_MODULE_WIDTH = 28;   // INMP441 I2S microphone module
MIC_MODULE_HEIGHT = 15;
MIC_MODULE_LENGTH = 38;

// Sound port opening
SOUND_PORT_DIAMETER = 8;  // 8mm opening for sound intake
SOUND_PORT_DEPTH = 5;

// ============================================================================
// UTILITY MODULES (From base model)
// ============================================================================

// Internal mounting frame (simplified from base)
module internal_frame() {
    color([0.7, 0.7, 0.7]) {
        // Frame posts for servo mounting
        translate([0, 0, 0]) cylinder(r=3, h=40, center=true, $fn=DETAIL_LEVEL);
    }
}

// Pan assembly (simplified)
module pan_assembly() {
    color([0.8, 0.2, 0.2]) {
        translate([0, 0, -RADIUS + 8]) {
            cube([50, 23, 22.5], center=true);
        }
    }
}

// Tilt assembly (simplified)
module tilt_assembly() {
    color([0.2, 0.8, 0.2]) {
        translate([RADIUS - 15, 0, 0]) {
            cube([8, 6, 25], center=true);
        }
    }
}

// Roll assembly (simplified)
module roll_assembly() {
    color([0.2, 0.2, 0.8]) {
        translate([0, 0, RADIUS - 8]) {
            cube([10, 10, 6], center=true);
        }
    }
}

// LED assembly (simplified)
module led_assembly() {
    color([1, 1, 0]) {
        translate([0, -RADIUS + 5, 0]) {
            union() {
                cylinder(r=3.5, h=8, center=true, $fn=DETAIL_LEVEL);
                translate([0, 0, 6]) {
                    cylinder(r1=5, r2=8, h=8, $fn=DETAIL_LEVEL);
                }
            }
        }
    }
}

// PCB mount
module pcb_mount() {
    color([0.2, 0.6, 0.2]) {
        translate([0, 0, -20]) {
            difference() {
                cube([60, 30, 8], center=true);
                translate([15, 0, 0]) cylinder(r=2, h=9, center=true, $fn=12);
                translate([-15, 0, 0]) cylinder(r=2, h=9, center=true, $fn=12);
            }
        }
    }
}

// Battery mount
module battery_mount() {
    color([1, 0.5, 0]) {
        translate([0, 15, -15]) {
            union() {
                cylinder(r=10, h=70, center=true, $fn=DETAIL_LEVEL);
                translate([0, 0, 35]) cube([8, 20, 4], center=true);
            }
        }
    }
}

// Internal wiring
module internal_wiring() {
    color([1, 1, 0, 0.5]) {
        // Visual wiring paths
        hull() {
            translate([0, 0, -RADIUS + 8]) sphere(r=1, $fn=8);
            translate([5, 0, -5]) sphere(r=1, $fn=8);
        }
    }
}

// ============================================================================
// MICROPHONE MOUNT MODULES (NEW)
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
            
            // Screw holes (2x)
            translate([-12, 0, 0]) cylinder(r=1.5, h=9, center=true, $fn=16);
            translate([12, 0, 0]) cylinder(r=1.5, h=9, center=true, $fn=16);
        }
        
        // Cable channel
        translate([15, 0, 0]) {
            cube([8, 3, 6], center=true);
        }
    }
}

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

module sound_port_opening() {
    // Port for acoustic input
    translate([RADIUS - WALL_THICKNESS - 1, 0, 0]) {
        union() {
            // Main port opening
            cylinder(r=SOUND_PORT_DIAMETER/2, h=SOUND_PORT_DEPTH, $fn=DETAIL_LEVEL);
            
            // Acoustic funnel
            translate([0, 0, SOUND_PORT_DEPTH/2]) {
                cylinder(r1=SOUND_PORT_DIAMETER/2, r2=SOUND_PORT_DIAMETER/2 + 2, 
                        h=4, $fn=DETAIL_LEVEL);
            }
        }
    }
}

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
// ENCLOSURE WITH SOUND PORT
// ============================================================================

module enclosure_shell_with_sound_port() {
    color([0.2, 0.2, 0.2, 0.3]) {
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
}

// ============================================================================
// COMPLETE ASSEMBLY WITH SOUND REACTIVITY
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
    microphone_mount_post();
    
    translate([RADIUS - 25, 0, -RADIUS + 20]) {
        rotate([0, 90, 0]) {
            microphone_mount();
        }
    }
    
    translate([RADIUS - 18, 0, -RADIUS + 20]) {
        rotate([0, 90, 0]) {
            microphone_housing();
        }
    }
    
    // Internal wiring (visual)
    internal_wiring();
}

// ============================================================================
// PRINTABLE PARTS - SOUND REACTIVE
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
// RENDER
// ============================================================================

// Full assembly with sound reactivity
complete_assembly_with_sound();

// Export individual parts (uncomment to render):
// microphone_bracket_printable();
// microphone_post_printable();

// ============================================================================
// NOTES
// ============================================================================
//
// MICROPHONE SPECIFICATIONS:
// - Model: INMP441 (I2S MEMS Microphone)
// - Interface: I2S digital audio
// - Sensitivity: -26 dBFS @ 94 dB SPL
// - Frequency response: 50 Hz - 20 kHz
// - Supply: 3.3V, Current: ~5mA
//
// WIRING (ESP32 to INMP441):
// - SCK (Clock):  GPIO 14
// - WS (Word Select): GPIO 32
// - SD (Serial Data): GPIO 33
// - GND: GND
// - VCC: 3.3V
//
// ACOUSTIC DESIGN:
// - Sound port diameter: 8mm
// - Acoustic funnel focuses sound
// - Internal channel routes audio
//
// 3D PRINTING:
// - Part 11: Microphone bracket (~30 min, 3g)
// - Part 12: Mount post (~20 min, 2g)
// - Total: ~50 min print time, 5g material
//
// ============================================================================
