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
| `fireplace` | 162 x 104 x 107 mm        | its bottom, as it stands     | 1     |
| `section`   | 70 x 50 x 32.8 mm         | its bottom, as it stands     | 24    |
| `gate`      | 70 x 53.9 x 13 mm         | the plate, band standing up  | 24 (days 1 to 24) |
| `cloud`     | 115 x 74 x 55 mm          | its flat underside           | 1     |

Assembled, it is about 0.88 m tall: fireplace 107 mm, 24 sections of 30 mm,
then the cloud.

## How it works

**Stacking.** Every joint in the stack is the same. The piece below has a
**pocket** in its top: the wall is cut back to a 1.8 mm outer rim for the top
5.5 mm, and the rim's top is bevelled 45° inward. The piece above has a
**ring** under it: the inner part of its wall hangs 3.3 mm down into that
pocket, and its outside is bevelled to sit on the rim's bevel. The ring lines
the pieces up. The fireplace's top is a pocket. Each section has a ring under
it and a pocket on top. The cloud has a solid plug that fills the top
section's pocket. The pieces just sit on each other and need no glue, so the
chimney comes apart for storage.

**Gates.** The gate is a 2 mm plate lying on the pocket's floor, under the
ring of the section above. It slides out through a notch in the front wall
of the piece below. At its front is a stone band across the chimney, over the
joint, with the day number on it. The band stops the plate when it is all
the way in, and its top edge is a lip to hook a finger under. Pull the gate
out and the shaft is open all the way down. On the fireplace, the day 1 gate
slides out along a trench across the mantel.

The pocket and the notch are open upward, so no part of the gate's path is
ever printed over air. The first version put the gate in a slot through the
section's own wall, whose 66 mm roof needed support.

**Fireplace.** The fireplace is much wider than the chimney (150 x 90, plus
the mantel and hearth), so the tall stack stands on its own. Behind the arch,
the firebox narrows in a 45° funnel up into the chimney's shaft. Everything
that drops lands on the firebox floor, where a hand can reach it through the
arch.

**Bricks.** The mortar is a groove 0.6 mm deep. Each section is 4 courses
tall, an even number, so the running bond carries on unbroken from one
section to the next. The joint between two sections falls on a mortar line.

## Parameters

The shared sizes live in `lib/chimney.scad`. Each model's own settings are at
the top of its file.

| Variable      | Where     | Default | What it sets                                           |
| ------------- | --------- | ------- | ------------------------------------------------------ |
| `ch_w` / `ch_d` / `ch_h` | lib | 70 / 50 / 30 | section outside width, depth, height (mm)  |
| `wall`        | lib       | 3.6     | chimney wall thickness at the brick faces              |
| `course` / `pitch` | lib  | 7.5 / 22.5 | brick course height and brick length, mortar included |
| `mortar` / `mortar_d` | lib | 1.0 / 0.6 | mortar line width and depth                       |
| `groove_d`    | lib       | 1.8     | how far the pocket cuts into the walls; the rim is `wall` minus this |
| `ring_v`      | lib       | 1.5     | straight part of the ring, below its bevel             |
| `joint_gap`   | lib       | 0.15    | ring to pocket wall clearance, per side                |
| `gate_t`      | lib       | 2.0     | gate plate thickness                                   |
| `gate_side` / `gate_vgap` | lib | 0.3 / 0.2 | gate clearance to the pocket wall / to the ring above |
| `trench_gap`  | fireplace | 0.5     | day 1 gate band to the trench's sides, per side        |
| `day`         | gate      | 1       | the number on the band                                 |
| `band_h` / `band_t` / `lip` | gate | 13 / 3 / 3 | band height, thickness, pull lip reach     |
| `fp_w` / `fp_d` / `fp_h` | fireplace | 150 / 90 / 107 | fireplace body size, to the mantel's top |
| `hearth_h`    | fireplace | 6       | hearth and plinth height; the firebox floor is flush with it |
| `box_w`, `arch_w`, `arch_sp` | fireplace | 96, 64, 26 | firebox width, arch width, arch springing height |
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
- **fireplace**: upright. The arch's crown is pointed at 45°, and the funnel
  and the mantel's underside are 45°, so nothing needs support. It's the
  base of an 0.88 m tower, so give it 3 walls and 20 % infill or more for
  weight.
- **cloud**: on its flat underside, the plug and the skirt round it on the
  bed. Each puff stands on a 45° cone.

## Colour

The fireplace and the cloud print multicolour. The sections and gates are
one colour.

| Part        | Filament 1 | Filament 2                   | Filament 3                     | Swaps per print |
| ----------- | ---------- | ---------------------------- | ------------------------------ | --------------- |
| `fireplace` | bricks     | mantel (corbel + shelf, top 13 mm) | hearth (slab, firebox floor, plinth, bottom 6 mm) | 2 |
| `cloud`     | cloud      | 4 snowflakes inlaid in the front, 1.2 mm deep | none            | about 90 (one per layer the flakes span, 18 mm) |

The fireplace's colours are horizontal bands, so it needs only two filament
changes. The snowflakes share layers with the cloud, so every layer they span
costs a swap. They sit in one low row to keep that span to 18 mm.

Build the 3MF in two steps. First export the colour parts with lazy-union,
then convert them into one multicolour object:

```sh
openscad --enable=lazy-union -D accent=true -o raw.3mf projects/advent-chimney/models/fireplace/fireplace.scad
python3 tools/multicolor-3mf.py raw.3mf projects/advent-chimney/exports/fireplace-fireplace.3mf
```

Do the same for `cloud`. In Creality Print the result loads as one object
with its parts already on filaments 1, 2 and 3. Set those slots to the
colours you want, and don't move the parts.
