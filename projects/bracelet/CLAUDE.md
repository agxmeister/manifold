# CLAUDE.md — bracelet

Project-specific guidance for AI agents. The repo-root `CLAUDE.md` still
applies; the rules here are bracelet-only and win where they add detail.

## The one rule

**Nothing may be cantilevered into air.** Every piece of material must either
stand on the bed, or be a bridge anchored at *both* ends to material that
stands on the bed. Three designs have now been tried here and the two that
broke this rule both failed. Do not relax it.

## The band hinges along ONE axis. Do not put the grid back.

A column is **one bar spanning the whole band**, not a row of tiles. The
cross-band hinges were removed on purpose: with `rows = 2` the only one of them
runs down the middle of the band from end to end, and both clasp yokes are
solid plates spanning the full width, so it is built in at both ends. A hinge
clamped at both ends is a stiff seam. It cost half the joints in the model and
bought nothing.

`rows` still exists and still sets the width — and now also the number of
**knuckle clusters** spaced along each joint, which is what stops a wide bar
twisting about a single pin.

## One model, one file, `cols` shells

`models/bracelet/bracelet.scad` is the whole project. Every dimension is at the
top of it; there is no `lib/`.

The export must be **`cols` shells** — 15 at the default size — one per bar,
with the two clasp plates fused onto the end bars. Anything else means a piece
came free; see the detent trap below.

**Genus is the second invariant**, and it is worth computing rather than
memorising. OpenSCAD reports `1 - p + sum(genus)`:

| contribution | count | at the default |
|---|---|---|
| pieces `p` | `cols` | 15 |
| blade bores | `rows * (cols-1)` | 28 |
| fork loops — body → lug → pin → lug → body encloses a hole | `rows * (cols-1)` | 28 |
| keyhole plate (entry + slot + seat + both relief slots, all merged) | 1 | 1 |

`1 - cols + (2*rows*(cols-1) + 1)` = **43** at the default, and it holds at
every `wrist` from 120 to 230 and at `rows = 3` (71). Note the last row: **the
relief slots run into the entry hole**, so the keyhole is one hole, not three.
One extra hole means a relief has stopped reaching the entry hole and the
detent leaves have silently become rigid ribs.

A connectivity checker reporting "15 disconnected pieces ... will NOT print as
one solid object" is the **expected, correct** result. This is a print-in-place
band; the pieces are the bars.

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
| along the pin at z = 0.10 | `lug 1.400 \| air 0.600 \| blade 2.000 \| air 0.600 \| lug 1.400`, once per cluster, `air 5.600` between clusters |
| along the pin at its axis (z = `pin_z`) | one unbroken `SOLID 6.000` per cluster |
| vertical through the pin's free span (y = 0) | `0.656 \| air 0.644 \| 1.792 \| air 0.453 \| 0.901` |
| vertical through the axial gap (y = 1.35) | `SOLID 1.792` — the pin alone, in mid-air, which is what a bridge looks like |
| vertical through a lug | `SOLID 4.445` |

The first says the pin's anchors are feet on the plate; the second says the pin
is continuous between them. Together they are the proof that nothing is
cantilevered. **Any change that breaks either reading is a regression.**

Two ways a probe lies, both hit here:

- **A ray that starts inside material inverts every solid/air run** in an
  even-odd walk, and the inverted result looks perfectly plausible. Start
  outside the part, and keep a control whose answer you know (a vertical
  through a bar centre must read exactly `thick` = 4.450).
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
| chord cap (now) | 331.6 mm² | **0.00 mm²** | **31.7°** |

Nothing below z = 0.7 may be past 45°. Separate the faces lying *on* the plate
(`zmax < 1e-6`, 2349 mm² of bed contact) from genuine overhangs first, or the
flat feet swamp the result at 90°.

**Why a chord is free.** The circle is only a *swing envelope* — nothing may
reach further than `rk` from the pin because that is how close the neighbour's
body comes. Only the envelope must be circular; the material inside it need
not be. The chord's endpoints are both exactly `rk` from the pin, so the
envelope is unchanged (verify: still free to ±100°, binds at 110° — rotate
about the real pin axis), and a chord
lies inside its arc, so clearance only improves. Keep the arc ABOVE the pin
axis — there it closes inward as it rises, which is a top surface.

