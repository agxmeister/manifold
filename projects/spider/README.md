# spider

An **articulated spider**, printed in place: one print, no assembly, no
supports. The legs are chains of rounded links joined **ring through ring**,
like a chain, with the rings hidden, as on a flexi octopus: each link's
front is a ring lying round a roofed hole, and the next link's rear is an
upright ring hooked through it, straight off the link with no neck. The
legs plug into the body the same way, and so does the abdomen: its nose tucks in
under the head's back edge. Every link swings side to side, nods up and
down, and twists a little, about 30° at most.

```
spider/
  models/
    spider/spider.scad   # body, abdomen, eight legs, the whole print (print 1)
    spider/joint.scad    # the ring joint: hole, crossbar, tab, seam (renders nothing)
  exports/               # generated meshes (gitignored): spider-spider.stl
  previews/              # generated renders (gitignored)
```

## Components

| Component | Print size (as exported) | Prints on           |
| --------- | ------------------------ | ------------------- |
| `spider`  | 127 x 114 x 16 mm        | its belly, as is    |

It comes off the bed as 34 loose-but-linked pieces: the body (head), the
abdomen, and 8 legs of 4 links each, the last one the foot.

## How the joints work

Each leg is one round bar lying on the bed, a cylinder 9.4 mm across with
its top at 8 mm, its sides running almost straight down to the bed (8.9 mm
wide there). It is cut into links at upright **seams**, tops flush. Each
link but the first, which is mostly inside the head, has a **curvy skin**:
smooth, wide swells and hollows over its top, up to 0.8 mm high and a few
mm across, running into each other like gentle waves. They never cut into
the link, so the roof over the joint keeps its thickness. They fade out
over 3 mm before each seam, so the tops still meet flush. They also fade
out down its flanks (none past 55° from the top), where a swell's
underside would face the bed and sag. The leg ends in a foot with a
half-ball end, as long as the other links. The joint is two rings, one lying flat and one standing up, like the
links of a chain:

- **Ring one, lying flat**: the front of a link has a **hole** in it, open
  underneath and roofed over, with a **cheek** either side. Across the
  hole's front, low down, a **crossbar** runs from cheek to cheek. The roof
  is a 45° gable along the link, cut flat 1 mm under the link's top (a
  1.7 mm bridge), and the hole opens forward through the link's front as a
  mouth of the same pointed shape.
- **Ring two, standing up**: the rear of the next link is a flat upright
  **tab**, 2.8 mm thick, with a round **window** through it. It grows
  straight out of the link's rear face and stands in the hole, its foot on
  the bed, the crossbar through its window.

Both rings are hidden in the link; only a sliver of the tab shows across the
seam, low down.

The tab's top is a half circle round the crossbar and its window is round
too (cut flat top and bottom), so the tab is a ring at least 1.2 mm thick
all round the window (1.0 under it), and it turns in the hole like a chain
link. The crossbar is 2 mm along the link and 1.8 mm tall, with its edges
cut off at 45°, so it fits a smaller round window and can still turn in it
however far the link swings. Neither ring can open, so the links can't come
apart.

The hole is the tab swept through ±25°, so the link swings freely. Its back
is the **droop stop**: as a link nods down, the tab's far end swings back
and up, and at 30° its foot reaches the back of the hole. The link's rear
is a flat face, the previous link's front that face swung through ±25°
(round in the middle, set back a little at the sides), 0.5 mm apart. The
rear's bottom edge is bevelled at 45° up to the crossbar's height, and its
top edge by 2 mm, so the rear doesn't swing into the previous link's
cheeks as it droops or nods up at full swing.

