# chess

A complete 3D-printable chess set: the board plus a full complement of pieces.
Each **model** is a folder under `models/`; a model's **parts** are the
`.scad` files inside it. Geometry shared across several models in the set lives
in `lib/` (e.g. a common figure base, once the pieces exist). Exported meshes
go in `exports/`, named `<model>-<part>.<ext>` — that directory is created on
the first export and is gitignored (never committed).

```
chess/
  models/
    board/            # the board model
      cell.scad       #   part: one battlefield tile (print 64)
      pin.scad        #   part: the connector (print 112 + spares)
      connector.scad  #   shared mating dimensions for cell + pin (renders nothing)
  lib/                # parts shared across chess models (future)
  exports/            # generated meshes (gitignored): board-cell.stl, board-pin.stl, …
```

## Models

| Model     | Parts               | Status  |
| --------- | ------------------- | ------- |
| `board`   | cell, pin           | done    |
| pawn      | single              | planned |
| knight    | single              | planned |
| bishop    | single              | planned |
| rook      | single              | planned |
| queen     | single              | planned |
| king      | single              | planned |

Every piece will have a **round base** sized to the cell's 18 mm flat central
plateau, so it stands firm on the battlefield terrain.

## The board

Cells slide together edge-to-edge on the pins — no glue. Styled as a smooth
"battlefield": each cell's top is a heightfield of blended sine ripples with a
big flat **round central plateau** (18 mm dia) for a piece's base, terrain
swelling toward the rounded corners. `design` (0–7) picks one of eight
deterministic layouts, so a board mixed from all eight reads as varied ground.
The pins hold a deliberate 2 mm gap between neighbours so height mismatches
read as natural seams rather than a step.

`connector.scad` defines the mating dimensions (groove size, clearance, cell
gap, pin size) that both `cell.scad` and `pin.scad` `include`, so the groove
and the pin that fits it can never drift apart. Tune the fit (`connector_gap`)
or the seam (`cell_gap`) there once and re-export both parts.

### Printing

Both parts print **flat on the bed, support-free**. The cell terrain is a
heightfield (no overhangs); the grooves are shallow pockets that bridge
cleanly. Cell: 0.2 mm layers, ~15–20 % infill, terrain up — print 32 in a
light filament and 32 in a dark one. Pin: 0.15–0.2 mm layers for a predictable
friction fit on such a small part. Raise `connector_gap` if the pins are too
tight, lower it if they don't hold.

### Export

Run from the repo root; meshes land in `exports/`:

```sh
# one cell of each battlefield design
for d in 0 1 2 3 4 5 6 7; do
  openscad -D design=$d -o projects/chess/exports/board-cell-d$d.stl \
    projects/chess/models/board/cell.scad
done
# the connector pin
openscad -o projects/chess/exports/board-pin.stl projects/chess/models/board/pin.scad
```

## License

This project is licensed [CC BY-NC 4.0](LICENSE) (Creative Commons
Attribution-NonCommercial 4.0 International): share and remix with credit, but
not for commercial purposes.
