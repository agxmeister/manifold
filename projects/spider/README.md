# spider

An **articulated spider**, printed in place: one print, no assembly, no
supports. The legs are chains of rounded links joined **ring through ring**,
like a chain, with the rings hidden, as on a flexi octopus: each link's
front is a hollow **collar** with a ring lying round a roofed hole inside,
and the next link's rear is a narrow **neck** that goes into the collar,
an upright ring hooked through the first. So each link sits partly inside
the one before, like a telescope, and it is the links themselves that stop
each other: every link swings side to side, nods up and down, and twists a
little, about 15° at most. The legs plug into the body with the same rings
(a plain tab in a niche, no collar), and so does the abdomen: its nose
tucks in under the head's back edge.

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
| `spider`  | 131 x 119 x 16 mm        | its belly, as is    |

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

- **Ring one, lying flat**: the front of a link is a **collar**: the link
  runs on 3 mm past its crossbar to its **lip**, hollow, with a **hole**
  in it, open underneath and roofed over, a **cheek** either side. Across
  the hole, low down, the **crossbar** runs from cheek to cheek. The roof
  is a 45° gable along the link, cut flat 1 mm under the link's top (a
  2.2 mm bridge), and the hole opens forward through the lip as a
  **mouth** of the same pointed shape.
- **Ring two, standing up**: the rear of the next link is a **neck**,
  3.6 mm wide and 5.6 mm tall, round over the top like a small link. Its
  far end is a thick upright **tab** with a round **window** through it;
  the tab stands in the hole, its foot on the bed, the crossbar through
  its window. The neck runs forward out of the mouth to the link's
  **shoulder**, where it is full width again, 1.7 mm past the lip, so a
  short stretch of neck shows between the two links.

Both rings are hidden in the collar; what shows is the neck going into it.

The tab's top is a half circle round the crossbar and its window is round
too (cut flat top and bottom), so the tab is a ring at least 1.2 mm thick
all round the window (1.0 under it), and it turns in the hole like a chain
link. The crossbar is 2 mm along the link and 1.8 mm tall, with its edges
cut off at 45°, so it fits a smaller round window and can still turn in it
however far the link swings. Neither ring can open, so the links can't come
apart.

The links stop each other. The **mouth** is the neck swept through ±15°
with no gap, 1 mm deep through the lip; the hole behind it is 0.5 mm
clear of the neck all round, so only the lip touches. Swung 15°, the neck
lies flat against the side of the mouth; nodded up 15°, its top comes up
under the mouth's ceiling. The hole's back is the **droop stop**: as a
link nods down, the tab's far end swings back and up, and at 15° its foot
reaches the back of the hole. The shoulder's corners stay at least 0.3 mm
clear of the lip, so the shoulder never takes over as the stop.

The body's sockets are sunk in the **head**, a flattened half ball standing
on the bed (44 mm across, 14 mm tall, the legs are 8). Its sockets use
the plain ring joint: a 2.8 mm tab straight off the first link's rear,
no neck or collar. Its profile is a
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
behind it. A joint can be bent this way because its mouth is swept through
the whole swing; it swings ±15° from straight, so from a 10° bend it swings
on 5° one way and 25° the other. Curling the legs in is what keeps the whole
print small; with the stiffer joints the bends are at most 10°, so it is a
little wider than before (131 x 119, was 127 x 114). Fanned out this wide, the sockets
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
abdomen droops 15° (the droop stop), lifts ~3° and rolls ~5°; its joint
swings ±15°, but with the back legs lying beside it the abdomen swings only
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
check, two leg links intersected at each pose):

| motion          | free to | stopped by                         |
| --------------- | ------- | ---------------------------------- |
| swing           | ±15°    | the neck against the side of the mouth |
| nod up          | ~14°    | the neck's top under the mouth's ceiling |
| nod down        | 15°     | the tab's foot on the back of the hole (the droop stop) |
| twist           | ±12°    | the thick tab round the crossbar, the neck in the mouth |

Swinging fully and drooping fully at once is free; at the full 15° swing
it nods up about 7° before the neck meets the roof. On the head
the first links droop the same 15° but swing only about ±5°, against the
neighbouring leg or the niche, and nod up ~3°, against the niche's leaning
back wall. The
crossbar can also slide in the window and the tab along the crossbar,
which adds a little. The abdomen stops the back legs swinging in towards it, and
they stop the abdomen (see above). Further out, neighbouring
legs stop each other at full swing.

It all prints in place, flat:

- The tab, the neck, the cheeks and the link behind them stand on the bed,
  at least 0.5 mm apart (the neck and the lip's mouth about 0.5 mm, the
  mouth swept wider than the neck).
- The bridges in a leg joint are short: the crossbar, about 5 mm across
  the hole, 0.7 mm above the tab's foot, with 45° sides; the roof's flat
  ridge, 2.2 mm wide; the mouth's ceiling, about 2.3 mm across the 1 mm
  lip. The window's round top is a small arch.
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
| `tab_t`        | joint  | 2.8     | tab thickness in the body's sockets (mm)       |
| `neck_w`       | joint  | 3.6     | a leg link's neck width, and its tab's thickness (mm) |
| `lip_x`        | joint  | 3.0     | the collar's lip, ahead of the crossbar (mm)   |
| `lip_t`        | joint  | 1.0     | how deep the mouth fits the neck with no gap (mm) |
| `sh_gap`       | joint  | 0.3     | the least between the shoulder and the lip, swung; sets the shoulder at 4.7 (mm) |
| `nod`          | joint  | 15      | how far a link nods up before its neck meets the mouth's ceiling (deg) |
| `foot_h`, `top_bar` | joint | 1.0, 1.6 | the tab under and over its window (mm)    |
| `win_r`        | joint  | 1.785   | the round window's radius; the crossbar slides and turns in it (mm) |
| `bar_w`, `bar_h` | joint | 2.0, 1.8 | crossbar section (mm)                       |
| `bar_ch`       | joint  | 0.6     | the crossbar's 45° edge cuts (mm)              |
| `bar_len`      | joint  | 7.2     | crossbar length, cheek to cheek (mm)           |
| `swing`        | joint  | 15      | side-to-side swing the mouth allows (deg)      |
| `droop`        | joint  | 15      | how far a link nods down before the tab's foot reaches the back of the hole (deg) |
| `bevel_top`    | joint  | 2.0     | the first link rear's top bevel, in the head; the bottom one runs up to the crossbar's height (mm) |
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
| `leg_bend`     | spider | [10,10,10] [5,5,5] [10,10,10] [10,2,10] | each leg's joints bent as printed, deg toward the back (at most `swing` − 5) |
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
- 0.2 mm layers, 0.4 mm nozzle. The bed needs to be at least 131 x 119 mm.
- Keep the first layer clean: elephant's foot is what welds print-in-place
  joints. If a joint is stuck when it comes off the bed, swing the link
  firmly once and it breaks free. Then work every joint in every direction a few
  times.
