# CLAUDE.md — bracelet

Project-specific guidance for AI agents. The repo-root `CLAUDE.md` still
applies; the rules here are bracelet-only and win where they add detail.

## The one rule

**Nothing may be cantilevered into air.** Every piece of material must either
stand on the bed, or be a bridge anchored at *both* ends to material that
stands on the bed. Three designs have now been tried here and the two that
broke this rule both failed. Do not relax it.

## One model, one file, 30 shells

`models/bracelet/bracelet.scad` is the whole project. Every dimension is at the
top of it; there is no `lib/`.

The export must be **30 shells** at the default size: `cols*rows` tiles (32),
less the four end tiles that the two clasp yokes fuse into two pieces.

**`Genus: 64` is the invariant to read.** OpenSCAD reports `1 - p + sum(genus)`:

| contribution | count |
|---|---|
| pieces `p` | 30 |
| blade bores (`col > 0` and `row > 0`) | 46 |
| fork loops — body → lug → pin → lug → body encloses a hole | 46 |
| keyhole plate (entry + slot + seat + both relief slots, all merged) | 1 |

`1 - 30 + (46 + 46 + 1) = 64`. Note the last row: **the relief slots run into
the entry hole**, so the keyhole is one hole, not three. If you ever get 66,
the reliefs have stopped reaching the entry hole and the detent leaves have
silently become rigid ribs — see below.

`check_connectivity.py` reporting "30 disconnected pieces ... will NOT print as
one solid object" is the **expected, correct** result. This is a print-in-place
textile; the pieces are the tiles.

## Why the joint is a hinge

Two earlier joints failed:

**A cable chain**, tipped 45° so both link families reached the plate. Tipped,
its arcs ran tangent to the bed; the outline leapt ~1.4 mm sideways in one
0.2 mm layer and links tore off the plate on a real printer. Twice.

**A head-in-pocket tile fabric.** A stem left tile A and ended in a free head
floating 0.4 mm over tile B's pocket floor — a ~5 mm **cantilever** laid into
air, which would have drooped onto the floor and welded the fabric solid.

`check_overhangs.py` passed that second design with 92 `BRIDGE` regions and
"nothing here needs support". **A `BRIDGE` verdict is only worth what its
anchors are worth**: the script measures the span between the features on
either side without asking whether they are *bonded* to the region, and one
anchor was a loose head. The current hinge exists precisely so that both
anchors are real.

## What to verify, and how

### 1. The anchors are real — probe, don't trust the verdict

Ray-probe the exported mesh. These are the readings that mean the rule holds:

| probe | must read |
|---|---|
| along the pin at z = 0.10 | `lug 1.500 \| air 0.500 \| blade 2.000 \| air 0.500 \| lug 1.500` |
| along the pin at its axis (z = 2.0) | one unbroken `SOLID 6.000` |
| vertical through the pin's free span | `0.700 \| air 0.400–0.500 \| 1.792 \| air 0.308 \| 0.896` |
| vertical through a lug | `SOLID 4.196` |

The first says the pin's anchors are feet on the plate; the second says the pin
is continuous between them. Together they are the proof that nothing is
cantilevered. **Any change that breaks either reading is a regression.**

Two ways a probe lies, both hit here:

- **A ray that starts inside material inverts every solid/air run** in an
  even-odd walk, and the inverted result looks perfectly plausible. Start
  outside the part, and keep a control whose answer you know (a vertical
  through a tile centre must read exactly `thick` = 4.200).
- **A bore is not empty** — it contains the neighbour's pin. A probe fired from
  the bore centre measures the pin, not the wall.

### 2. Curved undersides — BOTH automated checks are blind to them

The knuckle cap used to be a plain disc cut flat at z = 0. It left the bed at
**65° from vertical** and drooped on a real slicer preview. The user spotted it
by eye. Neither check said a word, and the reasons are worth knowing because
they generalise:

- **The step raster passed it.** Its first-layer step was 0.348 mm, under a
  0.4 mm bead. But that is still 87% of a bead hanging over nothing. *A step
  just under a bead is not the same as a supported step* — read the ANGLE too,
  not only the step.
