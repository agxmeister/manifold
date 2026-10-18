# advent-chimney

An advent calendar shaped like a brick chimney. The ground floor is a
fireplace, above it stand 24 chimney sections, and a snow cloud closes the
top. Every section's floor is a **gate** you can pull out. Each day a kid
pulls the next gate, and the surprise that sat on it drops down the chimney
into the fireplace.

Day 1 is the **bottom** section and day 24 the **top**. It has to be that way
round: a gate only empties into the shaft below it if every gate under it is
already open.

A section's floor lives in the **top of the piece below it**. Day 1's gate
sits in the fireplace's top, day 2's in the top of section 1, and so on up to
day 24's in the top of section 23. Section 24's top has no gate; the cloud
fills it.

```
advent-chimney/
  models/
    fireplace/fireplace.scad   # ground floor, where the surprises land   (print 1)
    section/section.scad       # one chimney section, all identical       (print 24)
    gate/gate.scad             # the pull-out floor, numbered             (print 1 per day: -D day=N)
    cloud/cloud.scad           # the snow cloud on top                    (print 1)
  lib/
    chimney.scad   # chimney size, bricks, the stacking joint, gate fit (renders nothing)
  exports/         # generated meshes (gitignored): section-section.stl, gate-gate-01.stl, ...
  previews/        # generated renders (gitignored)
```

## Components

| Component   | Print size (as exported)  | Prints on                    | Count |
| ----------- | ------------------------- | ---------------------------- | ----- |
| `fireplace` | 240 x 140 x 149.5 mm      | its bottom, as it stands     | 1     |
| `section`   | 100 x 70 x 44.3 mm        | its bottom, as it stands     | 24    |
| `gate`      | 100 x 73.6 x 16 mm        | the plate, band standing up  | 24 (days 1 to 24) |
| `cloud`     | 161 x 88 x 77 mm          | its flat underside           | 1     |

Assembled, it is about 1.18 m tall: fireplace 150 mm to the stub's top, 24
sections of 40 mm, then the cloud.

The back is **one flat plane**: the fireplace's back, the mantel's back edge,
every section's back and the cloud's back (cut flat) all line up, so the
calendar can stand against a wall and be held to it with double-sided tape.

## How it works

**Stacking.** Every joint in the stack is the same. The piece below has a
**pocket** in its top: the wall is cut back to a 1.8 mm outer rim for the top
7.3 mm, and the rim's top is bevelled 45° inward. The piece above has a
**ring** under it: the inner part of its wall hangs 4.8 mm down into that
pocket, and its outside is bevelled to sit on the rim's bevel. The ring's
straight 3 mm grips the pocket wall with 0.05 mm per side, so pushing a
section home takes some effort (0.15 mm over 1.5 mm printed loose). The fireplace's top is a pocket. Each section has a ring under
it and a pocket on top. The cloud has a solid plug that fills the top
section's pocket. The pieces just sit on each other and need no glue, so the
chimney comes apart for storage.

**Gates.** The gate is a 2 mm plate lying on the pocket's floor, under the
ring of the section above, with 0.6 mm to the pocket walls and 0.5 mm to the
ring, so it pulls out easily (0.3 / 0.2 printed tight). It slides out through a notch in the front wall
of the piece below. At its front is a stone band across the chimney, over the
joint, with the day number on it. The band stops the plate when it is all
the way in, and its top edge is a lip to hook a finger under. Pull the gate
out and the shaft is open all the way down. On the fireplace, the chimney
starts with a one-course brick stub standing on the mantel shelf, and the
day 1 pocket is in the stub's top. The stub lifts the gate's band 2.7 mm over
the shelf, so the gate pulls straight out over it and the shelf stays solid.

The pocket and the notch are open upward, so no part of the gate's path is
ever printed over air. The first version put the gate in a slot through the
section's own wall, whose 66 mm roof needed support.

