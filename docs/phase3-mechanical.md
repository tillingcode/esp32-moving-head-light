# Phase 3: Mechanical Design & 3D Printing

**Duration:** Week 2-4 (parallel with Phase 2)  
**Goal:** Design and print 3D enclosure that houses all electronics

---

## 3.1 Design Principles

### Constraints
- **Size:** Tennis ball (~6.5 cm diameter) or slightly larger
- **Weight:** <200g (serviceable by SG90 servos)
- **Volume:** ~150-200 cm³ usable interior
- **Motion:** Pan/Tilt/Roll - each servo must have independent freedom
- **Assembly:** Tool-free (press-fit or snap-fit)
- **Cooling:** Passive air circulation (no active cooling needed at this scale)

### Design Approach

```
     ┌─────────────────┐
     │   Main Sphere   │ (3D Printed)
     │   ~6.5cm dia    │
     └────────┬────────┘
              │
              ├─ Pan Motor (bottom servo)
              │  └─ Tilt Motor (side servo on pan arm)
              │     └─ Roll Motor (LED axis servo)
              │        └─ RGB LED + Reflector
              │
              └─ Internal Cavity
                 ├─ ESP32 main board
                 ├─ Power distribution
                 └─ Wiring channels
```

---

## 3.2 CAD Design Overview

### Parts to Design

1. **Main Sphere/Body**
   - Hemisphere or partial sphere
   - Interior cavity for electronics
   - Mounting bosses for pan servo

2. **Pan Mount Base**
   - Attached to main sphere
   - Accepts SG90 servo horn
   - Rotating platform for tilt assembly

3. **Tilt Arm Assembly**
   - Extends from pan servo
   - Servo mount at one end
   - LED housing at other end

4. **LED Housing / Reflector**
   - Focuses RGB LED beam
   - Can be parabolic or conical
   - Diffuser option for wide beam

5. **Roll Motor Bracket** (optional)
   - Mounts to tilt arm
   - Spins LED assembly

6. **Cable Management**
   - Internal channels for wires
   - Strain relief clips
   - Organized routing

7. **Assembly Clips / Fasteners**
   - M3 threaded inserts (low-profile)
   - Or snap-fit tabs
   - Tool-free preferred

---

## 3.3 Recommended CAD Software

| Software | Cost | Best For | Learning Curve |
|----------|------|----------|-----------------|
| **Fusion 360** | Free (personal) | Parametric, professional | Medium |
| **FreeCAD** | Free (open-source) | Non-commercial, flexible | High |
| **TinkerCAD** | Free (browser-based) | Beginners, fast design | Low |
| **OpenSCAD** | Free (code-based) | Precise, version control friendly | Medium |
| **Autodesk Inventor** | Paid | Professional designs | Medium |

### Recommendation for this project
**Fusion 360** - Best balance of capability and ease for prototype iteration

---

## 3.4 Basic Sphere Design (OpenSCAD Reference)

If using OpenSCAD or code-based approach:

```scad
// Main sphere dimensions
sphere_diameter = 65;  // 6.5 cm
wall_thickness = 3;    // 3mm walls
cavity_diameter = sphere_diameter - (2 * wall_thickness);

// Main body - solid sphere
sphere(d = sphere_diameter);

// Subtract cavity - create hollow interior
difference() {
  sphere(d = sphere_diameter);
  sphere(d = cavity_diameter);
  
  // Cut bottom for electronics access
  translate([0, 0, -sphere_diameter/2])
    cube([sphere_diameter, sphere_diameter, sphere_diameter/2], center=true);
}

// Pan servo mount boss
translate([0, 0, -sphere_diameter/2 + 2])
  cylinder(h = 4, r = 9, $fn = 20);  // Boss diameter ~18mm for servo

// Mounting holes for servo
for (angle = [0, 90, 180, 270])
  rotate([0, 0, angle])
    translate([6, 0, -sphere_diameter/2])
      cylinder(h = 5, r = 1.5, $fn = 12);  // M2 holes
```

---

## 3.5 Design Workflow (Step-by-Step)

### Step 1: Create Main Body

1. Start with sphere primitive (~6.5 cm diameter)
2. Shell/offset to create hollow cavity (3mm walls)
3. Create flat bottom access panel (removable or hinged)
4. Add internal mounting bosses for:
   - Pan servo at bottom
   - ESP32 PCB area
   - Cable routing channels

