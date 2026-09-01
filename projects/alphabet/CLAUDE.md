# CLAUDE.md — alphabet

Project-specific guidance for AI agents. The repo-root `CLAUDE.md` still
applies; the rules here are alphabet-only and win where they add detail.

## One model, two parts — and this is a deliberate exception

- `models/platform/chassis.scad` — part: the truck itself. One per letter.
  The module is `chassis()`.
- `models/platform/wheel.scad` — part: one road wheel. **Four** per platform.
- `models/platform/spring.scad` — part: the wave spring that grips letters. One
  per platform, glued in once.
- `models/letter/glyph.scad` — the shared letter geometry. Renders nothing.
- `models/letter/a.scad` .. `z.scad` — one part per letter, all 26, each a
  three-line file over glyph.scad. A letter IS its own model, unlike the wheel,
  because the whole point of the toy is that it comes off.

**The wheel is a PART of the platform model, not a model of its own, and that is
the owner's explicit call — do not "correct" it.** The repo-root rule would put
a wheel in its own model folder, since it turns relative to the chassis and is
the component-vs-part case that rule singles out. The owner's view is that a
platform is one thing which merely has to be printed in five pieces, so it is
one model with two parts, exported as `platform-chassis.stl` and
`platform-wheel.stl`. If you are tempted to split it back out because the
root `CLAUDE.md` says so, this paragraph is the answer: ask first.

**Every shared dimension lives in `lib/common.scad`.** Read it before anything
else; the part files carry geometry and nothing else. `lib/` rather than a file
inside `models/platform/` because the letters share it too. Do not consider the
chassis "done" without the wheel — the platform's whole reason for existing is
that it rolls.

## z = 0 is the GROUND, not the print bed

This is the thing to internalise before touching a coordinate in
`chassis.scad`. The platform's underside is at `body_bot` = 8, its deck at
`body_top` = 34, and the axle at `axle_z` = `wheel_dia / 2` = 17. Ride height is
what couples the components, so every height is measured from the floor the
train rolls on — which means the exported platform sits 8 mm above the origin
and the checks measure its footprint at z = 8. That is correct; do not "fix" it
by dropping the model. `wheel.scad` is different: it is written in its own print
frame, z = 0 at the outer face, +z along the peg.

The deck is level with the top of the wheels **by construction** — `body_top` is
literally `wheel_dia`. `axle_z` is `wheel_dia / 2` for the same reason. So
`wheel_dia` is the master dimension of the whole chassis: change it and the deck,
the ride height and the axle bore's headroom all move together. That is
deliberate, and it is the lever used to fatten the axle (see below).

## The one rule this project keeps re-learning: nothing may hang

Both real bugs so far were the same bug. A feature that is unioned at both ends,
manifold, thick-walled and stable can still have its first layer in mid-air.

- **The coupler used to be a low tongue sliding under the next platform's nose.**
  That nose then needs a tunnel, and a tunnel has a *roof* — a flat span 4.5 mm
  above the plate with nothing under it. The overhang check called it a
  bridgeable 11 mm span and it was accepted; it should not have been. The
  replacement is the vertical key and keyhole, in which **every surface of the
  joint is a vertical prism**. If you are asked to change the coupler, that is
  the property to preserve: cut it downward, never across.
- **The wheel's snap peg used to be a solid barb pushed through a smaller hole.**
  Geometrically fine, physically impossible — a solid 6.4 mm cone does not pass a
  5.4 mm hole in solid PLA. This is the *same* objection that ruled out the
  push-together coupler, and it was missed here because the wheel did not exist
  yet to check. The peg is slit, and see below.

So: for every feature, name what its lowest layer lands on, all the way to the
plate. And for every snap, name what flexes and by how much.

## The wheel's snap: broken once on a real print, called too thin twice

Read this before changing a number in `lib/common.scad`'s axle block. Two facts
govern the whole joint:

1. **A barb cannot pass a smaller hole unless something gives, and the only
   thing that can is the peg.** So the peg is slit, and a snap peg is therefore
   never a solid pin. If someone asks for a solid pin, the answer is not "make
   the fingers thicker" — it is to drop the snap: a separate glued axle, or a
   quarter-turn bayonet. Say so rather than iterating.
2. **The finger is loaded ACROSS the print layers.** The peg stands up on the
   bed, so every layer boundary is perpendicular to the tension in a bending
   finger — PLA's weakest and most brittle direction. This was the original
   error: it was sized to 1.2% against bulk PLA's 2–3% yield. Budget well under
   1% for `1.5*t*delta/L^2`.

