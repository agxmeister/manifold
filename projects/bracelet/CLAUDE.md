# CLAUDE.md — bracelet

Project-specific guidance for AI agents. The repo-root `CLAUDE.md` still
applies; the rules here are bracelet-only and win where they add detail.

## The ROUND KNOB IN A NICHE buckle (user's sketch) — 2026-10-20 (last), PRINTED 2026-10-21, reworked, UNPRINTED

**2026-10-23: SPRINGS IN THE BLOCK WALLS, solid round knob; far wall 3.0 — UNPRINTED.**
af3113f printed: "hard to close and relatively easy to open. It should be
the opposite", plus a screenshot circling the wall between the way-in and
bar 0's hinge (`tb_far` 1.44): "deformed while closing".
- **Why it was backwards.** A cantilever's tip moves about square to its
  root→tip chord. Leaves on a round knob's rim behind the widest point have a
  chord that falls going back, so the tip bends in AND FORWARD — the way a
  tooth pushes it when the knob is pulled out (opening easy, ratio ~0.5),
  whichever end it is rooted at. Back-rooted, closing also butts the free end
  face (a jam). Only a leaf whose chord RISES toward its free tip works.
- **First fix, REJECTED by the user the same day ("I don't like this shape
  of knob. Round one with springs on its side was better"):** two BARBS
  rooted in a front half-disc, swept back (arrowhead), tooth behind the tip.
  Physically right; the look is not wanted. Do not re-offer it.
- **Built (user chose it from two previews; the other was "back to af3113f
  + thick wall"):** a SOLID round knob; the springs are straight LEAVES in the
  way-in's side walls. `cl_*`, knob frame x' back from centre:
  - Knob = circle minus, each side, behind `cl_x0` (step + `tb_clear`): a
    RECESS, a LEAD-IN line rising at `cl_psi` (SOLVED so the bump at drop is
    `cl_rb + cl_dc` 0.65 off it: 21.4°) to the CREST C at `cl_xc` 1.35 on the
    circle, the CATCH at `cl_catch` 60° down to the NOTCH floor `cl_yn` (bump
    bottom − 0.15), floor back to the circle.
  - Bump r `cl_rb` 0.5 at home `cl_xb` 1.70, `cl_rb − cl_pre` (0.15) off the
    catch; hulled to the leaf face (base 1.2).
  - Way-in = hull(home circle r + 0.25, two corner discs `cl_wr` 0.8 at the
    old far end): straight side walls `cl_wy` 4.25 back to `cl_root`.
  - Leaf `cl_t` 0.8 from `cl_tip` (bump − 0.7) to `cl_root`, slot `cl_slot`
    0.9 behind it, mouth `cl_gap` 0.6 in front of the tip into the way-in,
    rounded root end. Outer wall 2.15. Straight-beam strain 3.6 %
    (`cl_strain`, asserted ≤ 4).
  - Effort ~tan(face + friction): close ~0.8 (21°), open ~4.3 (60°) × leaf
    force. Locks from ~73°; asserted `cl_catch` ≤ 65.
- **Far wall** `tb_far` 1.44 → 3.0. Buckle 21.44 → 23.00 (block 9.03 past
  bar 0); 130 still 12 bars, 151.9 flat; 160 still 14.
- Harness (scratch tfit.scad: socket moved `tb_x0 − x_f`, tab dx/dz; knob
  centre at x 135.875, split at 136.4): front home 0.0008 sheet (unchanged),
  dz 0.05 0.21, dx 0.1 EMPTY; bumps home 0.37, dx −0.1 0.12, −0.15 0.004,
  −0.2 EMPTY; dx 0.1…1.3 bumps only (peak 1.34 at 0.6); 1.5, 1.7 EMPTY; drop
  1.875 at dz 0/−1/−2/−4.3 EMPTY; CONTROL dx 1.0 dz −1 0.88; dx 2.1 seam.
  Sweep 110–230 genus 3·cols − 3, pieces == cols; rows=3 75; c3 36. 46
  BRIDGE + 2 RAMP, 12 islands 1722 mm². Walls (ends clipped short of the lug
  arms): block lip tips 0.67–0.72 only; tab ≥ 1.5.
- Trap hit in the wall check: a clip `.scad` with a syntax error writes no
  file and the checker re-reads the STALE one — rm the output first.

**2026-10-22 (later): WEDGE SEAT — UNPRINTED.** User: "the grip between
the knob's hooks and the lips is very loose", wanted the knob itself improved,
NOT a new mechanism (rejected: side-release buckle, sliding lock bolt, roofed
way-in). Chose option 2 of: tighter `tb_vfit` / WEDGE / deeper lips / lips
further round. Built: the old `tb_vfit` 0.3 split into three fits —
`tb_vfit` 0 (lip faces TOUCH at home: a V, top and bottom), `tb_wfit` 0.3
(niche's wall round the rim; was `tb_fit` 0.15 — so the V seats first,
asserted ≥ vfit + 0.2) and `tb_tfit` 0.3 (lip tip land ↔ knob's inset,
asserted ≥ 0.2; tip land now `tb_tip_z` 0.57). Overlap stays 0.8, so
`tb_slide` 1.875 is unchanged. `tb_ua` uses `tb_wfit` → knob 0.15 deeper,
buckle 21.29 → 21.44, block 7.47 past bar 0; 130 still 12 bars (11.51,
151.9); **160 now 14 bars** (12.04). Harness (scratch tfit.scad + `xcut`
138.8 to split front from teeth): home front 0.0008 (contact sheet on the
faces only, z 0.57–1.04 / 3.16–3.63); dz ±0.02, dx −0.02 HIT (no play);
dx +0.1 dz ±0.05 0.06; dx −0.25 wall; teeth rows unchanged (1.5, 1.7
EMPTY); drop 1.875 at dz 0/−1/−2/−4.3 EMPTY; CONTROL dx 1.0 dz −1 hits;
dx 2.1 seam. Sweep 110–230 shells == cols, genus formula; rows=3 75; c3 36;
46 BRIDGE + 2 RAMP, 12 islands 1715 mm². Clasp ends: nothing under 0.61
(the old 0.52 lip-tip flags are gone). If it is too stiff to close or the
knob sits back, raise `tb_vfit` to 0.05–0.1.

**2026-10-22: LONG TEETH, no bumps — UNPRINTED.** The cradle + 0.45 click
(cfeaa8f) printed "better, but still" — the user circled the tooth: "should
be 1.2 or 1.5 mm longer". I pushed back twice (leaf strain); the user: "make
what I am asking about. It should work." Built:
- Tooth tip `cl_ty` = r + `cl_cr` 0.2 − `cl_tooth` 1.25 = 2.95 (old tip 4.17:
  1.22 longer). Tip circle `cl_rt` 0.4, hulled into the wall. Bumps GONE: the
  tip rests `cl_pre` 0.25 into the leaf's rim behind the equator, at `cl_fu`
  2.45 behind the knob centre (solved), pressing the knob forward.
- Leaves `cl_tip` 113 → root 172, rigid rim to `cl_gap0` 88: at drop-out
  (`cl_fd` 0.57) the tooth stands in that gap. Asserts: clear of rigid rim/core
  in front, the leaf tip behind, the core; the tip circle meets the leaf's
  free end below its centre (cams it in when closing). `cl_slot` 1.2 ≥
  `cl_h` 0.73 + 0.45. Cradle wall = r + 0.2 from the step to the tooth.
- **Trap hit:** the niche cut was the knob's FULL circle, so it silently ate
  the tooth's tip inside r + fit (harness read home EMPTY). Now the niche cut
  stops at the step; behind it the way-in covers the knob.
- Strain (scratch leaf.py, calibrated): ~7.3 % at the root at 0.73 — told the
  user twice. If leaves crack: shorten `cl_tooth`.
- Harness: home 0.96 teeth-on-leaves only; dx −0.15 0.48 (grip survives the
  knob settling forward); dz ±0.25 lips; dx 0.3…1.4 teeth-on-leaves, peak 3.0
  at 0.6; 1.5, 1.7 EMPTY; drop 1.875 at dz 0/−1/−2/−4.3 EMPTY; CONTROL dx 1.0
  dz −1 1.89; dx 2.1 seam. Sweep OK, rows=3 75, c3 36, 48 regions no SUPPORT,
  walls unchanged.

**2026-10-21: printed (photos): "The hole is too big, hooks are too small."**
- Way-in: was a circle `tb_entry_gap` 1.4 round the knob at `tb_ue` (back
  gap at home 3.3). Now `tb_way_in_2d()` = hull of the knob circle and both
  bump discs, `tb_drop_fit` 0.25 round them, at home and at `tb_slide`
  (∩ behind the step, minus the teeth). Back gap at home = slide + 0.25.
  Buckle 22.44 → 21.29, block 7.32 past bar 0; 130 still 12 bars (pitch
  11.52, 151.8); 160 now 15 bars.
- Clicks: `cl_h` 0.3 → 0.45, `cl_rt` 0.5 → 0.45 (bump r stays 0.5: with
  bigger discs the bump cannot clear the tooth within `tb_slide` 1.875 —
  asserted), `cl_root` 168 → 172 (longer leaf; clamp 16°), `cl_slot` 0.8 →
  0.9 (≥ h + 0.45). Curved-cantilever unit-load model (scratch leaf.py,
  calibrated on the old 1.89 %): ~2.5 % (raw 2.7), force ×1.32; contact
  normal 30° off the pull (was 42°). Rigid-rim assert now vs r·sin(gap0)
  + 0.15 (0.17 real).
- Harness: home, dz ±0.05, dx −0.1 EMPTY; dz ±0.25 0.319 lips; dx −0.3
  0.87; dx 0.2…1.5 bumps-on-teeth only, peak 1.90 at 0.8; drop dx 1.875 at
  dz 0/−1/−2/−4.3 EMPTY; dy 0.2 there = neck slot only (0.50), dy 0.35
  (control) way-in too; CONTROL dx 1.0 dz −1 1.66; dx 2.05 seam faces.
  Sweep 110–230 shells == cols, genus formula; rows=3 genus 75; c3 36.
  46 BRIDGE + 2 RAMP, 12 islands 1711 mm². Walls: same lip/rim-stub flags.
- Same day, user: "your previous change didn't change anything" — the hooks
  must FIX the knob at home. Added the grip: `cl_c` −0.1 (tooth presses the
  bump forward) and `cl_pre` 0.15, a CRADLE (wall from the step to the tooth
  at y = bump top − pre) pressing each bump in. Harness: home / dz ±0.05 /
  dx −0.15 = bumps only (0.66 / 0.65 / 0.53); dx 0.2…1.2 bumps only, peak
  1.84 at 0.8; 1.5, 1.7 EMPTY; drop 1.875 at dz 0/−2/−4.3 EMPTY; control
  dx 1.0 dz −1 1.33. Sweep, rows=3 (75), c3 (36), 48 regions no SUPPORT.


From the user's sketch (red knob dropped into a blue hole). Reading confirmed
by the user before building: a big round WAY-IN behind (r + `tb_entry_gap`
1.4, centred where the knob drops in, `tb_ue`), a NICHE in front (the knob's
circle at home) whose lips end on a STRAIGHT STEP across the band
(`tb_ustep`, at `tb_lip_end` 75° on the knob's edge), pull ~2 mm. **No
spring.** 8 mm knob. Neck 4.5 → 3.5 (sketch is thin; at 4.5 the lips beside
the neck failed the ≥ 0.7 assert) — told the user.


**2026-10-20 (later): side CLICKS added** at the user's request ("springs on
the knob to improve the grip"). I explained once that a PUSH spring would bend
~2.3 on ~4 mm leaves (15–20 %) and offered clicks vs a bigger knob with push
springs; the user chose clicks. `cl_*`: the rim behind the step is two leaves
`cl_t` 0.7 from `cl_root` 168 (the 24° between the roots stays solid — the
clamp; trap hit: the slot's rounded end disc centred AT the root ran 8° past
it and left a sliver joining the leaves to the core → now ends at
`cl_root − cl_end`) to `cl_tip` 94, rigid rim ends `cl_gap0` 86, slot
`cl_slot` 0.8. Bump r 0.5 at 101°, centre r + 0.2. Tooth r 0.5 on the way-in
wall (hull out into the wall), `cl_c` 0.05 behind the bump at home, overlap
`cl_h` 0.3 at the peak (d 0.78), clear from d ≈ 1.45; asserted clear at
`tb_slide` with 0.15. Frame model (scratch click.py; control = meander.py's):
1.89 %, ~8 N radial per leaf at the peak. Harness: bumps-on-teeth only for d
0.2…1.2 (1.07 at 0.78), EMPTY at 0 / 1.5 / 1.875 (all depths). Walls: knob
0.56 only at the rim stub between the lip shaping (step + 0.2) and the tip
gap, inside the inset bands — accepted.

- `tb_slide` = sqrt((r+clear)² − tip_y²) − step = 1.875 (the last lip tip on
  the step is the worst point); seam 1.975. Lips = `tb_lips_2d` swept ±100
  minus the neck slot and everything behind the step. Knob edge cut swept
  ±100, kept to u ≤ step + clear. Pocket = (home circle − lips) ∪ (way-in ∩
  behind the step). Asserted: the knob at home, behind the step, lies inside
  the way-in.
- Rigid buckle 22.44, block 8.47 past bar 0; 130: 12 bars, pitch 11.41,
  151.8 × 16.2 × 4.2.
- Checks: home, dz ±0.05, dx −0.1, dx 1.0, 1.5 EMPTY; dz ±0.25 0.319 lips;
  dx −0.3 0.87; CONTROLS dx 0 / 1.0 / 1.5 at dz −1 → 2.69 / 0.29 / 0.003;
  dx 1.875 at dz 0, −0.6, −2, −3.5, −4.3 EMPTY; dx 2.1 seam faces. Note
  dz −4.3 is no control (knob wholly under the block). Sweep 110–230 OK;
  rows=3 genus 75; charms=3 36. 46 BRIDGE + 2 RAMP, no SUPPORT. Walls: tab
  ≥ 1.53; block 0.52–0.67 at the lips' tips/ends.

## The ROUND KNOB IN A SLOT buckle (hull slot, lips to 90°) — superseded the same evening — HISTORY

The user's own design, stated twice: "make the knob round and remove this
ugly spring. The hole in the B part of the buckle should be a widened circle
shape - knob should be inserted and pulled a bit - inserted into a niche by
its half." **NO SPRING — do not add one back unprompted** (rim leaves and the
zigzag were both rejected; I misread the first statement and kept a spring).

**Geometry**: knob r `tb_r` 4 (8 mm, user's choice), full plain cylinder,
edge cut by `tb_edge_cut_2d` swept ±93° (`tb_sector`). Pocket = neck slot +
`hull()` of the knob circle (r + fit) at home and moved back `tb_slide`,
minus `tb_lips()` (the `tb_lips_2d` section swept ±`tb_lip_end` 90, clear of
the neck slot). `tb_slide` 2.72 = sqrt((r+clear)² − (r−overlap)²) at 90°,
seam 2.82, slot end `tb_uend`, `tb_far` 1.44 → x 1.56 in bar 0. Rigid buckle
22.88, block 8.06 past bar 0. 130: 12 bars, pitch 11.37, 151.8 × 16.2 × 4.2.

**Checks** (scratch tfit.scad / fit.py: socket moved by `tb_x0 − x_f`, tab
moved dx/dz): home, dz ±0.05, dx −0.1, dx 1.0, 2.0 EMPTY; dz ±0.25 0.371 at
the lips; dx −0.3 0.58 front arc; CONTROL dx 2.0 dz −1 0.052; dx 2.72 dz 0 /
−2 / −4.3 EMPTY (drops out); dx 2.95 seam faces. Sweep 110–230 shells == cols,
genus 3(cols−1); rows=3 genus 75; charms=3 genus 36. 46 BRIDGE + 2 RAMP, no
SUPPORT. Walls: tab ≥ 1.53; block 0.48–0.58 only at the lips' tips/ends.

## The ROUND KNOB + ZIGZAG buckle (rejected the same day, "ugly spring") — HISTORY

Replaced the first round knob (next section, HISTORY, never printed). The
user: "The knob is too big and the rails are too short. The knob should be
inside the groove on its half of the length". I asked (lip reach / knob size)
after showing that lips to the widest point need a ~2.9 push; user chose
FULL FRONT HALF and an 8 mm knob. I had estimated the buckle at ~26 — it is
31.0 (spring 11.2 + pad 2.3 + 2.8 seam). Told the user; the lever is
`tb_lip_end` (75° → push ~2.0, shorter spring).

**Geometry**: knob r `tb_r` 4 (a parameter now, not band-derived), lips
`tb_lip_end` 90; heel = flat back from the centre to `sp_u0 + sp_t/2`, as wide
as the knob. `tb_slide` 2.72 (formula, worst point at 90°), seam 2.82, travel
`sp_travel` = pre 0.6 + seam = 3.42. Zigzag `tb_spring_2d`: `sp_legs` 3 legs
`sp_t` 0.9 at `sp_pitch` 2.8, spanning ±`sp_y` (= r), semicircle bends
(first off the heel's −y corner), then `sp_pad` 2.3. Room behind the lips:
±`tb_room_hw` 6.0 (side walls 2.1), from `tb_uc + tb_heel_gap − fit`.
Lead-in split: pad's top-back edge AND far wall's bottom edge chamfered
`tb_ch` = (travel + clear)/2 = 1.81 each → home contact at mid-height.
Trap hit: the pad's chamfer cut spanning only ±sp_y left a 0.06 sliver on the
last bend → spans ±room.

**Why a zigzag**: travel 3.4 is twice the dovetail's 1.8; rim leaves on an
8 mm knob would be ~10 %. Linear frame model (scratch `meander.py`; control:
straight 5.05 × 0.8 at 1.81 → 8.43 % vs 8.52 % analytic): 1.50 % open,
5.5 N open / 1.0 N rest, 0.20 min gap between legs. Variants: 2 flexible legs
collide mid-leg; t 0.8 p 2.6 → 0.7 N rest. The source asserts only travel
≤ 3.45 and slots; re-run the model if spring/knob/travel change.

**Checks** (tfit: "spring" = tb_spring_2d from leg 1 on):

| test | reads |
|---|---|
| knob home / dz ±0.05 / dx −0.1 / dx 1.0, 2.0 | EMPTY |
| dz ±0.25 | 0.371 at the lips |
| dx −0.3 | 0.79 front arc |
| dx 2.0 dz −1 (CONTROL) | 0.052 lips |
| dx 2.72, dz 0 / −2 / −4.3 | EMPTY — drops out |
| dx 2.95 | 4.6 seam faces |
| spring home | far wall only, 0.6 deep, z 1.21–2.99 |
| spring 2.82 dz −3.9 / −4.3 | chamfers only / EMPTY |

- Sweep 110–230 OK (130 = 11 bars, genus 30). rows=3 180 genus 70; charms=3
  genus 33.
- 130: 161.6 flat, 1628.9 mm² / 11 islands; 42 BRIDGE + 2 RAMP, no SUPPORT.
- Walls: tab ≥ 0.62 (legs 0.9). Block 0.48–0.58 at lip tips/ends, accepted.

## The first ROUND KNOB (13.1, lips to 50°, rim leaves) — 2026-10-20, never printed, rejected (too big, lips too short) — HISTORY

Replaced the dovetail knob (section below, now HISTORY). The user: the
dovetail "works good" but "the spring became broken almost instantly"; asked
for a round knob instead of the triangle, and a more reliable spring. Same
lips/pocket/drop-out idea, same user-chosen spring position (on the knob's
back, pressing the far wall).

**Geometry** (`tb_*` / `sp_*`, local frame u from the block's front face,
y off the band's middle; `tb_pol(a, r)` = angle a from the knob's FRONT):
- Knob: circle `tb_r` = band_w/2 − side − fit = 6.55, centre `tb_uc`.
  Lips are `tb_lips_2d` swept by `tb_sector()` (rotate_extrude round the
  front, ±`tb_lip_end` 50°) minus the neck slot; the knob's edge is cut by
  `tb_edge_cut_2d` over ±53° (3° past the lips so a lip's END face clears).
- `tb_slide` solved: the lip tip at 50° (radius r − overlap) must sit
  `tb_clear` outside the circle pushed back: 1.419. 60° would give 1.68.
- Springs: leaf `sp_t` 0.7 ON THE RIM from `sp_root` 70° to the tip at
  `sp_ytip` = 0.366·r (2.4) off the middle, round end + bump (`sp_nub` 0.3
  proud, r 0.4) on the tip's back. Hollow behind: slot `sp_slot` 0.5 at the
  root (rounded end disc, `sp_s`), the core falling away by `sp_hollow`·x²
  (2.6) toward the tip; between the tips open. Nose on the far wall,
  half-width ytip + 0.6, face `tb_un` = bump's back − `sp_pre` 0.4, bottom
  chamfer `tb_ch` 45°. Pocket = home circle − lips ∪ circle pushed `tb_slide`
  (room fit) − nose; far end `tb_uend`, `tb_far` 1.44 → pocket ends x 1.56.
- **Why the leaves are like that** (large-deflection beam model, scratch
  `final.py`/`el3.py`, not in repo — curved cantilever, tip contact found as
  the rear-most point, bisection on force): straight 5 mm leaves were 8.5 %.
  Following the rim from the equator: ~3 %; moving the root 20° forward of
  the equator: 2.70 % pushed fully open (δ = pre + face_gap = 1.92), 0.65 %
  at rest, 1.9 N/leaf at rest. Under tip load the arc CURLS: tips move in by
  ~1.8 and rotate ~30°; without the bump the contact migrates toward the root
  (stiffer). Tips at 2.4 leave 0.23 each from the middle fully pushed; at
  2.2 with a full-disc bump they crossed. Core clearance 0.35 fully pushed.
  The scad assert uses the small-deflection integral `sp_eps()` (2.76 %,
  within 0.1 % of the model): ≤ 2.9 % open, ≤ 1 % rest.
- A fixed `sp_ytip` broke rows=3 (bigger, flatter rim → the nose caught the
  leaf's side; asserted) → scaled with r.
- Rigid buckle 25.38 (was 20.08: a circle is as long as it is wide), block
  11.86 past bar 0. 130: 12 bars, pitch 11.15 (pitch_min 11.10!), 156.6 ×
  16.2 × 4.2. rows=3: r 11.65, buckle 35.7, strain 0.84 %.
- Known: at home the tips press only the nose above its chamfer (z ≥ 1.72);
  the dovetail had the same.

**Checks** (scratch `tfit.scad` + `fit.py`: socket moved by `tb_x0 − x_f`,
tab by dx/dz; parts "knob" = tab minus the leaves past the centre,
"spring" = those leaves):

| test | reads |
|---|---|
| knob home / dz ±0.05 / dx −0.1 / dx 0.5, 1.0 | EMPTY (zero-volume mask seams only) |
| dz ±0.25 | 0.356 at the lips beside the neck |
| dx −0.3 | 1.5, the front arc |
| dx 1.0 dz −1 (CONTROL) | 0.045, the lips |
| dx 1.419, dz −2 / −4.3 | EMPTY — drops out |
| dx 1.6 | 2.85 at the seam faces |
| springs home / 1.519 | nose only, 0.4 / 1.9 deep (|y| ≤ 2.9) |
| springs 1.519 dz −4.1 / −4.3 | chamfer only / EMPTY |

- Wrist sweep 110–230: shells == cols, genus = formula (33 at 130). rows=3
  at 180: 15 bars, genus 70. charms=3: genus 36.
- 130: 1685.7 mm² in 12 islands; 46 BRIDGE + 3 RAMP (nose chamfer from the
  bed; the knob's two lower lip insets). No SUPPORT.
- Walls: tab end ≥ 0.70 (the leaves). Block: 0.53–0.58 at the lips' ends
  (beside the neck slot, and at the 50° end), accepted as before.
- Not run: slicer; FEA beyond the beam model.

## The DOVETAIL KNOB buckle (user's sketch) — 2026-10-20, PRINTED: held well, springs broke — HISTORY


Replaced the T on rails (section below, now HISTORY). The user printed the
rails version and asked, with a photo and then a sketch (dovetail knob, two red
curved springs on its back corners pressing the far wall): knob longer, knob
"triangle" so the move to lock is much smaller, side springs removed (sides
solid), spring on the knob's end pressing it into the groove. I asked which
triangle with three previews; the user answered with the sketch. **The
widening dovetail (narrow at the neck) is the only orientation that works**:
the band's pull wedges it into the lips. An arrow pointing into the block
would be pulled out by the band.

**Geometry** (`tb_*` / `sp_*`; local frame u from the block's front face,
y off the band's middle; modules build in it via `tb_along()`, a multmatrix
that extrudes an (a, z) section along a plan line with a to its right):
- Knob `tb_knob_2d()`: front face half-width `tb_front` 3.1 at `tb_ua`,
  slanted sides at `tb_a` 45° to half-width `tb_hw` = band_w/2 − `tb_side`
  1.4 − fit = 6.55 at `tb_ub`, `tb_tail` 1.0 straight. 13.1 × 4.45. The width
  FOLLOWS THE BAND (rows=3: 23.3 wide, springs 10.15, 2.1 %).
- Lips (`tb_lips()`): front wall + both slanted walls, the old `tb_lips_2d`
  section, kept out of the neck slot (|y| ≥ neck/2 + fit) and stopped at
  `tb_ub` − fit. Knob shaped by the matching `tb_edge_2d` slabs.
  **Trap hit: the slant slabs must be long enough to cover the OTHER side's
  far corner** (−20, length 40). At −3, length 20 the +y slab's start cut the
  knob off on a diagonal; the harness read up/down 0.25 EMPTY (no lip grip)
  while home looked perfect.
- `tb_slide` = (lip − vfit + `tb_clear` 0.2)/sin a = 1.414: the push to
  open. `face_gap` = slide + 0.1. The pocket = knob ⊕ fit minus lips, ∪ knob
  moved `tb_slide` ⊕ `tb_room_fit` 0.15 (where it drops out), ∪ the spring
  room to the far wall `tb_uw`, whose bottom edge is chamfered 45° by `tb_ch`
  2.01 (springs' lead-in when closing). `tb_far` 3.45 so the chamfer stops at
  x 1.56 of bar 0, short of its lug arms (asserted ≤ 1.6).
- Springs `tb_spring()`: post `sp_post` 0.8 on each back corner, leaf
  `sp_t` 0.8 spanning `sp_len` 5.05 to tips `sp_gap` 0.6 apart, preload
  `sp_pre` 0.3. **The leaf is the tip-load deflection curve f(x) = x²(3−x)/2**
  (square off the post, rising `sp_rise` to the tip), so pushed fully open it
  lies flat on the wall; a straight diagonal leaf's middle would dig into the
  wall. **Strain 1.4 % at rest, 8.5 % pushed fully open** vs the proven
  2.9 %. Told the user once; asserts are 2.9 % at rest, 9 % open.
- Rigid buckle 20.08 (block 6.56 past bar 0), seam 1.51. 130: 12 bars,
  pitch 11.63, 151.4 × 16.2 × 4.2. 180: 16 bars, 201.4.

**Checks** (scratch `tfit.scad`: socket moved by `tb_x0 − x_f`, tab moved
dx/dz, split into "knob" (x < tb_ut), "spring", "post"):

| test | reads |
|---|---|
| knob home / dz ±0.05 / dx −0.1 | EMPTY |
| dz ±0.25 | 0.57 at the lips (front + slanted, x 134.2–137.5) |
| dx −0.3 | 2.38, the slanted walls |
| dx 0.5, 1.0 | EMPTY |
| dx 1.0 dz −1 (CONTROL) | 0.25, the lips |
| dx 1.414, dz 0 … −4.3 | EMPTY — drops out |
| dx 1.6 | 3.0 at the seam faces |
| springs home / 1.414 | far wall only (x ≥ 141.55), 0.3 / 1.7 deep |
| springs 1.514 dz −4.1 / −3 | EMPTY / on the chamfer only |
| posts 1.514 / 1.7 (CONTROL) | EMPTY / 0.15 |

- Wrist sweep 110–230: shells == cols, genus = formula (33 at 130), loop
  exact. rows=3 at 180: genus 75.
- 130: 1695.7 mm² in 12 islands; 46 BRIDGE + 3 RAMP (the far wall's chamfer,
  45°, from the bed; the knob's two lower slant insets). No SUPPORT.
- Walls: tab end nothing under 0.75. Block: 0.58–0.67 at the lip tips beside
  the neck slot (the front lip there is a 0.37 face at its tip), accepted.
- Not run: slicer, a bending simulation of the springs.

## The T ON RAILS buckle (user's design) — 2026-10-19, PRINTED, then replaced 2026-10-20 — HISTORY

**History, in order — do not re-offer the dead ends.**
1. Stud + keyhole: "asymmetric" (plates stacked, one end 1.6 higher), "too
   long" (~31 mm rigid). Replaced.
2. Jigsaw (knob clicked up into a roofed pocket by a 0.7 ridge on two leaves):
   **PRINTED AND FAILED — "opens very easily".** A click alone does not hold.
3. User's T-slot (insert from below pushed forward, lips on the shoulders
   only, one-sided spring leaf): built, never printed; superseded the same day.
4. User asked: deeper groove, grooves on the SIDES too ("held by 3 sides"),
   symmetric spring. A symmetric spring that fits behind the crossbar was
   worked out and CANNOT bend far enough: two half-length leaves ~5 %, a
   closed stadium ring 4.7 % (energy method, it acts clamped) vs the proven
   2.9 %. The user then sketched rails along both side walls ("as on rails")
   and "make the B part longer", and said "Let's make it!" without picking
   between the readings I offered. **I built reading 2**: the crossbar drops
   into an empty ROOM behind its home and slides forward along the rails.
   The far wall has NO rail (it is where the crossbar comes in); the spring
   became two mirrored DETENT leaves (symmetric). Told the user both.

**2026-10-19 (latest): crossbar 11 → 10, bigger detents — UNPRINTED.** The
user circled the detent bump (a 0.5 half-disc on a 0.8 leaf, its front
quarter over the cross slot: it rendered as a tiny hook) as "too small to
print" and asked to narrow the crossbar to make room. Now `tb_cw` 10 (the
neck assert allows 9.5), `lf_t` 1.2, `dt_r` 0.8, `lf_len` 5.4, and the leaf's
free end is FLUSH with the bump's front (`lf_u0 = dt_u − dt_r`), so the
cross slot runs only in front of the bump and the whole disc stands on the
leaf (asserted: `dt_y + dt_r ≤ tb_ws + lf_t`). Pinch 0.5 / 0.35 kept,
strain 2.16 %, leaf ~1.4× stiffer. Costs: rails 1.86 of 2.6 (assert 1.82),
slide 4.36, seam 4.46, rigid buckle 21.9, block 5.41 past bar 0; shoulders'
lips 0.5 shorter each side. Outer wall 1.15. Leaf root ends at x 1.5. Harness
(numbers below are the 11-wide version's): home / dz ±0.05 / dx −0.1 EMPTY;
dz ±0.25 0.45 at the lips; dx −0.2 0.56 shoulders; dx 0.1 … 3.9 bumps only
(peak 1.43, was 1.05); dx 4.36 and dz −1 … −4.3 there EMPTY; CONTROL dx 3.6
dz −1 → 0.21; dx 4.5 the faces. Wrist sweep 110–230 OK. 46 BRIDGE + 2 RAMP
(the T's lower end lips), same as before. The 0.38 bump-tip wall flags are
gone; nothing under 0.5 in the block. 130 still 12 bars, 146.35 flat.

**Geometry** (as of the 11-wide crossbar; see the paragraph above for what
changed) (clasp section, `tb_*` / `dt_*` / `lf_*`; `u` along the band
from the block's front face, fastened, home):
- T: neck `tb_neck` 4.5 (into the crossbar past the lip inset), crossbar
  `tb_cw` 11 × `tb_ct` 2.6, front AND both ends shaped by `tb_edge_2d()`:
  vertical `tb_land` 0.4 at bed and top, 60° (`tb_lip_a`) faces in by
  `tb_lip` 1.1. **The two ends are separate children of the intersection
  (`tb_end_shape(±1)`): a `for` inside intersection() is ONE child, the
  union, and shaped neither end — the harness found a 2 mm³ collision at
  home before that fix.**
- Block: bar 0 lengthened to `x_f` (`slab()`), `blk_ext` 4.93. Cut: neck
  slot; home + room as one through-cut (`tb_ws` = cw/2 + fit) whose front is
  the shoulders' lips; rails = `tb_lips_2d()` kept on each side wall from the
  shoulder to `tb_rail_u` (rails grip 1.98 of the 2.6 ends).
- Detents (`tb_side_keep` / `tb_side_cut`, mirrored by `tb_both_ends`): leaf
  `lf_t` 0.8, `lf_len` 4.4, slot 0.6 behind it and a cross slot in front of
  its free end, `lf_slot` wider than the bump (else the bump sits 0.1 from the
  wall). Bump r `dt_r` 0.5 centred on the wall plane at the leaf's free end,
  `dt_pinch` 0.5 → 0.35 into the crossbar's path; it CRADLES the crossbar at
  home (`dt_u`). `lf_strain` 2.17 %. Leaf root runs into `tb_far` 2.4 of bar 0
  and stops at x ≤ 1.6, short of bar 0's lug arms (x ≥ 2).
- Room: from `tb_urm` (bump + 0.3) to `tb_ufar` (+ ct + 0.3). `tb_slide`
  3.88, `face_gap` 3.98 = the seam. Rigid buckle 20.9. 130: 12 bars, pitch
  11.55, 146.35 × 16.2 × 4.2. 180: 16 bars.

**Checks** (scratch `band.scad`, `tfit.scad`: `sock()` moved by
`x_r + face_gap − x_f`, tab side by `dx`/`dz`; `r3.scad` renders):

| test | reads |
|---|---|
| home | EMPTY |
| dz ±0.05 / ±0.25 | EMPTY / 0.53 at the lips (front + rails, x 135.8–137.8) |
| dx −0.10 / −0.20 | EMPTY / 0.67 at the shoulders |
| dx +0.10 / +0.30 | bumps only, 0.03 / 0.25 |
| dx 0.6 … 3.0 | bumps only (x 138.4–139.4, z 0.84–3.36), ≤ 1.05 |
| dx 3.6, 3.877 (room) | EMPTY |
| room, dz −0.5 … −4.3 | EMPTY |
| dx 3.377, dz −1 (CONTROL) | 0.10 at the bumps |
| dx 4.03 | the faces |

- Wrist sweep 110–230 + 144, 155: all OK (shells == cols, genus, loop).
- 130: genus 33, 12 shells, 1629.8 mm² / 12 islands; 46 BRIDGE = 44 hinge +
  2 upper lip L's (front + rail, z 3.25); no SUPPORT. 180: 2200.4 / 16.
  `charms = 3`: genus 36, 1578.1.
- Walls `--nozzle 0.4`: T ≥ 1.50. Block: 0.37–0.38 only at the detent bumps'
  free front tips (a half-disc on the wall plane, its front quarter standing
  over the cross slot) — accepted; other flags were clip-plane artefacts
  (clip short of x 2.0, the lug arms).
- Not run: slicer; §1 probes / §3 raster (hinges untouched).

The sections below on the stud + keyhole ("The clasp — reworked
2026-09-22", "Bigger detent bumps", the keyhole traps, `leaf_free`,
`tip_wall`) are HISTORY. Numbers in other sections measured on 11 bars at
130 are from before 2026-10-18.

## The BOLT is the only mount — 2026-10-18, rib + grooves UNPRINTED

The user: "keep bolts a single way to attach charms". "Bolt" = the cone pin
(`models/cone-pin`, `lib/charm-cone.scad`, `cn_*`). What they asked, and
what was done:
1. **"Print bolts vertically, no need to keep one side flat."** Already true
   since c1a66fd (standing, round, hex socket); nothing changed. Told the user.
2. **"Remove all other connectors."** `lib/charm-dovetail.scad`,
   `lib/charm-pin.scad`, `models/pin` deleted; `mount` is gone from
   `bracelet.scad` and the heart. See "Mounts removed" below.
3. **"Change all charms to the bolt."** Every charm subtracts
   `cn_charm_mount()` (socket + grooves) at its origin and stands ≥ `cn_need`
   8.75 over the axis.
4. **Angles: "a semicircular protrusion on the bracelet, grooves under the
   charms".** The user chose (asked with previews) a HALF-ROUND RIB across
   the band through the axis, and 45° steps (8 grooves). The heart's
   `angle` parameter and its `-a*` exports are gone: the angle is chosen on
   the wrist.

**The mechanism has one consequence the user was told up front: the BOLT
turns, not the charm.** A charm screwed down would have to spin through the
rib for its last 1.0 mm (156° of thread). So the charm is set on the rib and
the bolt is turned from below with the hex key; the round cone spins in its
countersink. Right-hand thread: clockwise seen from below tightens.

**Geometry** (`lib/charm-cone.scad`):
- Rib `cn_bar_rib()`: two pills r `cn_rib_r` 1.0 (2.0 × 1.0 half-round, quarter-
  sphere ends) along y, tips from `cn_rib_in` 4.3 to `cn_rib_out` 7.0 off the
  axis, sunk 0.2 into the bar. Added AFTER the station `difference()`
  (`charm_station_add`). It stays on the bar's flat top (asserted: x ≤ 2.5,
  |y| ≤ 7.6 − 0.3). The helper that sweeps the thread was already called
  `cn_rib` — the name clash gave "Too many unnamed arguments" warnings and a
  silently smaller thread cut. Hence `cn_bar_rib`.
- Grooves `cn_grooves()`: 360/`cn_step` radial slots, teardrop section
  (r `cn_g_r` 1.15 = rib + `cn_g_fit` 0.15, 45° gable to apex `cn_g_apex`
  1.63), square ends `cn_g_fit` past the rib tips (`cn_g_in` 4.15 ..
  `cn_g_out` 7.15). Web between grooves at the inner end `cn_g_web` 1.18
  (≥ 0.8), solid ring round the thread `cn_g_ring` 1.5 (≥ 1.2). Play about
  ±1.7°. Charms must leave `cn_g_roof` 1.0 over a groove's ridge.
- `cn_charm_mount()` = `cn_charm_cut()` + `cn_grooves()`. Thread, bore,
  countersink, the +x fill and the pin are UNCHANGED: `cone-pin` and
  `screwdriver` exports are byte-identical.

**Checks (band `-D charms=3`, heart):**
- Plain band byte-identical. c3: 11 shells, genus 34, 1697.9 mm² in 11
  islands, 40 BRIDGE (= before), wall flags only the known ones. c3 − old
  c3-cone = 19.06 mm³ (three ribs above the top), old − new empty.
- Heart: old cone heart − new = 56.60 mm³ = exactly `cn_grooves()` ∩ z > 0;
  new − old empty. 1 shell, 252 mm², 1 BRIDGE (the bore's apex), no thin
  wall outside the thread. 5.79 over the grooves' far ends (asserted).

**Harness** (scratch: `c3.stl`, the charm export imported at bar 5's axis,
`translate([5*pitch + cn_off, band_cy, thick + dz]) rotate(a)`):

| test | reads |
|---|---|
| heart at a = 0, 45 … 315, dz 0 | 0-vol contact sheet at z 4.2, every one |
| a = 22.5 (CONTROL: between grooves) | 6.29 — stands on the rib |
| a = 0, dz −0.2 (CONTROL) | 27.43 |
| a = 45, dz +0.05 | empty (the rib clears its groove) |

**All five charms converted** (2026-10-18). Each subtracts
`cn_charm_mount()` at its origin and asserts its own roof over the socket and
the grooves. Older numbers in each charm's own section below are the H-pin
version's; these supersede them:

| charm | what grew / moved | size, vol, bed | notes |
|---|---|---|---|
| heart | grooves only (was already 9.2 for the cone) | 23 × 19.4 × 9.2, 2440.02, 252 mm² | `angle` and `-a*` exports gone |
| butterfly | round thorax r 3.85 (`thx_r`), domed to 9.3 hulled with the old body; head 4.6→5.4; spots out; wing notch filled to y −2.15 (a groove ran out through it in 0.0–0.3 slivers) | 16.1 × 19.8 × 9.3, 950.56, 104 mm² | hp_ sizes inlined (`body_x` 3.4, `body_y` 7.95…); wall flags left: wedges where diagonal groove ends meet the 43.6° relief (≥ 59°, one 0.07 sample at a corner), accepted |
| ladybug | `sh_h` 8.0→8.8, `sh_a` 6.3→7.6 (at 6.3 a 0.08–0.33 curtain over the diagonal grooves); legs moved between grooves: `[[2.25,10,5.9],[-2.25,-10,5.9],[-5.5,-50,4.8]]` (a 1.6-tall leg would be cut off by a 1.63 groove), asserted ≥ 0.1 clear (0.49); spots spread | 20.6 × 21.6 × 8.8, 1488.13, 177 mm² | colours red 5 / black 14 shells, sum exact; one 0.28 wedge at (−5.72, −4.60, 0.75) accepted. The old "1077.6 mm³" below was stale: the old export measured 1213.65 |
| rose | `core_top` 7.95→8.75 (socket roof exactly 1.00 on the axis — raise it for margin); petals untouched | 22.1 × 22.4 × 10.5, 2524.56, 201 mm² | gap scan (re-written in python from `dump=true`) 0 persistent; grooves end r 7.24 inside the 8.0 core |
| dolphin | torso rows s −2…8.5 raised to 8.86 over the axis (8.50), height peak 9.08 at s 2.5–3; `fin_lift` 0.35; `joints` [11.2,18.4,25.7]→[11.3,18.5,25.7] (pocket front 8.2, `g_wall` 1.05 past `cn_g_out`) | 29.8 × 52.5 × 13.9, 2517.81, 420 mm² in 4 | ±x grooves exit the body's sides at r ~6.9 as small arches at bed level; joint harness rows unchanged; `-bend.png` preview is stale |

Band harness for every charm, all pass: every 45° a 0-vol sheet; 22.5° →
6.29 (rib, ladybug 67.5° 5.97); dz −0.2 → 13–29 mm³; dz +0.05 empty.

**Swing with a charm seated, turned 0 / 45 / 90**, bars 3, 4, 6, 7 bent
about their pins (scratch `swing.scad` + `swing.sh`, `wearing` = neighbours
drop): all five EMPTY at 24° and 40°; at −1° (backwards, the CONTROL) all
hit — heart 0.8–3.5, ladybug 0.9–1.8, rose 0.9, dolphin 3.6–23.1, and the
butterfly now too (0.001–0.11: it used to bend back to 40°; turned, its
flat bottom lies over the neighbours). A dolphin turned 90° puts 52.5 mm
along the band, past the 35.1 mm station spacing — two charms next to it
would collide (told in the README).

Not printed. Not checked in a slicer.

## The cone pin — 2026-10-04, reworked after its first print; PRINTED GOOD 2026-10-05

The user's design: a pin with a CONE at its foot, inserted from under the
band into a countersink in a station bar, and an M5 THREAD on top that the
charm screws onto, clamping the bar. It ran **alongside** the dovetail H-pin
from 2026-10-04 (`mount = "cone"`, heart only, 9.2 tall for it) until it
became the only mount (section above). Exports then:
`bracelet-bracelet-c3-cone`, `cone-pin-cone-pin`,
`heart-charm-heart-charm-cone` (now `-c3` and `heart-charm-heart-charm`).

**The first print (M3, split cone, ball click, 15° ridges) and the user's
verdict, all done:**
- The BALL + click fingers "do not add any fixation". Removed; thread
  3.5 → 5.0 in the charm (1.26 → 1.91 turns).
- The 15° RIDGES "were not printed in the bracelet - too small" (0.3 tall,
  ~0.7 wide). Removed, along with the charm's groove ring. There is no angle
  fixation now; the charm holds by the clamp.
- The SLOT splitting the cone "is not needed". It is a true cone now, with
  only the bed flat (the top flat was relief for the split halves, so it is
  gone too).
- "Make the pin thicker", with a screenshot circling a ~6.4 mm hole that
  reached into the gap between knuckle clusters, offset ~1 mm toward it.

**Where the room comes from. Read this before moving anything.** The bar is
6.0 along the band. On its **+x side** (the fork side), the knuckles beside
the gap between the two clusters are the bar's OWN fork lugs (y ±2.1 ..
±3.5 about `band_cy`). That gap is FILLED COMPLETELY: `charm_seat` adds
`xz_extrude(band_cy ± cn_boss_y 2.6) knuckle_2d(pitch/2, +1, h − 1)`, one
wide lug with the lugs' exact profile, out to their ends, fused 0.5 into
each. It stays inside the lugs' swing envelope, so the joint swings exactly
as a plain one. The pin's axis is **`cn_off` 1.1 toward +x**. Asserts:
−x wall `h − (cn_cs_r − cn_off)` 0.75; +x chord 2.76 ≤ lugs' far faces − 0.7.

**A cone station keeps the bar's top bevels** (user, 2026-10-04): the chamfer
fill in `charm_seat` is dovetail-only now. The hole stays ≥ 0.8 clear of
the −x bevel's foot (asserted; 0.95). The dovetail c3 export is still
byte-identical.

**What the user wants here, after three misreads (2026-10-04):**
- "Fill the gap" meant the +x gap, OUT TO THE KNUCKLES' ENDS (the old boss
  stopped at 5.2). It did not mean the −x gap.
- "Do not change links": a version that mirrored the station's −x joint
  (forks on both sides) was rejected outright.
- "Keep the hole as is": 1.1 off-centre.
- The −x gap is flanked by the NEIGHBOUR's swinging lugs and STAYS OPEN. A
  narrow −x boss was also built and dropped.
- A top-down render of interleaved knuckles once read as "no boss".
  Probe the solid with small `intersection()` boxes instead.
- A harness that placed the pin at `X + cn_off` after `cn_off` was
  removed read EMPTY everywhere except the controls. Expect the seated
  contact SHEET, not EMPTY, and read the log's warnings.

**Geometry:** M5 × 2.3, the M4 tooth (e1425c5) at M5: ceiling 31.5°,
female crest 0.45, fit 0.15. Hole 5.3. Countersink 6.7 at the bed. **The
cone is LONG** (user's sketch, later 2026-10-04): it runs from the foot to
the thread's start with no straight shaft, so `cn_cs_a` is SOLVED, 12.94°
from the axis. The countersink is 3.05 tall, and the seated contact runs z
0.10–3.05. Costs, told to the user once: the wedge spreads the bar ~4.4× the
clamp's pull (35° was ~1.4×), and a cone printed `e` fat radially sits
~4.4·e higher, so `cn_sink` 0.5 covers e ≤ ~0.11. If bars split at the
countersink, go back toward 35°. The pin's foot is recessed 0.1 (0.4 since the standing pin) inside
the underside. Lying pin only (removed): bed flat `cn_flat` 1.75 (thread leaves the bed at 44.4°, cone
at 31.8°). **The thread starts `cn_sink` 0.5 DOWN inside the bar**: with the
smooth shaft ending exactly at the top face, a cone printed a hair fat
stands the shoulder proud. The charm then tightens on the pin, not the bar,
and rattles. The male is rotated `−cn_sink/pitch·360` so its phase stays
referenced to the seat face, like the charm's. Without that, every
screw-path harness step collides. That is a phase artefact only; a real
charm just catches at another angle. Charm bore 5.5 (0.5 dead depth past the
male's tip), 45° coned end, apex 7.75, `cn_need` 8.75 ≤ heart 9.2 (also
asserted over the bore's rim).

**Checks (the lying pin, superseded below):** pin 6.7 × 9.1 × 5.1 lying, 1 shell, 35.4 mm², no overhang. Thin
flags: thread tip and start wedges, and the cone's rim knife (55° wedge),
all accepted. Heart-cone 1 shell, 306 mm², one BRIDGE (the groove's
truncated top), thin flags at the thread's ends. Band c3-cone: 11 shells,
genus 34 (31 + one through-hole per station), 1697.9 mm² in 11 islands, 40
BRIDGE (= the plain band). Plain, -w180, -c3, pin and heart exports are
byte-identical.

**Harness** (scratch: `band.scad` = bracelet.scad with includes made
absolute and the `if (accent)` tail cut; `station()` =
`difference(){union(){bar(5);charm_seat(5);} charm_station_cut(5);}` at
`-D mount="cone" -D charms=3`; the heart imported from its export at the
pin's axis; the pin moved down `d` along the screw path,
`rotate(-d/pitch·360)`):

| test | reads |
|---|---|
| pin ∩ station seated / up 0.05 / down 0.05 | 0-vol sheet z 0.10–3.05 (the long cone) / 0.441 / empty |
| pin ∩ heart along the path, d 0 … 5.3 | empty at every step |
| same, d 1.15 straight (CONTROL, no twist) | 2.37 |
| pin up 0.55 past seat | 0.067 at z 4.20–4.25: the shaft's shoulder, 0.5 under the face |
| heart ∩ (station + bars 4, 6) seated / dz −0.2 | 0-vol sheet / 34.4 |
| bar 6 (+x) swung vs station: ±24 / ±60 / ±100 | empty |
| … at 115 / −115, station vs plain bar(5) (CONTROL) | 0.375 vs 0.545 / 4.05 vs 3.09 — binds where the hinge does |
| fill probes, 0.5 × 0.2 × 3 boxes: +x at x 6.0 y 1.5, x 7.0 y 0; −x at x −4.5 y 0 | solid / solid / empty (open) |

Not run: a slicer, the layer raster. **Printed 2026-10-05: "Printed good"** — band, pin and heart as exported (M5, long 12.9° cone, +x gap filled, bevels kept).

**2026-10-05 (later): pin STANDS UP, hex socket, foot deeper — UNPRINTED.**
The user asked for the pin to print vertically with "a hole for a hexagon
screwdriver" in the bottom. The bottom stays ROUND: I first asked about a hex
key in the bar or a hex head, and both were wrong. They also asked for it "a
bit shorter, so the pin sits fully inside the bracelet". That means the foot
goes deeper (`cn_recess` 0.1 → 0.4). The thread is unchanged.
`cn_flat` and its asserts are gone; `cn_pin_printed` stands it on its
foot. The socket takes a `cn_key` 2.5 key: 2.8 AF (`cn_key_fit` 0.15), 2.5
deep, a `$fn=6` cone end (45° at the corners), 0.3 lead-in at the mouth.
The cone's wall at the corners is 1.07 at the socket's top (asserted ≥ 0.8).
The foot's rim is chamfered 0.3 × 0.45 (`cn_foot_ch`/`cn_foot_cz`): on a
12.9° cone, a 0.1 elephant's foot at the rim would lift the pin ~0.44.
Pin 6.3 × 6.3 × 8.8, 1 shell, 21.4 mm², adhesion 1.9. One BRIDGE at z 3.3+
(the male's −z flanks, 53° from vertical, 0.4 deep). Thin flags at the
thread's ends, as before. Fit vs `cn_bar_cut`: seated = 0-vol sheet z
−3.35…−1.15, down 0.05 → empty, up 0.05 (CONTROL) → 0.457. Band and heart
are untouched; neither reads the pin's foot.

**2026-10-06: socket → 3 mm key, tight — UNPRINTED.** The 2.5 socket didn't
fit the user's screwdrivers. The user said "switch to 3 mm, and reduce the
clearance to minimum". So `cn_key` 3.0, `cn_key_fit` 0.05 (3.1 AF). I read
"minimum" as the least that still lets a key in, not 0. The depth stays 2.5.
The corner wall is 0.89 at the socket's top (≥ 0.8 asserted). That wall is
the source of the extra 0.8–1.2 thin flags; nothing new under 0.8. 19.8 mm²,
1 shell, same one BRIDGE. If the key jams, raise `cn_key_fit` first.

## The screwdriver — 2026-10-07, UNPRINTED

"A screwdriver that a kid can use to attach and detach charms": a hex key
for the cone pin's foot socket (`cn_key_af` 3.1). `models/screwdriver`,
export `screwdriver-screwdriver`. Prints LYING FLAT (bit on a flat, layers
along it for torsion). Bit `cn_key − 2·key_fit` = 2.9 AF, 4.0 long, 0.3 tip
chamfer; round shaft r 4 cut flat at the bed; a 32 mm teardrop paddle 8
thick with a 6 mm string hole. 65 × 32 × 8, 1 shell, 1033 mm², no
overhang, wall ≥ 2.9.

Fit harness (scratch: the file with its include absolute and the call
stripped; tool turned bit-up, `rotate([0,0,90])` to match the socket's
`$fn=6`, tip at `cn_base + d`, ∩ `cn_pin()`): d 2.5 EMPTY; dx 0.1 EMPTY;
CONTROLS dx 0.2 → 0.49, spin 30° → 0.32, d 2.85 → 0.05 (the cone end).
In zsh, build `-D` lists in bash arrays — word-splitting trap again.

## Mounts removed — the bolt is the only one since 2026-10-18

In order, every mount before the bolt, all removed at the user's request (git
history has each one; do not offer any of them again as they were):
- **Ball pin** fused to the bar with clip-on socket charms, and a loose
  double-ended **M4 screw** (the star): both printed and worked, removed
  2026-09-24 in favour of the H-pin.
- **H-pin** (2026-09-22 .. 09-28, 52b3f3b): a flat H, crossbar sunk in a
  pocket in the bar, hooked legs into two gabled holes in the charm. Printed
  many times; held in the charm, kept pulling out of the bar. Lesson that
  still applies: a printer rounds a 0.4 mm catch off, so do not tune a snap
  on spring force alone.
- **U-pin** (4b8d994, never printed, four parts too many), **twist-key**
  (PRINTED AND FAILED — "the key is small, it deformates easily and doesn't
  sit in the holes"), **slider** (disliked, never printed): rolled back
  2026-09-29.
- **Dovetail H-pin** (0d41592 .. f547bb7): the H's top half on a dovetail
  that slid across the band into a bar groove and clicked on a spring leaf.
  Printed well; deleted 2026-10-18 with `lib/charm-dovetail.scad`,
  `lib/charm-pin.scad` and `models/pin`.

Harness traps from those rounds that still apply to any harness here:
- **OpenSCAD writes NO file for an empty result**, and an assert that fails
  exports nothing either. Delete the old output first and treat a missing
  file as its own result; always keep a control row that must hit.
- **In zsh, `set -- $c` does not word-split.** A sweep built that way passed
  a malformed `-D` and read "empty" everywhere. Use bash arrays.
- **Never `include` two charms in one harness**: they share names (`span`,
  `x0`, `relief`…) and the second silently overwrites the first.
- **`use <>` carries neither `$fa`/`$fs` nor top-level variables.**

## The band is 16.2 mm wide since 2026-09-26 — unprinted

The user asked for a narrower bracelet and chose the narrowest band the
current H-pin allows over thinning the pocket's end walls or shrinking the pin
(which would remake every charm). **`row_pitch` 11.6 → 10.2, band 17.6 →
16.2.** The limit is the existing assert `band_w/2 - hp_out >= 2.0`, and
`hp_out` is **6.10**, not the 5.95 the lib's comment said: the legs moved 0.1
out with the bigger hooks (`hp_uo` 5.10). Both comments are fixed. The pin and
every charm are unchanged, so printed pins and charms fit.

Nothing along the band moves: 130 is still 11 bars at 11.71, 151.3 mm flat.
The knuckle clusters sit at y 0 and 10.2, so the gap between them is 4.2.

Verified:
- 130 and `charms = 3`: 11 shells, genus 31; 180: 15 shells, genus 43.
- `check_overhangs`: 40 BRIDGE (46 at `charms = 3`), no SUPPORT. Bed:
  **1752.2 mm²** in 11 islands. Wall check: the same stud-rim and keyhole
  artefacts as before.
- H-pin in bar 5: seated 0.0000, dz +0.10 empty, +0.25 0.3920, −0.05 0.8079,
  dz 0.05 dx 0.12 empty / 0.20 0.7407.
- Swing harness (exported charm STLs imported on bar 5, bars 4 and 6 turned
  about their pin axes), run at 16.2 and 17.6 side by side: heart (0° and 90°),
  rose, ladybug and butterfly are all clear in the wearing direction to 80°.
  The flat-bottomed charms hit backwards at −2° on both widths. Butterfly
  control: clear at −40°, hit at −50° on both.

## Bigger detent bumps on a tapered leaf — 2026-09-26 — HISTORY, the stud + keyhole is gone since 2026-10-18

The user asked for the buckle's "hooks" to be bigger, so opening it takes some
effort. The hooks are the two detent bumps. **`det_pinch` 0.15 → 0.30.** On
the straight 1.0 × 2.8 leaf that would strain it far past the proven 2.9 %,
and a straight leaf lengthened to stay at 2.9 % gets SOFTER (at fixed strain
side force ∝ w²/L). So the leaf **tapers**: `leaf_root` 1.6 → `leaf_tip` 0.8
at the bump, `leaf_free` 3.9. `leaf_strain` is now computed as a beam sum over
the taper (it reduces to the old formula for a straight leaf): **2.894 %**.
New echo `leaf force` = side force against the printed leaf: **1.85×**. With
the steeper bump (and μ 0.3) the modelled peak opening push is **~2.2×**.
Treat that as a ratio, not newtons. The last real lesson says catches get
rounded off by the printer.

What moved: `kh_w` 10.4 → **11.6**; `det_off` 0.70 → 1.04 (still solved to
cradle the seated post); travel 4.12 → **4.56**; buckle 17.24 → **18.88 mm**
fastened. The band exports all changed (the solver re-divides the run): 130 is
still 11 bars, pitch 11.71, **151.3 mm** flat; **180 is 15 bars again**
(11.94). The pin and all charms are byte-identical, so they still fit.
The relief is now three hulls: a tapered run, a straight run at `leaf_tip`,
then the radial turn-in.

Verified:
- shells == cols and genus = formula at every wrist 110–230; genus 31 at
  `charms = 3`, 11 shells.
- Clasp harness vs the old file, side by side: seated dx −0.05 … 0.25 reads
  the same pattern (far wall 0.0460 at 0.17, 0.4069 at 0.25, lift 0.05 →
  0.011 in both). Post centred on the bumps: 0.534 mm³ (was 0.179). It is
  clear again by dx −2.5, well before the entry. Fastening dx +0.25 is empty
  at dz 0/0.8/1.6/2.4/3.2. The control dx −0.25 gives 4.6387 = 0.25 × 11.6 ×
  1.6, and dx 0 is empty.
- `check_overhangs`: 40 BRIDGE, no SUPPORT (unchanged). Bed: 11 islands,
  1828.1 mm².
- Keyhole plate alone, under 0.78 mm: only the pointed FREE END of each leaf,
  where the entry hole's arc cuts it past the bump. The old plate had the same
  cusp, sharper (0.01 vs 0.06). It has no job.

If it is now too stiff to close, lower `det_pinch` to 0.25. The leaf only
gets less strained.

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

## Seven models, one library, `cols` shells

`models/bracelet/bracelet.scad` is the bracelet, and every dimension of the band
is at the top of it. `lib/charm-cone.scad` holds the charm mount — the bolt
(cone pin), the bar's hole, countersink and rib, and a charm's socket and
grooves. `models/cone-pin` is the bolt, `models/screwdriver` its hex key, and
`models/butterfly-charm`, `models/ladybug-charm`, `models/heart-charm`,
`models/rose-charm` and `models/dolphin-charm` are the five charms. The lib
draws nothing — variables, functions and modules only — so every model
`include`s it.

**The bolt is the ONLY mount** (2026-10-18). Every earlier one is listed
under "Mounts removed"; do not bring any back or propose them as options.

`charms` in `bracelet.scad` sets how many bars get a station. At `charms = 0`
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
openscad -o /tmp/p.stl models/cone-pin/cone-pin.scad && cmp /tmp/p.stl exports/cone-pin-cone-pin.stl
openscad -o /tmp/s.stl models/screwdriver/screwdriver.scad && cmp /tmp/s.stl exports/screwdriver-screwdriver.stl
openscad -o /tmp/f.stl models/butterfly-charm/butterfly-charm.scad && cmp /tmp/f.stl exports/butterfly-charm-butterfly-charm.stl
openscad -o /tmp/l.stl models/ladybug-charm/ladybug-charm.scad && cmp /tmp/l.stl exports/ladybug-charm-ladybug-charm.stl
openscad -o /tmp/h.stl models/heart-charm/heart-charm.scad && cmp /tmp/h.stl exports/heart-charm-heart-charm.stl
openscad -o /tmp/r.stl models/rose-charm/rose-charm.scad && cmp /tmp/r.stl exports/rose-charm-rose-charm.stl
openscad -o /tmp/d.stl models/dolphin-charm/dolphin-charm.scad && cmp /tmp/d.stl exports/dolphin-charm-dolphin-charm.stl
```

**The ladybug's export is NOT byte-stable** (found 2026-09-25). Two fresh
exports of the same unchanged file differ, with the same volume and bbox: the
triangle order changes run to run. Compare its VOLUME and bbox instead,
1077.6452 mm³. Everything else above is byte-stable, and a `cmp` difference
there is a real change. That includes the heart, which is one polyhedron. Its
first, hull-built version was not stable.

**Everything the lib defines is named `cn_*`.** That is not tidiness: this
file already has a `pin_d`, `pin_r`, `pin_z` and `pin_flat`, and they are the
HINGE pin. A second thing called a pin in the same namespace is how a silent
shadowing bug gets written.

The bracelet export must be **`cols` shells** — 12 at the default size, 16 at
180 — one per bar, with the socket block and the knob part of the two end
bars. Anything else means a piece came free.

**Genus is the second invariant**, and it is worth computing rather than
memorising. OpenSCAD reports `1 - p + sum(genus)`:

| contribution | count | at the default |
|---|---|---|
| pieces `p` | `cols` | 12 |
| blade bores | `rows * (cols-1)` | 22 |
| fork loops — body → lug → pin → lug → body encloses a hole | `rows * (cols-1)` | 22 |

`1 - cols + 2*rows*(cols-1)` = **33** at the default (45 at 180, 16 bars),
at every `wrist` from 110 to 230. The T on rails adds no hole: the cut is open
at the block's front through the neck slot, and each detent leaf's slot runs
into the pocket through its cross slot. (The old keyhole added 1.) An extra
hole means a cross slot stopped reaching the pocket — that leaf would be
rigid.

**A charm station adds one hole (its bore) and no shell**: `charms = 3` reads
genus 36 and 12 shells at the default.

A connectivity checker reporting "12 disconnected pieces ... will NOT print as
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
- **The first layer**: 1578.1 mm² in 12 islands at `charms = 3` (the
  countersinks open on the bed and take their rings out of it; 1629.8 plain).
  Before 2026-10-18 (stud + keyhole, 11 bars): 1697.9 / 1812.5.
- **The swing test with a butterfly seated**: clear to ±40°, binds at 60°, at
  both 130 and 180 (a wrist needs about 24°).

**Stations: the middle bar, then every `charm_step` = 3 bars either side**
(asked for 2026-09-27; `charms` must be odd, asserted). At 130 `charms = 3` is
bars [2, 5, 8], 35.1 mm apart; it used to spread them evenly, which gave
[3, 5, 7] — every second bar, 23.4 apart. An even `cols` has no middle bar;
the pattern then sits half a pitch toward bar 0 (`floor`). 5 charms need
≥ 15 bars. The re-check at `charms = 3` read the same shells, genus, bed
(1752.2 in 11 islands) and 46 BRIDGE as before; the middle station is still
bar 5, so the charm-seated swing tests there still apply.

**A flat-bottomed charm may not reach past r = 5.8 from its bar's centre.** The
band's top is a plane while it is STILL — `thick` is `pin_z + rk`, so a knuckle
crest reaches exactly a bar's top face. Turn the joint and the knuckle's ARM,
the full-height rectangle behind the cap, tilts its top edge up above that
plane. Swept with a plain disc at `thick` against the real band: clear to
r = 6.0 at 24° and 30°, r = 5.8 at 40°. The butterfly is long across the band,
right over the knuckle clusters, so its bottom stays within |x| ≤ 5.0 and is
relieved beyond (see below).

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
  closest stations are 35.1 apart (23.75 before 2026-09-27), so two ladybugs clear.
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
- Spacing: at `charms = 3` and 130 the stations are 35.1 apart (23.75 before
  2026-09-27). Two hearts at 0° are 23.0 wide along the band: ~12 clear.
- Harness: one per charm (`band.scad` with the `if (accent)` tail cut,
  `heart.scad` with `heart_charm();` stripped, both includes absolute).

## The rose charm — added 2026-09-26, printed and confirmed the same day

**Printed and confirmed by the user on 2026-09-26** ("Printed good"), so the
0.9 mm petals, the fused overlaps and the 0.4 ring gaps are proven. Treat its
shape and numbers as proven.

Asked for as "a rose, with thin fluffy petals". Same H-pin holes
(`charm_h_holes`), same pose (seat down), flat bottom to the edge. **The lib
and the band were not touched.**

- **Structure.** A solid core (r 8.0, side 6.6, dome to 7.6) holds the
  holes. `rings` is a table, one row per ring: a 3-petal bud around an open
  middle, then 5, 5 and 6 petals. Each petal is ONE polyhedron: a shell
  whose inner face is r(θ, z) = shingle + closed-form flare (lean linear in
  height) + a pleat, with thickness `petal_t / cos(lean)` outward. Every
  horizontal slice is an arc, so the inner face only faces up, and the
  outer face's lean is asserted ≤ `flare_max` (the pleat's slope included).
- **The grazing trap. This is the reason the source is shaped the way it
  is.** The first version was four rings with big shingle steps, and it
  looked best. But its petals crossed each other at shallow angles near the
  lip: neighbours' pleats rippled in opposite phase, and ring bands
  interleaved. The wall check flagged 0.3 mm slivers. A petal-pair scan
  found gaps down to −0.46 and thousands of samples of slit narrower than
  0.4 that persisted over height. The rules that fixed it, all asserted:
  - Within a ring, the overlap step leaves neighbours sharing ≥ `ring_fuse`
    (0.3) of wall. They are FUSED, never grazing. Going "apart" instead
    needs a ≥ 1.7 mm step, which made the rose 25 mm across.
  - The pleat lives only in the part of a petal no neighbour shares (`lap`).
  - Ring bands never interleave. The next ring's `r_start − pleat` sits
    ≥ `ring_gap` (0.4) outside this ring's `r_end + t + pleat`.
  - The outer ring's web runs up the core's whole side (6.6). At 4.4 the
    petals peeled off the vertical core wall at a 6° lean, a slit that
    stayed under 0.4 mm for 2 mm of height.
  A single Archimedean spiral of petals was also tried. It came out
  lopsided, crenellated and showed the core. Do not re-propose it.
- **The gap scan** (`dump = true` echoes every petal record). At every 1° and
  0.1 mm it collects each petal's wall interval plus the core. It flags air
  gaps under 0.4 that are still narrow 0.5 mm higher at the same radius.
  Every V-groove is narrow at its bottom, so a gap that is merely narrow is
  not a finding. It also flags near-coincident faces of overlapping petals.
  Now: **0 persistent, 0 near.** Control: the first version's table, with
  `ring_fuse`/`ring_gap` at −9, gives 4410 persistent and 48 near.
- **The bud's middle is open (r 1.3).** Petals starting at r 0.55 pinched
  one another into 0.02 mm slivers near the axis. A solid centre column
  fixed that, but grazed the bud petals in its turn.

**Invariants:**

- 1 shell, genus 0, 22.1 × 22.4 × 10.5 (echo: 22.68 across at the lip),
  vol 2506.600, byte-stable. **262.6 mm² in 1 island**, adhesion 0.6.
- Wall check `--nozzle 0.4`: min **0.82** (petals, 0.9 nominal). At the
  default 1.2 it flags the petals, which are thin by request.
  `check_overhangs` clean. `asin(|nz|)` scan: 0.000 mm² past 45°, and a
  1 mm² control ceiling reads 1.000.
- Envelope test (holes ⊕ sphere 1.15, z > 0, minus `rose()`): empty at
  nominal and at shifts of dx/dy ±1.0, dx 2.0, dy 2.0, dz −0.3. It leaks at
  dy 3.0 (9.2 mm³) and dz −1.0. The roof margin is 0.3–1.0; sideways it is
  over 2 mm.
- Pin harness: seated, dz +0.10 and dx/dy ±0.12 empty. dz +0.25 → 0.0015,
  +0.30 → 0.0262, +0.40 → 2.284, dx 0.20 → 0.3992. **The heart reads the
  identical numbers in the same harness.** The heart section's "dz +0.25 →
  0.224" is stale; it most likely predates the bigger hooks.
- Band (`charms = 3`, middle station): charm ∩ band 0.0 seated, 31.5 mm³ at
  dz −0.3. Wearing swing clear at 24/40/62/70/90 at 130 and 180. An exact
  60 reads a 0.0 coincidence, as for the heart. Backwards: **HIT from
  0.5°** (0.12 / 0.33 mm³), the heart's trade.
- Two roses at `charms = 3`, 130: stations 35.1 apart (23.75 before
  2026-09-27), so they clear by ~13.

## The dolphin charm — added 2026-09-27, unprinted (links hidden the same day)

Asked for as "an articulated dolphin", from a photo of a chubby flexi dolphin
(big round head, fin, flippers, two tail rings and a fluke). Same H-pin holes
(`charm_h_holes`), same pose (seat down), flat bottom to the edge. **The lib
and the band were not touched.**

- **Layout.** Spine along y (across the band), head at −y. The holes need a
  rigid block 14 mm long and 6.4 mm tall, so the CARRIER is head + body + fin
  + flippers in one solid. `joints` = [10.7, 18.2, 25.7]; the last segment
  carries the fluke. The first joint sits right at the band's edge, so the
  tail hangs past it.
- **Reworked the same day on request: "The tail should be raised up... use
  rings, to make it possible to move in all directions."** Asked, the user
  clarified that ONLY THE FLUKE ("rear fins") is raised. A raised tail of loose
  segments cannot print: each segment's first layer would be in the air, at
  any angle. Do not propose raising the segments themselves.
- **The joint is a chain link (replaced the post-and-ring hinge, which only
  wagged about a vertical axis).** A (front) ends in a WALL (`wall_t` 1.4)
  with a slot (`slot_w` 2.8) through its full height; a CROSSBAR (z 1.5–2.7)
  bridges the slot. B (rear) reaches forward in a closed LOOP (`loop_w` 1.8):
  a bottom rail on the bed (`rail_h` 1.0), an upright in a through-POCKET in A,
  and a top rail from z 3.2 up to the body's surface. Every clearance is 0.5
  (`bed_gap` sideways, `v_gap` vertically). Nothing is cantilevered: the
  crossbar is a 2.8 bridge between A's wall halves, the top rail a ~3 mm
  bridge from the upright to B's body.
  - **Facing surfaces are cones round the joint axis** (0, s, `z_c` 2.1), each
    `bend`/2 = 12.5° back from square. Turned `bend`, one lies parallel to the
    other. A's rear is FLAT out to `a_flat_r` 2.5 before its cone starts. A
    cone right to the axis thinned the wall beside the slot to 0.02–0.3 mm and
    left two zero-area bed patches. The flat costs ~1° of bend.
  - **A's pocket is the upright swung ±`bend` in plan, grown `bed_gap`, and
    STOPPED at the wall's front face.** Grown into the wall it made the same
    slivers.
  - **B's loop is clipped, in side view, to a disc (`loop_r` 2.9) round the
    joint axis.** Under the tall head a square upright's top corner hit the
    pocket front at 20° of lift. With the disc, lifting or dropping the tail
    never swings the loop's front forward. So under the head, B's loop tops
    out below the body surface, visibly.
- **The fluke tilts up `fluke_a` = 50° about its root** (`fluke_root`, the
  outline's min y). `inflate()` gained `lift`/`root`/`skirt`. The plan is
  shortened by cos and each point raised by sin × distance behind the root, so
  it stays a height field over a flat underside 40° from vertical. 50, not 45:
  faces on the threshold flicker in the checks. The skirt (the rim's vertical
  thickness, cut off by the bed when flat) is `fluke_skirt` 1.6. At 1.0 the
  leading edge read 0.3 mm. The tail stock's last rows were shortened
  (ends at 30.2) so it ends INSIDE the raised fluke (asserted), not as a stub
  under it.
- **Nose and fins, reworked the same day on request** ("nose sharper, the
  fins smooth, without any kinks... do not be afraid to make it wider").
  The beak runs on to a rounded point at s = −16. The flippers and the fluke
  were hulls of three ellipsoids, creased where one took over from the next.
  Each is now ONE `inflate()` surface, the heart's method: a closed
  Catmull-Rom spline through `flip_pts` / `fluke_pts`, with every ring that
  outline scaled toward `*_mid` on a superellipse profile. The star-shape is
  asserted, so the surface is a height field. The fluke must stay ≥ 0.5 in
  front of the last joint's A side (asserted). `inflate()` came out INSIDE
  OUT first (flippers −178, fluke −284 signed volume); the export said
  `NoError` and genus 1, and the total volume FELL as the fins grew. That
  fall is what gave it away.
- **Two harness traps, both hit here.** The envelope polyhedron's flat bottom
  lying ON the z = 0 cut left eight zero-thickness 4-triangle sheets
  (connectivity: 12 pieces); it is now carried 1 mm under the bed. And the
  first winding was inside out (signed volume −3038): the export still said
  `NoError` but fused carrier to segment 1 and left a crumb in a pin hole.
  Check the signed volume of any new polyhedron.

- **Fluke swept back, later the same day, on request** ("the tail fins are
  opposite to each other... maybe 120 degree"). The lobes read ~158° apart
  from above: the 50° tilt shortens their sweep by cos 50. `fluke_sweep` 0.6
  shears the half outline back by 0.6 × x, so the centreline and
  `fluke_root` do not move. That gives ~122° IN PLAN. The trailing-edge
  points moved back 0.4–0.9 to give the sheared lobes their chord back.
  Then "the tail is too big now": **`fluke_scale` 0.75** scales the swept
  outline about the root (y 27.3), so the V angle is kept. The span is now
  17.9.
- **Dorsal fin reshaped from a photo** of a real dolphin's fin (first
  enlarged: tip 11.8 → 13.0). The two-value `fin_z/le/te/t` became the
  `fin` table: rows [z, leading edge, trailing edge, half-thickness],
  sampled on an open Catmull-Rom spline (`fin_n` per row). The shape is a
  long, convex leading edge from s −6, a tip that curls back (the
  trailing edge moves back 3.9 → 4.95 over z 10–12.9; asserted ≤ 40° per
  sample), and a concave trailing edge running into a fillet at s 6.4. The
  "runs into the first joint" assert now takes the max trailing edge. Traps:
  - A half-thickness of 2.3 at body level stood proud of the falling back as
    a visible collar; it is 1.45–1.55 there now.
  - The rear root row must stay under the body (z 7.4 at s 6.4, body 7.48).
    At z 7.6 it poked out 0.15.
  - A half-ellipsoid dome on the top slice is vertical at its equator, and it
    read as a knob. The cap is now an ellipsoid cut at 0.8 of its height
    (`fin_cap` 0.35), so it meets the sides at a slope.
  - The fin's front now covers s −4, so **the blowhole moved −4.0 → −7.0**
    (it was cutting into the leading edge).

- **Beak reshaped from a photo**, the same day: a rounded melon whose
  forehead slopes down to a crease (s −12.1), then a slim rostrum 1.5–2.2
  tall and 2.6–3.5 wide, tapering to a rounded point at s −16.8. Only the
  `body` rows in front of s −8.8 changed (−8.8 itself 7.0 → 6.8 tall). The
  first try dropped the forehead almost vertically onto a thin stub; the
  photo's forehead slopes at ~45°. The body is a height field, so any
  profile here prints. Hole envelope (`charm_h_holes()` ⊕ sphere
  `hp_wall − 0.05`, z > 0, minus `dolphin()`): empty nominal, dy −1.5 and
  dz −1.0; leaks at dz −2.2 / −3 and dy −10 (controls).

- **Fullest at mid-torso** (later, from a silhouette picture: "the widest
  part should be closer to the middle of the torso, rather than the head").
  Height and width used to peak at s −2 (the "head's crown", 8.7 / 7.1).
  Now they peak at **s 3.5, under the fin**, at the same 8.7 / 7.1. The
  head swells from the crease with its growth rate ONLY EVER SLOWING. A
  first table where one row grew slower than the next left a visible ridge
  round the forehead, because the Hermite overshoots. The fin rows were
  raised ~0.6 at the rear (the body is taller there, and the fillet would
  have been buried) and moved back ~1.4 at the front. The root row was
  dropped to z 6.8 so it stays under the lower head.
  - **Costs: the head is now low over the pin holes.** The envelope test
    (below) is empty at nominal and dz −0.6, and leaks at dz −1.0 (the
    margin was 1–2.2). The old blowhole (s −7.0, 0.8 deep) cut INTO the
    hole's wall: it leaked at nominal, and the wall check read 0.31 there.
    It is now **[−7.6, 0.5, 0.5]**, which stays empty at depth 1.0 and at
    s −7.2. Do not lower the head any further without re-running the
    envelope test.

- **Links hidden, 2026-09-27 (last), on request**, from a flexi-dolphin
  photo whose tail segments nest like rings ("make links between moving
  parts hidden"). The chain link is unchanged in kind. The joint around it
  changed:
  - **A roofs its pocket and slot** (cut only up to `z_roof` 4.3, no longer
    through the top) and its skin runs on `hood_d` 1.8 past the joint as a
    **hood** over B's **nose**. The seam is a groove with B's nose at the
    bottom.
  - **Why the nose and cavity are solids of revolution about the joint's
    VERTICAL axis.** A hood can only overlap B if the surfaces under it are
    invariant under the turn. A nearly-square face (the old cones) cannot
    slant backward over B. So under the hood everything is round about the
    upright axis (yaw is free), and flat on top (nose top `z_n` 3.8 under
    the roof at 4.3). That flat-on-flat is what limits pitch to ~12°. The user
    accepted that before it was built ("±10–15° up/down").
  - The cavity radius is solved per height (`cav_r`): `hood_t` 0.9 of wall
    inside the body over y ∈ [wall, hood_d], `roof_min` 0.8 of roof over
    the flat ceiling's edge, and never narrowing upward faster than `cav_a`
    40° from vertical, so the ceiling is a ramp, then a bridge. The nose is
    the cavity `offset(-bed_gap)`.
  - **B's shoulder** (its body behind the groove) is an ELLIPTIC cone about
    the joint centre: y ≥ `sh_d` + norm([x tan(bend), dz tan(nod)]), with
    `sh_d` = (hood_d + gap)/cos(bend). This is the exact limiting case of
    rotation safety against a SQUARE hood rear face. Split angles
    (A's rim slanting forward too) fail at large radius. A plain round cone
    (tan(bend) in z too) left the segment core 0.5 thick between the shoulder
    and the next pocket; `nod` 15 fixed that.
  - Beyond `reach` (the hood's farthest point from the joint centre) AND
    outside the body's width, B is not cut to the shoulder. That spares the
    fluke lobes. Without the width limit the sphere left knife slivers at
    the body's bottom corners (134 wall samples at 0.0).
  - Consequences: `bar_t` 1.2 → 1.0, the top rail flat at `rail_t` 0.8
    (z 3.0–3.8), so z_c 2.1 → 2.0. `swing_room` 0.7 → 0.4 (pitch is roof-
    limited now), pocket front −3.1, `loop_r` 2.6. The loop's disc clips
    only its top half. The loop now ends at `loop_end` 1.7, inside the nose
    (asserted): at 3.2 its tail stuck into the groove as a visible plate and
    added a genus. The tail rows s 13–29 were fattened (≈ +0.4 wide, +0.5
    tall at the rear joints) for the roof (asserted).
  - **The fluke moved back `fluke_back` 1.6** (tail stock rows too), so the
    last shoulder does not cut its root. That cut left 0.0–0.2 knife edges.
    Asserted against the outline. Control: `-D fluke_back=0` fails it. Only
    the last segment gets the fluke (`dolphin(with_fluke)`), or segment 2's
    hood kept a fluke sliver. The dolphin is now 52.5 long.

**Invariants (after hiding the links):**

- **4 shells** (carrier + 3), genus **3**. 29.84 × 52.47 × 13.55,
  vol ≈ 2585.6.
- Bed: **480.9 mm² in 4 islands** (359.1 / 47.5 / 45.7 / 28.5). Each nose
  joins its shoulder above the bed and on it: still one island per segment.
- `check_overhangs`: **9 BRIDGE**: crossbars z 1.5, top rails z 3.0, hood
  roofs z 4.3 (5.5–7.1 span). No SUPPORT, no lifted features; the 40°
  ceilings are not flagged.
- Layer raster (same method): only z 1.513 (8.40 mm²), 3.113 (9.88) and
  4.313 (40.35, the roofs). The roof's anchors are A's hood/pocket walls,
  on the bed. The y 27.4 section shows the arch continuous over the nose.
- Joint harness, all three joints: rest empty; yaw ±23 empty, 35 HIT;
  pitch ±12 empty, −16 empty, +16 HIT; diagonal [1,0,±1] 15 empty; roll 10
  and 15 empty; dx/dy/dz ±0.4 empty, dz +0.7 HIT.
- Wall check `--nozzle 0.4`: 28 samples (the original had 26). The flipper
  tip (0.40–0.78), the fluke's rim and lobe tips (0.54–0.8), the top rails
  (0.80). Two samples read 0.03 on the last hood's rear rim edge
  (y 27.5, x ±2.5, z 3.6–4.1). The section there shows ≥ 0.9 of wall, so
  this is edge sampling.
- **Seen from outside**: at rest the link is invisible from the top, sides
  and 3/4. At a near-full sideways bend (20° + 8° up), looking straight into
  the open side of the groove, the loop's rails can be glimpsed deep in the
  hood. That is inherent (the nose swings aside in the cavity), and the
  README says so.
- Not re-run: the pin harness and the band swing. The carrier's front and
  holes are unchanged; the pocket front is now 7.6 (assert ≥ 7.16).
- Two dolphins at `charms = 3` clear by ~5 mm since 2026-09-27 (29.8 along the
  band, stations 35.1 apart; 3.5 at `pitch_min`). They collided at 23.75.

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
  length (18.88 mm fastened, 4.56 mm of travel at every size — see "The
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
- *(Stud + keyhole, history.)* **`leaf_free` + the relief reaching the entry hole.** The detent leaves must
  be **cantilevers**. Built in at both ends at this length they need ~50 N,
  which is a jam, not a clasp; as cantilevers, ~6 N. There is an assert, and
  the genus (one keyhole hole, not three) is the second witness.
- *(Stud + keyhole, history.)* **`tip_wall` = 1.8**, the plate left beyond the keyhole seat. It carries the
  entire clasp load. An earlier version left 0.8 mm there.

## The clasp — reworked 2026-09-22, printed and confirmed 2026-09-23 — HISTORY, replaced 2026-10-18 (now the T on rails)

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
- *(Superseded 2026-09-26 by the tapered leaf, top of this file.)* **The leaf is 1.0 × 2.8, not 0.8 × 2.5**: same root strain (2.87 % vs the
  printed 2.88 %, asserted ≤ 2.9 % as `leaf_strain`), 1.39× the force
  (∝ w³·pinch/L³). A deeper pinch was the rejected alternative — it overstrains
  the leaf.
- **The buckle was 17.24 mm fastened, from 20.5** (18.88 since the bigger bumps). `kh_entry` = `kh_wall` (1.0)
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
| fastening, dx −0.25 (control) | solid, 0.25 × 11.6 × 1.6 (10.4 before 2026-09-26) — the tip against the stud bar |

That last control is also the measurement: the tip reaches the bar face
exactly at dx 0.

## Traps already hit here

- **A brim welds every hinge shut.** The feet are 0.6 mm apart. Never recommend
  one, and never a raft either.
- *(Stud + keyhole, history.)* **The buckle no longer absorbs the sizing remainder — the joints do.** It is
  pinned at `kh_travel_min`, which puts it right on the edge of the trap below,
  so any change to `entry_d`, `det_off` or `det_r` moves that edge and must be
  swept. Do not restore the long plate to "simplify" the solver.
- *(Stud + keyhole, history.)* **The entry hole eats the detent bumps on a short keyhole plate.** Bring the
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
   in "Seven models", then the rib harness in the bolt section at the top
   (every 45° a contact sheet; 22.5° and dz −0.2 must hit). If the charm
   stations were touched, re-run steps 1–6 at `charms = 3`. If a charm
   changed: connectivity (1 piece; the dolphin 4), wall thickness outside the
   thread, bed stability (1 island), the `asin(|nz|)` scan (nothing past
   45.5° but the socket's apex and the groove gables), the swing test with
   it seated, and a render of its underside.
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
