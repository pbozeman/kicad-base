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
  - Sig1 (F.cu / L1)
  - Gnd (In1.cu / L2)
  - Sig2 (In2.cu / L3)
  - Pwr (In3.cu / L4)
  - Gnd (In4.cu / L5)
  - Sig3 (In5.cu / L6)
  - Gnd (In6.cu / L7)
  - Sig4 (B.Cu / L8)

- Why these layers: the JLC08161H-3313 dielectrics are not uniform — thin
  0.1mm cores sit at L2–L3 and L6–L7, while L4/L5 are surrounded by the
  0.3mm center core and 0.3568mm prepreg groups. Inner signals go on L3
  and L6, each tight against a ground plane across a 0.1mm core
  (50ohm ≈ 4.75mil). L4 is far from every plane (50ohm there would need
  ≈11.5mil traces), so it takes power, where plane distance doesn't
  matter. The cost: the Pwr(L4)–Gnd(L5) pair spans the 0.3mm core, so
  inter-plane capacitance is modest — lean on decoupling caps, not plane
  capacitance. (An earlier revision put Pwr on In2/L3 next to gnd for
  plane capacitance; that reflected an older stackup vintage and would
  waste the best inner signal layer on this one.)

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

  - Impedance widths (calculator output, 2026-08; inner = In2/In5.cu,
    i.e. L3/L6, which solve identically):
  - Single ended non-coplanar 50ohm:
    - F/B: 5.94mil
    - Inner: 4.75mil
  - Non-coplanar Diff Pair 90 (usb):
    - F/B: 6.05mil width, 8 mil spacing
    - Inner: 5.10mil width, 8 mil spacing
  - Non-coplanar Diff Pair 100ohm:
    - F/B: 4.69mil width, 8mil spacing
    - Inner: 4.05mil width, 8 mil spacing

#### Propagation delay tuning

Soldermask impedance values: <https://jlcpcb.com/impedance>

##### Microstrip single-ended

Calculator: <https://impedance.app.protoexpress.com/?appid=CTSEIMPCAL>

| Sierra field |    Enter |
| ------------ | -------: |
| H1           | 3.91 mil |
| ER1          |      4.1 |
| H1C          |  1.2 mil |
| H2C          |  0.6 mil |
| ER2          |      3.8 |
| W            | 5.94 mil |
| ΔW           |  0.7 mil |
| T            |  1.6 mil |

| Quantity             |       Result |
| -------------------- | -----------: |
| Calculated impedance |      50.97 Ω |
| Uncoated impedance   |      54.42 Ω |
| Effective εr         |       3.2709 |
| Propagation delay    | 153.23 ps/in |
| Inductance           |  7.810 nH/in |
| Capacitance          |  3.006 pF/in |

##### Microstrip differential

Calculator: <https://impedance.app.protoexpress.com/?appid=CTDPIMPCAL>

| Sierra field |    Enter |
| ------------ | -------: |
| H1           | 3.91 mil |
| ER1          |      4.1 |
| H1C          |  1.2 mil |
| H2C          |  0.6 mil |
| ER2          |      3.8 |
| W            | 3.51 mil |
| S            |  4.7 mil |
| ΔW           |  0.7 mil |
| T            |  1.6 mil |

| Quantity                    |       Result | Notes                        |
| --------------------------- | -----------: | ---------------------------- |
| Differential impedance (Zd) |     101.52 Ω | Good match to 100 Ω target   |
| Odd-mode impedance          |      50.76 Ω | Zd ≈ 2 × Zodd                |
| Odd-mode propagation delay  | 146.20 ps/in | Use for differential signals |
| Even-mode propagation delay | 155.52 ps/in | Common-mode propagation      |
| Coupling coefficient        |        19.2% | Pair coupling                |

##### Stripline single-ended

Calculator: <https://impedance.app.protoexpress.com/?appid=SLSEIMPCAL>

| Sierra field |     Enter |
| ------------ | --------: |
| H1           | 14.05 mil |
| ER1          |      4.16 |
| H2           |  3.94 mil |
| ER2          |       4.6 |
| W            |  4.75 mil |
| ΔW           |   0.7 mil |
| T            |   0.6 mil |

| Quantity             |       Result |
| -------------------- | -----------: |
| Calculated impedance |      49.95 Ω |
| Effective εr         |       4.4521 |
| Propagation delay    | 178.77 ps/in |

##### Stripline differential

Calculator: <https://impedance.app.protoexpress.com/?appid=SLDPIMPCAL>

| Sierra field |     Enter |
| ------------ | --------: |
| H1           | 14.05 mil |
| ER1          |      4.16 |
| H2           |  3.94 mil |
| ER2          |       4.6 |
| W            |  3.55 mil |
| S            |   5.8 mil |
| ΔW           |   0.7 mil |
| T            |   0.6 mil |

| Quantity                    |       Result | Notes                        |
| --------------------------- | -----------: | ---------------------------- |
| Differential impedance      |      99.77 Ω | Good match to 100 Ω target   |
| Odd-mode impedance          |      49.88 Ω |                              |
| Odd-mode propagation delay  | 178.30 ps/in | Use for differential signals |
| Even-mode propagation delay | 179.04 ps/in | Common-mode propagation      |
| Coupling coefficient        |       11.91% | Pair coupling                |

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