**The bore diameter is capped by the chassis HEIGHT, not its width.** The chamber
is a horizontal hole, so the floor between it and `body_bot` is the constraint:
`axle_relief_d < 2*(axle_z - body_bot - 1.5)`. That is why fattening the peg has
twice required raising `wheel_dia` — 22 -> 26 (axle 11 -> 13), then 26 -> 34
(axle 13 -> 17). `body_w` 38 -> 42 came after the first, to keep the deeper
chamber clear of the coupler socket. If asked for a still fatter axle, the lever
is `wheel_dia`, and it makes the whole toy bigger.

**`wheel_dia` is also the lever for GROUND CLEARANCE, and the two spend the same
budget.** `body_bot` and `axle_relief_d/2` both come out of `wheel_dia/2`, so
"raise the car" and "fatten the pin" compete unless the wheel grows. Asked for
both at once, 26 -> 34 delivered both: clearance 5 -> 8 mm, chamber 10.3 -> 12.0,
and the floor between them came out THICKER (2.85 -> 3.0), not thinner.

Five generations, so none of it gets undone:

| | v1 (broke) | v2 (too thin) | v3 | v4 | now |
| --- | --- | --- | --- | --- | --- |
| wheel diameter | 22 mm | 22 mm | 26 mm | 26 mm | 34 mm |
| shaft / fingers | 4.6 / 1.3 mm | 5.4 / 1.9 mm | 7.6 / 2.5 mm | 7.6 / 3.15 mm | 9.3 / 4.0 mm |
| journal / finger length | 3.0 / 8.9 mm | 7.0 / 13.7 mm | 9.0 / 15.7 mm | 9.0 / 16.2 mm | 12.0 / 22.6 mm |
| interference per side | 0.50 mm | 0.35 mm | 0.35 mm | 0.35 mm | 0.35 mm |
| slit root | square corner | radiused | radiused | radiused | radiused |
| mouth lead-in | none | 1.5 mm | 1.5 mm | 1.5 mm | 1.5 mm |
| peak strain | 1.2% | 0.53% | 0.53% | 0.63% | 0.41% |
| push to seat | ~10 N | ~7 N | ~15 N | ~29 N | ~37 N |

- **`axle_neck_l` is the cheap lever on strain**, because it sets the finger
  length and strain goes as 1/L². It also makes a better bearing. If the snap is
  too stiff, lengthen the finger (`axle_neck_l`, or `axle_slot_z` deeper) or
  widen `axle_slot_w`. Do NOT shrink `axle_barb_d`; that is the only thing
  holding the wheel on.
- **`axle_slot_w` is 1.3, halved from 2.6 at the owner's call** after the fingers
  were still judged fragile. It only has to close 0.7 mm, so there is 0.6 of
  margin. Know which way each term moves: halving the slit thickened the fingers
  2.5 -> 3.15 mm, which RAISED peak strain 0.53% -> 0.63% and roughly doubled the
  push, 15 -> 29 N. Thicker is not automatically stronger in a cantilever snap —
  it is stronger against handling and weaker against its own deflection.
  `axle_slot_z` went 2.0 -> 1.5 to claw back finger length against that, and the
  step after it (9.3 mm shaft) lengthened `axle_neck_l` 9 -> 12 in the same move
  for the same reason — which is why the current version is both the thickest
  finger and the LOWEST strain in the table.
- **`axle_slot_r` exists because a square slit floor is a stress riser sitting
  exactly at the finger root.** Never model the slit as a plain `cube()`.
- **`axle_mouth_lead` exists because there was no lead-in**, and a wheel offered
  up against a flat flank goes in crooked and side-loads one finger on its own.
  A real failure mode, not a nicety.
- **`wheel_boss_d` must stay OUTSIDE the socket's flared mouth.** The mouth is
  `axle_hole_d + 2*axle_mouth_lead` = 13.1 mm across; a boss narrower than that
  drops into the funnel instead of landing on the flank, and the wheel binds
  rather than seating. It went 12 -> 16 with the bigger bore, leaving a 1.45 mm
  land. `slit()`'s length is `wheel_boss_d + 2` and follows it automatically.
- **Measured on the mesh, not computed:** bore 17.5 mm deep, seated peg tip at
  y = 5.5 against a floor at y = 3.5, so 2.0 mm of clearance. If a sub-1.2 mm
  point appears anywhere on the wheel, something got thin that should not have.
