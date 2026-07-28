# chess

A complete 3D-printable chess set: the board plus a full complement of pieces.
Each **model** is a folder under `models/`; a model's **parts** are the
`.scad` files inside it. Geometry shared across several models lives in `lib/`:
`staunton.scad` (the foot, neck and collar the Staunton pawn, bishop, rook,
queen and king are all built from). Exported meshes go
in `exports/`, named `<model>-<part>.<ext>` — that directory is created on the
first export and is gitignored (never committed).

```
chess/
  models/
    board/            # the board model
      cell.scad       #   part: one battlefield tile (print 64)
      pin.scad        #   part: the dumbbell connector (print 112 + spares)
      platform.scad   #   part: the round piece-stage (print 32 black + 32 white)
      connector.scad  #   shared mating dims for cell + pin + platform (renders nothing)
    pawn/   pawn.scad     # turned classic Staunton pawn (print 16)
    bishop/ bishop.scad   # turned Staunton bishop  (print 4)
    rook/   rook.scad     # turned Staunton rook    (print 4)
    queen/  queen.scad    # turned Staunton queen   (print 2)
    king/   king.scad     # turned Staunton king + cross (print 2)
    knight/               # flat horse-head silhouette (planned — WIP)
  lib/
    staunton.scad     # shared Staunton foot, neck & collar (renders nothing)
  exports/            # generated meshes (gitignored): board-cell.stl, pawn-pawn.stl, …
```

## Models

| Model             | Parts               | Status  |
| ----------------- | ------------------- | ------- |
| `board`           | cell, pin, platform | done    |
| `pawn`            | single              | done    |
| `bishop`          | single              | done    |
| `rook`            | single              | done    |
| `queen`           | single              | done    |
| `king`            | single              | done    |
| `knight`          | single              | planned |

Every piece has a **round base** that fits within the 40 mm platform disc, so it
stands firm on the stage at the centre of each cell.

## The pieces

