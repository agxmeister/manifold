# CLAUDE.md — bracelet

Project-specific guidance for AI agents. The repo-root `CLAUDE.md` still
applies; the rules here are bracelet-only and win where they add detail.

## The band is 4.2 mm thick since 2026-09-25 — printed and confirmed the same day

The user asked for the accent stripe's three bands to be equal and chose to
thin the band for it. **Printed in one colour at `charms = 3` with a heart on
an H-pin: "Printed well, the pin sits fine."** So the 1.8 pin, `pin_z` 1.95
and the 0.6 pocket floor are proven. The two-colour stripe is still unprinted. `thick` = `pin_z + rk` went 4.45 → **4.2**:
**`pin_d` 2.0 → 1.8** (bore_r 1.35, rk 2.25, pin 0.73× as stiff in bending)
and **`pin_z` 2.1 → 1.95** (the bore floor is now exactly the asserted 0.6).
Every other hinge fit — `bore_fit`, `axial_fit`, `knuck_wall`, `pin_flat`,
`fit` — is the printed value. The clasp (`cl_t` 1.6) does not depend on
`thick` and is untouched. The H-pin pocket's floor went 0.8 → **0.6**, and
`hp_leg_lo` = 3.45 now fixes the lower legs' reach, so **the pin, the pocket's
hooks and every charm export byte-identical** — pins and charms printed for
the 4.45 band fit this one. The stripe is 1.4–2.8: three 1.4 mm bands.

Measured on the 4.2 band. The 4.45 band was re-run in the same harness as a
control and reproduced the old numbers:

- 130: 11 shells, genus 31, **1812.5 mm²** in 11 islands; 180: **16 bars**
  (was 15 — `pitch_min` fell 11.30 → 11.10, so the solver now picks 11.25),
  genus 46, 2471.5 mm². Every wrist 110–230: shells == cols, loop exact.
- Probes (§1): z 0.10 and axis rows unchanged; free span `0.605 | air 0.645 |
  1.590 | air 0.455 | 0.905`; axial gap `SOLID 1.590`; lug `4.199`; bar
  centre control `4.200`.
- §2: below z 0.7, 0.00 mm² past 45°, steepest 30.0°.
- §3 (grid 0.05, z at layer mid + 0.007): only z ≈ 1.3 (58.8 mm², was 57.6
  in this harness) and z ≈ 3.3 (23.0, was 5.2 — the roof's crown now falls
  so the last open layer leaves a ~1.4 mm gap, closed as one bridge). A
  1.5 mm ledge control flags.
- §4: bore contact between dx 0.40 and 0.50, dy 0.55/0.65, dz −0.40
  empty / −0.60 solid, +0.50 empty / +0.70 solid. Swing ±100° clear, 110°
  binds at 130; at the tightest pitch (wrist 145, 11.146) clear to 98°, binds
  by 100°, and dx −0.40 touches the neighbour's body (the 0.3 `fit`).
- H-pin: bar ∩ pin seated 0.0000, +0.10 empty, +0.25 0.3080, −0.05 0.8811,
  dx 0.12 empty / 0.20 0.7316 — all identical to the 4.45 band. Leg release
  −14.25° lift 1.2: 0.0867 (control 1.2577); −18.18° empty at every lift
  0–3.0. Pocket floor probe 0.600.
- Charms seated, neighbours swung: butterfly, heart, ladybug wearing-clear to
  70°. An exact 60° reads a 0.0000 coincidence for heart and ladybug (59.5 /
  60.5 / 62 empty) — do not read that as a bind. Backwards: as before.
- `check_overhangs`: 40 BRIDGE, no SUPPORT. Wall check: the same keyhole and
  stud-rim artefacts as the 4.45 band.

## The default size is `wrist = 130` — the numbers below are mostly at 180

Since 2026-09-22 the default is the 4-year-old's 130 mm wrist (printed and
confirmed 2026-09-14): **11 bars, 150.5 × 17.6 mm, genus 31, 1807 mm² of first
layer in 11 islands** (1812.5 on the 4.2 band). It exports byte-for-byte what used to be
`exports/bracelet-bracelet-w130.stl`, and the old default is now
`exports/bracelet-bracelet-w180.stl`.

**Almost every band-level invariant in this file — 15 shells, genus 43, 2396
mm², the downward-face and layer-step totals — was measured at `wrist = 180`
on the 4.45 mm band.** The 4.2 band's numbers are in the section above. Reproduce any of them with `-D wrist=180`. Per-joint
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

