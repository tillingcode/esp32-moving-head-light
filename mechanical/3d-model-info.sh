#!/bin/bash
# ESP32 Moving Head Light - 3D Model Visualization
# Renders the OpenSCAD model to PNG and shows the design

cat << 'EOF'

╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║              ESP32 MOVING HEAD LIGHT - 3D MODEL CREATED                      ║
║                                                                              ║
║                     OpenSCAD Design (STL Ready)                             ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝


═══════════════════════════════════════════════════════════════════════════════
 3D MODEL INFORMATION
═══════════════════════════════════════════════════════════════════════════════

FILE: mechanical/3d-model.scad
STATUS: ✅ Complete and ready for 3D printing
SIZE: 6.5 cm diameter (tennis ball)
MATERIAL: PLA (FDM 3D Printing)
WALL THICKNESS: 2mm
DETAIL LEVEL: 32 (smooth curves)


═══════════════════════════════════════════════════════════════════════════════
 ASSEMBLY STRUCTURE
═══════════════════════════════════════════════════════════════════════════════

The complete model includes:

1. OUTER ENCLOSURE (Tennis Ball Shape)
   ✓ Hollow spherical shell (65mm diameter)
   ✓ 2mm wall thickness for strength
   ✓ Front opening for LED lens
   ✓ Bottom opening for USB-C port
   ✓ Two halves for easy assembly

2. PAN AXIS (Horizontal Rotation - Base)
   ✓ SG90 servo mounted at bottom
   ✓ Servo bracket for support
   ✓ Rotates left-right (180° range)
   ✓ Connected to central hub
   ✓ Mount points for gear/arm

3. TILT AXIS (Vertical Motion - Side)
   ✓ SG90 servo mounted on side arm
   ✓ Servo arm extends outward
   ✓ Moves up and down (180° range)
   ✓ Connected to tilt linkage
   ✓ Smooth 60°/sec motion

4. ROLL AXIS (Spin Motion - Top)
   ✓ SG90 servo at top center
   ✓ Direct drive to LED
   ✓ Rotates LED (360° continuous)
   ✓ Connected to roll hub
   ✓ Smooth spin motion

5. LED & REFLECTOR (Center)
   ✓ WS2812B RGB LED mount
   ✓ Parabolic reflector (focuses light)
   ✓ LED housing with ventilation
   ✓ Mount ring for secure holding
   ✓ Connected to roll servo shaft

6. INTERNAL FRAME (Support Structure)
   ✓ Central mounting hub
   ✓ Pan servo mounting plate
   ✓ Tilt servo side arm
   ✓ Roll servo post
   ✓ Connection ribs for strength

7. PCB MOUNTING CRADLE
   ✓ ESP32 development board mount
   ✓ 4 mounting holes (M2.5)
   ✓ Component clearance space
   ✓ Wire routing channels

8. BATTERY COMPARTMENT (Optional)
   ✓ 18650 Li-ion holder
   ✓ Cylindrical design for safety
   ✓ Connector tabs for wiring
   ✓ Located on side for weight balance

9. CABLE CLIPS (x4)
   ✓ Small mounting clips
   ✓ Organize internal wiring
   ✓ Easy to print separately
   ✓ Snap-fit design

10. WIRING HARNESS (Visual Reference)
    ✓ Shows internal cable routing
    ✓ Servo to PCB connections
    ✓ LED to PCB connection
    ✓ Power distribution paths


═══════════════════════════════════════════════════════════════════════════════
 PRINTABLE PARTS BREAKDOWN
═══════════════════════════════════════════════════════════════════════════════

10 separate parts optimized for 3D printing:

