# CLAUDE.md — bracelet

Project-specific guidance for AI agents. The repo-root `CLAUDE.md` still
applies; the rules here are bracelet-only and win where they add detail.

## The default size is `wrist = 130` — the numbers below are mostly at 180

Since 2026-09-22 the default is the 4-year-old's 130 mm wrist (printed and
confirmed 2026-09-14): **11 bars, 150.5 × 17.6 mm, genus 31, 1807 mm² of first
layer in 11 islands.** It exports byte-for-byte what used to be
`exports/bracelet-bracelet-w130.stl`, and the old default is now
`exports/bracelet-bracelet-w180.stl`.

**Almost every band-level invariant in this file — 15 shells, genus 43, 2396
mm², the downward-face and layer-step totals — was measured at `wrist = 180`
and is still true there.** Reproduce any of them with `-D wrist=180`. Per-joint
readings (probes, swing, displacement, clearances) do not depend on size.

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

## Three models, one library, `cols` shells

`models/bracelet/bracelet.scad` is the bracelet, and every dimension of the band
is at the top of it. `lib/charm-pin.scad` holds the charm mount — the H-pin,
the pocket it snaps into and the holes a charm has for it. `models/charm-h-pin`
is the loose pin and `models/butterfly-charm` the one charm. The lib draws
nothing — variables, functions and modules only — so every model `include`s
it.

**The H-pin is the ONLY mount.** Two came before it — a ball pin fused to the
bar with clip-on socket charms (flower, heart, kitten, puppy, frog), and a loose
double-ended M4 screw through the bar (the star). Both printed and worked. The
user judged the H-pin the best and had the other two removed, charms and all,
on 2026-09-24. Do not bring them back or propose them as options; git history
before that date has them if the user asks.

`charms` in `bracelet.scad` sets how many bars get a pocket. At `charms = 0`
`module bracelet()` writes the band out in full rather than inside the
`difference()` the pockets need — that is what keeps the plain export
byte-for-byte identical.

**Any change to the lib or to `bracelet.scad` has to prove what it did not mean
to change.** These must come back `IDENTICAL` unless the change is meant to
touch them:

```sh
openscad -o /tmp/b.stl models/bracelet/bracelet.scad && cmp /tmp/b.stl exports/bracelet-bracelet.stl
openscad -o /tmp/b180.stl -D wrist=180 models/bracelet/bracelet.scad && cmp /tmp/b180.stl exports/bracelet-bracelet-w180.stl
openscad -o /tmp/c3.stl -D charms=3 models/bracelet/bracelet.scad && cmp /tmp/c3.stl exports/bracelet-bracelet-c3.stl
openscad -o /tmp/p.stl models/charm-h-pin/charm-h-pin.scad && cmp /tmp/p.stl exports/charm-h-pin-charm-h-pin.stl
openscad -o /tmp/f.stl models/butterfly-charm/butterfly-charm.scad && cmp /tmp/f.stl exports/butterfly-charm-butterfly-charm.stl
```

**Everything the lib defines is named `hp_*`.** That is not tidiness: this
file already has a `pin_d`, `pin_r`, `pin_z` and `pin_flat`, and they are the
HINGE pin. A second thing called a pin in the same namespace is how a silent
shadowing bug gets written.

The bracelet export must be **`cols` shells** — 11 at the default size, 15 at
180 — one per bar,
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

`1 - cols + (2*rows*(cols-1) + 1)` = **31** at the default (43 at 180), and it holds at
every `wrist` from 120 to 230 and at `rows = 3` (71). Note the last row: **the
relief slots run into the entry hole**, so the keyhole is one hole, not three.
One extra hole means a relief has stopped reaching the entry hole and the
detent leaves have silently become rigid ribs.

**A pocket adds no hole and no shell**: `charms = 3` reads genus 31 and 11
shells at the default, 43 and 15 at 180.

A connectivity checker reporting "15 disconnected pieces ... will NOT print as
one solid object" is the **expected, correct** result. This is a print-in-place
band; the pieces are the bars.

## Charm stations: what must stay true

- **`charms = 0` must export byte-for-byte the plain band** in
  `exports/bracelet-bracelet.stl`. Cheapest regression test here.
