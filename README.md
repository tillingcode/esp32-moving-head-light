# ESP32 Moving Head Light

A hardware project built around the ESP32 microcontroller, combining custom PCB design, 3D-printed mechanical enclosure, and embedded firmware for a moving head light system.

## Project Structure

```
esp32-moving-head-light/
├── firmware/           # ESP32 firmware (PlatformIO project)
├── hardware/           # PCB schematics, layouts, and BOM
├── mechanical/         # CAD files and 3D print designs
└── docs/               # Design documentation
```

## Quick Start

1. **Firmware Development**
   ```bash
   cd firmware
   platformio run -t upload
   ```

2. **View BOM**
   See `hardware/bom.csv` for component list and sourcing

3. **3D Printing**
   STL files ready in `mechanical/3d-prints/`

## Design Status

- [ ] Schematic complete
- [ ] PCB layout complete
- [ ] Firmware functional
- [ ] Mechanical design finalized
- [ ] First prototype built
- [ ] Manufacturing ready

## Documentation

- [Design Specification](docs/design-spec.md)
- [Component List](docs/component-list.md)
- [Assembly Instructions](docs/assembly-instructions.md)
- [Manufacturing Notes](docs/manufacturing-notes.md)

## Project Timeline

TBD

## License

MIT

## Contact

Project Lead: tillingcode