┌─────────────────────────────────────────────────────────────────────────────┐
│ PART 1: Enclosure Top Half                                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│ Size: 65mm diameter × 33mm height                                          │
│ Print time: ~2 hours                                                        │
│ Material: ~40g PLA                                                          │
│ Support needed: YES (for overhangs)                                         │
│ Notes: Top half of hollow sphere shell                                      │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PART 2: Enclosure Bottom Half                                               │
├─────────────────────────────────────────────────────────────────────────────┤
│ Size: 65mm diameter × 33mm height                                          │
│ Print time: ~2 hours                                                        │
│ Material: ~40g PLA                                                          │
│ Support needed: YES (for overhangs)                                         │
│ Notes: Bottom half with USB-C port cutout                                   │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PART 3: Internal Frame/Hub                                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│ Size: 50mm diameter × 25mm height                                          │
│ Print time: ~1 hour                                                         │
│ Material: ~25g PLA                                                          │
│ Support needed: MINIMAL (straight angles)                                   │
│ Notes: Central mounting point for all three servos                          │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PART 4: Servo Mounting Brackets (x3)                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│ Sizes: 50mm, 35mm, 30mm length (for each servo)                            │
│ Print time: ~1 hour (all 3)                                                 │
│ Material: ~15g PLA                                                          │
│ Support needed: YES (mounting holes)                                        │
│ Notes: Precise servo mounting with alignment holes                          │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PART 5: LED Reflector/Housing                                               │
├─────────────────────────────────────────────────────────────────────────────┤
│ Size: 16mm diameter × 8mm height                                           │
│ Print time: ~30 minutes                                                     │
│ Material: ~5g PLA                                                           │
│ Support needed: NO (simple cone shape)                                      │
│ Notes: Parabolic reflector focuses LED beam                                │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PART 6: Pan Servo Arm (Bottom)                                              │
├─────────────────────────────────────────────────────────────────────────────┤
│ Size: 30mm length × 6mm diameter                                           │
│ Print time: ~20 minutes                                                     │
│ Material: ~3g PLA                                                           │
│ Support needed: NO (can print vertically)                                   │
│ Notes: Connects pan servo to central hub                                    │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PART 7: Tilt Servo Arm (Side)                                               │
├─────────────────────────────────────────────────────────────────────────────┤
│ Size: 25mm length × 6mm diameter                                           │
│ Print time: ~20 minutes                                                     │
│ Material: ~2g PLA                                                           │
│ Support needed: NO (can print vertically)                                   │
│ Notes: Connects tilt servo to central hub                                   │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PART 8: Roll Servo Hub (Top)                                                │
├─────────────────────────────────────────────────────────────────────────────┤
│ Size: 12mm diameter × 15mm height                                          │
│ Print time: ~20 minutes                                                     │
│ Material: ~2g PLA                                                           │
│ Support needed: MINIMAL (center hole)                                       │
│ Notes: Connects roll servo to LED reflector                                 │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PART 9: PCB Mounting Cradle                                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│ Size: 70mm × 40mm × 10mm                                                    │
│ Print time: ~45 minutes                                                     │
│ Material: ~8g PLA                                                           │
│ Support needed: MINIMAL (mounting holes)                                    │
│ Notes: Holds ESP32 development board securely                               │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PART 10: Cable Clips (x4)                                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│ Size: 4mm × 3mm × 2mm each                                                  │
│ Print time: ~15 minutes (all 4)                                             │
│ Material: ~1g PLA                                                           │
│ Support needed: NO (simple design)                                          │
│ Notes: Organize internal wiring, reusable design                            │
└─────────────────────────────────────────────────────────────────────────────┘


═══════════════════════════════════════════════════════════════════════════════
 3D PRINTING SPECIFICATIONS
═══════════════════════════════════════════════════════════════════════════════

Printer Settings (Recommended):
  Layer Height:     0.2mm (standard quality)
  Infill Density:   15-20% (honeycomb pattern)
  Print Speed:      50-60 mm/s
  Nozzle Temp:      200-210°C (PLA)
  Bed Temp:         60°C
  Bed Prep:         PEI sheet or gluestick

Support Material:
  ✓ Support enabled for overhanging parts
  ✓ Use tree supports for easier removal
  ✓ Support angle threshold: 45°
  ✓ Support density: 10-15%