### Step 2: Pan Mount Assembly

1. Design servo horn attachment point
2. Create rotating platform (circular, ~4cm diameter)
3. Add bearings or friction fit for smooth rotation
4. Ensure wiring can run through center

### Step 3: Tilt Arm

1. Create arm extension (~5cm long)
2. Mount second servo at end
3. Add strain relief for power cable
4. Design LED housing at tilt arm endpoint

### Step 4: LED Reflector/Housing

```
    ┌─────────────┐
    │   Lens      │ (diffuser or clear)
    ├─────────────┤
    │   LED       │ (WS2812B mounted here)
    ├─────────────┤
    │  Reflector  │ (parabolic or conical)
    └─────────────┘
         ↓
      Beam Focus
```

Design options:
- **Parabolic reflector:** Tight focus beam (~15-30° cone angle)
- **Conical reflector:** Medium focus (~45° cone)
- **Flat diffuser:** Wide diffuse light (360° dispersal)

### Step 5: Assembly Features

Add to all parts:
- **Alignment pins/slots:** 2mm pins, 2.2mm slots for precise fit
- **Snap tabs:** Flexible plastic clips that lock parts together
- **Threaded inserts:** M2.5 or M3 for serviceable connections
- **Cable guides:** 3-4mm diameter tubes for wire management

### Step 6: Create Assembly View

- Stack parts in correct orientation
- Add exploded view for documentation
- Check for interference (no overlaps)
- Verify servo range of motion

---

## 3.6 3D Print Preparation

### Export for Printing

1. Export each part as `.stl` file
   - Separate file per part
   - STL format (ASCII or binary)
   - No unsupported overhangs >45°

2. Check files in print preview software:
   - **Cura** (free)
   - **Prusaslicer** (free)
   - **MatterControl** (free)

### Print Settings (PLA)

```
Printer: Ender 3 / Prusa i3 / Similar
Material: PLA (1.75mm)

Nozzle Temperature: 210°C
Bed Temperature: 60°C
Layer Height: 0.2mm (standard quality)
Infill: 20% (gyroid or honeycomb)
Print Speed: 50mm/s (normal)
Supports: YES (for overhangs >45°)
Brim: YES (improves adhesion)

Estimated Print Times:
- Main sphere: 6-8 hours
- Pan mount: 2 hours
- Tilt arm: 3-4 hours
- LED housing: 1-2 hours
- Misc parts: 2-3 hours
- TOTAL: ~16-20 hours
```

### Print Quality Tips