- **Shell count `cols` and the genus are unchanged at any `charms`.**
- **The first layer is unchanged** — 1807 mm² in 11 islands (2396 in 15 at
  180). The pocket keeps `hp_floor` = 0.8 mm of bar under it, so the first
  layer never sees it.
- **The swing test with a butterfly seated**: clear to ±40°, binds at 60°, at
  both 130 and 180 (a wrist needs about 24°).

Charm spacing is checked on the **smallest** gap between stations, not the
average: rounding station indices to whole bars makes the gaps uneven, and the
average passes a pair that lands one bar apart.

**A flat-bottomed charm may not reach past r = 5.8 from its bar's centre.** The
band's top is a plane while it is STILL — `thick` is `pin_z + rk`, so a knuckle
crest reaches exactly a bar's top face. Turn the joint and the knuckle's ARM,
the full-height rectangle behind the cap, tilts its top edge up above that
plane. Swept with a plain disc at `thick` against the real band: clear to
r = 6.0 at 24° and 30°, r = 5.8 at 40°. The butterfly is long across the band,
right over the knuckle clusters, so its bottom stays within |x| ≤ 5.0 and is
relieved beyond (see below).

## The H-pin mount — printed 2026-09-23; spring retuned the same day, unprinted

Asked for on 2026-09-22 ("an H type pin... legs should have small hooks on
their ends... Middle part of the H also should be recessed into the
bracelet"), then revised the same day: **upper half as short as the lower**,
**a less tall charm**, **charms printed bottom down so they can be 3D**. `hp_*`
in the lib, `charms` in `bracelet.scad`, `models/charm-h-pin`, `models/butterfly-charm`.
**Printed and confirmed by the user on 2026-09-23** ("It printed well"), band,
pin and butterfly together. The bar side "sits very well"; the charm side was
"a bit loose". **Retuned the same day, NOT printed yet**: see "The retune"
below. The layout is the user's and is fixed: **the crossbar entirely in the
bar, only the legs' holes in the charm, the upper legs as long as the lower**.
A symmetric H with the crossbar straddling the seat was built and REJECTED by
the user for breaking that. Do not re-propose it. So the crossbar spring, the mixed hook directions,
the 45°/55° catches, the gabled charm holes and the fits (0.15 lateral,
0.15 vertical play) are proven on a plate now. Treat them the same way: do not move them without a reason.

**The decisions that shape it, and none is free to undo:**

1. **The H prints LYING FLAT** — `linear_extrude(hp_t) hp_pin_2d()`. Hooks are
   outline corners; zero overhang.
2. **Both halves are the same length (3.45), so NEITHER leg can be the
   spring.** The legs TURN about the crossbar's middle and the CROSSBAR bends:
   `hp_strain_cb` = turn·depth/length = 2.55 %, set by the bar side (shorter
   lever, `hp_arm_lo` 1.76 vs `hp_arm_up` 2.44). Each hole has room on the side
   a turning leg's END swings to: `hp_room_lo` INSIDE the lower legs (bar),
   `hp_room_up` OUTSIDE the upper legs (charm).
3. **The upper hooks point IN, the lower ones OUT — do not "tidy" them into
   matching.** Turning moves a leg's ends opposite ways. With all hooks out,
   fitting the charm (upper hooks forced one way) drives the lower hooks up
   into their shoulders and JAMS. Mixed, fitting the charm eases the lower hooks
   off their shoulders and they spring back. Insertion order is pin first,
   charm second.
4. **Two catch angles, each forced by its part's print orientation.** Bar
   prints upright → its shoulder is a ceiling → 45°, descending away from the
   slot. The self-locking reverse barb (shoulder rising outward) is
   UNPRINTABLE there — it starts as a free edge over the chamber — and was
   rejected; do not re-propose it. The charm prints BOTTOM DOWN → its shoulder
   is a floor → `hp_catch_up` = 55°, what makes the charm hold. Asserted 45–60:
   past ~60 friction locks it on for good. The pin is held in the bar only
   because the charm stops the legs turning.
5. **The charm's hole ends are ceilings now, so they are GABLED** (45°, ridge
   along u, `hp_apex` 5.20). The chamber's roof follows the hook's lead-in, the
   material growing out from the chamber's inner wall. Its FLOOR is the
   shoulder. Nothing in the hole is a flat ceiling.