- **The peg must not bottom out in the bore.** It seats on its boss against the
  flank; if the tip lands first, the wheel stops before the barb clears the
  journal and never clicks. Re-derive after any change: tip depth below the
  flank = `axle_lead_h + axle_retain_h + axle_neck_l + (wheel_gap -
  wheel_boss_h)`, floor at `axle_neck_l + axle_relief_l`.
- **`axle_relief_l` is capped by the coupler, not the barb** — deeper and the
  chamber eats the nose wall the coupler pulls against.
- **The ~1.0 mm of wheel side play is the retaining cone's height**, not slop
  that can be tuned away without steepening the cone past printable.
- Print wheels in PETG where possible; in PLA, hotter and slower. This joint's
  strength is layer-bond strength, and perimeter count is irrelevant to it.

## The letter: a bare glyph, and everything that follows from it

**A letter is nothing but the glyph.** No plinth, no tongue, no tab — the owner
was explicit: this is a learning toy, and anything on a letter that is not the
letter is a distraction. A plinth was tried and rejected. Do not reintroduce one.

Everything else in the letter interface is a consequence:

- **The letter attaches by standing in the groove and resting on its floor.**
  Nothing grips it. `letter_slot_d` is the burial depth, and the letter's baseline
  sits exactly on the groove floor (`body_top - letter_slot_d`) — a coplanar
  contact, so `intersection(chassis, letter_fitted(ch))` comes back **empty**, not
  as a zero-volume sheet. To prove the letter really lands on the floor rather
  than floating, sink it: at 0.2 mm of drop, contact appears at z = 14.90 with the
  glyph's foot as its footprint. Do that test, not the plain one.
- **The groove is OVERSIZE and a wave spring clamps the letter in it.** Four
  straight-slot fits were printed — 0.5, 0.2, 0.05 and 0.0 mm a side — and every
  one came out loose. The lesson is not the numbers: a straight slot's grip IS
  the print tolerance, neither part can give, and the tolerance is not knowable
  in advance. Do not "fix" this by picking a fifth clearance.
- **`spring.scad` is a SINGLE-SPAN leaf, anchored only at its two ends. Do not add
  an intermediate support.** Any support between the ends pins the contact face
  where it sits, and a letter bearing there cannot push it at all — the wave
  version waved back to the wall at mid-length and was rigid exactly there. This
  is the failure that is invisible in a render and obvious in the fit test.
- **The anchors sit OUTBOARD of every letter's foot** (measured: no foot passes
  x = 18.3, anchors start at 19.8), which is what lets `spring_recess` be 0. A
  recess forces a taller bow, and a tall bow falls away from the letter fast: at
  0.5 mm of recess the leaf was proud over only +/-8.4 mm and A compressed it
  0.02 mm instead of 0.42. Re-run the 26-letter engagement sweep after ANY change
  to the bow, span or anchor length.
- **Engagement, measured per letter** (0.42 is full): most at 0.42; F K N P W X
  0.34-0.38; H R 0.30; **A worst at 0.27** — its feet straddle the centre. That is
  64% of force, ~13 N.
- **Sizing: at a fixed stress, force goes as t^2/L.** From `F = 4EhT^3d/L^3` and
  `sigma = 6Etd/L^2`. More force means a THICKER leaf on a LONGER span; thinning
  it or adding waves to make it "springier" lowers the force, which two earlier
  versions did. 4.0 mm over 39.6 mm gives 21 N at 19 MPa.
- **Stress, not yield, is the ceiling: the preload never comes off.** PLA much
  above ~25 MPa creeps its force away over months.
- **The spring pockets and the axle chamber fight for the same space, and the
  chassis's GENUS is what tells you.** The chamber is bored as a teardrop, so its
  45 deg gable reaches `0.707*axle_relief_d` above the axle — 8.5 mm at the
  current size, to z = 25.5 — while the pockets hang `spring_leg_l` below the
  groove floor. When the wheels went to 34 the 12 mm journal pushed the chambers
  inboard under the pockets, a 6 mm leg put the pocket floor at 23.8, the two
  voids met, and the chassis exported **genus 2**: two tunnels from the letter
  groove straight into the wheel bores. Nothing in a render shows it.
  `spring_leg_l` went 6.0 -> 2.5 to fix it, which costs nothing the leaf cares
  about — the legs only locate the spring, and the bow, span, thickness and
  anchor length are untouched. Keep `body_top - letter_slot_d - spring_leg_l -
  spring_fit` above `axle_z + 0.707*axle_relief_d`, and check the genus after any
  change to either.
