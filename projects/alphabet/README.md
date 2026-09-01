# alphabet

A 3D-printable **alphabet train**. Each letter stands on its own four-wheeled
platform; the platforms hook together nose to tail, so a child can roll them
around one at a time and then line them up into a word.

**The letters are interchangeable.** A letter is not part of its platform — it
drops into a slot in the deck and lifts straight out again, so the same set of
platforms spells anything the child has letters for.

Two models: the **platform** and the **letters**. The platform is one thing that
happens to print in two pieces — a chassis and four wheels — so it is one model
with two parts. A letter is a separate component, because the whole point is
that it comes off.

**All 26 letters exist**, one three-line file each over a shared `glyph.scad`.

```
alphabet/
  lib/
    common.scad        # the dimensions shared by the platform and the letters
  models/
    platform/
      chassis.scad     # part: the truck that carries one letter     (print 1)
      wheel.scad       # part: one road wheel                       (print 4)
      spring.scad      # part: the wave spring that grips letters    (print 1)
    letter/
      glyph.scad       # the shared letter geometry (renders nothing)
      a.scad .. z.scad # part: one per letter                        (print 1 each)
  exports/             # generated meshes (gitignored): platform-chassis.stl,
                       #   platform-wheel.stl,
                       #   platform-spring.stl, letter-a.stl .. letter-z.stl
  previews/            # generated .png previews (gitignored)
```

## The chassis

97.5 x 42 x 26 mm as printed (64 mm of body, plus a 9 mm nose extension at the
front and 24.5 mm of coupler key at the back — both of which sit below deck
level), 34 mm tall off the ground once it is on its wheels, 60.4 mm across the
wheels. Coupled platforms sit 85 mm apart.

**It stands 8 mm off the floor.** That clearance is bought straight out of the
wheel radius, and it is the same budget the axle bore is bought from: the floor
between the bore and the underside is `wheel_dia/2 - body_bot - axle_relief_d/2`
and has to stay around 3 mm. See *The wheel*, below — one number pays for both.

**A drop-in letter slot.** A 5.0 x 31.0 mm slot down the middle of the deck,
12 mm deep, with a flared mouth. Every letter has a 4 mm x 30 mm tongue on its
underside; the child drops it in and it stands up. Nothing to line up, nothing
to twist, nothing to push. The fit is deliberately loose — 0.5 mm a side — and
it is the 12 mm of depth, not the grip, that keeps the letter upright (it can
lean about 5°).

**A keyhole coupler, and it lives in the bottom half.** The back of each chassis
carries a **round key** 9 mm across on a web; the nose carries a matching
**keyhole socket** — a bore with a wedge-shaped slot out to the front face.

**Both are only 13 mm tall, the bottom half of the body**, so the deck above
them is untouched: the top surface is a clean rectangle with nothing on it but
the centred letter groove. The nose extension stops at the same height for the
same reason. Verified on the mesh — the only material at deck level is the body
itself, x -30.8..30.8 by y -19.8..19.8.

That has a cost the full-height version did not have: a socket that stops half
way up has a **ceiling**, where before it was a hole cut clean through. Ceilings
are this project's recurring failure, so it is built at 45°: a cone closing over
the bore and a hip roof over the wedge, both self-supporting, both clear of the
letter groove above.

Getting there took two more fixes, both found by the overhang check:

- **The flared mouth under the socket was hanging.** It was built as one
  `hull()` across the whole socket profile — but that profile is a circle with a
  wedge running off one side, which is *not convex*, so the hull filled the
  wedge's two reentrant corners and left a horizontal, downward-facing ledge
  1.5 mm above the plate: two of them, 9.6 x 2.9 mm. It is now built as two
  pieces, a cone under the bore and a hulled wedge under the slot, each convex on
  its own.
- **The mouth's flare was exactly 45°**, right on the limit and still flagged. It
  is now 0.8 mm of flare over 1.5 mm of height — 28° from vertical — which still
  opens the mouth by 1.6 mm for aiming.

**The chassis now has no real overhang anywhere**: the only downward faces past
45° are sliver facets below the area filter.

### The key is as short as the swing allows

The key sticks out 24.5 mm behind the body, and that is a measured floor, not a
guess: the gap between coupled cars is what lets them turn, so shortening the key
eventually makes the cars foul each other instead.