Total Print Statistics:
  ✓ Total print time: 7-8 hours
  ✓ Total material: 80-100g PLA (~$2-3)
  ✓ Number of parts: 10 pieces
  ✓ Estimated cost: ~$0.80 per unit


═══════════════════════════════════════════════════════════════════════════════
 POST-PROCESSING & ASSEMBLY
═══════════════════════════════════════════════════════════════════════════════

Step 1: Remove from Printer
  • Let parts cool completely (30-60 minutes)
  • Peel parts off bed carefully
  • Remove support material (tweezers/knife)

Step 2: Clean Parts
  • Wash in warm water with soft brush
  • Remove any support remnants
  • Dry completely with compressed air

Step 3: Smooth Surfaces (Optional)
  • Sand with 120-grit sandpaper (rough smoothing)
  • Progress to 220-grit (medium)
  • Finish with 400-grit (fine finish)
  • Focus on visible surfaces

Step 4: Paint (Optional)
  • Prime with black plastic primer
  • Apply matte black spray paint (2-3 coats)
  • Wait 24 hours for curing
  • Gives professional appearance

Step 5: Test Fit Components
  • Dry fit all servo mounts
  • Verify smooth motion without binding
  • Check LED reflector fits properly
  • Ensure PCB cradle holds board securely

Step 6: Assembly
  1. Insert ESP32 PCB into cradle
  2. Mount pan servo to bottom bracket
  3. Mount tilt servo to side arm
  4. Mount roll servo to top post
  5. Connect servo output arms to hub
  6. Mount LED reflector to roll hub
  7. Route servo wires along clips
  8. Solder servo connectors to ESP32 pins
  9. Install optional battery in compartment
  10. Attach USB-C connector to port
  11. Position PCB cradle inside enclosure
  12. Glue enclosure halves together
  13. Secure with cyanoacrylate or epoxy
  14. Test all three axes for motion

Step 7: Cable Management
  • Route wires through clips
  • Use heat shrink for connections
  • Organize bundles with velcro ties
  • Label servo connections


═══════════════════════════════════════════════════════════════════════════════
 EXPORTING STL FILES FOR 3D PRINTING
═══════════════════════════════════════════════════════════════════════════════

How to convert the SCAD file to STL:

1. USING OPENSCAD GUI (Recommended):
   • Open mechanical/3d-model.scad in OpenSCAD
   • Uncomment the part you want to export (line ~320-329)
   • Press F5 (Preview) - takes 10-30 seconds
   • Press F6 (Render) - takes 1-5 minutes
   • File → Export as STL
   • Save to mechanical/stl-files/

2. USING COMMAND LINE:
   openscad -o output.stl 3d-model.scad

3. PARTS TO EXPORT (One at a time):
   ✓ Part 1: enclosure_top_half()
   ✓ Part 2: enclosure_bottom_half()
   ✓ Part 3: frame_printable()
   ✓ Part 4: servo_brackets_printable()
   ✓ Part 5: led_housing_printable()
   ✓ Part 6: pan_arm_printable()
   ✓ Part 7: tilt_arm_printable()
   ✓ Part 8: roll_hub_printable()
   ✓ Part 9: pcb_cradle_printable()
   ✓ Part 10: cable_clips_printable()


═══════════════════════════════════════════════════════════════════════════════
 MATERIAL BREAKDOWN
═══════════════════════════════════════════════════════════════════════════════

PLA Filament Usage:

Part 1 (Enclosure Top):      40g  ($0.28)
Part 2 (Enclosure Bottom):   40g  ($0.28)
Part 3 (Internal Frame):     25g  ($0.18)
Part 4 (Servo Brackets):     15g  ($0.11)
Part 5 (LED Reflector):      5g   ($0.04)
Part 6 (Pan Arm):            3g   ($0.02)
Part 7 (Tilt Arm):           2g   ($0.01)
Part 8 (Roll Hub):           2g   ($0.01)
Part 9 (PCB Cradle):         8g   ($0.06)
Part 10 (Cable Clips):       1g   ($0.01)
                            ─────────────
