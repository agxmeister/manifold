# jar-cap

Reusable caps for **flanged plastic yogurt pots**: the kind with a flat rim
the foil is sealed to (measured on a Milbona 450 g Greek-style pot). Once the
foil is off, a cap closes the pot again.

There are two options, to try side by side:

- **Snap cap**: one part, presses on and clicks over the rim.
- **Screw cap + collar**: two parts. The collar gives the jar the thread it
  doesn't have, and the cap screws onto it.

```
jar-cap/
  models/
    snap-cap/snap-cap.scad      # option 1: press-on cap              (print 1)
    collar/collar.scad          # option 2: threaded ring for the jar (print 1)
    screw-cap/screw-cap.scad    # option 2: the cap that screws on    (print 1)
  lib/
    common.scad   # jar measurements, the shared thread, cap body (renders nothing)
  exports/        # generated meshes (gitignored): snap-cap-snap-cap.stl, ...
  previews/       # generated renders (gitignored)
```

## Why there's no one-piece screw cap

The first version was a one-piece cap with helical lugs, meant to screw
directly onto the rim. It just spun in place. The rim is a flat circle that
looks identical at every angle, so turning a cap on it can never change how it
sits, whatever the thread angle. A thread needs a partner on the jar side, and
the collar is that partner.

## Components

| Component   | Print size (as exported) | Prints on                 |
| ----------- | ------------------------ | ------------------------- |
| `snap-cap`  | 101.6 x 101.6 x 7.6 mm   | its top, skirt up         |
| `collar`    | 104.0 x 104.0 x 14.0 mm  | its ribbed bottom edge    |
| `screw-cap` | 110.2 x 110.2 x 11.4 mm  | its top, skirt up         |

## How they work

**Snap cap.** Three short lugs reach 0.6 mm under the flange. Push the cap
straight down: the round rim flexes into a slight rounded triangle to get past
them, then clicks back under. The skirt stands 1.3 mm clear of the rim so the
rim has room to bulge between the lugs. That missing room is why the first
version was too stiff to push on. To take it off, lift the tab. It sits right outside one lug, so that lug
comes off first.

**Screw cap + collar.**

1. Slide the **collar** onto the jar from the **bottom**, threaded end first,
   and push it all the way up under the flange. It sits loose on the wall, so
   hold it up there while you start the cap.
2. Hold the collar by its ribbed band and screw the **cap** on clockwise. Two
   turns pull the collar up under the flange and the cap's seal ring down on
   top of it, clamping the flange between them. There is no hard stop: the
   squeezed flange is the stop, so don't overtighten.

The collar's bore is 86.9 mm, so the jar can't be wider than that anywhere
below the rim. The first collar's 85.2 mm bore jammed just short of the
flange.

## Parameters

The jar's measurements and the shared thread live in `lib/common.scad`. Each
model's own fit is at the top of its file.

| Variable                 | Where       | Default | What it sets                                    |
| ------------------------ | ----------- | ------- | ----------------------------------------------- |
| `flange_d`               | lib         | 94.0    | outer diameter across the jar's flange (mm)     |
| `flange_h`               | lib         | 1.2     | flange height (mm)                              |
| `neck_d`                 | lib         | 85.4    | jar wall just below the flange (mm)             |
| `thread_d` / `thread_p`  | lib         | 102 / 4 | collar thread diameter and pitch (mm)           |
| `thread_l`               | lib         | 8       | thread length, two turns (mm)                   |
| `thread_slop`            | lib         | 0.1     | thread clearance (BOSL2 `$slop`)                |
| `grip`                   | snap-cap    | 0.6     | how far the lugs reach under the flange (mm)    |
| `skirt_gap`              | snap-cap    | 1.3     | room for the rim to flex between lugs (mm)      |
| `snap_gap`               | snap-cap    | 0.4     | axial room for the flange under the lugs (mm)   |
| `bore_fit`               | collar      | 1.5     | bore minus jar wall diameter (mm)               |

**Snap cap too hard to push on:** raise `snap_gap` (0.6), or lower `grip`
(0.4). **Rattles once on:** lower `snap_gap` (0.2). **Pops off too
easily:** raise `grip` (0.8). **Collar won't go up the jar:** raise
`bore_fit` (2.0). **Collar too sloppy:** lower it (1.0). **Thread too tight or too loose:** adjust `thread_slop`.

## Printing

- None of the parts need supports.
- The snap cap's lugs have a 0.8 mm flat ledge that the flange rests on.
  The rest of each lug is a 45° brace off the wall. A ledge that short prints
  without support. Keep supports off: a blob under a lug would stop the cap
  seating.
- The threads are the clamp project's proven profile: trapezoidal, flanks
  40° off vertical, printed with their axes vertical.
- PETG springs better than PLA, which matters for the snap cap. PETG also
  survives the dishwasher's top rack, where PLA softens.