**Invariants at `charms = 3`:**

- Default (130): 11 shells, **genus 31**, **1807 mm² in 11 islands** —
  identical to the plain band; 46 BRIDGE regions against the plain band's 40
  (the six pocket shoulders). At 180 the same holds as 15 / 43 / 2396.
- Ray probes at a station (start OUTSIDE the part or the solid/air labels
  invert — an along-band ray from inside a knuckle does exactly that): along
  the band 1.450 wall | 3.100 pocket | 1.450 wall, 0.99 at z = 4.4 (the rim);
  vertical through a leg slot `SOLID 0.800`; through a chamber (`y = cy + 5.5`)
  `0.800 | air 1.485 | 2.165`; between the legs `SOLID 3.450`.
- Pin: 1 shell, 11.1 × 6.9 × 2.8, 22 mm² of bed, **zero** downward faces. The
  wall check flags 0.80 (crossbar) and 1.00 (legs) — meant.
- Butterfly: 1 shell, genus 0, 16.1 × 18.6 × 7.0, 146 mm² in one island.
  `check_overhangs.py` clean. Measured off the mesh (`asin(|nz|)`): the gables
  at 44–45.5° (z 3.6–5.2), wing relief 43.6°, head/ridge/antennae < 40°,
  **nothing past 45.5°**. Thinnest wall 1.19, the roof over each gable's far
  end — why `body_top` carries +0.1.
- `cmp`: the plain band and `-D wrist=180` (== `-w180`): IDENTICAL.

**The retune (2026-09-23, unprinted).** The looseness was the LEVERS, not a
fit. Hook force ∝ `hp_cb_h`³ / lever², and the charm's hooks sat at the leg
tops on 3.21 against the bar's 1.81: 0.32 of the bar's force. Now:

- **The upper hooks sit as LOW as `hp_under` = 1.0 allows** (catch at 1.15,
  tip 1.54). The leg still runs to 3.45, and above the hook is one long lead-in,
  `hp_lead_up` = 19° (gentler than the lower 35°, so the charm goes on more
  easily). Lever 3.21 → 2.44.
- **`hp_cb_h` 0.8 → 0.9.** Against the printed pin: charm ~2.5×, bar
  insertion ~1.5×, strain 2.55 %. Setting 0.8 back restores the bar side
  exactly and leaves the charm at ~1.7×.
- **The charm's lever MUST stay the longer one.** Pulling the charm drives the
  legs the same way that releases the bar's hooks. The longer lever turns
  less for the same travel, so the charm clears first and `hp_keep` = 0.11 mm
  of the bar's hook is still under its shoulder. This is asserted ≥ 0.1. That
  is what bounds how low the upper hooks may go and how far the levers can be
  evened. Equal levers would free both catches at once and let the pin leave
  with the charm.
- The charm's chamber roof still slopes at `hp_lead` 35°, NOT along the new
  hook ramp. Following the 19° ramp pinches the chamber to 0.1 at its inner
  wall. An assert checks that the roof clears the ramp by `hp_gap`.
- Unchanged, and still byte-identical checks: bar pocket shape (only 0.1
  deeper, for the thicker crossbar), 46 overhang regions / 1807 mm² / genus
  31 at 130 and 60 / 2396 / 43 at 180, identical wall-check counts to the
  printed version, the butterfly's single 1.19 roof point.

Two harness rows are added for this: **bar ∩ a single leg turned by the
charm's release angle (−9.41°), lifted 1.2 → solid** (the pin stays), and
turned 1.03 × the bar's own angle (−12.99°), lifted 1.2 / 2.5 → empty. Lift
it well clear. The shoulder is a 45° ceiling, and a hook swung under it sits
under a higher part, so a lift of only `hp_vfit` reads empty whether or not
it would hold.

**The joint harness** (band include made absolute, `bracelet();` stripped;
`charm_on(dz)` = `translate([X, band_cy, thick + dz]) butterfly_charm()` — no
flip, it prints as it sits; `pin_on(dz)` = `charm_h_pin()` at `thick + dz`):