**Fireplace.** The fireplace is much wider than the chimney (200 x 100, plus
the mantel and hearth). The chimney stands at its back edge, flush with it.
Behind the arch, the firebox narrows in a 45° funnel up into the chimney's
shaft (its back face leans out only slightly, to the shaft's back wall). Everything
that drops lands on the firebox floor, where a hand can reach it through the
arch.

**Hearth.** In front lies a flagstone hearth, reaching 40 mm forward and
running on down both sides of the body to the back plane, 20 mm wide there:
240 mm wide in all. Its top edge is chamfered 1 mm at the front and ends; the
back stays flush. It is paved with big irregular stones, and the paving carries on through the arch
across the firebox floor. The stones come from splitting the front, each side run and the
firebox floor in two by a slightly leaning cut, then each half again, until
they are about `flag_max`. So they come out uneven, and their joints meet in
T's and never run straight across. Each stone's top sits 0, 0.2 or 0.4 mm
down, so neighbours don't quite line up. The joints are 45° V grooves 0.8 mm
deep, cut into the top. Where one reaches the front or an end of the slab, it
runs down the face as a vertical V. Change `flag_seed` for a different
layout.

**Mantel.** The shelf is a live-edge wooden slab. Its front edge wanders in
by up to 1.5 mm (never out, so the footprint is unchanged), and the 45°
corbel under it follows. Grain lines are cut 0.4 mm deep: across the top,
bending round four knots (each with an oval dimple at its heart), and as
two wavy V grooves along the front and both ends. The V grooves have 45°
roofs like the mortar, and the top grooves are open upward, so the wood needs
no support. The grain is spaced so no ridge between grooves is thinner than
0.8 mm.

**Bricks.** The mortar is a groove 0.6 mm deep. Each section is 4 courses
tall, an even number, so the running bond carries on unbroken from one
section to the next. The joint between two sections falls on a mortar line.

## Parameters

The shared sizes live in `lib/chimney.scad`. Each model's own settings are at
the top of its file.

| Variable      | Where     | Default | What it sets                                           |
| ------------- | --------- | ------- | ------------------------------------------------------ |
| `ch_w` / `ch_d` / `ch_h` | lib | 100 / 70 / 40 | section outside width, depth, height (mm)  |
| `wall`        | lib       | 3.6     | chimney wall thickness at the brick faces              |
| `course` / `pitch` | lib  | 10 / 30 | brick course height and brick length, mortar included |
| `mortar` / `mortar_d` | lib | 1.0 / 0.6 | mortar line width and depth                       |
| `groove_d`    | lib       | 1.8     | how far the pocket cuts into the walls; the rim is `wall` minus this |
| `ring_v`      | lib       | 3.0     | straight part of the ring, below its bevel             |
| `joint_gap`   | lib       | 0.05    | ring to pocket wall clearance, per side (the section fit) |
| `gate_t`      | lib       | 2.0     | gate plate thickness                                   |
| `gate_side` / `gate_vgap` | lib | 0.6 / 0.5 | gate clearance to the pocket wall / to the ring above |
| `wood`        | fireplace | true    | live-edge wooden mantel with grain; false for a plain shelf |
| `live_a`      | fireplace | 1.5     | how far the live front edge wanders in                 |
| `grain_w` / `grain_d` | fireplace | 0.8 / 0.4 | top grain line width, depth of every grain groove |
| `grain_y` / `grain_z` | fireplace | 26 lines / 2 lines | top grain lines' y; edge grain lines' heights above the shelf's underside |
| `knots`       | fireplace | 4 knots | knots in the top grain, as `[x, y, r]`                 |
| `stub_courses` | fireplace | 1      | brick courses of chimney on the mantel shelf, under the day 1 pocket |
| `day`         | gate      | 1       | the number on the band                                 |
| `band_h` / `band_t` / `lip` | gate | 16 / 3 / 3 | band height, thickness, pull lip reach     |
| `fp_w` / `fp_d` / `fp_h` | fireplace | 200 / 100 / 140 | fireplace body size, to the mantel's top |
| `hearth_h`    | fireplace | 6       | hearth and plinth height; the firebox floor is flush with it |
| `hearth_w` / `hearth_o` | fireplace | 240 / 40 | hearth slab width (side runs are `(hearth_w - fp_w) / 2`), and how far it reaches in front of the body |
| `flags`       | fireplace | true    | flagstone paving on the hearth and firebox floor; false for a plain slab |
| `flag_seed` / `flag_max` / `flag_skew` | fireplace | 3 / 34 / 6 | stone layout, about how big a stone is, how far a joint leans (mm) |
| `flag_gd` / `flag_drop` | fireplace | 0.8 / [0, 0.2, 0.4] | joint depth, the heights a stone's top drops by |
| `box_w`, `arch_w`, `arch_sp` | fireplace | 130, 88, 34 | firebox width, arch width, arch springing height |
| `arch_band`, `arch_stones`, `jamb_stones` | fireplace | 10, 13, 3 | ring of arch stones round the opening: width, stones over the semicircle, stones up each jamb |
| `puffs`       | cloud     | 12 puffs | the cloud's balls, as `[x, y, z, r]`                  |
| `flakes`      | cloud     | 4 flakes | snowflakes, as `[x, z, size, turn]`                   |
| `flake_w` / `flake_d` | cloud | 1.4 / 1.2 | snowflake arm width and inlay depth          |
| `accent`      | fireplace, cloud | false | write the colour parts instead of one solid  |

## Printing

All parts print without support. PLA, 0.2 mm layers, 15 % infill.

- **section**: upright, as it stands, on the ring. The pocket and the front
  notch are open upward and the ring's outside is a 45° bevel. Supports off.
- **gate**: plate flat on the bed, band standing at the front edge. Export
  one per day:
  `openscad -D day=7 -o projects/advent-chimney/exports/gate-gate-07.stl projects/advent-chimney/models/gate/gate.scad`.
- **fireplace**: upright. The funnel and the mantel's underside are 45°.
  The arch is a plain semicircle, so the top of its curve is a near-flat
  ceiling. It's only the 8 mm front wall deep, so the slicer may simply
  bridge it; if it sags, paint support on the arch only ("support on build
  plate only" also works, the arch is the only overhang reaching the plate). It's the
  base of a 1.18 m tower, so give it 3 walls and 20 % infill or more for
  weight.
- **cloud**: on its flat underside, the plug and the skirt round it on the
  bed. Each puff stands on a 45° cone.

## Colour

The fireplace and the cloud print multicolour. The sections and gates are
one colour.

| Part        | Filament 1 | Filament 2                   | Filament 3                     | Swaps per print |
| ----------- | ---------- | ---------------------------- | ------------------------------ | --------------- |
| `fireplace` | bricks (and the chimney stub on the shelf) | mantel (corbel + shelf, 14 mm band) | hearth (slab, firebox floor, plinth, bottom 6 mm) | 3 |
| `cloud`     | cloud      | 4 snowflakes inlaid in the front, 1.2 mm deep | none            | about 125 (one per layer the flakes span, 25 mm) |

The fireplace's colours are horizontal bands, so it needs only three filament
changes. The snowflakes share layers with the cloud, so every layer they span
costs a swap. They sit in one low row to keep that span to 25 mm.

Build the 3MF in two steps. First export the colour parts with lazy-union,
then convert them into one multicolour object:

```sh
openscad --enable=lazy-union -D accent=true -o raw.3mf projects/advent-chimney/models/fireplace/fireplace.scad
python3 tools/multicolor-3mf.py raw.3mf projects/advent-chimney/exports/fireplace-fireplace.3mf
```

Do the same for `cloud`. In Creality Print the result loads as one object
with its parts already on filaments 1, 2 and 3. Set those slots to the
colours you want, and don't move the parts.