### 3. Layer steps — raster, and sample off the feature planes

Only two layers may reach more than one 0.4 mm bead past the layer below:

| layer | past a bead | what |
|---|---|---|
| z ≈ 1.4 | 90.2 mm² | each pin's first layer, a 3.2 mm bridge |
| z ≈ 3.6 | 32.4 mm² | each bore's roof, a 2.9 mm ceiling |

Both grew per feature when the bore was loosened (the old, printed version read
123.3 and 30.8 mm² over twice as many joints) while the total fell from 154 to
115 mm². That is the whole price of the looser hinge, and it is paid in the two
places that were already bridges.

Feature planes are z = 0, 0.655, 1.3, 2.1, 3.55, 3.85, 4.45, 5.0 — `pin_z`,
`pin_z ± pin_r ∓ pin_flat`, `pin_z ± bore_r`, `thick`. **Sampling exactly on
one** puts triangle vertices in the sampling plane and splits or invents steps:
sampled on the grid, the pin bridge reads as two events of 11.6 and 10.1 mm²;
offset by 0.07 mm it reads as the single 87.4 mm² event it really is. Offset
both the xy grid and the z samples. This cost a full debugging round.

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
intersection() { bar(0); translate([dx,dy,dz]) bar(1); }
```

Nominal must be empty; first contact at **dx 0.45** (the bore), **dy 0.6**
(`axial_fit`) and **dz 0.45–0.65** (the bore, plus `pin_flat` downwards).

For the swing, rotate about the **pin axis** (the x-joint's pin runs along
*y*, so it is `rotate([0,a,0])` about `(x_pin, ·, pin_z)` — rotating about the
global X axis is a different motion entirely and reports a bogus bind at 10°):

```scad
intersection() {
  bar(0);
  translate([pitch/2,0,pin_z]) rotate([0,-a,0])
    translate([-pitch/2,0,-pin_z]) bar(1);
}
```

Free to **±100°**, binds at 110° — and that bind is the control proving the
test can detect anything at all. A wrist needs 24°.

### 5. Everything else

- Bed stability: **`cols` islands** (15), 2366 mm² of first layer, one
  full-width bar foot each. If it ever reports **1 island**, the feet have
  merged — see `axial_fit`.
- `check_overhangs.py`: all `BRIDGE`, no `SUPPORT`. The regions are the pins
  and the bore roofs, and the count was **identical** before and after a
  knuckle cap that visibly drooped, so do not read it as coverage. Necessary,
  not sufficient; §1 and §2 are what actually settle it.
- Echoed footprint must match the exported bbox exactly.

## Numbers that are not free

- **`axial_fit` = 0.6**, the gap *along* the pin between a lug and the blade.
  This is the single most important clearance in the model: those two parts sit
  side by side and **both stand on the bed**, so their first layers are laid
  0.6 mm apart. At `fit` = 0.3 two 0.4 mm beads spread into each other and weld
  the hinge on layer one. It is asserted at ≥ 0.45.
- **`bore_fit` = 0.45**, the pin's radial play, and the number that decides
  whether the band drapes. The first version printed at 0.3, worked, and came
  off the plate stiff — the user asked for it looser. It is not free: it raises
  `bore_r`, hence `rk`, hence `pitch_min` (11.0 → 11.3), and it lengthens both
  bridges in §3. `fit` = 0.3 now means only the swing clearance and the clasp
  stack-up.
- **`pitch` is SOLVED, not set.** The buckle is fixed at its shortest working
  length (`kh_lock` = `kh_entry` + `kh_travel_min`, 5.5 mm of travel at every
  size), so it no longer absorbs the sizing remainder — the joints do. The
  solver picks the bar count nearest `pitch_nom` = 11.6 and divides the run by
  it, landing between `pitch_min` = `2*(h + rk + fit)` = 11.30 and
  `pitch_max` = 11.30 + 1.4. Both bounds are asserted, and the lower one IS the
  old swing assert. Across `wrist` 110–230 the solved pitch runs 11.34–12.32;
  at the tight end the hinge still swings clear to 95°, at the loose end
  neighbouring bars still export as an empty `intersection()`. **`row_pitch` is
  separate and fixed** — the band's width must not move when the length solver
  breathes the joints.
- **`knuck_wall` = 0.9** is the deliberate thinnest vertical wall. Raising it
  raises `rk`, which forces `pitch` up through the swing assert. Everything
  else `check_wall_thickness.py` flags under 1.2 mm is either a horizontal
  layer (the 0.7 bore floor) or `leaf_w`, which is a flexure and is *meant* to
  be thin. The three points under 0.6 mm are an edge artifact at the stud
  head's top rim, not a wall.
- **`pin_z` = 2.1 is squeezed from both sides**: the bore needs floor under it
  (`pin_z - bore_r >= 0.6`, and at `bore_fit` = 0.45 only 0.65 is left, so
  loosening the bore further means raising `pin_z` too) and the knuckle must
  reach the bed with a real foot (`knuck_foot >= 0.6`, currently 1.05). Assert
  on the **foot width**, not on `rk > pin_z` — a
  disc that only just dips below z = 0 technically "reaches" the bed while
  standing on a knife edge.
- **`knuck_slope` = 31.7°**, derived from `rk`, `pin_z` and the foot, asserted
  at ≤ 40°. It is the largest sloped surface in the model.
- **`pin_flat` = 0.2.** A plain cylinder is tangent to the bed, and its outline
  jumps 0.63 mm in the first layer — the failure that killed the chain. Cut
  flat, the first layer is 1.20 mm wide. The bore stays round, so the flat only
  adds clearance.
- **`leaf_free` + the relief reaching the entry hole.** The detent leaves must
  be **cantilevers**. Built in at both ends at this length they need ~50 N,
  which is a jam, not a clasp; as cantilevers, ~6 N. There is an assert, and
  the genus (one keyhole hole, not three) is the second witness.
- **`tip_wall` = 1.8**, the plate left beyond the keyhole seat. It carries the
  entire clasp load. An earlier version left 0.8 mm there.

## Traps already hit here

- **A brim welds every hinge shut.** The feet are 0.6 mm apart. Never recommend
  one, and never a raft either.
- **The buckle no longer absorbs the sizing remainder — the joints do.** It is
  pinned at `kh_travel_min`, which puts it right on the edge of the trap below,
  so any change to `entry_d`, `det_off` or `det_r` moves that edge and must be
  swept. Do not restore the long plate to "simplify" the solver.
- **The entry hole eats the detent bumps on a short keyhole plate.** The entry
  is 6 mm across and the bumps sit `det_off` = 1.8 mm from the seat, so below
  about 5.3 mm of post travel the hole swallows them and they export as two
  loose 1 mm crumbs — a clasp with no detent. The *only* symptom is two extra
  shells, which reads exactly like "a bar came free". This was latent in the
  printed version too (it appears there at `wrist` = 144 and 155); the sizing
  solve now reserves `kh_travel_min` = 5.5 mm and an assert measures the
  centre-to-centre distance. **Sweep `wrist` across its whole range and check
  the shell count after any change to the clasp or to `pitch`** — a shift in
  quantisation is all it takes to land on a bad size.
- **The lug arm must reach far enough into the bar's rounded corner to fuse.**
  At `h - 0.6` the corner radius had eaten the overlap at the outer end of the
  lug; it is `h - 1.0` now.
- **There used to be a `-y` blade and `+y` fork**, mirrored in `y = x`. They
  went with the cross-band hinges. If you ever reinstate them, mirror — do not
  rotate — or they land on the wrong edge.

## Verifying a change

1. Export; read **genus (43)** and the **shell count (15)** — and confirm the
   formula still holds at `rows = 3` and across a `wrist` sweep. The sweep also
   checks the pitch solver: every size must echo `loop` = `wrist + ease`
   exactly and a pitch inside its bounds.
2. The four ray probes in §1 — the anchoring proof — with their control.
3. Downward-face angles off the mesh (§2): nothing past 45° below z = 0.7.
4. Raster the layer steps; only the two layers in §3, sampled off the feature
   planes, with a positive control.
5. The displacement and swing `intersection()` tests in §4.
6. Bed stability (`cols` islands), `check_overhangs.py` (all BRIDGE).
7. Echoed footprint against the exported bbox.