The **pawn, bishop, rook, queen and king** are plain, classic **Staunton**
pieces, each turned on the axis and built from the same shared parts — a common
**foot** and **neck**, and a shared **collar** on all but the rook
(`lib/staunton.scad`), scaled per piece — with each piece's own head and body
traced from the same reference photo. Every piece grows taller by rank and
stands on the same 32 mm footprint, so the set reads as one army on the terrain
board. (The **knight** is planned separately in a **medieval / battlefield**
style — a flat heraldic horse-head blade on a round stone plinth — and is being
reworked; it isn't part of the shared Staunton family.)

- **Pawn** — the classic **Staunton pawn**: a round **ball** head on a thin neck,
  a flared **collar** bead, a bell-shaped flaring body and a **tiered stacked
  base**, traced from a reference photo and **turned on its axis**
  (`rotate_extrude` of the measured `[r, z]` profile). The shortest piece, and
  the **canonical Staunton shape**: its foot, neck and collar are the shared
  parts (`lib/staunton.scad`) every other turned piece is built from. It isn't
  built on the medieval knight's plinth; its base is cut flat for a full disc of
  bed contact, so it prints upright with only the classic turned overhangs under
  the ball and collar brim, short enough to bridge acceptably at this size (add
  light support for the crispest finish).
- **Bishop** — the classic **Staunton bishop**, built like the pawn: a small
  **ball finial** on a thin stem, a tall pointed **mitre** with the traditional
  diagonal **slit**, then the shared **collar**, **neck** and tiered **foot**,
  with its own bell-flaring body between — the mitre and slit traced from the
  reference photo, **turned on its axis** (`rotate_extrude` of the measured
  `[r, z]` profile, with the mitre slit subtracted). Its base is cut flat for a
  full disc of bed contact, so it prints upright with only the classic turned
  overhangs under the mitre and collar brim, short enough to bridge acceptably at
  this size (add light support for the crispest finish). About 1.5× the pawn's
  height.
- **Rook** — the classic **Staunton rook**, built like the pawn but the odd one
  out on parts: it shares the **foot** and a much thicker **neck**, but has **no
  collar**. A **crown that flares out to a battlemented parapet**, an **astragal
  bead** and a concave **trumpet body** narrow straight into the heavy waist,
  traced from the same reference photo and **turned on its axis** (`rotate_extrude`
  of the measured `[r, z]` profile). Its mark, the **crenellations**, is the one
  non-axisymmetric feature — a hollow central well and a ring of notches cut into
  the rim, leaving a wreath of **merlons** around an open walk (like the bishop's
  subtracted slit). Its base is cut flat for a full disc of bed contact, so it
  prints upright: the flared crown is a shallow turned overhang (~15° from
  vertical) that bridges cleanly, and the crenels open upward so the merlons
  self-support (add light support only for the crispest finish on the crown and
  beads). Taller than the pawn, shorter than the bishop.
- **Queen** — the classic **Staunton queen**, built like the pawn (the pawn's
  big sister): a stacked **ball finial** and a flaring **coronet** (its scalloped
  crown points read as a continuous turned rim), then the shared **collar**
  (widened and stretched), **neck** and **foot** (stretched taller), with her own
  swelling bell body between — the finial and coronet traced from the reference
  photo, **turned on its axis** (`rotate_extrude` of the measured `[r, z]`
  profile). Her base is cut flat for a full disc of bed contact, so she prints
  upright with only the classic turned overhangs under the coronet rim and collar
  brim (the same short overhangs the pawn's collar has), which bridge acceptably
  at this size (add light support for the crispest finish). Taller than the
  bishop, shorter than the king.
- **King** — the classic **Staunton king**, the tallest piece and the queen's
  big brother: a flaring **crown** (a rounded onion dome, widest at the
  shoulders), then the shared **collar**, a long slim **neck**, a swelling bell
  body and the shared **foot** stretched tallest of the family — the crown traced
  from the same reference photo and **turned on its axis** (`rotate_extrude` of
  the measured `[r, z]` profile). Its mark, the **cross**, is the one feature a
  lathe cannot turn: a flat **bottony cross** blade rooted into the top of the
  crown (as the queen's ball finial sits on her turned coronet). Its base is cut
  flat for a full disc of bed contact, so it prints upright. Its turned overhangs
  (crown shoulders, collar brim) bridge acceptably, but the **cross wants light
  support** underneath (its arm undersides and bottony end-bulbs face down) — the
  deliberate trade for a cross faithful to the photo. About 1.9× the pawn's
  height.

Print counts for one set: 8 pawns, 2 knights, 2 bishops, 2 rooks, 1 queen and
1 king **per side** — so 16 pawns and 4 each of knight/bishop/rook, 2 queens and
2 kings in total.

## The board

The board has three parts: the **cell** (the terrain tile), the **pin** (the
connector), and the **platform** (the round stage a piece stands on). Cells
are 50 mm square — a standard tournament cell.

**Cell.** Styled as a smooth "battlefield": each cell's top is a heightfield of
blended sine ripples, terrain swelling toward the rounded corners, with a flat
**round central plateau** (44 mm dia). `design` (0–7) picks one of eight
deterministic layouts, so a board mixed from all eight reads as varied ground.
In the middle of the plateau is a round **socket** that holds a platform.

**Platform.** A separately printed disc (40 mm dia — larger than a piece base)
that friction-fits into the cell socket, its top finishing flush with the
plateau. Because it's its own
part it can be a different colour from the terrain — print it **black for the
dark squares and white for the light squares** to colour the board, while every
cell can share one neutral terrain filament.

**Pin.** A flat **dumbbell**: one bulb drops into a chamber in each cell and the
narrow waist spans the seam. Because a bulb is wider than the slot its waist
passes through, joined cells can't pull apart. The chambers are **open at the
bottom of the cell**, so pins are loaded (and removed) from **underneath the
board** — you can add or lift out a tile in the *middle* of an assembled field
without disturbing its neighbours, which the old side-sliding pin couldn't do.
The pins hold a deliberate 2 mm gap between neighbours so height mismatches read
as natural seams rather than a step.

`connector.scad` defines the mating dimensions — the dumbbell groove/pin sizes,
the platform socket, the clearance, and the cell gap — that `cell.scad`,
`pin.scad` and `platform.scad` all `include`, so mating features can never
drift apart. Tune the fit (`connector_gap`) or the seam (`cell_gap`) there once
and re-export the affected parts.

### Printing

All three parts print **flat on the bed, support-free**. The cell terrain is a
heightfield (no overhangs); each bottom-opening pin groove is a shallow pocket
whose ~10 mm-wide roof bridges cleanly with no support.

- **Cell:** 0.2 mm layers, ~15–20 % infill, terrain up. Print 64 in a neutral
  terrain filament (the platform, not the cell, carries the square colour).
- **Platform:** print **top-face-down** for the smoothest visible surface —
  32 black and 32 white. 0.15–0.2 mm layers.
- **Pin:** the full dumbbell face is the bed contact. 0.15–0.2 mm layers for a
  predictable friction fit on such a small part.

Raise `connector_gap` if the pins or platforms are too tight, lower it if they
don't hold.

### Export

Run from the repo root; meshes land in `exports/`:

```sh
# one cell of each battlefield design
for d in 0 1 2 3 4 5 6 7; do
  openscad -D design=$d -o projects/chess/exports/board-cell-d$d.stl \
    projects/chess/models/board/cell.scad
done
# the dumbbell pin and the platform
openscad -o projects/chess/exports/board-pin.stl projects/chess/models/board/pin.scad
openscad -o projects/chess/exports/board-platform.stl projects/chess/models/board/platform.scad
# the pieces (each is single-part, prints upright on its base)
for p in pawn bishop rook queen king; do
  openscad -o projects/chess/exports/$p-$p.stl projects/chess/models/$p/$p.scad
done
```

All five Staunton pieces print **upright on their base**. The **pawn**,
**bishop**, **rook**, **queen** and **king** print on their own flat base with
only the classic turned overhangs — the pawn's ball and collar brim, the
bishop's mitre and collar brim, the rook's flared crown and base rings, the
queen's coronet rim and collar brim, the king's crown shoulders and collar brim —
short enough to bridge acceptably, with **light support optional** for the
crispest finish (the bishop's diagonal slit and the rook's crenels are cut with
solid material behind or below them). The one piece that truly needs support is
the **king's cross**, whose arm undersides and bottony end-bulbs face down: it
wants **light support** under the cross alone (the turned body below it prints
clean) — the trade for a cross faithful to the photo.

## License

This project is licensed [CC BY-NC 4.0](LICENSE) (Creative Commons
Attribution-NonCommercial 4.0 International): share and remix with credit, but
not for commercial purposes.
