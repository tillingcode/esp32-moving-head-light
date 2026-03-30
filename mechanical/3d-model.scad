// ESP32 Moving Head Light - Complete 3D Model
// OpenSCAD Design for 3D Printing
// Created: 2026-03-30
// Size: Tennis ball (~6.5 cm diameter)
// Material: PLA (FDM 3D Printing)

// ============================================================================
// PARAMETERS & CONFIGURATION
// ============================================================================

// Main enclosure
DIAMETER = 65;  // 6.5 cm tennis ball size
RADIUS = DIAMETER / 2;
WALL_THICKNESS = 2;  // 2mm PLA walls
DETAIL_LEVEL = 32;  // $fn for smooth curves

// Servo specifications
SG90_WIDTH = 23;
SG90_HEIGHT = 22.5;
SG90_LENGTH = 50;

// LED specification (WS2812B)
LED_DIAMETER = 5;

// USB-C port
USB_C_WIDTH = 9;
USB_C_HEIGHT = 6;
USB_C_DEPTH = 3;

// Mounting holes & clips
CLIP_WIDTH = 4;
CLIP_HEIGHT = 3;
CLIP_DEPTH = 2;

// ============================================================================
// UTILITY MODULES
// ============================================================================

// Create a rounded sphere (enclosure base)
module sphere_rounded(radius, wall_thick) {
    difference() {
        sphere(r=radius, $fn=DETAIL_LEVEL);
        sphere(r=radius - wall_thick, $fn=DETAIL_LEVEL);
    }
}

// Servo bracket for mounting
module servo_bracket(length, width, height) {
    difference() {
        cube([length, width, height], center=true);
        // Mounting holes
        translate([length/4, 0, 0]) cylinder(r=1.5, h=height+1, center=true, $fn=16);
        translate([-length/4, 0, 0]) cylinder(r=1.5, h=height+1, center=true, $fn=16);
    }
}

// LED mount/reflector
module led_reflector() {
    union() {
        // LED housing (cylinder)
        cylinder(r=LED_DIAMETER/2 + 1, h=8, center=true, $fn=DETAIL_LEVEL);
        
        // Parabolic reflector (cone)
        translate([0, 0, 6]) {
            cylinder(r1=LED_DIAMETER/2 + 2, r2=LED_DIAMETER/2 + 5, h=8, $fn=DETAIL_LEVEL);
        }
    }
}

// Servo arm/linkage
module servo_arm(length) {
    union() {
        // Arm shaft
        cylinder(r=3, h=length, center=true, $fn=16);
        // Mounting hub
        cylinder(r=7, h=4, center=true, $fn=DETAIL_LEVEL);
    }
}

// Mounting clip (for holding components)
module mounting_clip() {
    difference() {
        cube([CLIP_WIDTH, CLIP_HEIGHT, CLIP_DEPTH], center=true);
        cylinder(r=1, h=CLIP_DEPTH+1, center=true, $fn=12);
    }
}

// ============================================================================
// MAIN ASSEMBLY
// ============================================================================

// PAN AXIS (Base Rotation)
module pan_assembly() {
    color([0.8, 0.8, 0.8]) {
        // Pan servo at base
        translate([0, 0, -RADIUS + 8]) {
            cube([SG90_LENGTH, SG90_WIDTH, SG90_HEIGHT], center=true);
        }
        
        // Pan servo shaft bracket
        translate([0, 0, -RADIUS + 15]) {
            servo_bracket(40, 15, 8);
        }
    }
}

// TILT AXIS (Side Motion)
module tilt_assembly() {
    color([0.7, 0.7, 0.7]) {
        // Tilt servo on side arm
        translate([RADIUS - 15, 0, 0]) {
            rotate([0, 90, 0]) {
                cube([SG90_LENGTH, SG90_WIDTH, SG90_HEIGHT], center=true);
            }
        }
        
        // Tilt arm linkage
        translate([RADIUS - 5, 0, 0]) {
            rotate([0, 90, 0]) {
                servo_arm(25);
            }
        }
    }
}

// ROLL AXIS (Spin Motion)
module roll_assembly() {
    color([0.6, 0.6, 0.6]) {
        // Roll servo at top center
        translate([0, 0, RADIUS - 8]) {
            rotate([0, 0, 0]) {
                cube([SG90_LENGTH, SG90_WIDTH, SG90_HEIGHT], center=true);
            }
        }
        
        // Roll servo to LED connection
        translate([0, 0, RADIUS - 2]) {
            cylinder(r=3, h=12, center=true, $fn=16);
        }
    }
}

