# spider

An **articulated spider**, printed in place: one print, no assembly, no
supports. The legs are chains of rounded links joined **ring through ring**,
like a chain, with the rings hidden. Each link ends in a round knuckle with a
crossbar inside it. The next link's narrow neck runs into the knuckle's
mouth, and the tab on its end hooks over that crossbar. The legs plug into
the body the same way, and so does the abdomen: its nose tucks in under the
head's back edge, the way each link tucks under the one before. Every link
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
| `spider`  | 148 x 121 x 18 mm        | its belly, as is    |

It comes off the bed as 34 loose-but-linked pieces: the body (head), the
abdomen, and 8 legs of 4 links each, the last one the foot.

## How the joints work

Each leg is one round bar lying on the bed, a cylinder 9.4 mm across with
its top at 8 mm, its sides running almost straight down to the bed (8.9 mm
wide there: a true circle would meet the bed only 6.7 mm wide, too narrow
for the joint's cavity inside). It is cut into links at **seams**, with a
**rough skin** of random shallow dents and low bumps round each link —
dents down to just above its widest point, bumps only over its top half
(all shrunk near the seams so none reaches their sharp edges) — and ends in
a foot with a half-ball end, as long as the other links. Side on, a seam stands straight up for its lower
half and then leans forward at 45° to the top, a 0.6 mm gap across it, the
tops flush: each link's front leans over the next link's rear.

- **Outer end** of a link: inside it is a cavity, open underneath and
  roofed over. A **crossbar** runs across the cavity from wall to wall, and
  a **mouth** opens at the front, under the seam's leaning part.
- **Inner end**: a narrow neck runs out of the link's rear and ends in a
  flat upright **tab** with a window through it.

The rings are as big as the round link allows. The tab is 2.8 mm thick.
Its top is a half circle round the crossbar, and its window is round too
(cut flat top and bottom), so the tab is a ring at least 1.2 mm thick all
round the window (1.0 under it). The crossbar is 2 mm along the link and
1.8 mm tall, with its edges cut off at 45°, so it fits a smaller round
window and can still turn in it however far the link swings. Above the crossbar the cavity
is only the tab's own room: its round top, swept through the swing, with
45° corners. It is tall only in the middle, where the link is tall too, so
the link's walls stay ≥ 1.2 mm. In the head, each socket's crossbar and
droop stop are kept out of the neighbouring sockets' cavities, since the
sockets sit close together.

The neck runs into the previous link's mouth, and the tab sits in the cavity
with the crossbar through its window, all hidden. The next link's rear is a
flat face; the previous link's front is that face swung through ±25°, round
in the middle and set back a little at the sides, so the link swings
freely. Neither ring can open, so the links can't come apart.

The body's sockets are sunk in the **head**, a flattened half ball standing
on the bed (50 mm across, 16 mm tall, the legs are 8). Its profile is a
superellipse rather than an ellipse, so it stays full almost to its edge and
then rounds down to the bed: no straight side, but still high enough at the
legs to stand over them. Each leg sits in a
**niche** in the head, cut to the same 45° seam as the links: the first link
is cut like every other link, and the niche's back wall leans over it. The
niche is an **arched cutout**, as if a ball (9 mm radius, centred on the
bed under the top of the leg's seam, drawn outwards into a tunnel) were
taken out of the head, past the leg's seam: a round arch in the head's side
over each leg, its top a short bridge. Neighbouring balls run into each other, so nothing of
the head comes down to the bed between the legs. The legs sit 30° apart, as
close as their first links allow. Two
**fangs** lean down the head's front, rooted under the eyes, their tips
lying on the bed.

The **abdomen** is a separate piece, a big egg hung on a ninth joint, the
waist, like one more leg: the cavity and its crossbar are in the head, just
inside its back edge, and the abdomen's tab and neck hang on that crossbar.
Its nose is a leg link cut to a leg's seam, and it goes in under the head's
back edge. The head's shape is unchanged from above. Only underneath, at
the back, is its edge lifted at 45° over the nose, the way a link's front
leans over the next link. Above that the egg follows the head round, `gap`
clear of it however far it swings. The abdomen swings ±25°, droops 30°
(the droop stop), lifts ~3° and rolls ~3°+.

The head and the abdomen carry the same **rough skin** as the legs, spots
of the same size and depth set along the surface. On the head it covers
only the part above the legs' arches (10 mm up), so no spot reaches a cut
edge, and it skips the eyes; over the head's back, where the abdomen hugs
it, there are dents but no bumps. On the abdomen the dents cover its whole
dome, the bumps only its back half above the legs' tops, so neither the
head nor a swinging back leg ever meets a bump.

The cavity is the tab and the neck swept through ±25°, so the link swings
freely. The seam is tight, so a link barely nods up: its rear top runs into
the previous link's front. Turning the outer link about the crossbar, with
nothing else moving (a 3D check):

| motion          | free to | stopped by                         |
| --------------- | ------- | ---------------------------------- |
| swing           | ±25°    | the crossbar in the window          |
| nod up          | ~3°     | its rear against the previous link's front, across the seam |
| nod down        | ~29°    | the tab's far end on the droop stop |
| twist           | ±15°    | the tab against the crossbar        |

Swinging and drooping fully at once, they touch (25° + 20°); 25° + 10° and
20° + 25° are free. On the head the first links
nod and droop the same way, but swing only about ±6°: against the
neighbouring leg, or the niche on the outer side of the front and back legs. The crossbar can also slide in the window and the tab along the crossbar,
which adds a little. The **droop stop** is a ledge in the back of the
cavity, round the tab's far end. As a link nods down, the tab's far end
swings back and up, and at about 30° its foot lands on the ledge. The back legs
swing the full ±25° past the abdomen, and the abdomen swings the full ±25°
past them. Further out, neighbouring legs stop each other at full swing.

It all prints in place, flat:

- The tab, the neck and the knuckle's walls stand on the bed, at least
  0.5 mm apart.
- The crossbar is a short bridge (about 5 mm) across the cavity, 0.7 mm above
  the tab's foot, with 45° sides. The window's flat top (2.2 mm), the top of the cavity's roof and the droop stop's ledge
  (2.6 mm up) are short bridges too, and so is each mouth's roof, 4.5 mm up.
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
| `link_base`    | joint  | 4.45    | link half-width on the bed (mm)                |
| `knuckle_r`    | joint  | 5.5     | knuckle radius (mm)                            |
| `tab_t`        | joint  | 2.8     | tab thickness (mm)                             |
| `foot_h`, `top_bar` | joint | 1.0, 1.6 | the tab under and over its window (mm)    |
| `win_r`        | joint  | 1.785   | the round window's radius; the crossbar slides and turns in it (mm) |
| `bar_w`, `bar_h` | joint | 2.0, 1.8 | crossbar section (mm)                       |
| `bar_ch`       | joint  | 0.6     | the crossbar's 45° edge cuts (mm)              |
| `neck_w`, `neck_h` | joint | 3.0, 3.6 | neck section (mm)                         |
| `swing`        | joint  | 25      | side-to-side swing the cavity allows (deg)     |
| `droop`        | joint  | 30      | how far a link nods down before the droop stop (deg) |
| `segments`     | spider | 4       | links per leg, the last one the foot            |
| `pitch`        | spider | 13.5    | joint to joint along a leg (mm)                |
| `seam_r`       | joint  | 4.75    | the seam's upright part, ahead of the crossbar (mm) |
| `seam_gap`     | joint  | 0.6     | across the seam (mm)                           |
| `rough_n`, `rough_d` | spider | 120, 0.15–0.35 | dents and bumps per link, and their depth (mm) |
| `head_rough_n`, `belly_rough_n` | spider | 600, 450 | spots scattered over the head and the abdomen (about half land where they are allowed) |
| `socket_at`    | spider | 13.5    | how far out from the body centre its crossbars sit (mm) |
| `leg_angles`   | spider | 43 73 103 133 | leg directions, deg from straight ahead  |
| `belly_tuck`   | spider | 3       | how far the abdomen's nose reaches in under the head's back edge, on the bed (mm); sets `waist_at` (16.75), the waist's crossbar behind the body centre, inside the head |

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
