# CLAUDE.md — bracelet

Project-specific guidance for AI agents. The repo-root `CLAUDE.md` still
applies; the rules here are bracelet-only and win where they add detail.

## The dovetail H-pin — 2026-09-30, UNPRINTED. The only mount

The pin's BOTTOM is a dovetail that slides across the band into a groove
through a station bar and clicks (a lip on a spring leaf in the groove's
floor, a pit under the pin). Its TOP is the H-pin's upper half, exactly
(`hp_pin_2d` above `hp_cb_bot`), so **every charm's `charm_h_holes` fits
unchanged: no charm file changed**. `lib/charm-dovetail.scad` (`dt_*`)
includes `lib/charm-pin.scad` (`hp_*`). The H's lower legs, lower hooks and
`charm_h_pocket` there are dead code the band no longer uses.

**How it got here (the user's decisions, 2026-09-29/30):**
1. The user sketched an hourglass pin: dovetail into the bar, dovetail into
   the charm, lip + pit. With both dovetails parallel, no rigid stop keeps
   the charm on the pin. Anything slid on can slide back off, and a blind end
   and a shoulder stop the SAME direction. I first offered a "stepped head"
   that I claimed locked it, and had to retract it.
2. So it became CROSSED (top dovetail along the band) with a tooth on the bar
   top in a slot under the charm. The user then said the top "doesn't
   conform the charm geometry" and asked for the H-pin's top half on the
   dovetail bottom, printed horizontally. That is this pin; the tooth, the
   slot and the charm's dovetail groove are gone.

**Geometry that is forced, not chosen:**
- The H's crossbar sits at −0.3..−1.3 (as in the H-pin), so a CHANNEL
  (`hp_slot_x` 3.8 wide) runs across the bar top, 1.75 deep. It removes the
  top of any groove under it, so the dovetail is BELOW the channel: waist at
  −1.75, 45° flank to the foot at ±1.75 (`hp_t`/2), foot sides 0.55, pin
  bottom −3.05, floor/leaf 1.0.
- The foot's half-width = `hp_t`/2, so on its side the H's face and the
  dovetail's foot both touch the bed. The foot's straight side must be ≥ 0.5
  or the dovetail stands on a sub-bead line (asserted).
- The neck (2.0 × 0.8 along y) fuses the crossbar's middle. That shortens
  the spring: strain ×7/(7 − 0.8) = 5.5 % per charm (H-pin 4.9), grip +13 %.
  At 0.6 the neck flagged as a single-bead wall. The user was told 5.5 % in ABS.
- CHARM FIRST, then pin into the bar. In the bar the channel's floor blocks
  the legs: the release turn swings the legs' outer feet to −2.34
  (`dt_leg_foot`). Harness: turned rigid legs hit the bar from ~45 % of
  `hp_turn_up`, with the hooks still ~0.47 over their shoulders. So a charm
  cannot come off while its pin is in the bar.

**Checks:** pin 6.5 × 16 × 3.5 on its side, 1 shell, 36 mm² in 2 patches
(the foot strip 0.7 wide joins at 0.9 mm), no overhang past 45. Thin-wall
flags are the neck (0.8), the crossbar (1.0, the H's spring) and the walls
beside the pits (0.95), all accepted. Band c3: 11 shells, overhangs
identical to the plain band (40), plain band byte-identical. The heart,
imported from its unchanged export, was used as the charm in the harness.

**Harness** (scratch `h.scad` + `vol.py`, `intersection(){part(A);part(B)}`,
volume off the ASCII STL; bar = a 6 × 16.2 × 4.2 block minus `dt_bar_cut`;
"pindefl" turns each leg + half-crossbar outside the neck by `defl` ×
`hp_turn_up` about (±`hp_ui_g`, `hp_pivot`) and drops it `defl` ×
`dt_end_drop`):

| test | reads |
|---|---|
| pin UP ∩ bar / low 0.15 / CONTROL up 0.05 / CONTROL x 0.2 | 0-vol flank sheet / empty / 0.94 / 1.82 |
| pin ∩ lip seated / 1.5 from home | 0.22 (preload) / 0.97 (ride) |
| pin ∩ heart seated / pin low 0.15 | empty / 0-vol sheet at the catch (`hp_vfit`) |
| heart ∩ bar | seat sheet only |
| pindefl ∩ bar at 0 / 30 / 40 / 50 / 100 % | empty / empty / empty / 0.04 / 1.07 |
| pin + heart sliding in at 1, 6, 16 mm | seat sheet only |

**Not printed. Not checked in a slicer.**

## Mounts tried and removed — rolled back 2026-09-29

Three mounts came after the H-pin and all were removed at the user's request:
- **U-pin** (charm locked on a stem, a U-pin slid along the band, a lock
  tooth): committed 4b8d994, never printed. The user found four moving parts
  too many.
- **Twist-key** (a loose key twist-locks into bar and charm): PRINTED AND
  FAILED — "the key is small, it deformates easily and doesn't sit in the
  holes".
- **Slider** (the charm's saddle threads onto the plain band through a
  tunnel, clicks on a bar): the user didn't like it; never printed.

Don't offer these again as they were. The whole H-pin (below) printed and
held, but kept pulling out of the bar; its upper half lives on in this pin.

## Bar hooks like the charm's — 2026-09-28, PRINTED AND CONFIRMED ("Printed well")

The stiff pin printed: "sits quite good in a charm, but still loosy in a
bracelet". The user confirmed the pin *pulls out* (not a rattle), and noticed
the upper hooks looked bigger. They were: 0.85 past the wall on a 0.6 tip,
against 0.70 on a 0.3 tip. Offered: tip only (6.1 %), tip + longer hook
(~8 %), or a U-shaped longer crossbar (a redesign). **The user chose tip +
longer hook.**

- `hp_hook_lo` 0.85 → 1.00, `hp_tip_lo` 0.3 → 0.6, `hp_lead` 44 → 50.
  - At 44 this is 9.2 %. Going blunter to 50 lowers the hook on its short lever.
  - The assert is now `hp_lead <= 50`, and `hp_strain_cb <= 0.082`.
- Lever lo 1.51, insertion turn 32.2°, **strain 8.04 % going in** (per charm
  4.90, unchanged). `hp_keep` 0.33. `hp_out` 6.25.
- `bracelet.scad`: `band_w/2 - hp_out >= 1.8` (was 2.0). The end wall is 1.85,
  still thicker than the 1.1 beside the pocket. `hp_fill_u` 7.05 ≤ 7.1.
- Mouth `hp_mouth_v`/`hp_mouth_u` 0.6/0.3 → 0.8/0.5. At 0.6/0.3 the −33.2°
  leg hit it: 0.278 / 0.125 / 0.018 at lift 0 / 0.1 / 0.2. 0.8/0.45 still
  read 0.008 at lift 0.
- Upper half, `hp_c_out` and every charm are unchanged. Charms printed for the
  stiff pin fit.
- Harness: bar seated 0.0000, dz +0.1 / dx, dy 0.12 empty, dy 0.2 0.289.
  Release −19.67° lift 1.2 / 2.0 / 2.3: 0.594 / 0.391 / 0.069 (was 0.089 at
  1.2). 1.3× release at 1.2: 0.151. Insert −33.2° lift 0 → 3.3: empty; 0.9×
  (−29.0°) at 1.0: 0.024. Charm rows as below, unchanged.
- Pin: 12.2 × 6.9 × 3.5, 1 shell, no overhangs. Lower tip wall 0.98 (was
  0.68). Band c3: 11 shells, 46 regions, no SUPPORT. Accent 3MF regenerated.

## Stiff crossbar, longer charm hooks — 2026-09-27 (last), printed: good in a charm, pulls out of the bar

The step-free pin (next section) printed and was "still very loose", wobbly,
with charms and pins both letting go. The user asked for a wider crossbar and
longer hooks. A first question quoted ~5–6 % strain for "1.0 + both hooks".
That was wrong: the thicker crossbar drops the pivot and shortens the bar's
lever, so longer LOWER hooks reach **8.3 %** going in. The user was told and
re-chose **`hp_cb_h` 0.65 → 1.0, `hp_hook_up` 0.90 → 1.00, lower hooks
unchanged**. **Pins are printed in ABS** (user), and the strain asserts were
raised to 5.0 % (per charm) and 6.3 % (insertion).

- `hp_under` 1.5 → 1.35 keeps `hp_lead_up` at 40.4° (< 44).
- Pivot −0.80. Levers 1.62 / 2.48. Turns 24.76° / 19.67°. Strain 4.90 / 6.17 %.
  `hp_keep` 0.144. `hp_c_out` 6.66, `hp_c_in` 2.35. Paper hold force (∝
  h³·turn/(L·arm²)) is ~3.9× the 0.65 pin's.
- **New: `hp_mouth_v` 0.6 / `hp_mouth_u` 0.3.** They were a fixed
  0.4 × 0.15 mouth chamfer. With the lower pivot, the leg above the pivot
  swings out into the mouth going in. At 1.03× insertion that read 0.194 /
  0.103 / 0.063 / 0.028 / 0.005 mm³ at lift 0 / 0.1 / 0.15 / 0.2 / 0.25, at
  y 5.25–5.54, z −0.6…0. The hook is still fully deflected to lift ~0.15, so
  this was real, not the old floor-edge artefact. 0.6 × 0.25 still hit at
  lift 0 (0.037) and 0.8 × 0.2 at 0.15. 0.6 × 0.3 is empty at every lift.
- Charms refitted:
  - heart: `length` 19 → 19.4 (notch 8.20 ≥ 8.16, at any angle);
  - ladybug: `sh_b` 8.8 → 9.1, `hd_y` 8.2 → 8.5 (6.999 over gable ends,
    need 6.95);
  - dolphin: `joints` [11.0, 18.2] → [11.2, 18.4]. Moving only the first
    joint fails the segment-middle assert.
  - Butterfly and rose pass with no change.
- Checks: pin 1 shell, no overhangs, adhesion 0.6. The thinnest walls are the
  crossbar (1.00) and the lower hook tip (0.68, as before). Charms 1 shell
  (dolphin 4), only BRIDGE regions. Heart wall-check low point 1.04 at
  (0, 7.59, 5.74), the known gable-top trade. Band c3: 11 shells, 46 regions,
  no SUPPORT. Both accent 3MFs regenerated.
- Not re-run: the Euclidean hole-wall minkowski pass and the band swing
  harness.

Harness (same lib-only blocks, turned leg rotated in 2D about (`hp_s`,
`hp_pivot`)):

| test | reads |
|---|---|
| bar ∩ pin seated / dz +0.10 / −0.05 | 0.0000 / empty / 0.789 |
| bar dz 0.05 dx/dy 0.12; dy 0.20 | empty; 0.322 |
| bar ∩ leg −19.67° (release), lift 1.2 / 2.0 / 2.5 | 0.089 / 0.088 / empty (the hook has left the bar) |
| bar ∩ leg −25.50° (1.03×), lift 0 → 3.3 | empty everywhere; 0.9× at lift 1.0: 0.0088 |
| charm ∩ pin seated, dz +0.10, dx/dy 0.12 | empty |
| charm ∩ pin dz +0.25 / −0.25 / dy 0.2 (controls) | 0.595 / 0.093 / 0.367 |
| charm ∩ leg −20.26° (1.03×), 0 → 3.3 | empty at every step |
| charm ∩ leg 0.9× −17.7° at −0.6 | empty. The tip sits 2.1 inward of the pivot, so the cos term adds ~0.1 mm; the 0.8× control hits (0.047 at −0.9) |
| charm ∩ leg unturned −1.0; 1.6× seated (controls) | 2.448; 1.351 |
| charm ∩ leg unturned lift 0.10 / 0.14 / 0.20 | empty / empty / 0.149 |

**Harness trap, hit here:** in zsh, `set -- $c` does not word-split. The
override came through malformed, every run exported nothing, and the whole
sweep read "empty". Always keep a known-hit control row in a sweep.

## Step-free H-pin legs — 2026-09-27 (final), printed: "still very loose"

The user rejected the notches below ("No, once again, as on the picture - wide
leg, step-free"). Each leg is now `hp_ui_g`..`hp_uo` top to bottom, and
`hp_notch` is gone. The crossbar joins the grown inner face, so `hp_cb_len` =
2·`hp_ui_g` = 7.0 (was 8.2). **`hp_cb_h` 0.76 → 0.65** keeps
`hp_strain_up` 2.86 % and `hp_strain_cb` 3.62 %. The spring is ~25 % softer
(h³/L): the user was told, and 0.76 is the number to restore if they accept
~3.3 / 4.4 % strain.

- Pivot −0.625. Levers 1.79 / 2.43. `hp_keep` 0.147. `hp_c_out` 6.46,
  `hp_c_in` 2.45.
- The band's pocket changed: the crossbar slot's floor rose to −0.95, which
  needs a band reprint. The plain band is byte-identical.
- All charms are assert-clean with no source changes. Hole walls are as
  before (dolphin head 0.7, a zero-volume graze; heart ≥ 0.9; the rest ≥ 1.1).
- Harness at release −17.66° / insertion 1.03 × 22.35°:
  - keep, lift 1.2 / 2.0 / 2.5: 0.108 / 0.108 / 0.036;
  - bar sweep: empty from lift 0.05 (0.0027 at 0);
  - charm sweep 0 → 3.3: empty;
  - every control solid.
  - The single-leg clip (u ≥ `hp_ui` − 0.05 ∪ v > 0.1 ∪ v < `hp_cb_bot` −
    0.05) now drops a sliver of leg beside the crossbar. That is
    conservative for the keep row.

## Straight H-pin legs — 2026-09-27 (last), unprinted (notches since removed)

The user redrew the upper leg on a render of the pin below. The upper leg now
grows INWARD like the lower one, and its outside runs straight up at `hp_uo`
with no taper. `hp_grow_lo`/`hp_grow_up`/`hp_step`/`hp_taper`/`hp_uo_up` are
gone, replaced by one `hp_grow` = 0.6 and `hp_ui_g` = 3.50 (`hp_ui` is really
4.10, `hp_s` 4.6; older comments here saying 4.00/3.40 were stale).

- Each leg is one 1.6 bar with a 1.0 NECK at the crossbar. `hp_notch` (0.8)
  of air sits above and below the crossbar's end, so `hp_cb_len` stays 8.2.
  The user's line ran straight through there. That was explained and the
  notches were kept: fused, the spring would be 7.0 long (+17 % strain).
- `hp_room_up` is now measured at the leg's top corner:
  `turn_up*(v_top − pivot) + 0.1` = 1.34, so `hp_c_out` = 6.44 (6.45
  before). The chambers moved in 0.6: `hp_c_in` 2.45. The band's pocket is
  byte-identical to the previous round.
- Levers, strain (2.79 / 3.73 %), keep 0.176 and lead-ins are unchanged. The
  harness gives the same rows as the table below, except the charm dy 0.2
  control (0.311) and 1.6× seated (1.123). Pin: 1 shell, no overhangs.
- Every charm is assert-clean with no changes from the previous round.
  Overhangs are clean now (the gables no longer flag). Hole walls are the
  same as below (dolphin head 0.7–0.9, heart ≥ 0.9, the rest ≥ 1.1).

## Thicker H-pin, grown legs, taller upper tip — 2026-09-27 (later), unprinted (legs superseded above)

The near-square catches (next section) PRINTED: "slightly better, but not
enough. It seems the angle was smoothed while printing it, because the part is
quite small." The user sketched the change and chose from options:

- **`hp_t` 2.8 → 3.5.** They chose it over 3.0 (no band change) and 3.7 (the
  `h - 1.0` knuckle limit). The wall beside the pocket is 1.1, so
  `bracelet.scad` fills the top chamfer at a station: `charm_h_seat`, a block
  the full `body` along the band, ±`hp_fill_u` (6.9) across it, from 0.1
  below the chamfer's foot to the top face. It is flush with the slab faces:
  no overhang, no layer step. The chamfer is cosmetic, and every charm covers
  the fill. The assert is now `hp_wall_bar >= 1.0`.
- **Legs grown on their hookless faces:** `hp_grow_lo` 0.6 inward (under the
  crossbar) and `hp_grow_up` 0.5 outward (above the seat). `hp_grow_up` was
  0.6 first, but that put `hp_c_out` at 6.55 and failed the heart, ladybug and
  dolphin asserts.
  - **`hp_notch` 0.8:** air between the crossbar's underside and the lower
    growth. Fused there, the growth would shorten the spring (8.0 → 6.8,
    +18 % strain).
  - **`hp_step` 0.5 plus a 45° chamfer:** where the upper growth starts. A
    square corner at 0.1 dropped 0.26 into the bar's rim under the 23°
    insertion turn. The harness caught it: 0.32 mm³ at lift 0.15.
- **`hp_tip_up` 0.3 → 0.6**, split from `hp_tip_lo` (0.3). The user wanted
  ~0.8.
  - **`hp_arm_up` now runs to `hp_v_ut`, the tip's bottom (catch) corner, not
    its middle.** The harness found that with a tall tip the catch corner does
    not clear at 1.03× the modelled turn (0.013 mm³ at −0.6…−1.8).
  - Measured correctly, 0.8 needs `hp_under` ≥ 1.47 for strain, and then
    `hp_lead_up` reaches 47° (> `hp_lead` 44, asserted). 0.6 with
    `hp_under` 1.5 gives 41°.
  - `hp_roof_lead` 35 → 42 keeps the chamber roof clear of the steeper ramp
    (roof assert 0.206).
  - The lower lever still runs to its tip's middle. That tip is on the
    outside, so the cos term adds to its travel, and the harness sweep
    agrees.
- **Result:** `hp_strain_up` 2.79 %, `hp_strain_cb` 3.73 % (unchanged),
  `hp_keep` 0.176, `hp_c_out` 6.45, `hp_apex` 5.55, `hp_boss_x` 6.2. Pin
  11.9 × 6.9 × 3.5, 1 shell, no overhangs, adhesion 0.7.
- **Charms refitted:**
  - butterfly: spots out 0.4 (lower one 1.6 → 1.4 dia, to stay inside `x0`);
  - ladybug: `sh_b` 8.0 → 8.8, `sh_h` 7.8 → 8.0, `hd_y` 7.4 → 8.2;
  - rose: `core_side` 6.6 → 6.95, `core_top` 7.95, outer web 6.95;
  - dolphin: `joints[0]` 10.7 → 11.0 (segment 1 is 7.2).
  - The heart is unchanged (notch assert passes at 6.45).
  - All assert-clean, 1 shell (dolphin 4). Each charm's only overhang regions
    are its two 45° gables, which read BRIDGE at exactly 45 (the known
    threshold flicker).
- **Hole wall, Euclidean** (`minkowski(holes, sphere(t))` ∩ z > 0.05, minus
  (charm ∪ holes)):
  - butterfly, rose, ladybug, heart 90/270: clear at 1.1;
  - heart 0/45/315: clear at 0.9, not at 1.1 (at the gable's far top);
  - dolphin: clear at 0.7, not at 0.9, at the head over the −y hole end
    (y −7.1…−7.5, z 5.8–6.4). That is the dolphin's known low-head trade.
    Raising the head rows breaks the table's slowing-growth rule, so it was
    left.
- Band c3: 11 shells, 46 BRIDGE (shoulders 3.9 × 1.1, worst 85°), no SUPPORT.
  The plain band is byte-identical.

Harness: the lib-only blocks as below. The single-leg clip is now `u ≥ hp_ui −
0.05` ∪ `v > 0.1` ∪ `v < hp_cb_bot − 0.05`, so the lower growth is kept.

| test | reads |
|---|---|
| bar ∩ pin seated / dz +0.10 / −0.05 / +0.25 | 0.0000 / empty / 0.800 / 0.490 |
| bar dz 0.05, dx/dy 0.12 / dx 0.20 / dy 0.20 | empty / 0.819 / 0.360 |
| bar ∩ leg −17.27° (charm release), lift 1.2 / 2.0 / 2.5 | 0.149 / 0.149 / 0.071 — the pin stays |
| bar ∩ leg unturned lift 1.2; −20° lift 1.2 (controls) | 1.696; 0.032 |
| bar ∩ leg −23.74°, lift 0 / 0.05 / 0.10 / ≥ 0.15 | 0.047 / 0.015 / 0.000 / empty (the known floor edge) |
| charm ∩ pin seated, dz +0.1, dx/dy 0.12 | empty |
| charm ∩ pin dz +0.25 / −0.25 / dy 0.2 / dx 0.2 (controls) | 0.137 / 0.525 / 0.398 / 0.547 |
| charm ∩ leg −17.79° (1.03×), 0 → 3.3 below seat | empty at every step |
| charm ∩ leg unturned −1.0; 1.6× seated (controls) | 2.149; 2.433 |
| charm ∩ leg unturned lift 0.10 / 0.14 / 0.20 | empty / empty / 0.131 |

## Near-square H-pin catches — 2026-09-27, printed: "slightly better, but not enough"

The user: charms come off the pin "due to contact with sleeves. Quite small
effort is enough". They want charms removable, "but with significant effort",
and chose the angles themselves: **`hp_catch_lo` 60 → 85, `hp_catch_up`
60 → 80**, plus longer hooks. Pre-bent legs (bottom out, top in) were also
proposed and set aside. That pre-bend is the same rotation the legs already
make (a sustained preload in the locking direction). It adds straight onto the
3.73 % insertion strain, it creeps away in PLA/PETG, and past about 68° the
spring does not decide retention anyway. Re-raise it only if the catches fail.

On paper, anything past ~68° (µ ≈ 0.4) is friction-locked against a straight
pull. The user knows and accepted that: rounding of the printed catch edge is
what makes it releasable. The asserts now read `hp_catch_up` 45 to <90, and
`hp_catch_lo` either 45–60 (a stepped ceiling) or 80–90 (a flat bridge).

- **`hp_hook_up` 0.75 → 0.90** (0.75 past the wall). **`hp_under` 1.0 →
  1.5**: the steeper catch drops the hook by the smaller catch rise
  (0.43 → 0.16), so the hook is lifted to keep the charm's lever at 2.64. At
  `hp_under` 1.0 the taper leaves a 0.38 leg tip (assert ≥ 0.5 fails).
  Limits: `hp_hook_up` 0.95 needs a leg tip under 0.5 or strain past 2.9.
- **`hp_hook_lo` cannot grow.** `hp_out` 6.10 is the band-width limit, and
  the lower turn sets `hp_strain_cb` 3.73 %.
- Now: `hp_strain_up` 2.63 %, `hp_keep` **0.205** (was 0.267), `hp_lead_up`
  34°, `hp_taper` 0.47, `hp_c_out` 5.76 → **5.91**, `hp_c_in` 3.05. The
  charm holes changed, so **every charm, the band and the pin reprint
  together**. The charm model sources are untouched, and all their asserts pass.
- Band c3: 11 shells, 46 BRIDGE, no SUPPORT. The six shoulders now read
  "near-flat, worst 85°, 3.2 × 1.1, 2.07 above the plate". The plain band is
  byte-identical to `exports/bracelet-bracelet.stl`. Pin: 1 shell, no
  overhangs. The wall check adds 0.68 on the lower hook's tooth (its catch is
  now flat, so the tooth is thinner at the root: 1.25 vs 1.67).
- Charm wall around the grown holes, as `minkowski(holes, cube(2t)) ∩ z>0.05`
  minus (charm ∪ holes). Heart (0/45/90/270/315), rose and dolphin are empty
  at t = 1.0. Butterfly is solid at 0.8 both before and after (the cube's
  corners over-reach). Ladybug is empty → solid at 0.8. That is at the dome
  over the gable ends, (0, ±6.7, 6.0), ≥ 1.1 Euclidean, and its own asserts
  pass.

Harness (lib only: a 6 × 16.2 × 4.2 block minus `charm_h_pocket()`, and an
8 × 16 × 8 block minus `charm_h_holes()`; a single leg turns about
(`hp_s`, `hp_pivot`)). **Clip the single leg at `hp_ui` − 0.05, but keep
v > 0.1.** A clip at `hp_s` − 1.2 carries a crossbar stub that swings up
through the seat plane (a false 0.005 mm³ hit). Clipping at `hp_ui` without the
v > 0.1 band cuts off the inward upper hook, and every charm control reads
empty. OpenSCAD writes NO file for an empty result, so detect a missing file
and remove the old one first.

| test | reads |
|---|---|
| bar ∩ leg −16.29° (charm release), lift 1.2 / 2.0 / 2.5 | 0.160 / 0.160 / 0.089 — the pin stays (0.314 at 1.2 before) |
| bar ∩ leg unturned, lift 1.2 (control) | 1.357 |
| bar ∩ leg −23.74° (1.03 × insertion), lift 0.15 → 3.3 | empty (0 / 0.05 / 0.10: 0.037 / 0.012 / 0.000, the known floor edge) |
| bar ∩ pin, dz +0.10 / −0.05 / +0.25; dz 0.05 dy 0.12 / 0.20 | empty / solid / solid; empty / solid |
| charm ∩ pin seated, dz +0.10, dx/dy 0.12 | empty |
| charm ∩ pin dz +0.25 / −0.25, dy 0.2 (controls) | 0.076 / 0.420 / 0.410 |
| charm ∩ leg −16.77° (1.03 × charm turn), 0 → 3.0 below seat | empty at every step |
| charm ∩ leg unturned −1.0; 1.6× turn seated; 0.9× turn at −0.6 (controls) | 1.531; 2.165; 0.013 |
| charm ∩ leg unturned, lift 0.10 / 0.14 / 0.20 | empty / empty / 0.105 (the 0.15 `hp_vfit`) |

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

## Bigger detent bumps on a tapered leaf — 2026-09-26, unprinted

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
is at the top of it. `lib/charm-pin.scad` holds the charm mount — the H-pin,
the pocket it snaps into and the holes a charm has for it. `models/pin`
is the loose pin, and `models/butterfly-charm`, `models/ladybug-charm`,
`models/heart-charm`, `models/rose-charm` and `models/dolphin-charm` are the
five charms. The lib draws
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
openscad -o /tmp/r.stl models/rose-charm/rose-charm.scad && cmp /tmp/r.stl exports/rose-charm-rose-charm.stl
openscad -o /tmp/d.stl models/dolphin-charm/dolphin-charm.scad && cmp /tmp/d.stl exports/dolphin-charm-dolphin-charm.stl
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
   ladybug, heart, rose) or a new
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