**The big wheels are what set it.** A 34 mm wheel on a 36 mm wheelbase stands
3 mm proud of each body end, and the wheelbase cannot be closed up to hide that —
36 mm is already the minimum at which two 34 mm wheels on one side clear each
other. So the nearest parts of two coupled cars are no longer their bodies but
their wheels, and `coupler_key_x` had to go 14 -> 20 to keep them apart. Swept:
at 20 the first contact is the coupler's own throat again at 30° (2 mm³ of it,
out at y = 3.1..4.0, exactly where the slot grips) with the wheels only joining
in at 33°; at 14 the wheels met at 20°, which is worse than the bodies ever
managed. Going on to 22 buys almost nothing — the sign that the constraint has
handed back to the joint, which is where the design wants it.

The prow is 28 mm wide rather than 34 for the related reason that its tip corners
used to be what struck first. The prong is 12.5 mm wide back at the throat, where
the load actually is, and 6.5 mm at the tip.

You couple by lowering one chassis over the other's key — **a 13 mm lift rather
than the full 26 mm of body**, which is easier for small hands. It cannot be pushed or
shaken apart: the key cannot pass the slot, so the only way out is straight up.
The key's top is tapered and the socket funnelled from underneath, so it does not
have to be aimed.

**Two things fight each other in this joint, and the first version lost both.**
Grip is (key diameter − narrowest slot width); swing is how far the web can turn
before it jams in that same slot. Narrow the slot and it holds but will not turn;
widen it and it turns but pulls out. v1 had a parallel 7.0 mm slot on an 8.0 mm
key — 0.5 mm of interlock, which a real print did not hold — and still only made
19°. Three changes break the deadlock:

- **The slot is a wedge, not a parallel groove.** Its narrow point — the throat —
  is not a wall you place; it is where the wedge crosses the bore circle, and
  that lands only 3.8 mm out from the key axis, where the web barely sweeps at
  all. Everywhere the web actually needs room, the slot is generous.
- **The wedge has to open faster than sin(swing).** This was the real limiter:
  the web was jamming on the wedge *wall* 5.8 mm out, not at the throat, because
  the wall opened at 0.50 mm of half-width per mm where the web's corner needed
  0.54. The mouth now flares to 15 mm at the nose face.
- **The web is parallel and thin across the whole slot** — 2.2 mm — and only
  flares to 5.0 mm at its root inside the body. A web that starts tapering
  immediately is already 25% wider by the time it reaches the throat, which cost
  about 10° on its own. The flare is what makes the root strong.

Measured on the mesh and by interference test, not calculated: **throat 6.3 mm
against a 9.0 mm key — 1.35 mm of interlock a side, 2.7× v1** — and it swings
**25° completely free, rubbing lightly from 30°**, with the neighbouring car's
wheel joining in at 33° and a real collision by 38°. Pulling two coupled
platforms straight apart is hard-blocked: the key jams on the throat.

**Snap-on wheels.** A stepped hole in each flank: a 10.1 mm neck through 12 mm of
wall, opening into a 12 mm chamber. Both bores are cut as teardrops, because
they are horizontal holes and a round ceiling in a horizontal hole has to be
bridged. The wheel carries the peg; the platform carries only the hole.

## The wheel

34 mm across, 8 mm wide, printed lying on its outer face with its peg pointing
straight up — which is exactly why the peg is on the wheel and not on the
chassis. A peg on the chassis points sideways, so its retaining shoulder faces
sideways too and cannot be printed; standing up, the shoulder is a 37° cone and
the whole part needs no support at all.

**The peg is slit, and it has been through four versions.** A barb cannot pass a
smaller hole unless something gives, and the only thing that can give is the
peg — so it is split down its axis into two fingers that flex inward as the barb
passes the journal and spring back into the chamber behind it. That also means
**a snap peg is never a solid pin**; the two are mutually exclusive.

The first version snapped its fingers off on the first attempt to fit a wheel.
The reason was a mistake in how it was sized: the peg prints standing up, so its
layers are horizontal and a bending finger is pulled *across* them — PLA's
weakest and most brittle direction. It was designed to 1.2% strain, which bulk
PLA shrugs off and a bond line does not. Three other things made it worse: the
finger was as short as it could be (3 mm of journal), the slit bottom was a
square corner sitting exactly at the finger root, and the hole had no lead-in,
so a wheel offered up against a flat flank went in crooked and side-loaded one
finger on its own.

