# spider

An **articulated spider**, printed in place: one print, no assembly, no
supports. The legs are chains of rounded links joined **ring through ring**,
like a chain, with the rings hidden. Each link ends in a round knuckle with a
crossbar inside it. The next link's narrow neck runs into the knuckle's
mouth, and the tab on its end hooks over that crossbar. The legs plug into
the body the same way. Every link swings side to side, nods up and down, and
twists a little.

```
spider/
  models/
    spider/spider.scad   # body, eight legs, the whole print    (print 1)
    spider/joint.scad    # the hidden ring joint: knuckle, crossbar, tab (renders nothing)
  exports/               # generated meshes (gitignored): spider-spider.stl
  previews/              # generated renders (gitignored)
```

## Components

| Component | Print size (as exported) | Prints on           |
| --------- | ------------------------ | ------------------- |
| `spider`  | 149 x 123 x 13 mm        | its belly, as is    |

It comes off the bed as 33 loose-but-linked pieces: the body and 8 legs of 4
links each, the last one the claw.

## How the joints work

Each link is a rounded block lying on the bed:

- **Knuckle**, at the outer end: a round bead, a little wider than the link
  (11 mm). Inside it is a cavity, open underneath and roofed over. A
  **crossbar** runs across the cavity from wall to wall, and a **mouth**
  opens at the front.
- **Neck and tab**, at the inner end: a narrow neck runs out of the link and
  ends in a flat upright **tab** with a window through it. The link's end
  round the neck is hollowed to fit round the previous knuckle.

The neck runs into the previous link's mouth, and the tab sits in the cavity
with the crossbar through its window. The crossbar and the tab stay hidden
under the knuckle's roof. The link's hollow end sits round the knuckle with a
0.5 mm gap seen from above, so only a sliver of neck shows between them.
Neither ring can open, so the links can't come apart.

The body's sockets are knuckles too. They're built into the coxae, the ring
of bumps around the head, so each leg's first ring is hidden inside the body.
The coxae are a little lower than the legs (7 mm). The head is taller
(10 mm), so they come out of its sides without a step.

The cavity is the tab and the neck swept through ±25°, so the link swings
freely. The knuckle is round about the crossbar. The next link's hollow is a
cylinder round it (the 0.5 mm gap from above) and a sphere clear of
everything on it, so the link turns about the crossbar in any direction
without the two bodies meeting. Turning the outer link about the crossbar, with
nothing else moving (a 3D check):

| motion          | free to | stopped by                         |
| --------------- | ------- | ---------------------------------- |
| swing           | ±25°    | the crossbar in the window          |
| nod up          | 20°     | the neck against the mouth's roof   |
| nod down        | 75°+    | nothing up to 75°                   |
| twist           | ±15°    | the tab against the crossbar        |

The crossbar can also slide in the window and the tab along the crossbar,
which adds a little. At the body the back legs swing back only until they
meet the abdomen, and neighbouring legs stop each other.

It all prints in place, flat:

- The tab, the neck and the knuckle's walls stand on the bed, at least
  0.5 mm apart.
- The crossbar is a short bridge (4.3 mm) across the cavity, 0.7 mm above the
  tab's foot. The window's top (3.5 mm) and the knuckle's roof (8.5 mm) are
  short bridges too.
- The cavity is open underneath, onto the bed. Where the knuckle's dome gets
  too thin to roof it, the mouth is open on top.

**Don't print it scaled.** Scaling shrinks the clearances with everything
else. At 50 % the first version's 0.4 mm gaps became 0.2 mm and every joint
fused. To change the size, change the parameters below, not the slicer's
scale.

## Parameters

| Variable      | Where  | Default | What it sets                                  |
| ------------- | ------ | ------- | --------------------------------------------- |
| `gap`          | joint  | 0.5     | clearance round the crossbar and between pieces (mm) |
| `under_gap`    | joint  | 0.7     | between the crossbar and the tab's foot (mm)   |
| `roof_gap`     | joint  | 0.6     | between the tab's top and the knuckle's roof (mm) |
| `link_w`       | joint  | 9.4     | link width (mm)                                |
| `link_h`       | joint  | 8       | link height (mm)                               |
| `knuckle_r`    | joint  | 5.5     | knuckle radius (mm)                            |
| `tab_t`        | joint  | 2.0     | tab thickness (mm)                             |
| `win_w`        | joint  | 3.0     | window length; the crossbar slides in it (mm)  |
| `bar_w`, `bar_h` | joint | 1.6, 1.8 | crossbar section (mm)                       |
| `neck_w`, `neck_h` | joint | 3.0, 3.6 | neck section (mm)                         |
| `swing`        | joint  | 25      | side-to-side swing the cavity allows (deg)     |
| `segments`     | spider | 4       | links per leg, the last one the claw           |
| `pitch`        | spider | 16      | joint to joint along a leg (mm)                |
| `socket_at`    | spider | 15      | how far out from the body centre its crossbars sit (mm) |
| `leg_angles`   | spider | 38 72 106 142 | leg directions, deg from straight ahead  |

The body (`head_*`, `belly_*`) and face (`eye_r`, `fang_*`) are at the top of
`spider.scad`.

**Crossbar fused to the tab:** raise `under_gap` (0.9). That bridge is where
sag would weld it. **Tab stuck to the roof:** raise `roof_gap` (0.8).
**Fused elsewhere:** raise `gap` (0.6).

## Printing

- No supports, no brim. It prints flat exactly as exported. Nothing in it
  overhangs past 45°, apart from the short bridges of the crossbars, the
  windows' tops and the knuckles' roofs.
- 0.2 mm layers, 0.4 mm nozzle. The bed needs to be at least 149 x 123 mm.
- Keep the first layer clean: elephant's foot is what welds print-in-place
  joints. If a joint is stuck when it comes off the bed, swing the link
  firmly once and it breaks free. Then work every joint in every direction a few
  times.
