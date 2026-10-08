# spider

An **articulated spider**, printed in place: one print, no assembly, no
supports. Every leg segment swings left and right on its own joint, so the
legs wiggle in the plane of the table.

```
spider/
  models/
    spider/spider.scad   # body, eight legs, the whole print    (print 1)
    spider/joint.scad    # the leg joint (renders nothing)
  exports/               # generated meshes (gitignored): spider-spider.stl
  previews/              # generated renders (gitignored)
```

## Components

| Component | Print size (as exported) | Prints on           |
| --------- | ------------------------ | ------------------- |
| `spider`  | 231 x 190 x 25 mm        | its belly, as is    |

It comes off the bed as 41 loose-but-linked pieces: the body and 8 legs of 5
segments each.

## How the joints work

Each segment ends in a round **bulb**, and the next segment's **knuckle** sits
inside it. All of it is round about a vertical axis:

- An hourglass **pin** stands on the bed in the middle of the bulb. Its top
  flares out at 40° from vertical and becomes the bulb's roof, so the roof
  grows out of the pin and never bridges over air.
- The knuckle is a ring printed around the pin's waist, also standing on the
  bed. The hourglass holds it both ways: it can't lift off the pin or drop
  out of it.
- A neck runs from the knuckle out through a slot in the bulb to the
  segment's own bulb. The slot's sides are the stops: ±30° per segment, ±20°
  where a leg meets the body.

Clearance is 0.4 mm everywhere. On the first layer the pieces sit at least
0.5 mm apart (0.52 mm at the pin), so they don't weld together.

## Parameters

| Variable      | Where  | Default | What it sets                                  |
| ------------- | ------ | ------- | --------------------------------------------- |
| `gap`         | joint  | 0.4     | clearance between moving parts (mm)           |
| `pin_waist_r` | joint  | 1.6     | pin radius at its waist (mm)                  |
| `knuckle_r`   | joint  | 5.4     | knuckle ring radius (mm)                      |
| `neck_w`      | joint  | 4       | neck width (mm)                               |
| `bulb_r`      | joint  | 7.4     | leg bulb radius; joint pitch is 2·r + 1 (mm)  |
| `bulb_h`      | joint  | 12.5    | leg bulb height (mm)                          |
| `segments`    | spider | 5       | segments per leg, the last one the claw       |
| `leg_angles`  | spider | 38 72 106 142 | leg directions, deg from straight ahead |
| `leg_swing`   | spider | 30      | swing per segment, either way (deg)           |
| `coxa_swing`  | spider | 20      | swing where the leg meets the body (deg)      |

The body (`head_*`, `belly_*`) and face (`eye_r`, `fang_*`) are at the top of
`spider.scad`.

**Joints fused, won't move:** raise `gap` (0.5). **Too floppy:** lower it
(0.3). Below 0.3 the first layers start to touch.

## Printing

- No supports, no brim. It prints flat exactly as exported, and nothing in it
  overhangs past 45°.
- 0.2 mm layers. The bed needs to be at least 231 x 190 mm.
- Keep the first layer clean: elephant's foot is what welds print-in-place
  joints. If a joint is stuck when it comes off the bed, flex it firmly once
  and it breaks free.
