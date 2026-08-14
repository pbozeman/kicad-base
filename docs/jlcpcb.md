# JLCPCB Notes

Capability numbers re-verified against JLCPCB's published capabilities
2026-08. Impedance widths are outputs of the JLCPCB impedance calculator for
the named stackup — re-run the calculator when starting a new board rather
than trusting these blindly.

## Stackup

### 6 Layer

- Stackup:
  - Sig1 (F.cu)
  - Gnd (In1.cu)
  - Pwr (In2.cu)
  - Sig2 (In3.cu)
  - Gnd (In4.cu)
  - Sig3 (B.Cu)

- Signal layers:
  - See: <https://resources.altium.com/p/6-layer-pcb-design-guidelines-pcb-design>
  - F/B are best for impedance control and analog signaling
  - The space between layers is not the same, so each has its own width
    requirements for impedance control
  - Sig2 is closer to the power plane than ground and might reference it
    instead. Avoid routing sig2 over routed power or changes in the power
    plane.

- JLC06161H-3313 stackup is the cheapest impedance-controlled option — no
  additional cost
  - See: <https://jlcpcb.com/pcb-impedance-calculator>
  - Physical stackup (per <https://jlcpcb.com/impedance>, total 1.6mm):

    | Layer        | Material       | Thickness | Er   |
    | ------------ | -------------- | --------- | ---- |
    | F.Cu         | copper (1oz)   | 0.035mm   |      |
    | dielectric 1 | prepreg 3313   | 0.0994mm  | 4.1  |
    | In1.Cu       | copper (0.5oz) | 0.0152mm  |      |
    | dielectric 2 | core           | 0.55mm    | 4.6  |
    | In2.Cu       | copper (0.5oz) | 0.0152mm  |      |
    | dielectric 3 | prepreg 2116   | 0.1088mm  | 4.16 |
    | In3.Cu       | copper (0.5oz) | 0.0152mm  |      |
    | dielectric 4 | core           | 0.55mm    | 4.6  |
    | In4.Cu       | copper (0.5oz) | 0.0152mm  |      |
    | dielectric 5 | prepreg 3313   | 0.0994mm  | 4.1  |
    | B.Cu         | copper (1oz)   | 0.035mm   |      |

  - Impedance widths (calculator output, 2026-08):
  - Single ended non-coplanar 50ohm:
    - F/B: 5.94mil
    - In2 (In3.cu): 5.59mil
  - Non-coplanar Diff Pair 90 (usb):
    - F/B: 6.05mil width, 8 mil spacing
    - In2: 5.59mil width, 8 mil spacing
  - Non-coplanar Diff Pair 100ohm:
    - F/B: 4.69mil width, 8mil spacing
    - In2: 4.33mil width, 8 mil spacing

### 8 Layer

- Stackup:
  - Sig1 (F.cu)
  - Gnd (In1.cu)
  - Pwr (In2.cu)
  - Sig2 (In3.cu)
  - Gnd (In4.cu)
  - Sig3 (In5.cu)
  - Gnd (In6.cu)
  - Sig4 (B.Cu)

Note: In2 is power to increase the capacitance between it and Gnd1/In1.

- Signal layer notes are the same.

- JLC08161H-3313 stackup:
  - Physical stackup (per <https://jlcpcb.com/impedance>, total 1.6mm; the
    3x 2116 prepreg groups press into one dielectric layer each, 0.3568mm
    total = 0.1164 + 0.1240 + 0.1164):

    | Layer        | Material          | Thickness | Er   |
    | ------------ | ----------------- | --------- | ---- |
    | F.Cu         | copper (1oz)      | 0.035mm   |      |
    | dielectric 1 | prepreg 3313      | 0.0994mm  | 4.1  |
    | In1.Cu       | copper (0.5oz)    | 0.0152mm  |      |
    | dielectric 2 | core              | 0.1mm     | 4.6  |
    | In2.Cu       | copper (0.5oz)    | 0.0152mm  |      |
    | dielectric 3 | prepreg 2116 (x3) | 0.3568mm  | 4.16 |
    | In3.Cu       | copper (0.5oz)    | 0.0152mm  |      |
    | dielectric 4 | core              | 0.3mm     | 4.6  |
    | In4.Cu       | copper (0.5oz)    | 0.0152mm  |      |
    | dielectric 5 | prepreg 2116 (x3) | 0.3568mm  | 4.16 |
    | In5.Cu       | copper (0.5oz)    | 0.0152mm  |      |
    | dielectric 6 | core              | 0.1mm     | 4.6  |
    | In6.Cu       | copper (0.5oz)    | 0.0152mm  |      |
    | dielectric 7 | prepreg 3313      | 0.0994mm  | 4.1  |
    | B.Cu         | copper (1oz)      | 0.035mm   |      |

  - Impedance widths (recorded 2025 — stale calculator data, re-run
    before use):
  - Single ended non-coplanar 50ohm:
    - F/B: 7.33mil
    - In3/In5: 6.97mil
  - Non-coplanar Diff Pair 90 (usb):
    - F/B: 7.15mil width, 8mil spacing
    - In3/In5: 7.07mil width, 8 mil spacing
  - Non-coplanar Diff Pair 100ohm:
    - F/B: 4.28mil width, 5mil spacing
    - In3/In5: 4.33mil width, 5 mil spacing

## PCB manufacturing checklist

- To keep costs at $2 (6-layer, 5 pcs), stay within these parameters
  - 50x50mm max size
  - 1.6mm thickness
  - Green mask
  - Default specifications otherwise (0.3/0.45mm vias are safe)
  - There is also a once-a-month free 6/8-layer prototype on the same
    conditions (≤50x50mm, 5 pcs, default specs)
- Upgrade to FR-4 TG155 for a few dollars.
  It is better for lead free solder and 6+ layer boards.
- Vias Epoxy Filled & Capped (for via in pad) — default and free for 6+
  layers; supported for 0.15–0.55mm via holes
- Finish: ENIG — the only finish for 6+ layers, currently free on 6–20
  layer boards
- Select JLC06161H-3313 stackup
- Confirm production file
- Remove mark

## Capabilities / design rules

- Track width/spacing: 3.5/3.5mil (0.09mm) minimum on multilayer
  (4/4mil on 1-2 layer boards). 3mil is acceptable in BGA fan-outs.
- Minimum via hole: 0.15mm (0.2mm+ preferred)
- Minimum via diameter: 0.25mm; make the diameter at least 0.1mm larger
  than the hole (0.05mm annular width; 0.15mm preferred)
- PTH annular ring: >= 0.2mm recommended on multilayer
- Via hole to via hole: 0.2mm (pad-to-pad holes: 0.45mm)
- Via hole to copper: 0.2mm; PTH pad to inner-layer copper: 0.3mm
- Pad to trace clearance: 0.1mm minimum; 0.09mm allowed locally for BGA
  pads on multilayer boards
- BGA pads of 0.2-0.25mm require ENIG

## Default via size

- 0.3/0.45 is the default size, but use 0.3/0.4 inside bga pads, if needed