// LED AND REFLECTOR (Center)
module led_assembly() {
    color([1, 0.5, 0]) {
        // LED reflector
        led_reflector();
        
        // LED mount ring
        translate([0, 0, -3]) {
            difference() {
                cylinder(r=12, h=3, $fn=DETAIL_LEVEL);
                cylinder(r=8, h=3.5, center=true, $fn=DETAIL_LEVEL);
            }
        }
    }
}

// MAIN ENCLOSURE (Tennis Ball Shape)
module enclosure_shell() {
    color([0.2, 0.2, 0.2, 0.3]) {
        difference() {
            // Outer sphere
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
        }
    }
}

// INTERNAL MOUNTING FRAME
module internal_frame() {
    color([0.4, 0.4, 0.4]) {
        // Central hub for servo interconnection
        union() {
            // Main hub
            cylinder(r=15, h=8, center=true, $fn=DETAIL_LEVEL);
            
            // Pan servo mount plate
            translate([0, 0, -8]) {
                cube([50, 30, 4], center=true);
            }
            
            // Tilt servo mount arm
            translate([20, 0, 0]) {
                cube([8, 6, 25], center=true);
            }
            
            // Roll servo mount post
            translate([0, 0, 12]) {
                cube([10, 10, 6], center=true);
            }
        }
    }
}

// CIRCUIT BOARD MOUNT
module pcb_mount() {
    color([0.2, 0.6, 0.2]) {
        // ESP32 development board mount
        translate([0, 0, -20]) {
            difference() {
                // Board cradle
                cube([60, 30, 8], center=true);
                
                // Component cutouts
                translate([15, 0, 0]) {
                    cylinder(r=2, h=9, center=true, $fn=12);
                }
                translate([-15, 0, 0]) {
                    cylinder(r=2, h=9, center=true, $fn=12);
                }
            }
        }
    }
}

// BATTERY COMPARTMENT
module battery_mount() {
    color([1, 0.5, 0]) {
        // 18650 battery holder (optional)
        translate([0, 15, -15]) {
            union() {
                // Battery cylindrical holder
                cylinder(r=10, h=70, center=true, $fn=DETAIL_LEVEL);
                
                // Connector tabs
                translate([0, 0, 35]) {
                    cube([8, 20, 4], center=true);
                }
            }
        }
    }
}

// CONNECTOR CABLES (Visual)
module internal_wiring() {
    color([1, 1, 0, 0.5]) {
        // Pan servo wire
        hull() {
            translate([0, 0, -RADIUS + 8]) sphere(r=1, $fn=8);
            translate([5, 0, -5]) sphere(r=1, $fn=8);
        }
        
        // Tilt servo wire
        hull() {
            translate([RADIUS - 15, 0, 0]) sphere(r=1, $fn=8);
            translate([5, 0, -5]) sphere(r=1, $fn=8);
        }
        
        // Roll servo wire
        hull() {
            translate([0, 0, RADIUS - 8]) sphere(r=1, $fn=8);
            translate([5, 0, -5]) sphere(r=1, $fn=8);
        }
        
        // LED wire
        hull() {
            translate([0, 0, 0]) sphere(r=1, $fn=8);
            translate([5, 0, -5]) sphere(r=1, $fn=8);
        }
    }
}

// ============================================================================
// COMPLETE ASSEMBLY (Main View)
// ============================================================================

module complete_assembly() {
    // Enclosure shell (transparent)
    enclosure_shell();
    
    // Internal mounting frame
    internal_frame();
    
    // Pan assembly (base rotation)
    pan_assembly();
    
    // Tilt assembly (side motion)
    tilt_assembly();
    
    // Roll assembly (spin motion)
    roll_assembly();
    
    // LED and reflector (center)
    led_assembly();
    
    // Circuit board mount
    pcb_mount();
    
    // Battery compartment (optional)
    battery_mount();
    
    // Internal wiring (visual reference)
    internal_wiring();
}

// ============================================================================
// PRINTABLE PARTS (For 3D Printing - Export these separately)
// ============================================================================

// Part 1: Enclosure Top Half
module enclosure_top_half() {
    intersection() {
        sphere(r=RADIUS, $fn=DETAIL_LEVEL);
        translate([0, 0, 0]) cube([DIAMETER+10, DIAMETER+10, RADIUS+5], center=true);
    }
}