| test | reads |
|---|---|
| bar ∩ pin, seated | 0.0000 mm³ — crossbar ON its slot floor, the stop |
| bar ∩ pin, dz +0.10 / +0.25 (control) / −0.05 (control) | empty / solid / solid |
| bar ∩ pin, dz +0.05, dx 0.12 / 0.20 | empty / solid |
| charm ∩ pin, seated; dz +0.10; dx or dy ±0.12 | empty |
| charm ∩ pin, dz +0.25, dz −0.25, dy 0.20, dx 0.20 (controls) | solid |
| charm ∩ band, seated / dz −0.3 | 0.0000 (bottom on the bar top) / solid |
| swing a neighbour, charm seated, wrist 130 and 180 | clear to ±40°, HIT at 60° |

Test lateral play on the bar side with the pin LIFTED off its stop (dz 0.05),
or the stop's coincident sliver reads as contact at every dx.

**The butterfly's bottom stays within |x| ≤ `x0` = 5.0.** Not the r = 5.8
disc: that disc only reached x = 5.08 at the knuckle clusters' edge, and this
charm is long across the band, right over the clusters. Beyond it the
wings' undersides rise at 43.6° (`relief` = 1.05) — NOT 45 exactly: faces on
the threshold flicker, and `check_overhangs.py` split one clean ramp into a
"ramp" and a phantom "bridge" 2 mm up.

**Traps this round hit:**

- **A closing pass over the WHOLE H fills every catch root** (a concave
  corner) by ~0.03 mm and eats the hooks' clearance. The fillet is clipped to
  the crossbar band; `hp_recess` ≥ `hp_fillet` keeps it under the charm's seat.
- **`scale(r) circle(1)` takes its facet count from r = 1** — 21 sides on a
  4.7 mm wing. The wings set `$fn`.
- **`use <>` carries neither `$fa`/`$fs` nor the file's top-level
  variables.** A harness drew the wings as pentagons, and `height` came
  through `undef`. Put `$fa`/`$fs` in every harness; recompute dimensions from
  lib variables.
- **A spot cutter carried on above a tilted surface keeps widening** and bit
  scoops out of the body beside it. Cone to the surface, then straight up.
- **A gable started 0.01 below the eaves leaves a 0.01 mm ledge** along each
  eave — 0.07 mm² of flat ceiling, found only by the direct angle scan. The
  gable's walls are carried a millimetre down into the hole instead.

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