- **`spring_t` is capped by the back clearance**: the leaf must be able to move
  `spring_preload` toward the wall, so `spring_t <= spring_space` with margin.
  0.92 mm of clearance at present.
- **`letter_slot_l` is set by the WIDEST letter's own footprint**, because the
  footprint is the whole width of the glyph. 52 mm on a 64 mm deck.
- **`prow_l` exists solely because of that.** The coupler socket used to occupy
  the deck from x = 19.2 outward, which is where the groove now runs, so it moved
  onto a full-height nose extension. If someone asks why the nose sticks out, this
  is why; shortening the prow means shortening the groove means smaller letters.
- **The font choice is structural, not cosmetic.** The widest letter sets the
  groove length: Helvetica Bold's W is 1.27x its cap height, Verdana Bold's 1.46.
  `letter_condense` = 0.85 buys cap height back at the same footprint.
- **Trim every glyph flat at the baseline.** Round letters overshoot it by design,
  and a letter standing on a convex curve has nothing stopping it rocking.

**Known, reported, unresolved: six letters stand on a narrow foot.** Measured on
every export, as the lean each tolerates before tipping in its own plane:
solid (30-39 deg) A M X K R H N Z E L W; fine (20-28) G Q B D; watch (15-17)
U O S C; J 14; and **V P I F Y T at ~10 deg** — the single-stem letters, where a
sans-serif I is a bar standing on 7.8 mm. Note what does NOT fix it:
`letter_slot_d`. The groove holds a letter sideways; fore-and-aft it is held by
nothing but its own foot, and the tipping angle is `atan(half-foot / CoM height)`
— neither term depends on burial depth. The zero-clearance groove may cover for
it by clamping both faces; only a print settles that. If not, the fix is a face
with feet (Georgia Bold gives I and T a 20 mm foot, Rockwell Bold 21.5), which is
a legibility trade for the owner to make, not a silent substitution.

**text() has two traps**, both live:

- **A missing font falls back silently** — no warning, no error. The first version
  asked for "Liberation Sans:style=Bold" (OpenSCAD bundles it) and on macOS got
  the fallback face, because the bundled Liberation faces are not registered with
  fontconfig. Nothing in the render or the console said so. To verify a font
  resolved, render a string with it and with a deliberately bogus name and compare
  bounding boxes; identical means it fell back.
- **`size` is not the cap height in general.** For Helvetica Bold they coincide
  (size 44 -> 44.0 mm), which is why `letter_size` reads as a height. Change the
  font and re-measure.

## The coupler lives in the BOTTOM HALF, and that is a requirement

`coupler_h` = half the body height. The key stands 10.5 mm, the socket is a
pocket 10.5 mm deep in the underside, and `prow_l`'s plate stops at the same
height. The reason is the owner's: the deck must carry nothing but the letter
groove, so the top surface stays symmetrical. Do not restore a full-height key or
a socket bored through the deck to "simplify" it.

The cost is that the socket acquired a **ceiling**. Before, it was cut clean
through and had none. So:

- **`socket_roof()` is load-bearing, not decoration.** A cone closing over the
  bore at 45 deg, plus a 45 deg hip roof over the wedge (hull of the flat
  trapezoid and a ridge segment above it — exact for a convex base). Both
  surfaces rise at 45 deg from every edge, and because both are continuous their
  union has no ledge where they meet. Delete it and you get a flat ceiling
  9.6–15 mm across, hanging 10.5 mm up: the exact failure this project started
  with.
- **The roof cutter still matters even though the prow is half-height.** The bore
  spans x 28.2..37.8 and the body's front face is at 32, so its rear 3.8 mm sits
  under the deck and genuinely needs the coned ceiling. The part of the cutter
  above the prow does nothing — harmless, and simpler than special-casing it.
- **Both roof apexes must clear the letter groove**: cone apex 20.3 at x = 33, hip
  apex up to 23 at the nose face, groove floor 15 but only out to x = 26. They do
  not overlap in x; if the groove or the prow moves, re-check that.
