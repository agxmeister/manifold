# spider

An **articulated spider**, printed in place: one print, no assembly, no
supports. Every leg segment hangs on a **ball joint**, so it swings side to
side, nods up and down, and twists.

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
| `spider`  | 127 x 105 x 13 mm        | its belly, as is    |

It comes off the bed as 33 loose-but-linked pieces: the body and 8 legs of 4
segments each, the last one the claw.

## How the joints work

Each segment ends in a round **bulb** with a spherical **socket** inside it.
The next segment's **ball** is printed in that socket, and a neck leads from
the ball out through an opening in the bulb to the segment's own bulb.

- The ball stands on the bed, cut off where its surface turns past 45°, so it
  grows straight off the plate.
- The socket is a sphere 0.4 mm bigger than the ball. Its lower half wraps
  under the ball's sides, so the ball can't drop out once it's off the bed.
  Its top closes in a 45° cone instead of a flat ceiling, so the roof never
  bridges over air.
- The opening's roof is a 45° cone too. Its sides are the stops.

Each joint swings **±18°** side to side, nods **13°** up, droops more than
**60°**, and twists about **90°** either way. The ranges shrink a little when
you combine them, and over four joints a leg curls a long way.

Clearance is 0.4 mm all round the ball. On the first layer the pieces sit at
least 0.5 mm apart, so they don't weld together.

**Don't print it scaled.** Scaling shrinks the clearances with everything
else. At 50 % the first version's 0.4 mm gaps became 0.2 mm and every joint
fused. This version is drawn at its small size with full-size gaps. To change
the size, change the parameters below, not the slicer's scale.

## Parameters

| Variable      | Where  | Default | What it sets                                  |
| ------------- | ------ | ------- | --------------------------------------------- |
| `gap`         | joint  | 0.4     | clearance all round the ball (mm)             |
| `ball_r`      | joint  | 3.15    | ball radius (mm)                              |
| `neck_w`      | joint  | 2.0     | neck width (mm)                               |
| `nod_up`      | joint  | 15      | how far the opening lets a segment nod up (deg) |
| `bulb_r`      | joint  | 4.75    | leg bulb radius; joint pitch is 2·r + 1 (mm)  |
| `bulb_h`      | joint  | 8.6     | leg bulb height (mm)                          |
| `segments`    | spider | 4       | segments per leg, the last one the claw       |
| `leg_angles`  | spider | 38 72 106 142 | leg directions, deg from straight ahead |
| `leg_swing`   | spider | 20      | side-to-side room per segment (deg)           |
| `coxa_swing`  | spider | 15      | the same where the leg meets the body (deg)   |

The body (`head_*`, `belly_*`) and face (`eye_r`, `fang_*`) are at the top of
`spider.scad`.

**Joints fused, won't move:** raise `gap` (0.5). **Too floppy:** lower it
(0.3). Below 0.3 the first layers start to touch.

## Printing

- No supports, no brim. It prints flat exactly as exported, and nothing in it
  overhangs past 45°.
- 0.2 mm layers, 0.4 mm nozzle. The bed needs to be at least 127 x 105 mm.
- Keep the first layer clean: elephant's foot is what welds print-in-place
  joints. If a joint is stuck when it comes off the bed, twist it firmly
  once and it breaks free. Then work every joint in every direction a few
  times.