// Part 2: Enclosure Bottom Half
module enclosure_bottom_half() {
    intersection() {
        sphere(r=RADIUS, $fn=DETAIL_LEVEL);
        translate([0, 0, 0]) cube([DIAMETER+10, DIAMETER+10, RADIUS+5], center=false);
    }
}

// Part 3: Internal Frame/Hub (Single piece)
module frame_printable() {
    internal_frame();
    
    // Add connection ribs
    for (angle = [0 : 90 : 270]) {
        rotate([0, 0, angle]) {
            translate([10, 0, 0]) {
                cube([8, 4, 20], center=true);
            }
        }
    }
}

// Part 4: Servo Mounting Brackets
module servo_brackets_printable() {
    translate([0, 0, 0]) servo_bracket(50, 20, 10);
    translate([70, 0, 0]) servo_bracket(35, 20, 8);
    translate([140, 0, 0]) servo_bracket(30, 20, 8);
}

// Part 5: LED Reflector/Housing
module led_housing_printable() {
    led_reflector();
}

// Part 6: Pan Servo Arm
module pan_arm_printable() {
    servo_arm(30);
}

// Part 7: Tilt Servo Arm
module tilt_arm_printable() {
    servo_arm(25);
}

// Part 8: Roll Servo Connection Hub
module roll_hub_printable() {
    difference() {
        cylinder(r=12, h=15, $fn=DETAIL_LEVEL);
        cylinder(r=3.5, h=15.5, center=true, $fn=16);
    }
}

// Part 9: PCB Mounting Cradle
module pcb_cradle_printable() {
    difference() {
        cube([70, 40, 10], center=true);
        translate([-20, -15, 0]) cylinder(r=2.5, h=11, center=true, $fn=12);
        translate([20, -15, 0]) cylinder(r=2.5, h=11, center=true, $fn=12);
        translate([-20, 15, 0]) cylinder(r=2.5, h=11, center=true, $fn=12);
        translate([20, 15, 0]) cylinder(r=2.5, h=11, center=true, $fn=12);
    }
}

// Part 10: Cable Clips (Multiple)
module cable_clips_printable() {
    for (i = [0 : 3]) {
        translate([i*20, 0, 0]) mounting_clip();
    }
}

// ============================================================================
// RENDER OPTIONS
// ============================================================================

// MAIN: Full Assembly View (For visualization)
complete_assembly();

// UNCOMMENT BELOW TO EXPORT INDIVIDUAL PRINTABLE PARTS:

// enclosure_top_half();
// enclosure_bottom_half();
// frame_printable();
// servo_brackets_printable();
// led_housing_printable();
// pan_arm_printable();
// tilt_arm_printable();
// roll_hub_printable();
// pcb_cradle_printable();
// cable_clips_printable();

// ============================================================================
// NOTES FOR 3D PRINTING
// ============================================================================
// 
// Print Settings:
// - Layer height: 0.2mm (standard)
// - Infill: 15-20% (honeycomb pattern recommended)
// - Support: YES (for overhangs, especially servo brackets)
// - Print speed: 50-60 mm/s
// - Nozzle temp: 200-210°C (PLA)
// - Bed temp: 60°C
//
// Parts List:
// - Part 1: Enclosure Top Half (~2 hours print)
// - Part 2: Enclosure Bottom Half (~2 hours print)
// - Part 3: Internal Frame (~1 hour print)
// - Part 4: Servo Brackets (~1 hour print)
// - Part 5: LED Reflector (~30 minutes print)
// - Parts 6-10: Small parts (~1 hour total print)
//
// Total print time: ~7-8 hours
// Material: ~80-100g PLA (~$2-3)
//
// Post-Processing:
// 1. Remove support material carefully
// 2. Clean up layer lines with sanding (120→400 grit)
// 3. Optional: Smooth with acetone vapor (ABS only, skip for PLA)
// 4. Paint with matte black (optional, for professional look)
// 5. Test fit all servo mounts before assembly
//
// Assembly:
// 1. Mount pan servo to bottom of enclosure
// 2. Mount tilt servo to side arm
// 3. Mount roll servo to top
// 4. Connect all servo arms to central hub
// 5. Mount LED reflector to roll servo shaft
// 6. Install ESP32 PCB in cradle
// 7. Solder servo connections to ESP32
// 8. Install optional battery in compartment
// 9. Attach USB-C port connector
// 10. Glue enclosure halves together with epoxy
// 11. Cable management with clips
// 12. Test all three axes for smooth motion
//
// ============================================================================