- **`socket_funnel()` is two pieces, and hull() is why.** The socket profile is a
  circle with a wedge off one side, which is NOT convex. Hulling the whole
  profile to make the flare filled the wedge's reentrant corners, and where the
  convexified cut stepped back to the true profile it left a horizontal,
  downward-facing ledge 1.5 mm above the plate — 9.6 x 2.9 mm, twice. Build the
  cone and the wedge flare separately; each is convex on its own. This is the
  same trap as `socket_roof()`, and it will come back if either is "simplified".
- **`coupler_funnel_w` is 0.8 against a 1.5 mm height on purpose.** A 1:1 funnel
  is a 45 deg downward surface, on the limit, and it gets flagged. 0.8 puts it at
  28 deg and still opens the mouth by 1.6 mm.
- Measured after all of it: deck-level material is exactly the body outline
  (x -30.8..30.8, y -19.8..19.8) and nothing else, and the overhang check reports
  **no real overhang anywhere on the chassis** — only sliver facets under the area
  filter.

## The coupler: grip and swing fight each other, and v1 lost both

A real print did not hold, and the swing was judged too small. Grip is
`coupler_key_d - throat`; swing is how far the web turns before it jams in that
same slot. v1 was a parallel 7.0 mm slot on an 8.0 mm key: 0.5 mm of interlock
and 19 deg. Do not "simplify" any of the following back to a parallel slot.

- **The slot is a WEDGE and the throat is emergent.** The narrow point is where
  the wedge crosses the bore circle — you do not place it, you solve for it. That
  puts it ~3.8 mm out from the key axis, where the web hardly sweeps.
  `coupler_slot_w` is 0.2, i.e. effectively a point at the bore axis; it exists
  to keep the polygon non-degenerate. Narrowing it tightens the throat AND moves
  it outward, so it is not a simple grip knob.
- **The wedge must open faster than sin(swing), and this was the real limiter.**
  The web was fouling on the wedge *wall* 5.8 mm out, not at the throat: the wall
  opened at 0.50 mm of half-width per mm where the corner needed 0.54.
  `coupler_slot_face_w` = 15 fixes it. If someone asks for more swing, this is
  the first knob.
- **`coupler_neck_flat` is worth ~10 deg on its own.** The web is parallel at
  `coupler_neck_w0` for 7 mm — the whole length that lives inside the slot — and
  only then flares to `coupler_neck_w1`. A web that tapers from the key is
  already 25% wider by the throat. The flare is for root strength, so do not
  extend the flat all the way in.
- **Retention is geometric, and it is tested by pulling, not by looking.**
  Translate one car along +x in the assembled pose: at 1 mm and 2 mm of pull the
  key must jam on the throat (contact at x ~= 27, y ~= 3.8). At 0 mm the
  intersection is *empty* and that is correct — it is a free swivel, not a
  friction fit. Do not read "empty at pull 0" as "it fell apart".
- **Measured, not computed** (probe with a 0.2 mm cube; a 0.4 mm cube inflates
  the reading by up to 0.2): throat **6.3 mm** at x = 27.6–27.8 against a 9.0 mm
  key, so 1.35 mm of interlock a side. Swing: free to 25 deg, 2 mm^3 of rub at 30
  which is the coupler's own throat (y = 3.1..4.0); the next car's WHEELS join at
  33 and it is a real collision by 38. **Past ~33 deg the coupler is no longer the
  constraint** — more swing then needs a bigger `coupler_key_x` (a wider body
  gap), not slot changes.
- **`coupler_key_x` is 20, and the WHEELS are what set it.** The gap between
  coupled cars is what lets them turn. It was 14 while the wheels were 26 mm and
  sat inside the body; at `wheel_dia` 34 a wheel stands 3 mm PROUD of each body
  end, and the wheelbase cannot be closed up to hide that (36 is already the
  minimum at which two 34 mm wheels on one side clear each other). So the nearest
  parts of two coupled cars became their wheels, and at 14 they met at yaw 20 —
  worse than the bodies ever managed. Swept: 18 gets first contact to 30, 20 puts
  it back on the coupler's own throat at 30 with the wheels waiting until 33, and
  22 buys almost nothing more. **Stop when the throat is the first contact
  again** — that is the signal the joint is the constraint, which is where it
  belongs. If `wheel_dia` changes, re-sweep this; it is not a constant.
  `prow_w` is 28 rather than 34 from the era when the prow's tip corners struck
  first. Do not lengthen the key "for strength": retention is the throat, not the
  reach.
