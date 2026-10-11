# spider

An **articulated spider**, printed in place: one print, no assembly, no
supports. The legs are chains of rounded links joined **ring through ring**,
like a chain, with the rings hidden. Each link ends in a round knuckle with a
crossbar inside it. The next link's narrow neck runs into the knuckle's
mouth, and the tab on its end hooks over that crossbar. The legs plug into
the body the same way, and so does the abdomen, at the waist. Every link
swings side to side, nods up and down, and twists a little, about 30° at
most.

```
spider/
  models/
    spider/spider.scad   # body, abdomen, eight legs, the whole print (print 1)
    spider/joint.scad    # the hidden ring joint: knuckle, crossbar, tab, droop stop (renders nothing)
  exports/               # generated meshes (gitignored): spider-spider.stl
  previews/              # generated renders (gitignored)
```

## Components

| Component | Print size (as exported) | Prints on           |
| --------- | ------------------------ | ------------------- |
| `spider`  | 134 x 124 x 18 mm        | its belly, as is    |

It comes off the bed as 34 loose-but-linked pieces: the body (head), the
abdomen, and 8 legs of 4 links each, the last one the foot.

## How the joints work

Each leg is one rounded bar lying on the bed (9.4 mm wide, 8 mm tall), cut
into links at **seams**, with a **rough skin** of random shallow dents and
low bumps over the top of each link (shrunk near the seams so none reaches
their sharp top edges), and ending in a foot with a rounded, full-width end. Side on, a seam stands straight up for its lower
half and then leans forward at 45° to the top, a 0.6 mm gap across it, the
tops flush: each link's front leans over the next link's rear.

- **Outer end** of a link: inside it is a cavity, open underneath and
  roofed over. A **crossbar** runs across the cavity from wall to wall, and
  a **mouth** opens at the front, under the seam's leaning part.
- **Inner end**: a narrow neck runs out of the link's rear and ends in a
  flat upright **tab** with a window through it.

The neck runs into the previous link's mouth, and the tab sits in the cavity
with the crossbar through its window, all hidden. The next link's rear is a
flat face; the previous link's front is that face swung through ±25°, round
in the middle and set back a little at the sides, so the link swings
freely. Neither ring can open, so the links can't come apart.

The body's sockets are sunk in the **head**, a low round dome standing on
the bed (46 mm across, 14 mm tall, the legs are 8). Each leg sits in a
**niche** in the head, cut to the same 45° seam as the links: the first link
is cut like every other link, and the niche's back wall leans over it. The
niche is only as wide as the leg (and its gap), so the head between
neighbouring legs comes down to the bed; the first link swings about ±5° in
it. Two
**fangs** lean down the head's front, rooted under the eyes, their tips
lying on the bed.

The **abdomen** is a separate piece, a big egg on the end of a link. A ninth
knuckle stands half out of the head's back, as the waist, and the abdomen's tab hangs
on its crossbar like the next link of a leg. So the abdomen swings, nods and
twists on the waist the same way.

The cavity is the tab and the neck swept through ±25°, so the link swings
freely. The seam is tight, so a link barely nods up: its rear top runs into
the previous link's front. Turning the outer link about the crossbar, with
nothing else moving (a 3D check):

| motion          | free to | stopped by                         |
| --------------- | ------- | ---------------------------------- |
| swing           | ±25°    | the crossbar in the window          |
| nod up          | ~3°     | its rear against the previous link's front, across the seam |
| nod down        | 30°     | the tab's far end on the droop stop |
| twist           | ±15°    | the tab against the crossbar        |

Swinging and drooping fully at once, they touch. On the head the first links
nod and droop the same way, but swing only about ±5°, in their niches. The crossbar can also slide in the window and the tab along the crossbar,
which adds a little. The **droop stop** is a ledge in the back of the
cavity, round the tab's far end. As a link nods down, the tab's far end
swings back and up, and at 30° its foot lands on the ledge. At the body, the
back legs swing back 20° before they meet the abdomen, and the front legs
swing in the full 25° past the fangs. Neighbouring legs stop each other at
full swing. The abdomen swings 20° before it meets a back leg; swung that
far it nods up 15° before the head's rim, 19° when swung 15°.

It all prints in place, flat:

- The tab, the neck and the knuckle's walls stand on the bed, at least
  0.5 mm apart.
- The crossbar is a short bridge (4.3 mm) across the cavity, 0.7 mm above the
  tab's foot. The window's top (3.5 mm), the cavity's roof and the droop
  stop's ledge (2.4 mm up) are short bridges too, and so is each mouth's
  roof, 4.5 mm up.
- The cavity is open underneath, onto the bed. The seams' leaning fronts
  are 45° overhangs, so they print without support; the gap across them is
  0.6 mm (0.85 mm upright), as an overhang sags a little.

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
| `droop`        | joint  | 30      | how far a link nods down before the droop stop (deg) |
| `segments`     | spider | 4       | links per leg, the last one the foot            |
| `pitch`        | spider | 13.5    | joint to joint along a leg (mm)                |
| `seam_r`       | joint  | 4.75    | the seam's upright part, ahead of the crossbar (mm) |
| `seam_gap`     | joint  | 0.6     | across the seam (mm)                           |
| `rough_n`, `rough_d` | spider | 90, 0.15–0.35 | dents and bumps per link, and their depth (mm) |
| `socket_at`    | spider | 13.5    | how far out from the body centre its crossbars sit (mm) |
| `leg_angles`   | spider | 37 71 105 139 | leg directions, deg from straight ahead  |
| `waist_at`     | spider | 15.5    | how far behind the body centre the waist's crossbar sits (mm) |

The body (`head_*`, `belly_*`) and face (`eye_r`, `fang_*`) are at the top
of `spider.scad`.

**Crossbar fused to the tab:** raise `under_gap` (0.9). That bridge is where
sag would weld it. **Tab stuck to the roof:** raise `roof_gap` (0.8).
**Fused elsewhere:** raise `gap` (0.6).

## Printing

- No supports, no brim. It prints flat exactly as exported. Nothing in it
  overhangs past 45°, apart from the short bridges of the crossbars, the
  windows' tops, the cavities' and the mouths' roofs.
- 0.2 mm layers, 0.4 mm nozzle. The bed needs to be at least 134 x 124 mm.
- Keep the first layer clean: elephant's foot is what welds print-in-place
  joints. If a joint is stuck when it comes off the bed, swing the link
  firmly once and it breaks free. Then work every joint in every direction a few
  times.