The body's sockets are sunk in the **head**, a flattened half ball standing
on the bed (44 mm across, 14 mm tall, the legs are 8). Its profile is a
superellipse rather than an ellipse, so it stays full almost to its edge and
then rounds down to the bed: no straight side, but still high enough at the
legs to stand over them. In the head the joints are the same, but hidden:
each socket's hole is a room in the solid head, open underneath, its
ceiling a 45° cone round the crossbar's upright axis, so it is
self-supporting however far the tab swings. Each leg sits in a **niche** in
the head: the first link's rear is cut to a seam that stands up 4.7 mm and
then leans forward at 45°, and the niche's back wall leans over it the same
way, and goes on leaning at 45° out to the head's side (about 9 mm up), so
the head's whole underside over the legs grows off the wall under it, layer
by layer, and nothing over the legs hangs in the air. (Round arches here,
one per leg, left floating regions: their crowns were flat and the
cusps between neighbouring arches hung in mid-air.) The neighbouring legs'
leans run into each other, so nothing of the head comes down to the bed
between the legs; the front pair's leans are narrow on their inner side,
clear of the fangs, and the back pair's on theirs, clear of the waist.
The legs are laid out like a real spider's: each leaves its own socket round
the head's side (32°, 68°, 102° and 140° from straight ahead) and points its
own way (25°, 58°, 94° and 155°), so the front pair reach forward and the
back pair run back beside the abdomen. The legs print **bent at their
joints** (`leg_bend`), the way a resting spider holds them: the front pair
sweep out and back, the middle pairs curve back, and the back pair follow
the abdomen's side about a millimetre clear of it, their feet curling in
behind it. A joint can be bent this way because its hole is swept through
the whole swing; it swings ±25° from straight, so from a 15° bend it swings
on 10° one way and 40° the other. Curling the legs in is what keeps the whole
print small. Fanned out this wide, the sockets
pack in closer to the centre (13 mm) than legs spread evenly from it could,
which is what keeps the head small; they are as close as the first links,
swinging in their niches, and the rooms round the rings (at least 1.2 mm of
head between neighbours) allow. Two **fangs** lean down the head's front,
rooted under the eyes, their tips lying on the bed.

The **abdomen** is a separate piece, an egg (22 x 34 x 15 mm) hung on a ninth joint, the
waist, like one more leg: the room and its crossbar are in the head, just
inside its back edge, and the abdomen's tab hangs on that crossbar. Its
nose is a leg link cut to the niche's seam, and it goes in under the head's
back edge. The head's shape is unchanged from above. Only underneath, at
the back, is its edge lifted at 45° over the nose. Above that the egg
follows the head round, `gap` clear of it however far it swings. The
abdomen droops 30° (the droop stop), lifts ~3° and rolls ~5°; its joint
swings ±25°, but with the back legs lying beside it the abdomen swings only
~5–10° before it meets them (more if they swing out of the way).

The head and the abdomen carry the same **curvy skin**, a little bigger
(up to 1 mm, 3–4.5 mm spread). On the head it covers only the part above
where the head leans over the legs (10 mm up), so it never reaches a cut edge. It fades out
round the eyes and over the back of the head's rim, where the abdomen hugs
it. On the abdomen it covers the back of the dome above the legs' tops,
pushed out along the surface. It fades in gently up the steep sides, so
neither the head nor a swinging back leg ever meets it. It replaces the
earlier rough skin of small dents and bumps, which didn't print well.

Turning the outer link about the crossbar, with nothing else moving (a 3D
check):

| motion          | free to | stopped by                         |
| --------------- | ------- | ---------------------------------- |
| swing           | ±25°    | the crossbar in the window          |
| nod up          | 12°     | its rear top against the previous link's front |
| nod down        | 30°     | the tab's foot on the back of the hole (the droop stop) |
| twist           | ±15°    | the tab against the hole's sides    |

