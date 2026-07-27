# clamp

A 3D-printable **F-clamp** — the sliding-arm bar clamp, modelled on the
familiar steel workshop pattern: a bar with a fixed jaw at the top, a sliding
jaw that locks anywhere along it, and a screw with a swivel pad doing the
actual squeezing.

**It holds anything from 0 to 86 mm**, with a 55 mm throat.

Getting there in plastic needs one change from the steel original. A steel
F-clamp's sliding jaw grips the bar by *canting* — it tilts under load and its
sharp bore corners bite into the bar. Printed plastic on printed plastic will
not bite; it will slip. So the sliding jaw is located instead by an **8 mm pin
through the bar**, dropped into one of eight holes at 10 mm spacing, and the
screw covers the 16 mm between them. Every clamping force in the tool is
reacted by that pin in double shear, which is a load path printed parts are
actually good at.

```
clamp/
  models/
    frame/frame.scad    # the bar + fixed jaw, one piece      (print 1)
    slider/slider.scad  # the sliding jaw                     (print 1)
    screw/screw.scad    # the spindle with its tommy lever    (print 1)
    pad/pad.scad        # the swivel pad                      (print 1)
    pin/pin.scad        # the locking pin                     (print 1)
  lib/
    common.scad     # shared dimensions, fits and layout maths (renders nothing)
  exports/          # generated meshes (gitignored): frame-frame.stl, ...
```

## Components

| Component | Print size (as exported)  | Prints on                     |
| -------- | -------------------------- | ----------------------------- |
| `frame`  | 89.0 x 164.6 x 12.0 mm     | its flat profile face         |
| `slider` | 94.3 x 26.0 x 30.0 mm      | its flat underside            |
| `screw`  | 84.0 x 26.0 x 82.5 mm      | the lever                     |
| `pad`    | 24.0 x 24.0 x 21.6 mm      | the clamping face             |
| `pin`    | 22.0 x 12.0 x 31.7 mm      | the head plate                |

The frame is the part to check against your bed: it needs 165 mm in one axis.

## How it goes together

1. Wind the **screw** up through the **slider**'s boss from underneath, from
   below, until a few threads show above.
2. Press the **pad** down onto the screw's ball until it clicks over. It is a
   genuine snap fit — 0.4 mm of interference per side, spread over four collet
   fingers. If it feels too stiff, thirty seconds in hot water softens the
   fingers enough; do not lever it on with a screwdriver.
3. Slide the **slider** onto the bottom of the **frame**'s bar, pad facing up
   toward the fixed jaw.
4. Line the collar up with a hole and push the **pin** through.

To use it: pick the hole that leaves 16 mm or less to close, drop the pin in,
and wind the lever. Never clamp with the screw wound out past its last few
threads — the boss holds 30 mm of thread and the design assumes at least 14 mm
of it is engaged.

## Parameters

Everything lives in `lib/common.scad`, and the layout is derived
rather than hand-placed: change `notch_count`, `notch_pitch`, `throat` or
`capacity_min` and the bar length, jaw height and hole positions all follow.

| Variable                 | Default | What it sets                             |
| ------------------------ | ------- | ---------------------------------------- |
| `notch_count`            | 8       | number of pin holes                      |
| `notch_pitch`            | 10      | spacing between them (mm)                |
| `throat`                 | 55      | bar face to screw axis (mm)              |
| `bar_x` / `bar_y`        | 20 / 12 | bar cross-section (mm)                   |
| `thread_d` / `thread_p`  | 16 / 4  | screw diameter and pitch (mm)            |
| `min_engage`             | 14      | shortest thread engagement allowed (mm)  |

The screw's travel is `boss_h - min_engage` = 16 mm, which must stay larger
than `notch_pitch` or there will be gaps in the range the clamp can reach.

### Fits

Named once in `lib/common.scad`, applied to both halves of each joint:

| Fit           | Value    | Joint                                     |
| ------------- | -------- | ----------------------------------------- |
| `slide_gap`   | 0.35 mm  | slider bore on the bar — free sliding      |
| `pin_gap`     | 0.25 mm  | pin in its holes — pushes in and out by hand |
| `pad_gap`     | 0.2 mm   | socket on the ball — free swivel            |
| `pad_lip`     | 0.4 mm   | *interference*, per side — the pad's snap  |
| `thread_slop` | 0.1 mm   | BOSL2 `$slop`; 0.4 mm on the internal thread |

`pad_lip` is the only deliberate interference in the tool. It is sized against
how far the retaining finger has to bend, not by eye: the slots run the whole
length of the collet barrel and a little into the head, so the finger flexes
over about 11.5 mm, and a 2.4 mm wall bent 0.4 mm over that length works out at
roughly 1.1% surface strain — survivable once. Root the fingers at the top of
the barrel instead, over a 3 mm flexure, and the same 0.4 mm is nearer 17%: it
would simply crack on assembly.

## Printing

**Every part prints without support in the orientation the `.scad` exports.**
That is the main thing the design is arranged around:

- The **frame** is a single 2D outline extruded 12 mm, so it lies flat on the
  bed. Every fibre of the bar and the jaw runs along a layer, and the pin holes
  come out as clean vertical bores. It is also why the jaw is not a separate
  piece bolted on — there is no joint at the most highly stressed point in the
  tool.
- The **slider** prints as it is used. Both its bores end up on the build axis:
  the square bar bore and, more importantly, the internal thread, which is the
  only orientation a printed thread comes out of cleanly. Its one sideways
  hole, for the pin, is a teardrop so the crown does not sag.
- The **thread** is coarse and blunt on purpose: 16 mm diameter, 4 mm pitch,
  flanks 40 degrees off vertical so they self-support. Holding that angle while
  leaving a real land on the crest and root is what forces the coarse pitch —
  each flank eats 1.4 mm of it.
- The **screw**'s lever is moulded on rather than pressed on. The spindle
  threads in from below and the lever never has to pass through the boss, so
  splitting them would only have added a joint that has to carry the
  tightening torque. It also gives the part an 84 mm flat footprint to stand
  on. The grip grooves start outboard of the cone at the lever's centre;
  a groove passing under the cone would leave the cone's underside bridging
  over the void.
- The **pad** prints upside-down, clamping face on the bed. The socket then
  opens upward, so the retaining lip is a shallow taper rather than a ceiling
  and all four slots run vertically.

Suggested settings, 0.4 mm nozzle:

| | |
| --- | --- |
| Material | PETG for preference — it takes the pad's snap-on and the thread's bearing load better than PLA. PLA works; avoid brittle filled filaments. |
| Layer height | 0.2 mm |
| Perimeters | 4 or more, especially on the frame and the slider |
| Infill | 40%+ on `frame`, `slider`, `screw`, `pin`; anything on `pad` |
| Supports | none, on any part |
| Brim | optional on `screw` — it is 82 mm tall, though the lever base is wide |

Two things a mesh checker will flag, both deliberate:

- The **pad's socket lip** reads as near-zero thickness. That is the retaining
  ridge itself — an internal edge where the mouth taper meets the socket
  sphere, not a wall. The pad's thinnest real wall is 2.4 mm at the barrel.
- The **screw** at full extension leaves only 14 mm of thread engaged. That is
  the design minimum, and `min_engage` is what places the pin holes.

## Licence

The models in this project are licensed under
[CC BY-NC 4.0](LICENSE) — see `LICENSE`.