- Bed stability: **`cols` islands** (15), 2396 mm² of first layer, one
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
  length (17.24 mm fastened, 4.12 mm of travel at every size — see "The
  clasp"), so it no longer absorbs the sizing remainder — the joints do. The
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

## The clasp — reworked 2026-09-22, printed and confirmed 2026-09-23

The user asked for "the buckle as short as possible", "the fastener more
tight" and "the pin of the fastener thicker — to make it less fragile". The
stud-and-keyhole principle is unchanged; its numbers are not. **All of them
went on a plate on 2026-09-23, with the H-pin print, and it printed well** — so
they are proven now, like the rest of the band. What changed, and what each is
pinned by:

- **`post_d` 3.0 → 4.0** (2.4× the bending strength). Everything the post sizes
  is now derived from it: `slot_w` = post + 2·`slot_fit` (0.15, the printed
  play), `head_d` = slot + 2·`head_lip` (1.05, the printed overhang),
  `entry_d` = head + 0.6, `det_gap` = post − 2·`det_pinch` (0.15, printed),
  `kh_w` from the leaf, relief and `rail_w` (1.25, printed).
- **Vertical fit is `head_gap` = 0.15, measured AT THE SLOT EDGE with the post
  centred.** The first clasp set the cylinder top `fit` above the plates, and the
  38.7° cone then only met the slot edge 0.49 mm up. `post_top` (3.16) now ends
  just *below* the stacked plates' top face on purpose. Pulled against the
  seat's far wall, the cone meets the rim at the plate top: the head clamps the
  plates under load.
- **The bumps CRADLE the seated post.** `det_off` (0.70) is solved so that, with
  the post against the far wall, it just touches the bumps. Post centred in the
  seat is 0.047 mm into them — deliberate, the leaves take it.
- **The leaf is 1.0 × 2.8, not 0.8 × 2.5**: same root strain (2.87 % vs the
  printed 2.88 %, asserted ≤ 2.9 % as `leaf_strain`), 1.39× the force
  (∝ w³·pinch/L³). A deeper pinch was the rejected alternative — it overstrains
  the leaf.
- **The buckle is 17.24 mm fastened, from 20.5.** `kh_entry` = `kh_wall` (1.0)
  + entry radius; `kh_travel_min` is solved from the bump/entry clearance;
  `kh_tip` = relief end + `tip_strip` (2.0 of full-width plate carrying the
  load); `stud_ext` = travel + `kh_tip`, which is the **insertion constraint**:
  while the head drops through the entry hole the ends are `travel` closer than
  when fastened, and the keyhole plate's tip must come down beside the stud's
  end bar. The old flat 8.0 overran it by 0.95 mm. It is now exactly 0 nominal
  (asserted), with the entry hole's 0.3 radial play as the working clearance.
  **Travel counts twice** in the fastened length, once per plate — that is why
  shortening it is what shortens the buckle.
- **The relief turns radially into the entry hole's centre.** At the 4 mm post
  its centreline (3.55 off-axis) is outside the 3.5 mm entry radius; run
  straight it only grazes the hole and leaves a 0.02 mm cusp of rail, which
  `check_wall_thickness.py` flags at (−6.2, 9.1). Genus still reads one keyhole
  hole.

**The clasp harness** (include `bracelet.scad` with `bracelet();` stripped and
the include made absolute). Fastened = keyhole side TRANSLATED by
`x_stud - x_lock + dx` and lifted `cl_t + 0.02 + dz`; `dx > 0` moves the post
toward the seat's far wall. Fastening = translated by `x_stud - x_entry + dx`,
keyhole side with `bar(0)`, stud side with `bar(cols-1)`.

| test | reads |
|---|---|
| seated, dx 0.10 | 0.00 mm thick — touching the bumps |
| seated, dx 0.17 / 0.25 (control) | solid — the far wall |
| seated at dx 0.14, lift dz 0.05 | solid — no vertical play under load |
| fastening, dx +0.25, dz 0 … 3.2 | empty at every height |
| fastening, dx −0.25 (control) | solid, 0.25 × 10.4 × 1.6 — the tip against the stud bar |

That last control is also the measurement: the tip reaches the bar face
exactly at dx 0.

## Traps already hit here

- **A brim welds every hinge shut.** The feet are 0.6 mm apart. Never recommend
  one, and never a raft either.
- **The buckle no longer absorbs the sizing remainder — the joints do.** It is
  pinned at `kh_travel_min`, which puts it right on the edge of the trap below,
  so any change to `entry_d`, `det_off` or `det_r` moves that edge and must be
  swept. Do not restore the long plate to "simplify" the solver.
- **The entry hole eats the detent bumps on a short keyhole plate.** Bring the
  entry hole too close to the bumps and it swallows them and they export as two
  loose 1 mm crumbs — a clasp with no detent. The *only* symptom is two extra
  shells, which reads exactly like "a bar came free". This was latent in the
  printed version too (it appears there at `wrist` = 144 and 155). Travel is
  now SOLVED from exactly that distance (`kh_travel_min`, with 0.05 mm over the
  assert's own margin) and an assert measures the centre-to-centre distance. **Sweep `wrist` across its whole range and check
  the shell count after any change to the clasp or to `pitch`** — a shift in
  quantisation is all it takes to land on a bad size.
- **The lug arm must reach far enough into the bar's rounded corner to fuse.**
  At `h - 0.6` the corner radius had eaten the overlap at the outer end of the
  lug; it is `h - 1.0` now.
- **There used to be a `-y` blade and `+y` fork**, mirrored in `y = x`. They
  went with the cross-band hinges. If you ever reinstate them, mirror — do not
  rotate — or they land on the wrong edge.

## Verifying a change

0. If the lib, `bracelet.scad` or a charm model was touched: the `cmp` block
   at the top of this file, then the H-pin joint harness with its controls.
   If the charm stations were touched, re-run steps 1–6 at `charms = 3` —
   every number must be identical to `charms = 0`. If the butterfly or a new
   charm changed: connectivity (1 piece), wall thickness (≥ 1.19 mm, the gable
   roof), bed stability (1 island), the `asin(|nz|)` scan (nothing past 45.5°),
   the swing test with it seated, and a render.
1. Export; read **genus (31; 43 at 180)** and the **shell count (11; 15 at 180)** — and confirm the
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