Swinging fully and drooping fully at once is free; at the full 25° swing it
still nods up 7°, but twists only once it swings back to ~22° (the crossbar
then sits right at the window's edge). On the head the first links
droop the same 30° but swing only about ±5°, against the neighbouring leg
or the niche, and nod up ~3°, against the niche's leaning back wall. The
crossbar can also slide in the window and the tab along the crossbar,
which adds a little. The abdomen stops the back legs swinging in towards it, and
they stop the abdomen (see above). Further out, neighbouring
legs stop each other at full swing.

It all prints in place, flat:

- The tab, the cheeks and the link behind them stand on the bed, at least
  0.5 mm apart.
- The bridges in a leg joint are short: the crossbar, about 5 mm across
  the hole, 0.7 mm above the tab's foot, with 45° sides, and the roof's
  flat ridge, 1.7 mm wide. The window's round top is a small arch.
- The holes are open underneath, onto the bed. Their roofs lean in at 45°
  (the legs' gables, the head's cones), and so do the niches' and the
  waist's leaning backs and the rear bevels.
- The roof over each leg joint is 1 mm thick at its ridge.

**Don't print it scaled.** Scaling shrinks the clearances with everything
else. At 50 % the first version's 0.4 mm gaps became 0.2 mm and every joint
fused. To change the size, change the parameters below, not the slicer's
scale.

## Parameters

| Variable      | Where  | Default | What it sets                                  |
| ------------- | ------ | ------- | --------------------------------------------- |
| `gap`          | joint  | 0.5     | clearance round the crossbar and between pieces (mm) |
| `under_gap`    | joint  | 0.7     | between the crossbar and the tab's foot (mm)   |
| `roof_gap`     | joint  | 0.6     | between the tab's top and a head room's cone (mm) |
| `roof_min`     | joint  | 1.0     | the least of the link over a leg joint's roof (mm) |
| `link_w`       | joint  | 9.4     | link width (mm)                                |
| `link_h`       | joint  | 8       | link height (mm)                               |
| `link_base`    | joint  | 4.45    | link half-width on the bed (mm)                |
| `tab_t`        | joint  | 2.8     | tab thickness (mm)                             |
| `foot_h`, `top_bar` | joint | 1.0, 1.6 | the tab under and over its window (mm)    |
| `win_r`        | joint  | 1.785   | the round window's radius; the crossbar slides and turns in it (mm) |
| `bar_w`, `bar_h` | joint | 2.0, 1.8 | crossbar section (mm)                       |
| `bar_ch`       | joint  | 0.6     | the crossbar's 45° edge cuts (mm)              |
| `bar_len`      | joint  | 7.2     | crossbar length, cheek to cheek (mm)           |
| `swing`        | joint  | 25      | side-to-side swing the hole allows (deg)       |
| `droop`        | joint  | 30      | how far a link nods down before the tab's foot reaches the back of the hole (deg) |
| `bevel_top`    | joint  | 2.0     | the link rear's top bevel; the bottom one runs up to the crossbar's height (mm) |
| `segments`     | spider | 4       | links per leg, the last one the foot            |
| `pitch`        | spider | 13.5    | joint to joint along a leg (mm)                |
| `seam_gap`     | joint  | 0.6     | across the head's leaning seams (mm); the leg seams are `gap` |
| `swell_h`, `swell_s` | spider | 0.8, 2.5–3.5 | a link's curvy skin: how high it rises, and a swell's spread (mm) |
| `leg_swells`   | spider | 10      | swells and hollows per link                    |
| `swell_a`      | spider | 20, 55  | round a link from its top: full swells to the first, none past the second (deg) |
| `body_swell_h`, `body_swell_s` | spider | 1.0, 3–4.5 | the same on the head and the abdomen (mm) |
| `head_swells`, `belly_swells` | spider | 60, 60 | swells and hollows scattered over the head and the abdomen |
| `socket_at`    | spider | 13      | how far out from the body centre its crossbars sit (mm) |
| `socket_angles` | spider | 32 68 102 140 | where each socket sits round the head, deg from straight ahead |
| `leg_angles`   | spider | 25 58 94 155 | leg directions, deg from straight ahead  |
| `leg_bend`     | spider | [15,15,15] [5,5,5] [15,20,15] [14,2,20] | each leg's joints bent as printed, deg toward the back (at most `swing` − 5) |
| `lean_w`       | spider | [10,6] [10,10] [10,10] [6,14] | how far the head leans over each leg on either side (mm) |
| `belly_tuck`   | spider | 3       | how far the abdomen's nose reaches in under the head's back edge, on the bed (mm); sets `waist_at` (16), the waist's crossbar behind the body centre, inside the head |

The body (`head_*`, `belly_*`) and face (`eye_r`, `fang_*`) are at the top
of `spider.scad`.

**Crossbar fused to the tab:** raise `under_gap` (0.9). That bridge is where
sag would weld it. **Tab stuck to a roof:** raise `roof_gap` (0.8) for the head; on a leg, raise `gap` (0.6).
**Fused elsewhere:** raise `gap` (0.6).

## Printing

- No supports, no brim. It prints flat exactly as exported. Nothing in it
  overhangs past 45°, apart from the short bridges of the crossbars and the
  leg roofs' ridges and the windows' small arches.
- 0.2 mm layers, 0.4 mm nozzle. The bed needs to be at least 127 x 114 mm.
- Keep the first layer clean: elephant's foot is what welds print-in-place
  joints. If a joint is stuck when it comes off the bed, swing the link
  firmly once and it breaks free. Then work every joint in every direction a few
  times.