| | v1 (broke) | v2 | v3 | v4 | now |
| --- | --- | --- | --- | --- | --- |
| wheel diameter | 22 mm | 22 mm | 26 mm | 26 mm | **34 mm** |
| shaft | 4.6 mm | 5.4 mm | 7.6 mm | 7.6 mm | **9.3 mm** |
| slit width | 2.0 mm | 2.0 mm | 2.6 mm | 1.3 mm | 1.3 mm |
| finger thickness | 1.3 mm | 1.9 mm | 2.5 mm | 3.15 mm | **4.0 mm** |
| journal / finger length | 3.0 / 8.9 mm | 7.0 / 13.7 mm | 9.0 / 15.7 mm | 9.0 / 16.2 mm | **12.0 / 22.6 mm** |
| interference per side | 0.50 mm | 0.35 mm | 0.35 mm | 0.35 mm | 0.35 mm |
| peak strain | 1.2% | 0.53% | 0.53% | 0.63% | **0.41%** |
| push to seat | ~10 N | ~7 N | ~15 N | ~29 N | **~37 N** |

Two of those steps are worth understanding, because they pull in opposite
directions.

**v4 halved the slit**, which is the direct way to a thicker finger — but it runs
the *other* way on strain: a thicker finger strains more for the same deflection,
and the push roughly doubles.

**The current step went back to the only real lever, the wheel itself.** Fingers
can only get thicker if the peg gets fatter, the peg needs a bigger bore, and
**the bore is capped by the chassis height, not its width** — the chamber is a
horizontal hole and the floor under it has to survive. Raising the wheel 26 -> 34
lifts the axle 13 -> 17, and that 4 mm pays for two things at once: the chamber
grows to 12 mm (52% more finger section) *and* the ground clearance goes 5 -> 8
mm, with the floor between them coming out thicker than before, not thinner —
3.0 mm against 2.85.

Lengthening the journal 9 -> 12 mm in the same move is what keeps it comfortable.
Finger stiffness goes as 1/L³ and strain as 1/L², so the longer finger takes the
strain back down to **0.41%** — the lowest it has ever been, on the thickest
section it has ever had — and holds the push to ~37 N. That is a firm adult push
of about 3.8 kg, deliberately not something a child does, and it is a one-time
assembly cost; the section is what survives being handled afterwards.

**The bore is 17.5 mm deep** — a 12 mm journal then a 5.5 mm chamber, into a
flank 21 mm thick, measured on the mesh rather than taken off the drawing. The
peg stops **2.0 mm short of the floor** (tip at y = 5.5, floor at y = 3.5), so
the wheel seats on its boss against the flank rather than bottoming out in the
hole. Deliberately overshooting the seat by 3 mm reports a collision at the boss
*and* at the peg tip, which is the test that proves that margin is real.

The wheel turns on the 9.3 mm shaft inside the 10.1 mm journal — a 12 mm long
bearing, so it runs straight — and bears against the flank on a 16 mm boss rather
than on its whole face. The boss has to stay outside the socket's flared mouth
(13.1 mm across) or it drops into it and the wheel binds; 16 mm leaves a 1.45 mm
land. It has about 1.0 mm of side play, which is the height of the retaining
cone.

## The letter

**A letter is nothing but a letter.** No plinth, no tongue, no tab: it is the
bare glyph, and it attaches by standing in a long groove down the deck, resting
on the groove's floor. This is a learning toy, and anything on a letter that is
not the letter is a distraction.

`A` is 35 mm wide, 44 mm tall, **7 mm thick** — 4 mm of it stands in the groove
and 40 mm shows above the deck. All 26 exist: `models/letter/a.scad` through
`z.scad`, each a three-line file over the shared `glyph.scad`. Drop it in and it stands up; lift it out
and it's gone. The groove mouth is flared, so it does not have to be aimed.

It is a flat plate of one thickness, so it prints face-down with no overhang
anywhere and no supports, and the face on the bed comes out smoothest.

**Every glyph is trimmed flat at the baseline.** Round letters (O, C, G, S)
overshoot the baseline by design, and a letter standing on a convex curve has
nothing to stop it rocking. The trim costs nothing visible and gives each one a
flat foot.

### The groove is oversize and a leaf spring clamps the letter in it

Four straight-slot fits were tried — 0.5, 0.2, 0.05 and finally 0.0 mm a side —
and every one came out loose. That is the lesson, not the numbers: **a straight
slot's grip is nothing but the print tolerance.** Neither part can give (the
letter is a 7 mm plate, the deck has 17 mm of material behind each wall), so the
fit is whatever the printer happened to deliver.

So the groove is deliberately too wide — **11.5 mm for a 7.0 mm letter** — and a
**leaf spring** lives permanently down one side of it, pressing every letter
against the opposite wall. It is printed separately, dropped into two pockets in
the groove floor and glued once; after that letters stay a plain one-handed
drop-in, with nothing to remove or refit to change one.