- **`check_overhangs.py` never reported it, at any threshold.** At 45° it
  returned 92 regions, all BRIDGE, zero RAMP; at `--threshold 30` it still
  returned zero RAMP. A curved underside is triangulated into many small
  facets, and the region grouping appears to discard regions below a minimum
  area, so the whole band vanishes. The flat chord that replaced it shows up
  immediately (136 ramps at the same threshold). **A curved overhang can be
  entirely invisible to that script.**

So: measure downward-facing area directly off the mesh, by angle and by height.
The invariant, in the band where the part leaves the plate (z < 0.69):

| | downward surface | past 45° | steepest |
|---|---|---|---|
| disc cap (old) | 251.2 mm² | 184.4 mm² | 68.9° |
| chord cap (now) | 269.9 mm² | **0.00 mm²** | **32.7°** |

Nothing below z = 0.69 may be past 45°. Separate the faces lying *on* the plate
(`zmax < 1e-6`, 2171 mm² of bed contact) from genuine overhangs first, or the
flat feet swamp the result at 90°.

**Why a chord is free.** The circle is only a *swing envelope* — nothing may
reach further than `rk` from the pin because that is how close the neighbour's
body comes. Only the envelope must be circular; the material inside it need
not be. The chord's endpoints are both exactly `rk` from the pin, so the
envelope is unchanged (verify: still free to ±100°, binds at 110°), and a chord
lies inside its arc, so clearance only improves. Keep the arc ABOVE the pin
axis — there it closes inward as it rises, which is a top surface.

### 3. Layer steps — raster, and sample off the feature planes

Only two layers may reach more than one 0.4 mm bead past the layer below:

| layer | past a bead | what |
|---|---|---|
| z ≈ 1.2 | 102.6 mm² | each pin's first layer, a 3.0 mm bridge |
| z ≈ 3.2 | 9.2 mm² | each bore's roof |

Feature planes are z = 0, 0.7, 1.2, 3.0, 3.2, 3.5, 3.6, 4.2, 5.0. **Slicing
exactly on one** puts triangle vertices in the slicing plane, breaks the
even-odd scanline fill, and invents hundreds of mm² of phantom steps. Offset
the sample by a fraction of a layer. This cost a full debugging round.

Give the raster a positive control (bolt a 1.5 mm ledge onto the mesh; it must
flag). And note that a dilation test counts the *neighbour's* material as
support — it will report the pin as "within 0.9 mm of material below", which is
the blade's bore wall, a different piece. That is not an anchor. Use the probes
in §1 for anchoring; use the raster only for step size.

### 4. Clearance — `intersection()`, with a control that cannot be vetoed

Strip `bracelet();` off the end, `include` the file, and intersect a pair.
**Do not build the control by pushing a parameter negative**: `-D fit=-0.2`
trips an assert, OpenSCAD prints the error and exports *nothing*, and a test
that only checks whether the file exists reads that as "no interference". Both
controls came back clean that way and all of it was meaningless.

Use a **displacement** control instead — no assert can veto it:

```scad
intersection() { tile(5,0); translate([dx,dy,dz]) tile(6,0); }
```

Nominal must be empty; first contact at **dx 0.3 / dy 0.5 / dz 0.4**.

For the swing, rotate about the **pin axis** (the x-joint's pin runs along
*y*, so it is `rotate([0,a,0])` about `(x_pin, ·, pin_z)` — rotating about the
global X axis is a different motion entirely and reports a bogus bind at 10°):

```scad
px = 5*pitch + pitch/2;
intersection() {
  tile(5,0);
  translate([px,0,pin_z]) rotate([0,a,0]) translate([-px,0,-pin_z]) tile(6,0);
}
```

Free to **±100°**, binds at 110° — and that bind is the control proving the
test can detect anything at all. A wrist needs 22.5°.

### 5. Everything else