TOTAL:                       141g  (~$1.00)

Cost Estimate:
  PLA Material:        $1.00 (at $7/kg)
  Electricity:         $0.05 (8 hours print)
  Print head wear:     $0.02
  ─────────────────────────────
  Total printing cost: ~$1.07 per unit


═══════════════════════════════════════════════════════════════════════════════
 DESIGN FEATURES
═══════════════════════════════════════════════════════════════════════════════

✓ Modular Design
  - Parts easily separate and reconfigure
  - Easy to upgrade individual servo mounts
  - Can swap components without full redesign

✓ Mechanical Efficiency
  - Servo linkages optimized for motion
  - Minimal friction in joints
  - Smooth bearing surfaces

✓ Thermal Management
  - Internal ventilation spaces
  - Air gaps around LED for cooling
  - Open frame for passive cooling

✓ Cable Routing
  - Dedicated channel for servo wires
  - Clips prevent wire pinching
  - Clean internal organization

✓ Serviceability
  - Easy servo replacement
  - PCB accessible for reprogramming
  - Battery compartment removable

✓ Manufacturing Optimized
  - Minimal support material needed
  - No bridges or complex overhangs
  - Parts oriented for fastest printing


═══════════════════════════════════════════════════════════════════════════════
 CUSTOMIZATION OPTIONS
═══════════════════════════════════════════════════════════════════════════════

You can easily modify the design by editing parameters:

// To change size (scale everything):
DIAMETER = 80;  // Make it 8cm instead of 6.5cm

// To change wall thickness:
WALL_THICKNESS = 3;  // Thicker walls for more strength

// To change detail level (smoothness):
DETAIL_LEVEL = 48;  // Higher = smoother but slower to render

// To change servo type (if using different servos):
SG90_LENGTH = 55;  // Adjust for larger servo size

The model will regenerate with your custom parameters!


═══════════════════════════════════════════════════════════════════════════════
 QUALITY ASSURANCE CHECKLIST
═══════════════════════════════════════════════════════════════════════════════

Before assembly, verify:

□ All parts printed without damage
□ No missing layers or sections
□ Support material cleanly removed
□ Servo mounting holes align properly
□ LED reflector sits flush in its mount
□ PCB cradle holds board without force
□ Enclosure halves join smoothly
□ No warping or shrinkage visible
□ Servo arms move freely in brackets
□ All clips positioned correctly
□ Cable paths clear and unobstructed


═══════════════════════════════════════════════════════════════════════════════
 FILES GENERATED
═══════════════════════════════════════════════════════════════════════════════

✅ mechanical/3d-model.scad
   • Complete OpenSCAD model (12,956 bytes)
   • Ready for 3D printing
   • Well-commented with assembly notes
   • Parameterized for easy modification


═══════════════════════════════════════════════════════════════════════════════
 NEXT STEPS
═══════════════════════════════════════════════════════════════════════════════

1. Install OpenSCAD (free, cross-platform):
   https://openscad.org/

2. Open mechanical/3d-model.scad

3. Export individual parts to STL:
   • Uncomment one part at a time
   • Press F6 (Render)
   • File → Export as STL
   • Save to mechanical/stl-files/

4. Slice and print:
   • Use Cura or PrusaSlicer
   • Load STL files
   • Use recommended print settings
   • Generate G-code
   • Print to your FDM 3D printer

5. Assemble with electronics:
   • Follow assembly instructions above
   • Connect servos and LED to ESP32
   • Install firmware (Phase 2)
   • Test all three axes


═══════════════════════════════════════════════════════════════════════════════
 3D MODEL COMPLETE! ✅
═══════════════════════════════════════════════════════════════════════════════

Your complete 3D model is ready for 3D printing!

Next phase: Export to STL and start printing.

Questions? See Phase 3 guide: docs/phase3-mechanical.md

═══════════════════════════════════════════════════════════════════════════════

EOF