- **Use print support material** for any feature >45° overhang
- **Orient parts to minimize support** (don't print flat - orient at angle)
- **Print on clean bed** with proper leveling
- **First layer is critical** - must be perfect or restart
- **Check prints periodically** during first hour
- **Post-processing:**
  - Remove supports with pliers/scraper
  - Sand lightly (120-220 grit) for smooth finish
  - Paint/stain if desired (optional)

---

## 3.7 Assembly Instructions

### Parts Checklist

After printing, you should have:
- [ ] Main sphere body
- [ ] Pan motor mount base
- [ ] Tilt arm assembly
- [ ] LED housing
- [ ] Bottom access panel
- [ ] Cable clips (×4)
- [ ] Mounting bosses
- [ ] Threaded inserts

### Assembly Steps

**Step 1: Install Threaded Inserts**
```
- Heat threaded inserts with soldering iron
- Press into designated holes in 3D prints
- Use specified insertion depth (usually 2-3mm)
- Allow to cool before handling
```

**Step 2: Mount Pan Servo**
```
1. Take SG90 servo
2. Align servo horn with pan mount boss
3. Secure with M2 screws (provided with servo)
4. Center servo at 90° position
5. Connect servo cable to ESP32 GPIO 4
```

**Step 3: Mount Tilt Servo**
```
1. Attach to tilt arm endpoint
2. Servo horn extends downward
3. Secure LED housing to servo horn
4. Connect servo cable to ESP32 GPIO 5
```

**Step 4: Mount Roll Servo (if used)**
```
1. Attach to LED housing
2. Orient for maximum rotation freedom
3. Connect servo cable to ESP32 GPIO 18
```

**Step 5: Install RGB LED**
```
1. Mount WS2812B in LED housing
2. Solder data line: GPIO 2
3. Solder power: 5V
4. Solder ground: GND
5. Use small heat shrink to insulate connections
6. Add small dab of hot glue to secure LED module
```

**Step 6: Interior Wiring**
```
1. Route all servo cables through internal channels
2. Use adhesive-backed cable clips to organize
3. Group by function (servos, power, data)
4. Leave 5cm slack for serviceability
5. Use hot glue sparingly to anchor cables
```

**Step 7: Mount ESP32 & Power Board**
```
1. Attach ESP32 to bottom interior surface
2. Use double-sided foam tape or small plastic clips
3. Mount USB-C power module nearby
4. Keep wiring organized and labeled
5. Ensure airflow around ESP32 (passive cooling)
```

**Step 8: Close Enclosure**
```
1. Route all cables to exit point (bottom panel)
2. Insert bottom access panel (clip or screw-fit)
3. Test all motion before final closure
4. Apply small plastic feet to bottom if needed
```

---

## 3.8 Testing After Assembly

### Mechanical Tests

- [ ] All three servos move smoothly
- [ ] No binding or grinding sounds
- [ ] Pan rotates 180° or more
- [ ] Tilt covers 0-90° minimum
- [ ] Roll (if present) completes full rotation
- [ ] No vibration during movement
- [ ] Servo arms don't hit body
- [ ] LED housing is secure and doesn't wobble

### Electrical Tests

- [ ] RGB LED lights up when powered
- [ ] WiFi connects successfully
- [ ] Web interface responsive
- [ ] Color control works
- [ ] Position sliders move servos
- [ ] No sparks, smoke, or burning smell
- [ ] Temperature remains cool (<50°C on outside)

### Environmental Tests

- [ ] No rattle when shaken gently
- [ ] All screws tight
- [ ] Cable strain reliefs holding
- [ ] Access panel removable
- [ ] No visible cracks in prints
- [ ] Dust doesn't easily enter

---

## 3.9 Troubleshooting Guide

| Problem | Likely Cause | Solution |
|---------|-------------|----------|
| Servo won't move after assembly | Cable pinched/damaged | Carefully re-route cable, test continuity |
| Enclosure feels loose | Insert holes oversized | Use slightly larger screws or washers |
| LED not visible | Reflector blocked | Check LED orientation, clean lens |
| Servo binds at certain angles | Internal interference | Print clearance test piece, adjust CAD |
| Printing fails halfway | Bed adhesion issue | Releveling bed, clean print surface |
| Parts don't fit together | Tolerance too tight | Increase clearance by 0.2-0.3mm in CAD |
| Hot glue damaged print | Too much heat | Use low-temperature glue gun or epoxy |

---

## 3.10 Iteration & Refinement

### After first assembly, evaluate:

1. **Fit & Finish**
   - Are all parts properly aligned?
   - Do any parts need sanding/cleanup?
   - Is cable management clean?

2. **Functionality**
   - Do all servos have full range of motion?
   - Is vibration acceptable?
   - Does LED beam look right?

3. **Aesthetics** (optional)
   - Does it look professional?
   - Any visible screw heads to hide?
   - Color or finish improvements?

### Iterate if needed:
- Adjust tolerances in CAD
- Reprint problem areas only
- Test again
- Document changes

---

## 3.11 Phase 3 Checklist

By end of Phase 3, verify:

- [ ] CAD design complete and validated
- [ ] STL files exported and checked
- [ ] All parts printed successfully
- [ ] Assembly completed without issues
- [ ] All servos move freely
- [ ] LED illuminates and changes color
- [ ] WiFi connection works
- [ ] Web interface controls device
- [ ] No mechanical interference
- [ ] Device runs for 1+ hour without issues

---

## 3.12 Design Files Location

Save all CAD files in:
```
mechanical/
├── cad/
│   ├── moving-head-assembly.f3d     (Fusion 360 native)
│   ├── moving-head-assembly.step    (STEP export)
│   ├── main-sphere.stl
│   ├── pan-mount.stl
│   ├── tilt-arm.stl
│   ├── led-housing.stl
│   └── assembly-notes.md
│
└── 3d-prints/
    ├── print-settings.txt           (Cura/Prusaslicer profile)
    ├── assembly-guide.md
    └── [print files for slicing]
```

---

**Next Phase:** [Phase 4: Final Integration & Testing](./phase4-integration.md)
