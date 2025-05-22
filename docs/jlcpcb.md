# JLCPCB Notes

## Stackup

### 6 Layer

* Stackup:
  * Sig1 (F.cu)
  * Gnd (In1.cu)
  * Pwr (In2.cu)
  * Sig2 (In3.cu)
  * Gnd (In4.cu)
  * Sig3 (B.Cu)

* Signal layers:
  * See: <https://resources.altium.com/p/6-layer-pcb-design-guidelines-pcb-design>
  * F/B are best for impedance control and analog signaling
  * The space between layers is not the same, so each has it's own width
    requirements for impedance control
  * Sig2 is closer to the power plane than ground and might reference it instead.
    Avoid routing sig2 over routed power or changes in the power plane.

* JLC0616H-3313 stackup is the cheapest option - no additional cost
  * See: <https://jlcpcb.com/pcb-impedance-calculator>
  * Single ended non-coplanar 50ohm:
    * F/B: 6.16mil
    * In2: (In3.cu): 5.61mil
  * Non-coplanar Diff Pair 90 (usb):
    * F/B: 6.23mil width, 8mil spacing
    * In2: 5.66mil width, 8 mil spacing
  * Non-coplanar Diff Pair 100ohm:
    * F/B: 4.88mil width, 8mil spacing
    * In2: 4.4mil width, 8 mil spacing

### 8 Layer

* Stackup:
  * Sig1 (F.cu)
  * Gnd (In1.cu)
  * Sig2 (In2.cu)
  * Pwr (In3.cu)
  * Sig3 (In4.cu)
  * Gnd (In5.cu)
  * Sig4 (B.Cu)

* Signal layer notes are the same.

* JLC0616H-3313 stackup:
  * Single ended non-coplanar 50ohm:
    * F/B: 7.33mil
    * In2/In4: 6.97mil
  * Non-coplanar Diff Pair 90 (usb):
    * F/B: 7.15mil width, 8mil spacing
    * In2/In4: 7.07mil width, 8 mil spacing
  * Non-coplanar Diff Pair 100ohm:
    * F/B: 5.6mil width, 8mil spacing
    * In2/In4: 5.55mil width, 8 mil spacing
  
## PCB manufacturing checklist

* To keep costs at $2, stay within these parameters
  * 50x50mm max size
  * 1.6mm thickness
  * Green mask
  * 0.3/(0.4/0.45mm) vias
* Upgrade to FR-4 TG155 for a few dollars.
  It is  better for lead free solder and 6+ layers boards.
* Vias Epoxy Filled & Capped (for via in pad) (default for 6+)
* Finish: ENIG (default for 6+)
* Select JLC06161H-3313 stackup
* Confirm production file
* Remove mark

## Capabilities / design rules

* Minimum annular width: 0.05 (for a 0.1 annular ring, but 0.15 is preferred)
* Minimum via diameter: 0.4 (for low cost, higher cost is 0.25)
* Hole to hole: 0.2mm
* Track width: 3.5mil, 3 ok when doing bga fanout
* BGA Pad to trace clearance 0.09mm (otherwise, 0.1mm)
* Copper to hole 0.2 (jlcpcb is hole to track)

## Default via size

* 0.3/0.45 is the default size, but use 0.3/0.4 inside bga pads, if needed