## Five models, one library, `cols` shells

`models/bracelet/bracelet.scad` is the bracelet, and every dimension of the band
is at the top of it. `lib/charm-pin.scad` holds the charm mount — the H-pin,
the pocket it snaps into and the holes a charm has for it. `models/pin`
is the loose pin, and `models/butterfly-charm`, `models/ladybug-charm` and
`models/heart-charm` are the three charms. The lib draws
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
openscad -o /tmp/p.stl models/pin/pin.scad && cmp /tmp/p.stl exports/pin-pin.stl
openscad -o /tmp/f.stl models/butterfly-charm/butterfly-charm.scad && cmp /tmp/f.stl exports/butterfly-charm-butterfly-charm.stl
openscad -o /tmp/l.stl models/ladybug-charm/ladybug-charm.scad && cmp /tmp/l.stl exports/ladybug-charm-ladybug-charm.stl
openscad -o /tmp/h.stl models/heart-charm/heart-charm.scad && cmp /tmp/h.stl exports/heart-charm-heart-charm.stl
```

**The ladybug's export is NOT byte-stable** (found 2026-09-25). Two fresh
exports of the same unchanged file differ, with the same volume and bbox: the
triangle order changes run to run. Compare its VOLUME and bbox instead,
1077.6452 mm³. Everything else above is byte-stable, and a `cmp` difference
there is a real change. That includes the heart, which is one polyhedron. Its
first, hull-built version was not stable.

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

## The two-colour stripe (`accent`) — added 2026-09-24, unprinted

`accent = true` splits the finished bracelet at `accent_lo` = 1.4 and
`accent_hi` = 2.8 into two top-level `color()`ed objects:
`difference()` and `intersection()` with `accent_region()` — a slab minus
the clasp plates. At `accent = false` the file
still ends in a bare `bracelet();`, which is what keeps every `cmp` above
IDENTICAL. The user asked for "the middle part (vertically) in another color",
for a multi-material printer.

- **Export needs `--enable=lazy-union`.** Without it OpenSCAD unions the two
  objects, and even the 3MF comes out as ONE mesh with per-triangle materials,
  which slicers handle inconsistently. With it, the 3MF holds two `<object>`s,
  one base material each.
- **That raw 3MF is NOT the deliverable. Always run it through
  `tools/multicolor-3mf.py`.** Creality Print, the user's slicer (an
  Orca/Bambu fork), loaded the raw file as **two separate models, both in
  one filament**: it ignores 3MF colours, and every build item becomes its
  own model. The tool writes a single build item whose `<components>` are the
  meshes, plus `Metadata/model_settings.config` with a `<part id=…>`
  carrying `extruder` for each one. This was verified against Creality
  Print's `src/libslic3r/Format/bbs_3mf.cpp`:
  - config is read for any Application tag;
  - `part id` = the component's object id;
  - part metadata goes into the volume config;
  - with no project settings the filament cap is INT_MAX, so extruder 2
    survives.

  The user has not yet confirmed that it loads correctly.
- **Invariants.** The two volumes sum to the plain band's STL volume (to
  ~1e-3 mm³). Base: `2*cols + 1` shells (bottom and top of each bar, plus the
  stud head), so 23 at 130 and 33 at 180 (16 bars). Stripe:
  `cols + 1 + rows*(cols-1)` shells, so 32 at 130 and 47 at 180. Smallest
  shell 2.47 mm³ — anything near zero is a coincident-face sheet. The extra `rows*(cols-1)` are each
  blade's far bore wall, cut loose inside the slab because the bore
  (0.6–3.3) spans it completely. They are not free pieces: each one sits on
  base material and has base material on top of it. Stripe z range 1.4..2.8
  exactly. `charms = 3` gives the same shell counts.
- **Three equal 1.4 mm bands.** History: 1.8 / 1.4 / 1.25 at first; the
  user saw the top was thinner; 1.6 / 1.4 / 1.45 was the best a 4.45 band
  allowed; the user then chose to thin the band to 4.2 (section at the top).
- **The stripe starts INSIDE the clasp plates (`cl_t` = 1.6), so
  `accent_region` cuts the plates out of it**, except where a yoke bites into
  its end bar (the bar keeps its stripe; a 0.2 mm white corner shows where
  the square yoke meets the bar's rounded corner). The cut-out is the plates'
  outline GROWN 0.05 sideways and 0.01 up. Cut to the exact outline, every
  plate wall and the keyhole plate's top face left a ZERO-VOLUME sheet in the
  stripe: 47 shells instead of 32 at 130, `NoError`, invisible in renders.
  Keep both planes on 0.2 layer boundaries and off the feature planes in §3.
- **PNG previews need `--render`.** The default OpenCSG preview draws the
  whole bar in the accent colour.
- Not printed. No slicer is installed on this machine to check it with.

## Charm stations: what must stay true

- **`charms = 0` must export byte-for-byte the plain band** in
  `exports/bracelet-bracelet.stl`. Cheapest regression test here.
- **Shell count `cols` and the genus are unchanged at any `charms`.**
- **The first layer is unchanged** — 1812.5 mm² in 11 islands (2471.5 in 16
  at 180). The pocket keeps `hp_floor` = 0.6 mm of bar under it, so the first
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

## The H-pin mount — printed 2026-09-23; retuned, printed, still loose; bigger hooks printed and confirmed 2026-09-25

Asked for on 2026-09-22 ("an H type pin... legs should have small hooks on
their ends... Middle part of the H also should be recessed into the
bracelet"), then revised the same day: **upper half as short as the lower**,
**a less tall charm**, **charms printed bottom down so they can be 3D**. `hp_*`
in the lib, `charms` in `bracelet.scad`, `models/pin`, `models/butterfly-charm`.
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
   `hp_strain_cb` = turn·depth/length = 2.85 %, set by the bar side (shorter
   lever, `hp_arm_lo` 1.79 vs `hp_arm_up` 2.41). Each hole has room on the side
   a turning leg's END swings to: `hp_room_lo` INSIDE the lower legs (bar),
   `hp_room_up` OUTSIDE the upper legs (charm).
3. **The upper hooks point IN, the lower ones OUT — do not "tidy" them into
   matching.** Turning moves a leg's ends opposite ways. With all hooks out,
   fitting the charm (upper hooks forced one way) drives the lower hooks up
   into their shoulders and JAMS. Mixed, fitting the charm eases the lower hooks
   off their shoulders and they spring back. Insertion order is pin first,
   charm second.
4. **The catches, each shaped by its part's print orientation.** Bar
   prints upright → its shoulder is a ceiling, descending away from the
   slot: 45° until 2026-09-25, now `hp_catch_lo` = 60° (see "A firmer bar
   catch" below). The self-locking reverse barb (shoulder rising outward) is
   UNPRINTABLE there — it starts as a free edge over the chamber — and was
   rejected; do not re-propose it. The charm prints BOTTOM DOWN → its shoulder
   is a floor → `hp_catch_up` = 60° (55 until 2026-09-25), what makes the charm hold. Asserted 45–60:
   past ~60 friction locks it on for good. **The charm does NOT stop the
   legs turning** — this file used to say it did. The turn that frees the
   charm's hooks is the same turn that frees the bar's; only `hp_keep` stands
   between them.
5. **The charm's hole ends are ceilings now, so they are GABLED** (45°, ridge
   along u, `hp_apex` 5.20). The chamber's roof follows the hook's lead-in, the
   material growing out from the chamber's inner wall. Its FLOOR is the
   shoulder. Nothing in the hole is a flat ceiling.

**Invariants at `charms = 3`:**

- Default (130): 11 shells, **genus 31**, **1807 mm² in 11 islands** —
  identical to the plain band; 40 BRIDGE regions, the same as the plain band.
  (It read 46 until 2026-09-25. The six pocket shoulders flickered just past
  the 45° threshold and now land on it. The `asin(|nz|)` area past 45.5° is
  183.73 mm² both before and after, so nothing real changed.) At 180 the same holds as 15 / 43 / 2396.
- Ray probes at a station (start OUTSIDE the part or the solid/air labels
  invert — an along-band ray from inside a knuckle does exactly that): along
  the band 1.450 wall | 3.100 pocket | 1.450 wall, 0.99 at z = 4.4 (the rim);
  vertical through a leg slot `SOLID 0.800`; through a chamber (`y = cy + 5.5`)
  `0.800 | air 1.485 | 2.165`; between the legs `SOLID 3.450`. (Measured before the 2026-09-25 bigger hooks. The chamber
  profile has changed, so re-measure before comparing.)
- Pin: 1 shell, 11.6 × 6.9 × 2.8, 22.6 mm² of bed, **zero** downward faces. The
  wall check flags 0.76 (crossbar) and 1.00 (legs) — meant. The tapered leg
  tips (0.54) are too small for it to sample.
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
it well clear. The shoulder is a ceiling (45° then, 60° now), and a hook swung under it sits
under a higher part, so a lift of only `hp_vfit` reads empty whether or not
it would hold.

**Bigger hooks (2026-09-25) — PRINTED AND CONFIRMED the same day** with the heart: "it sits very well now". The retuned pin DID print, with the
heart, and the user reported the heart "comes off with a light pull" (a
straight pull, not prying and not wobble). On paper the retune held at ~2.5×
and ~60 N. So the spring was never what gave way. The catch was: 0.40 mm of
overlap is one bead, and the printer rounds it off. **Do not tune this mount
on spring force alone. The rigid model cannot see rounding.** Now:

- `hp_hook` split into **`hp_hook_up` 0.75** (0.60 past the wall) and
  **`hp_hook_lo` 0.70** (0.55), asserted ≥ 0.5 of overlap each. `hp_catch_up`
  55 → **60**, the top of its asserted band.
- **The upper hooks cannot grow alone.** Their bigger release turn frees the
  bar hooks too: 0.75 up with 0.55 down gives `hp_keep` −0.04, and the pin
  leaves with the charm. At equal footprint, the rigid model even prefers
  the OLD hook size. Bigger hooks only pay because of rounding.
- Bigger bar hooks mean a bigger insertion turn, so `hp_lead` 35 → **40** (to
  keep the lower catch under the crossbar), **`hp_cb_h` 0.9 → 0.76** and
  **`hp_s` 4.5 → 4.6** (strain 2.85 %). The charm chamber's roof keeps its
  35° as the new `hp_roof_lead`, so it did not move with `hp_lead`.
- **`hp_taper`: the upper legs' outer face leans in above the hook by exactly
  the turn** (0.46, tip 0.54 wide). `hp_room_up` is now measured at the hook
  tip, not the leg top. `hp_c_out` 5.79 → **5.76**. The charms' holes did NOT
  grow, so every charm model and its asserts stand unchanged.
- Old bands, pins and charms do not mix with new ones (bar chamber `hp_out`
  5.70 → 5.95, charm chamber `hp_c_in` 3.30 → 3.20). Reprint all three.
- The user proposed legs that splay outward. It was explained and not built.
  With rigid legs turning about the crossbar, splayed legs in matching holes
  would drive the lower hooks into their shoulders on removal. The charm
  would be permanent. The user chose "removable, just firmer".

Harness rows for this, heart and butterfly identical:

| test | reads |
|---|---|
| bar ∩ single leg turned −14.25° (charm release), lift 1.2 | 0.0869 — SOLID, the pin stays |
| same, unturned (control) | 1.2577 |
| leg turned −18.18° (1.03 × bar turn), lift 1.2 / 2.5 | empty / empty |
| same turn, lift 0 → 3.0 (bar insertion sweep) | empty at every step |
| charm ∩ leg turned −14.66° (1.03 × charm turn), pin 0 → 3.0 below seat | empty at every step |
| charm ∩ leg turned 1.6 × charm turn, seated (control, the room is real) | 1.9498 |
| charm ∩ leg unturned, 1.0 below seat (control, the hook must turn) | 1.2692 |
| charm ∩ pin, dz +0.25 (control) | 0.0015 — the tapered tip meets the gable |
| heart envelope, every 30° −150..180 | empty; controls dy +1.0 at 0° and −1.0 at 180° leak 0.418 (0.512 before) |

**The heart envelope control's sign:** the notch is at +y (`notch at 8.03`),
so the leaking shift at 0° is dy **+1.0**, not −1.0. A −1.0 shift reads empty
and proves nothing.

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

**A firmer bar catch (2026-09-25, later the same day) — NOT printed yet.**
The user: the pin "sits well in the charm, but in the bracelet it still sits
a bit loosely — small effort to detach it". The cause was a false claim in
this file: that a seated charm holds the legs still. Upper hooks point IN and
release by the upper ends swinging OUT; lower hooks point OUT and release by
the lower ends swinging IN. About the crossbar's middle **that is ONE
rotation**. A pull on the charm cams both catches the same way, and with
friction (µ ≈ 0.4) the bar's 45° catch was doing about two thirds of that
camming (cot-with-friction 0.43 × lever 1.79, against the charm's 60°:
0.14 × 2.41). The release order is purely geometric: the charm lets go
first, with `hp_keep` 0.106 mm of bar hook still under its shoulder. On a
real print, the ceiling's sag and rounding can eat that.

- **`hp_catch_lo` = 60** (new; asserted 45–60), the charm's proven angle.
  The shoulder `hp_b_sh(u)` is the hook's catch face lifted `hp_vfit`, so
  `hp_catch_lo = 45` reproduces the old pin, c3 band and plain band byte for
  byte (checked). As a ceiling it is 0.8 × 3.1 mm, anchored on the slot's two
  walls along the band: `check_overhangs` gives 46 BRIDGE (40 + the six
  shoulders, each "3.1 × 0.9, worst 60°"), no SUPPORT. At a 0.2 mm layer each
  step is 0.35, under a bead, for about 2 layers.
- Friction estimate only (the rigid model has already been wrong once here):
  bare pin ~3× firmer, charm-on pull ~1.8× firmer. **The charm itself comes
  off ~1.8× harder too**, because the bar's cam was helping turn the legs.
  If the charm gets too firm, lower `hp_catch_up` to 55 before touching the
  bar.
- **`hp_keep` is unchanged at 0.106 and cannot grow cheaply.** It is capped at
  `arm_lo·(turn_lo,max − turn_up)`, and `turn_lo,max` is set by the 2.9 %
  crossbar strain. More keep means a longer crossbar (wider pin: every charm's
  holes move) or higher upper hooks (a weaker charm). If the pin still
  follows the charm out of the bar, this is the next step, and it costs charm
  reprints.
- Bare-pin removal: spread the upper legs apart (upper ends out → lower ends
  in). No pull needed.
- Untouched: the charms (heart, butterfly byte-identical), `hp_keep`, the
  strain, the levers, the plain band and `-w180`.
- **A new pin fits an old band** (lifted 0.05 off the stop: empty), with only
  the old 45° grip. **An old pin does NOT fit a new band** (0.116 mm³). Reprint
  the pin with the band.

Harness (`bar(c)` minus `charm_h_station(c)` — `bar()` alone has NO pocket,
and a harness without the station reads ~40 mm³ everywhere, controls
included). At 45 it reproduces every earlier row exactly. At 60:

| test | reads |
|---|---|
| bar ∩ pin seated / dz +0.10 / +0.25 / −0.05 | 0.0000 / empty / 0.3080 / 0.8811 |
| dz 0.05, dx 0.12 / 0.20 | empty / 0.7212 |
| leg turned −14.25° (charm release), lift 1.2 | 0.0778 — the pin stays |
| same unturned (control) | 1.1719 |
| leg −18.18°, lift 0 → 3.0 step 0.3 | empty at every step |
| leg unturned, lift 0.10 / 0.14 / 0.20 | empty / empty / 0.0770 (the 0.15 `hp_vfit`) |

**Longer bar hooks (2026-09-26) — PRINTED AND CONFIRMED the same day** ("It is much better now"). The 60° catch printed
and changed nothing the user could feel: the pin still left the bar with a
light pull, both bare and under a charm. A spring-finger redesign (a separate
flexure for the charm, so the legs could be locked by the charm's holes) was
proposed and declined: "Just make the hooks longer - it should be enough."
Done:

- **`hp_hook_lo` 0.70 → 0.85** (0.70 past the wall), **`hp_lead` 40 → 44**
  (a shorter lead-in, so a longer lever and a smaller turn). `hp_keep`
  **0.106 → 0.267**. Pin 11.9 wide, pocket 12.2 (`hp_out` 6.10, 2.7 mm of
  bar beyond it).
- **The strain assert is split.** `hp_strain_up` (2.30 %, every charm on and
  off) stays ≤ 2.9. `hp_strain_cb` (the max, set by the one-off push into the
  bar) is now **3.73 %**, asserted ≤ 3.8. This deliberately breaks the
  project's 2.9 % rule for a single bend per pin. If a crossbar cracks going
  in, 0.80 gives 3.36 % and keep 0.20.
- Charms are byte-identical (heart, butterfly checked); the plain band too.
  At 130: 11 shells, genus 31, 1812.5 mm², 46 BRIDGE, no SUPPORT; genus 25 /
  37 / 46 / 58 at 110 / 150 / 180 / 230. Pin: 1 shell, wall flags the same
  as before (0.76 crossbar, 1.00 legs), no overhangs.
- New pin in an old band: SOLID (does not fit). Old pin in the new band: fits
  (loose, as before). Reprint pin and band.

| test (at 60° catch, 0.85 hook) | reads |
|---|---|
| bar ∩ pin seated / dz +0.10 / +0.25 / −0.05 | 0.0000 / empty / 0.3920 / 0.8079 |
| dz 0.05, dx 0.12 / 0.20 | empty / 0.7407 |
| leg −14.25° (charm release), lift 1.2 / 2.5 | 0.3144 / 0.1715 — the pin stays |
| leg unturned, lift 1.2 (control) | 1.5697 |
| leg −20°, lift 1.2 (under the insertion turn — control) | 0.0309 |
| leg −23.73° (1.03 × insertion turn), lift 0.15 → 3.3 | empty at every step |
| same, lift 0 / 0.05 / 0.10 | 0.0372 / 0.0116 / 0.0000 — see below |
| leg unturned, lift 0.10 / 0.14 / 0.20 | empty / empty / 0.0980 |

The fully turned leg's outer lower corner drops ~0.2 onto the pocket floor
(0.15 below the leg) within 0.1 mm of seating. That state does not happen:
there the hooks are already under their shoulders, and a 12° turn clears
them at lift 0.15. The turn peaks near lift 0.9, where 23° clears. (The
old pin's row was on the same edge: a 0.16 drop against 0.15.)

## The ladybug charm — added 2026-09-25, unprinted

Asked for as "a ladybug charm. Use two colors - one for body and another one
for dots", with a plush ladybug as the reference: heart-shaped spots, a black
head with eyes, antennae with red tips, stubby legs. Same H-pin holes as the
butterfly (`charm_h_holes`), same print pose (seat down). **The lib and the
band were not touched.** Every `cmp` above stayed IDENTICAL.

- **It lies ACROSS the band, head at +y.** The two holes need ~16 mm across
  the band. The legs set its 20.6 mm span along it. That is past
  `charm_reach` = 16: on 2026-09-25 the user lifted any size limit on charms
  ("they can span outside the bracelet size"). `bracelet.scad` was NOT
  changed, and its spacing assert still reads 16. At `charms = 3` the
  closest stations are 23.75 apart, so two ladybugs still clear each other.
  The middle pair is longer (5.8 against 5.0) because the shell hides more
  of it. The user found the equal-length version's middle legs "too
  short". 5.8 shows 4.0 mm, the same as the others.
- **Shell: a superellipsoid dome**, `sh_p` = 3.3. An ellipsoid comes down too
  fast near its ends to roof the gables. The binding numbers are
  `shell_z(0, hp_c_out)` ≥ `hp_apex + hp_wall + 0.2` (6.86 against 6.6),
  asserted, and the wall check's minimum, now **1.20**. At `sh_p` = 3.0 it
  read 1.13 at (0.09, 6.65, 5.86), over a gable's far end.
- **Legs lie FLAT ON THE BED**, at the user's request (2026-09-25). They
  were first built lying on the 43.6° relief, rising up and out. Each is
  the hull of two `dome()`s, a stadium in plan with a rounded top, 2.0 wide
  and 1.6 tall. **This deliberately breaks the flat-bottom-within-`x0`
  rule**, and the cost is measured below. Only the shell is intersected
  with `keep()`. Put the legs back inside it and it trims them away.
- **Colour is a region cut from the finished solid** (`accent_region`), not
  separately built parts. Its surfaces are GROWN by 0.2 (`head(0.2)`,
  `legs(0.2)`, `shell(0.2)`...) so they never coincide with the solid's.
  Coincident faces rendered as ragged hearts and red streaks down the legs.
  The shell it cuts the head/legs back to is shrunk by `cg` = 0.05, **and
  carried 1 mm under the bed**. Without that, its floor lay on the solid's
  and the black part carried **133 zero-volume sheets** at z = 0. Those are
  invisible in renders; only a per-shell volume count found them.

**Invariants:**

- Single colour (`accent = false`): 1 shell, genus 0, 20.6 × 18.3 × 7.8,
  196.9 mm² in 1 island. Wall ≥ 1.20 (1.28 now).
  Flat legs made the 1.20 point over the gables no longer the thinnest. `check_overhangs`
  clean. `asin(|nz|)` scan: **0.000 mm² past 45°**. A 1 mm² ceiling bolted on
  as a control reads 1.000. The only 90° faces are zero-area eave slivers,
  the same as on the butterfly.
- Two colour: red **5 shells** (body, 2 eyes, 2 antenna tips).
  Black **14 shells** (head + antennae, seam, 6 hearts, 6 legs).
  The two sum to the whole within 0.0002 mm³. Any shell under 0.01 mm³ is a
  regression.
- Pin harness: identical to the butterfly's rows (seated / dz +0.10 / dx, dy
  ±0.12 empty; dz ±0.25, dx, dy 0.20 solid; charm ∩ band 0.0000 seated,
  19.2 mm³ at dz −0.3).
- Swing, wrist 130 and 180. In the harness, `test="swing"` is the WEARING
  direction (neighbours drop, the top face goes convex) and `"swing2"` is
  BACKWARDS.
  - Wearing: clear to 60°.
  - Backwards: **HIT from 0.5°**, 0.12 mm³ spread over x −6.7..+8.8 of the
    bar centre and the full band width. The flat legs rest on both
    neighbours, and the two joints beside the charm cannot bend back at all.
  - Control: the butterfly, clear both ways to 40° and HIT backwards at 50°.
  - The user was told and asked whether that is acceptable.
  - The earlier sloped-leg version matched the butterfly exactly.

**Harness trap:** do NOT `include` the butterfly and the ladybug in one
harness file. Both define `span`, `x0`, `relief`... and the second silently
overwrites the first with `undef`s. Every swing then read "clear", including
the butterfly's known bind. One harness per charm.

Colour cost: both colours share every layer (legs and head start on the bed),
so it is a filament change per layer, ~39 of them. The user was told this.
Not printed. Not loaded in a slicer.

## The heart charm — added 2026-09-25, printed and confirmed the same day

**Printed and confirmed by the user on 2026-09-25** ("Printed good"), the
smooth 23 × 19 version. Treat its shape and numbers as proven.

Asked for as "a heart charm. It should be 3D, look artistic, and I would like
to have configurable rotation angle - so we can export different options,
rotated differently." Same H-pin holes (`charm_h_holes`), same pose (seat
down). **The lib and the band were not touched.** The band, `-c3`, pin and
butterfly `cmp`s stayed IDENTICAL, and the ladybug's volume is unchanged
(its bytes never were stable, see above).

- **`angle` turns the HEART, never the holes.** `rotate(angle)` wraps only
  the heart. `charm_h_holes()` is subtracted after, in the band frame, because
  the pin always runs across the band. Rotating the finished charm (or
  rotating it in a slicer) would turn the holes with it and it would not go
  on. Exports: `-a45`, `-a90`, `-a270`, `-a315`, plus 0 without a suffix.
- **Size is set by ALL angles at once.** The holes plus a 1.2 wall reach 6.99
  along their axis and 7.51 at the lozenge's corners, roofed at `hp_apex +
  hp_wall` over the middle 11.6. The heart must hold that wherever it is
  turned. The binding direction is the NOTCH: the lozenge points into it at 0
  and 180.
- **The envelope test is the proof, not the wall check.** `minkowski()`
  `charm_h_holes()` with a sphere of `hp_wall − 0.05`, clip to z > 0, and
  subtract the rotated `heart() − shine()`. It must be EMPTY at every 10°
  over −150..180. Displacement controls must leak: dy +1.0 at 0° (toward the notch — see "Bigger hooks"; −1.0 reads empty), and dy
  −1.0 at 180° (+1.0 at 30° also read empty on 2026-09-25). Shifts of 0.6 stay clean, so that is the margin. **Do not
  build the control from a smaller parameter.** An assert (notch,
  star-shape) vetoes it, OpenSCAD exports nothing, and "empty" reads as a
  pass. `check_wall_thickness.py` only samples: it reads 1.51+ here and
  misses the ~1.2 gable roofs that the envelope test pins down.
- **Shape: ONE inflated surface, a polyhedron.** The outline is the classic
  heart curve with `side_q` = 1.6 (x = sin^q: full sides), `round_e` (a
  rounded point and notch bottom) and `notch_up` = 5 × cos(t)^6 lifting the
  top (1.5 mm notch). Each ring is the outline scaled by `prof_s(phi)` about
  the origin, at `prof_z(phi)`, with a superellipse profile `prof_p` = 4.
  The outline being star-shaped about the origin is ASSERTED, and it makes
  the surface a height field, so it has no downward face. The rejected
  versions:
  - **Hull of domes** (lobe, belly, tip; the first version shown). The user
    rejected it: "should be wider, and without corners on the sides - it
    should be smooth". A hull is ruled between its domes and leaves an edge
    wherever one dome takes over from another.
  - **`notch_up` as a narrow Gaussian** at the notch. It raised a bump in the
    middle of the top edge, three humps instead of two lobes. The cos^6 lift
    is as broad as the lobes.
  - An inflated surface falls away from the middle, so it needs the width.
    Tuned in python across angles: at 19–21 mm wide it could not hold the
    holes with any notch left. At 23 × 19, p 4, it has 0.5 mm to spare.
- **The shine is placed in surface coordinates** `(s, t)`, so the arc runs
  parallel to the lobe's edge. It is cones at `shine_flare` = 20° hulled
  along the arc and clipped to a 0.6 mm skin between `heart(+0.5)` and
  `heart(−0.6)`. With VERTICAL walls on a 45° slope, the downhill lip was a
  45° wedge that the wall check read as 0.06 mm. The slope under it is
  asserted ≤ 32°, and the lip ≥ 75°. The dot is asserted `hp_wall` clear of
  the arc's NEARER end. An earlier assert measured the far end only, and
  passed a 0.47 mm land.
- **Flat bottom to the edge, like the ladybug's legs.** The heart reaches
  13.07 from the pin at 45°. The butterfly's 43.6° relief would eat it.

**Invariants (angle 0; the others are the same solid turned):**

- 1 shell, genus 0, 23.0 × 19.0 × 8.0, **vol 2166.785 at every angle**.
  **306.7–306.9 mm² in 1 island.** Wall check ≥ 1.51. `check_overhangs`
  clean. `asin(|nz|)` scan: 0.000 mm² past 45°.
- Pin harness at 0, 45 and 90: seated / dz +0.10 / dx, dy 0.12 empty; dz
  +0.25 → 0.224 mm³, dx 0.20 → 0.4165 (controls). charm ∩ band 0.0000
  seated, 32–42 mm³ at dz −0.3.
- Swing at 130 and 180, angles 0, 45 and 90:
  - wearing (`"swing"`): clear to 60°.
  - backwards (`"swing2"`): **HIT from 0.5°**, the ladybug's trade. The user
    committed the ladybug knowing it, so it was taken as accepted.
- Spacing: at `charms = 3` and 130 the stations are 23.75 apart. Two hearts
  at 0° are 23.0 wide along the band, so they clear by only 0.75.
- Harness: one per charm (`band.scad` with the `if (accent)` tail cut,
  `heart.scad` with `heart_charm();` stripped, both includes absolute).

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
| vertical through the pin's free span (y = 0) | `0.605 \| air 0.645 \| 1.590 \| air 0.455 \| 0.905` |
| vertical through the axial gap (y = 1.35) | `SOLID 1.590` — the pin alone, in mid-air, which is what a bridge looks like |
| vertical through a lug | `SOLID 4.199` |

The first says the pin's anchors are feet on the plate; the second says the pin
is continuous between them. Together they are the proof that nothing is
cantilevered. **Any change that breaks either reading is a regression.**

Two ways a probe lies, both hit here:

- **A ray that starts inside material inverts every solid/air run** in an
  even-odd walk, and the inverted result looks perfectly plausible. Start
  outside the part, and keep a control whose answer you know (a vertical
  through a bar centre must read exactly `thick` = 4.200).
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

(The table is the 4.45 band. For the 4.2 band see the section at the top.)

Feature planes are z = 0, 0.6, 1.25, 1.95, 3.3, 3.6, 4.2 (4.45 band: 0,
0.655, 1.3, 2.1, 3.55, 3.85, 4.45, 5.0) — `pin_z`,
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

- Bed stability: **`cols` islands** (16 at 180), 2471.5 mm² of first layer, one
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
- **`pin_z` = 1.95 is squeezed from both sides**: the bore needs floor under it
  (`pin_z - bore_r >= 0.6`, and it sits exactly on 0.6 now, so loosening the
  bore or fattening the pin means raising `pin_z` — and `thick` — too) and
  the knuckle must reach the bed with a real foot (`knuck_foot >= 0.6`,
  currently 1.12). Assert
  on the **foot width**, not on `rk > pin_z` — a
  disc that only just dips below z = 0 technically "reaches" the bed while
  standing on a knife edge.
- **`knuck_slope` = 30.0°** (31.7 on the 4.45 band), derived from `rk`, `pin_z` and the foot, asserted
  at ≤ 40°. It is the largest sloped surface in the model.
- **`pin_flat` = 0.2.** A plain cylinder is tangent to the bed, and its outline
  jumps 0.63 mm in the first layer — the failure that killed the chain. Cut
  flat, the first layer is 1.13 mm wide (1.20 with the 2.0 pin). The bore stays round, so the flat only
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
   every number must be identical to `charms = 0`. If a charm (butterfly,
   ladybug, heart) or a new
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