- `check_bed_stability.py`: **30 islands**, 2243 mm², tiles 60.6–67.3 mm²,
  clasp ends 225.1 / 234.8, adhesion and tipping 0.3. (2188 mm² since the
  chord cap; the foot at z = 0 is unchanged, the checker just samples a little
  above it.)
  If it ever reports **1 island**, the feet have merged — see `axial_fit`.
- `check_overhangs.py`: 92 regions, all `BRIDGE`, no `SUPPORT`. Those 92 are
  the 46 pins and the 46 bore roofs — the count was **identical** before and
  after the knuckle cap was fixed, so do not read it as coverage. Necessary,
  not sufficient; §1 and §2 are what actually settle it.
- Echoed footprint must match the exported bbox exactly.

## Numbers that are not free

- **`axial_fit` = 0.5**, the gap *along* the pin between a lug and the blade.
  This is the single most important clearance in the model: those two parts sit
  side by side and **both stand on the bed**, so their first layers are laid
  0.5 mm apart. At `fit` = 0.3 two 0.4 mm beads spread into each other and weld
  the hinge on layer one. It is asserted at ≥ 0.45. `fit` = 0.3 is only for
  radial clearances, which are well clear of the plate.
- **`knuck_wall` = 0.9** is the deliberate thinnest vertical wall. Raising it
  raises `rk`, which forces `pitch` up through the swing assert. Everything
  else `check_wall_thickness.py` flags under 1.2 mm is either a horizontal
  layer (the 0.7 bore floor) or `leaf_w`, which is a flexure and is *meant* to
  be thin. The three points under 0.6 mm are an edge artifact at the stud
  head's top rim, not a wall.
- **`pin_z` is squeezed from both sides**: the bore needs floor under it
  (`pin_z - bore_r >= 0.6`) and the knuckle must reach the bed with a real foot
  (`knuck_flat >= 1.2`). Assert on the **foot width**, not on `rk > pin_z` — a
  disc that only just dips below z = 0 technically "reaches" the bed while
  standing on a knife edge.
- **`knuck_slope` = 32.7°**, derived from `rk`, `pin_z` and the foot, asserted
  at ≤ 40°. It is the largest sloped surface in the model and there are 92 of
  them.
- **`pin_flat` = 0.2.** A plain cylinder is tangent to the bed, and its outline
  jumps 0.63 mm in the first layer — the failure that killed the chain. Cut
  flat, the first layer is 1.20 mm wide. The bore stays round, so the flat only
  adds clearance.
- **`leaf_free` + the relief reaching the entry hole.** The detent leaves must
  be **cantilevers**. Built in at both ends at this length they need ~50 N,
  which is a jam, not a clasp; as cantilevers, ~6 N. There is an assert, and
  the genus (64, not 66) is the second witness.
- **`tip_wall` = 1.8**, the plate left beyond the keyhole seat. It carries the
  entire clasp load. An earlier version left 0.8 mm there.

## Traps already hit here

- **A brim welds every hinge shut.** The feet are 0.5 mm apart. Never recommend
  one, and never a raft either.
- **The keyhole plate absorbs the sizing remainder, so the loop is exact.** Do
  not "simplify" it to a fixed length.
- **The `-y` blade and `+y` fork are the `-x`/`+x` ones MIRRORED IN `y = x`,
  not rotated.** A rotation sends them to the wrong edge.
- **The lug arm must reach far enough into the tile's rounded corner to fuse.**
  At `h - 0.6` the corner radius had eaten the overlap at the outer end of the
  lug; it is `h - 1.0` now.

## Verifying a change

1. Export; read **genus (64)** and the **shell count (30)**.
2. The four ray probes in §1 — the anchoring proof — with their control.
3. Downward-face angles off the mesh (§2): nothing past 45° below z = 0.69.
4. Raster the layer steps; only the two layers in §3, sampled off the feature
   planes, with a positive control.
5. The displacement and swing `intersection()` tests in §4.
6. `check_bed_stability.py` (30 islands), `check_overhangs.py` (all BRIDGE).
7. Echoed footprint against the exported bbox.