- **`coupler_bore_d` is capped at ~9.6 by the axle chamber**, which reaches in to
  |y| = 7 at x = 12.85..23.15. A bigger key would buy swing at constant grip, but
  11 mm leaves a 1.2 mm wall into the wheel bore — and the wheels are working, so
  they do not get regressed for the coupler's benefit. It would need a longer
  body or a full-height nose extension.
- **`letter_tongue_l` is capped by the bore**, which starts at x = 19.2 and needs
  ~3.5 mm of wall. 30 mm leaves 3.7 mm.
- **The socket's funnel is at the BOTTOM.** That is the mouth the key enters
  through, and a cone opening downward at the underside grows straight off the
  bed. On top it would be both useless and an overhang.
- Do not implement a push-together snap by narrowing the slot in the solid nose:
  the prongs either side are 14 mm of solid PLA and will not flex at all.

## Do not read hole depth off an F5 preview

OpenSCAD's preview draws the cut faces of a `difference()` in a highlight
colour, which makes a blind bore look like a shallow dimple — the axle sockets
read as 2 mm dents when they are 10 mm deep. Probe the exported mesh instead:
`intersection()` of the part with a small cube walked along the axle line tells
you exactly where the floor is, and a `z = axle_z` section render shows the
stepped bore and a seated peg together.

## Verifying a change

Most of the risk is in the two joints, and neither is visible in a render.
After any edit to `lib/common.scad` or to a mating surface:

1. Export both parts and run connectivity, wall thickness, bed stability and
   overhangs on each. Expected clean state:
   - **letters** (`letter-a.stl` .. `letter-z.stl`): all 26 single-piece, no wall
     under the probe cap, no overhangs, adhesion ~0.2. The widest is W at
     47.5 mm, inside the 52 mm groove.
   - **chassis** (`platform-chassis.stl`): one piece; thinnest wall 1.93 mm;
     97.5 x 42 x 26 mm; adhesion 0.3; two small `RAMP` regions at the socket
     funnel — and **nothing else**. **Genus 0** — see the spring-pocket trap
     below; that check is what caught it.
   - **wheel** (`platform-wheel.stl`): one piece; **no** overhang regions at
     all; 34 x 34 x 24.7 mm; adhesion 0.9.
2. Re-run the coupled-pair interference test across yaw (0, 20, 25, 30, 33, 35,
   38) AND the pull-apart test (1–2 mm), with real wheels included, plus the
   wheel-in-chassis test, AND the letter fit test. Expect free to yaw 25, a 2 mm³
   rub at 30 that is the coupler's OWN throat (y = 3.1..4.0), the wheels joining
   in at 33, a real collision by 38; pull-apart blocked at 1–2 mm; the seated
   wheel empty; and every letter clearing the groove. **Include a pose you know
   must fail** — yaw 38 for the pair, and shoving the wheel 3 mm too deep for the
   axle (that one must report a collision at the boss, y up to 21, AND a hit at
   the peg tip, y ~= 2.5 against a floor at 3.5; if only the boss shows, the
   depth margin is not being tested).
   **Placing the wheel is itself a trap:** the wheel's outer face is its own
   z = 0 and the peg runs along +z, so a seated wheel is
   `translate([x, sy*(body_w/2 + wheel_gap + wheel_w), axle_z]) rotate([sy>0 ? 90
   : -90, 0, 0])`. Get the sign or the offset wrong and the peg points out into
   free air, the intersection is empty, and it reads as a clean pass. Always
   render the placed wheel alone first and check its bounds span the flank. An `intersection()` harness that silently builds nothing reports every
   pose as clean, and that failure looks exactly like success. **A stale
   coordinate does the same damage:** when the socket moved onto the prow, the
   coupled-pair harness was still deriving the bore from `body_l/2 -
   coupler_bore_x` and reported an 837 mm^3 collision at yaw 0 on a joint that is
   fine. `nose_x` lives in chassis.scad and `use <>` does not import variables, so
   a harness has to rebuild it as `body_l/2 + prow_l - coupler_bore_x`. Note the
   shape of it: an unknown module name does not error, so `intersection() { chassis();
   wheels(); }` with a stale module name returns **the wheels** — 2680 mm³,
   which reads as a catastrophic collision — while the same slip in the other
   operand reads as a clean pass. Grep the run for `unknown module` before
   believing either answer. (This is not hypothetical; it happened when the part
   was renamed from `platform` to `chassis`, because BSD `sed` has no `\b`.)
3. If you touch the axle, re-derive the finger strain (`1.5·t·δ/L²`) rather than
   trusting the number in this file.