A spring delivers much the same force anywhere in its travel, so the groove can
print wide or narrow and the letter is still clamped.

**It is a single span with no intermediate support**, anchored only at its two
ends and bowing toward the letter in between. That is not a simplification — any
support between the ends pins the contact face where it sits, and a letter
bearing on that spot cannot push it at all. The version before this waved back to
the wall at mid-length and was rigid exactly there.

**Its anchors sit outboard of every letter's foot.** Measured across all 26
exports, no letter's foot reaches past x = 18.3; the anchors start at 19.8. So no
letter can bear on the rigid ends, which in turn means the leaf needs no recess
at its ends — and that matters, because a recess forces a taller bow, and a tall
bow falls away from the letter fast. At 0.5 mm of recess the leaf stood proud of
the letter over only ±8.4 mm, and **A** — whose two feet straddle the centre at
|x| = 10…18 — compressed it 0.02 mm instead of 0.42. With no recess the whole
span is live.

Measured, how far each letter actually pushes the leaf back (0.42 is full):

| | letters |
| --- | --- |
| 0.42 mm (full) | B C D E G I J L M O Q S T U V Y Z |
| 0.34–0.38 | F K N P W X |
| 0.30 | H R |
| **0.27 (worst)** | **A** |

So the weakest case is A at 64% of full force, ~13 N; most letters get the full
~21 N.

### Sizing it: force and creep, not force and stiffness

```
F = 4·E·h·t³·δ / L³        σ = 6·E·t·δ / L²
```

Stress is the ceiling, not yield: the preload never comes off, and PLA held much
above ~25 MPa creeps its force away over months. A long span is what lets the
leaf be **thick**, and thickness is what carries force — 4.0 mm over 39.6 mm
gives **21 N at 19 MPa**. Two earlier versions got this backwards, thinning the
strip and adding waves to make it "springier", which lowers the force.

| | |
| --- | --- |
| leaf | 4.0 mm thick over a 39.6 mm span |
| bow / preload | 0.42 mm |
| clamping force | **~21 N** (13 N worst case, A) |
| stress at preload | ~19 MPa |
| back clearance | 0.92 mm |

The **anchors are 4.5 × 6 mm blocks** dropping 2.5 mm into pockets in the groove
floor, with a spot of glue — nothing like the 1 × 6 mm pegs of the first attempt.

They used to drop 6 mm, and the bigger wheels are why they no longer do. The axle
chamber is bored as a teardrop, so its 45° gable reaches 8.5 mm above the axle —
to z = 25.5 — while a 6 mm leg put the pocket floor at 23.8. The two voids met,
and the chassis came out **genus 2 instead of 0**: two tunnels straight from the
letter groove into the wheel bores. Raising the pocket floors to 27.3 is the
cheap side of that trade. The legs only locate the spring and stop it creeping up
when a letter is pulled out — the glue does the rest — whereas the chamber is
what holds the wheel on. Nothing about the leaf's bow, span, thickness or anchor
length moved, so none of the engagement figures above change.

### The groove is 52 mm long, and that is why the nose sticks out

The letter's own footprint has to fit inside the groove, and its footprint is the
full width of the letter — so the groove is 52 mm on a 64 mm deck. The coupler
socket used to occupy the deck from x = 19.2 outward, straight through where the
groove now runs, so **the socket moved into a 9 mm full-height nose extension.**
It is a plain tapered prism, so it adds no overhang — just 9 mm of length, and
9 mm more between letters.

The font matters more than it looks: the widest letter sets the groove length.
Helvetica Bold has the narrowest W of any bold sans on this machine (1.27x the
cap height, against Verdana Bold's 1.46), and condensing to 0.85 buys back cap
height for the same footprint. At these numbers W is 47.5 mm wide inside a 52 mm
groove.

### Which letters stand up, and which do not

A bare glyph stands on its own foot, so steadiness varies by letter. Measured on
every export — the foot each one actually lands on, and the lean it tolerates
before tipping in its own plane:

| tips at | letters |
| --- | --- |
| 30-39 deg (solid) | A M X K R H N Z E L W |
| 20-28 deg (fine) | G Q B D |
| 15-17 deg (watch) | U O S C |
| 14 deg | J |
| **~10 deg (tippy)** | **V P I F Y T** |

The six at the bottom are the single-stem letters — a sans-serif `I` is a bar
standing on 7.8 mm, and `T`, `F`, `P`, `Y`, `V` are little better. Note what does
*not* fix it: groove depth. The groove holds a letter sideways; fore-and-aft it
is held by its own foot, and the tipping angle is `atan(half-foot / centre-of-mass
height)`, neither of which depth changes.

**The zero-clearance groove may well cover for it.** Those numbers assume a
letter free to pivot on its foot; a groove clamping both faces over 4 mm resists
that rotation by friction, and how much is a question only the print answers. If
the six still topple, the fix is a face with feet — Georgia Bold gives `I` and `T`
a 20 mm foot, Rockwell Bold 21.5 — which is a legibility trade rather than an
engineering one, and a one-line change to `letter_font`.

## Parts

| Model    | Part       | Print size            | Prints on          | Per platform |
| -------- | ---------- | --------------------- | ------------------ | ------------ |
| platform | `chassis`  | 97.5 x 42.0 x 26.0 mm | its flat underside | 1            |
| platform | `wheel`    | 34.0 x 34.0 x 24.7 mm | its outer face     | 4            |
| platform | `spring`   | 51.6 x 4.9 x 6.5 mm   | its deck-flush face | 1           |
| letter   | `a` .. `z` | up to 47.5 x 44 x 7 mm | its face          | 1 each       |

## Printing

- **One chassis, four wheels, one spring and one letter per car.** The letter prints flat on
  its face, exactly as exported — no supports, no brim, and the face on the bed
  comes out the smoothest.
- **One chassis and four wheels per letter.** The chassis is happy in PLA.
  **Print the wheels in PETG if you have it** — their fingers have to flex
  across the layer lines, and PETG is both tougher and far less brittle there
  than PLA. In PLA, run the wheels 5–10 °C hotter and slower than usual; layer
  bonding is what is being asked for, and extra perimeters do not buy it.
- **Orientation: as exported, for both parts.** No supports and no brim.
  - The chassis lands 2905 mm² of first layer under a part 26 mm tall. Its
    footprint did not change when the body grew — only its height did.
  - The wheel lands 824 mm² under a part 24.7 mm tall, so it is if anything
    better planted than the 26 mm wheel was.
- 0.2 mm layers, 15–20 % infill, 2–3 perimeters. Solid volumes are 63.1 cm³ for
  the chassis (~21 g at 20 %) and 8.1 cm³ per wheel (~6 g); call it about an
  hour and a quarter for a chassis and 25 minutes for a wheel. The 34 mm wheel
  and the stronger axle roughly doubled the plastic in a wheel — that is what
  the ground clearance and the 4 mm fingers cost.
- **Assembly**: drop the spring into the groove, legs into the two pockets, with
  a spot of glue in each — that is a once-per-platform job. Then offer each wheel
  up square to the flank — the flared mouth will
  pull it straight — and push until the boss meets the flank and it clicks. That
  is the whole build. Push, don't rock: a wheel worked in at an angle loads one
  finger on its own, which is how the first set broke.
- Off the chassis a wheel is small enough to be a choking hazard, and the barb
  *can* be pulled back out with determination. Check all four are properly
  clicked in before handing the train over.
- The tread is plain — it rolls well on hard floors and slips a little on
  carpet. Printing the wheels in something grippier (TPU) works if you have it.

## Tuning

Everything is in `lib/common.scad`.

| What you want                         | Change                                          |
| ------------------------------------- | ----------------------------------------------- |
| Thicker or thinner letters            | `letter_t` — the groove, and the letter itself, both follow |
| A letter that grips harder            | `letter_grip` up (or `letter_fit` down) — it steepens the wedge. Neither helps fore-and-aft tipping, which is the glyph's own foot |
| Bigger wheels / more ground clearance | `wheel_dia` (`axle_z` and the deck follow), then `body_bot` for the clearance itself. This is also the only way to fatten the axle — see above. Check three things after: the floor under the axle chamber, the chamber's teardrop gable against the spring pockets above it, and the swing of a coupled pair |
| A longer or shorter chassis           | `body_l` — `wheelbase` cannot go below `wheel_dia` + 2 mm |
| A softer wheel snap                   | `axle_neck_l` longer, or `axle_slot_z` deeper — both lengthen the finger. Not `axle_barb_d`, which is what holds the wheel on |
| More swing at the coupler             | `coupler_slot_face_w` (open the wedge faster) or `coupler_neck_w0` thinner — but only up to 33°, past which it is the neighbouring car's wheel, not the joint. Beyond that the lever is `coupler_key_x`, which spaces the letters further apart |

## Still to come

Nothing structural. The open question is the font: six letters stand on a narrow
foot (above), and whether that matters is something the first full set will show.

## License

The models in this project are licensed
[CC BY-NC 4.0](LICENSE) — free to print, remix and share for
non-commercial use, with attribution.
