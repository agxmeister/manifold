# bracelet

A bracelet made of **printed 3D fabric**: a row of rigid bars joined by
print-in-place **hinges**. It comes off the bed as a band that rolls up around
a wrist, and nothing is assembled, glued, or picked out of supports.

**Sized to the wrist it is printed for — a 192 mm loop on a 180 mm wrist,
15 bars, printed flat in a 199 × 17.6 × 5 mm strip.** The clasp is the same
short buckle at every size; length is band, not plate.

![the bracelet as it comes off the bed](previews/bracelet-bracelet.png)

It can also carry **charms**: turn on a few charm stations and the band grows
ball pins that separately-printed charms snap onto — firmly enough that they do
not fall off, by hand when you want them to. See [Charms](#charms).

## It hinges in one axis only

The band used to be a **grid** of small tiles, hinged along its length *and*
across its width. The cross-band hinges never worked. With `rows = 2` the only
one of them runs straight down the middle of the band, end to end — and both
clasp yokes are solid plates spanning the full width, so that line is built in
at both ends. A hinge clamped at both ends is not a hinge, it is a stiff seam.
It cost thirty-odd joints' worth of knuckles, bores and first-layer welding
risk and bought no movement at all.

So each column is now **one bar** spanning the whole band, and the only
articulation left is the one the wrist actually asks for. Half the joints
disappeared with it: the print has 27% less material hanging over air than the
version that came before it, and 8% more first layer.

## The rule this design obeys

**Nothing is cantilevered into air.** Every piece of material either stands on
the bed, or is a bridge anchored at *both* ends to material that stands on the
bed.

That rule is the whole design, and it is there because the two previous
versions of this bracelet broke it:

- A **cable chain** had to be tipped 45° to get both families of links onto the
  plate, and tipped, its arcs ran tangent to the bed. The outline leapt
  sideways further than a bead can carry and links tore off the plate. Twice.
- A **head-in-pocket** tile fabric replaced it, and was worse in a quieter way:
  the head was a *cantilever*. It left tile A and its far end was free,
  floating 0.4 mm above tile B's pocket floor, so the nozzle had to lay a
  1.2 mm bead nearly 5 mm out into air. It would have drooped onto the floor
  below and welded the fabric solid.

The overhang checker called that second one 92 clean `BRIDGE` regions needing
no support. It was wrong: it measures the span between the features on either
side without asking whether those features are *bonded* to the region, and one
"anchor" was a loose floating head. **A `BRIDGE` verdict is only worth what its
anchors are worth.**

## How the joint works

```
         bar A                                        bar B
   +----------+   lug  #####                          +----------+
   |          |--------#####===== pin =====           |          |
   |   body   |        #####      (o) blade, bored    |   body   |
   |  on bed  |--------#####===== pin =====  on bed   |  on bed  |
   +----------+   lug  #####                          +----------+
```

A three-knuckle hinge, repeated `rows` times along each joint — so a 2-wide
band is held by two knuckle clusters per joint and the bar cannot twist about a
single pin. Bar A carries **two lugs** with a **pin** fused into both of them;
bar B carries a single **blade** with a closed **bore** around that pin.

- The pin's free span is **3.2 mm**, anchored at each end inside a lug that is
  solid from the plate up. A bridge, not a cantilever.
- The blade's bore is a *closed* hole, so the roof over the pin is anchored on
  both sides too. (A hook opening toward the neighbour would simply pull off.)
- B cannot escape: the bore encircles the pin, and A's two lugs block the only
  way out along it.

Measured on the exported mesh:

| probe | reading |
|---|---|
| along the pin, at the bed (z = 0.10) | `lug 1.400 \| air 0.600 \| blade 2.000 \| air 0.600 \| lug 1.400` |
| along the pin, at its axis | one unbroken `SOLID 6.000` — fused lug to lug |
| vertical through the pin's free span | `floor 0.656 \| air 0.644 \| pin 1.792 \| air 0.453 \| roof 0.901` |
| vertical through a lug | `SOLID 4.445` — bed to top |

The first two lines are the point: the pin's anchors are feet on the plate, and
the pin is continuous between them.

**The 0.6 mm along the pin is the number the whole thing lives on.** A lug and
the blade beside it sit side by side and *both* stand on the bed, so their
first layers are laid 0.6 mm apart. At the 0.3 mm used elsewhere, two 0.4 mm
beads spread into each other and weld the joint solid on layer one, and no
amount of flexing afterwards frees it.

**And the pin is deliberately loose in its bore: 0.45 mm of radial play.** The
first version of this band ran 0.3 mm there, printed well and came off the
plate *stiff* — 0.3 mm is barely a layer and a half of clearance, so every
joint rubbed and the band would not drape. At 0.45 the pin is visibly loose in
the bore and the band falls limp. It is not free: the bore grew, so the knuckle
grew, so `pitch` had to step from 11.0 to 11.6 to keep the swing clearance.

Nothing is tangent to the bed either, and nothing overhangs off it. The pin's
underside is cut flat so its first layer is **1.20 mm** wide instead of a knife
edge, and the knuckle caps are **not plain discs** — see below.

The hinge swings freely through **±100°** and only binds at 110°. Wrapping a
180 mm wrist over 15 bars needs 24°.

### The knuckle cap is a chord, not a disc

A knuckle drawn as a full disc and cut flat at z = 0 leaves the bed at **65°
from vertical**. Its outline steps 0.348 mm in the first 0.2 mm layer — under a
0.4 mm bead, so it passes a step check, but it is still 87% of a bead hanging
over nothing, and it droops.

The circle is only ever needed as a **swing envelope**: when the hinge turns,
nothing may reach further than `rk` from the pin, because that is how close the
neighbour's body comes. Only the envelope has to be circular — the material
inside it does not.

So below the pin axis the arc is replaced by a straight **chord** from the foot
to the widest point. Both endpoints lie exactly `rk` from the pin, so the swing
envelope is untouched (still ±100°, still binds at 110°), and a chord lies
inside the arc it replaces, so clearance only improves. Above the pin axis the
arc stays — there the surface closes inward as it rises, which is a top
surface, not an overhang.

Measured on the mesh, in the band where the part leaves the plate (z < 0.69):

| | downward surface | past 45° | steepest |
|---|---|---|---|
| disc cap | 251.2 mm² | **184.4 mm²** | 68.9° |
| chord cap | 331.6 mm² | **0.0 mm²** | **31.7°** |

Per-layer step falls from 0.348 mm to a uniform 0.128 mm.

## The clasp

A **stud and a keyhole** — *not* a toggle. A toggle made of two flat plates in
the same plane does not lock: the bar has to lie across the ring's face,
perpendicular to the pull, and getting it there needs a 90° twist that a flat
PLA stand will never give. Coplanar, the bar just slides back out through the
bore.

This one locks out of plane. A 3.0 mm post carries a 5.4 mm head; the keyhole
plate has a 6.0 mm entry hole the head drops through, and a 3.3 mm slot the
post then slides along. Once the post is in the slot the head is **above** the
plate and cannot come back through it.

Two **detent bumps** pinch the slot to 2.7 mm, so the post snaps 0.15 mm past
them a side and will not wander back to the entry hole. Each bump sits on a
**cantilever spring leaf** — a 0.8 mm strip freed by a relief slot that
deliberately runs out into the entry hole. That free end is what makes it a
spring: built in at both ends it would take about 50 N to push the post past,
which is not a clasp but a jam. As a cantilever it takes roughly 6 N — a click
you can feel and undo.

The head's underside is a cone at 38.7° from vertical, so the stud prints
standing up with no support under the head.

The slot has a **minimum length**, and it is not cosmetic: the entry hole is
6 mm across and the detents sit only 1.8 mm from the seat, so on a short plate
the hole reaches the bumps and cuts them off the plate entirely. They then come
out of the printer as two loose 1 mm crumbs and the clasp has no detent at all.
That is why the sizing solve reserves at least 5.5 mm of post travel — and why
there is an assert measuring the gap between the entry hole and the bumps. At
the default size this never showed; it needed a small wrist to appear, and the
only symptom in the export was two extra shells.

## What is printed over air

| layer | reaches past a bead | what it is |
|---|---|---|
| z ≈ 1.4 | 87.4 mm² | each pin's first layer — a 3.2 mm bridge between two lugs |
| z ≈ 3.6 | 28.0 mm² | each bore's roof — anchored on both sides of the blade |

Nothing else in the print reaches more than one 0.4 mm bead past the layer
below it. Both entries are the same two anchored features as before, and the
trade the looser hinge makes is visible in them: each individual pin bridge and
bore roof is slightly bigger (3.2 mm rather than 3.0, and a 2.9 mm ceiling
rather than 2.4), while the total fell from 154 mm² to 115 mm² because half the
joints are gone. If one thing in this print wants a slow, well-cooled bridge
setting, it is those two.

Note that an overhang checker's clean bill is **not** what settles this. It
reported the same count of `BRIDGE` regions before and after a knuckle cap that
visibly drooped, and neither automated check ever saw that cap (see
`CLAUDE.md` — it took looking at the model in a slicer). The ray probes above
are what prove the anchors are real.

Bed stability: **15 separate contact patches**, 2362 mm² of first layer — one
per bar, with the two clasp plates fused onto the end bars. Each patch is a
full-width bar foot, so there is far more of it than the old tile grid had.

## Charms

`charms` bars along the band can grow a **ball pin** out of their top face, and
a charm snaps onto it. `models/flower-charm` is the first one and the pattern
for any other.

**A bar's top is the best mounting face in the project**: flat, horizontal,
5.0 × 16.6 mm inside the chamfer, and solid all the way down to the plate. So
the pin is a plain vertical stalk. It adds nothing to the footprint, no
overhang, no layer step — measured, not assumed: with three charms the export
is still 15 shells and genus 43, still 2338 mm² of first layer across 15
islands, still 0.00 mm² of downward surface past 45° below z = 0.7, and the
layer-step raster is **identical** to the plain bracelet's. The rule at the top
of this README is not even tested by it.

The pin is **fused to its bar, permanently**. Everything here is printed in
place; the joint that comes apart is the one at the *top* of the pin, where it
can be made as stiff as you like because nothing has to flex to get it there.

Set `charms` and the stations spread themselves evenly, clear of the two bars
carrying the clasp yokes. **`charms = 0` is the default, and the export is then
byte-for-byte the bracelet it always was.**

| `charms` | stations land on bars (of 15) | closest pair |
|---|---|---|
| **0 (default)** | — | — |
| 1 | 7 | — |
| 3 | 4, 7, 11 | 35.5 mm |
| 6 (the most that fits) | 2, 4, 6, 8, 10, 12 | 23.6 mm |

Rounding station indices to whole bars makes those gaps uneven, so what the
file checks is the **smallest** gap, not the average — an average happily
passes a pair that lands one bar apart.

### The snap, and why it holds

The head is a **4 mm ball on a 2.4 mm neck**; the charm's socket is a **4.4 mm
cavity behind a 3.5 mm mouth**, split by four slits. The mouth is 0.25 mm
narrower per side than the ball it has to swallow, so putting a charm on means
spreading four jaws — a firm push with a click. Seated, the ball has 0.2 mm all
round: the charm **spins freely and tilts about 14°**, and there is no
interference at all until you start pulling it off.

That is measured rather than hoped for. Walking the charm along the pin in the
pull-off direction and intersecting the two solids: nothing at all up to
0.3 mm of travel, overlap appearing at 0.6 mm, peaking around 1.6 mm at 0.16 mm
of characteristic thickness, and **four separate pieces the whole way** — one
per jaw, so all four are working.

**Printed and confirmed.** `charm_grip` = 0.25 is a proven number, not a
guess — if you change it, you are re-opening a settled fit. If some future
charm will not clip on, or clips on too easily, that is the one number to
touch, in `lib/charm-pin.scad`.

A mounted flower clears the five bars around it on a flat band, and the hinge
still swings free to ±100° and binds at 110° with a pin on the bar — the same
readings as without one.

### Neither half is a sphere on a stalk

Both halves are shaped by what FDM can print, and neither shape is the obvious
one:

- Below its 45° latitude a **ball** leans past what the nozzle holds up. The cap
  is removed by hulling the ball down to a disc the width of the neck, which
  leaves a 21° skirt under it and the full 4 mm equator — the part that does the
  retaining — untouched.
- The **socket prints mouth up**, so its cavity closes in on itself as the
  nozzle climbs, exactly like the roof of a horizontal hole. That is why the
  charm prints face down and is flipped to wear: the mouth is on its back, and
  the back has to point at the ceiling.

Neither half needs support, and neither bridges.

### The flower

16 mm across, 7.2 mm tall printed, one flat 131 mm² island on the plate. Six
petals, a countersunk eye, and the socket boss on the back. The face is
**engraved rather than embossed**, and the engraving is only the eye — a groove
that opens onto the bed splits the first layer into islands, and there is no
room on a flower this size for one that also clears the boss.

To make another charm: `include <../../lib/charm-pin.scad>`, union
`charm_socket(<your plate thickness>)` onto the back of a flat shape, and print
it face down. The socket brings its own asserts.

## Models and parts

```
projects/bracelet/
├── lib/charm-pin.scad                    # the ball-and-socket every charm shares
└── models/
    ├── bracelet/bracelet.scad            # the whole bracelet — one printed object
    └── flower-charm/flower-charm.scad    # one charm, printed separately
```

The bracelet exports as **15 separate shells** — one per bar, with the clasp
plates fused onto the two end bars. They are not supposed to touch. Every charm
exports as one piece.

| Model | Part | Size (print pose) | Sits on |
|---|---|---|---|
| `bracelet` | `bracelet` | 199.0 × 17.6 × 5.0 mm (10.25 with charm pins) | all 15 bars' own flat feet |
| `flower-charm` | `flower-charm` | 16.0 × 14.3 × 7.2 mm | its own face, 131 mm² in one piece |

## Sizing

`wrist` is the only number you normally touch, and `ease` (12 mm) is exact,
not approximate — the loop lands on `wrist + 12` at every size.

**How it lands there is worth knowing, because it changed.** The keyhole plate
used to soak up whatever the band could not cover, since the band only came in
whole bars. On a small wrist that left a 27 mm slab of flat plate hanging off
the end of a 149 mm bracelet. Now the buckle is cut to the shortest slot the
clasp can actually use — **5.5 mm of post travel, the same at every size** —
and the band makes up the difference: the solver picks the bar count that lands
nearest the nominal 11.6 mm spacing, then stretches or squeezes **every joint
equally**, by a fraction of a millimetre, to hit the length exactly. Bars never
change; only the gaps do, and they have about a millimetre of room between the
knuckles binding (11.3 mm) and the band looking gappy (12.7 mm).

`charms` is independent of all of it — it does not touch the length budget, and
the stations are placed on whatever bar count the solver lands on.

`rows` widens the band, adds a knuckle cluster to every joint, and costs
nothing but filament. It spaces those clusters on its own fixed `row_pitch`, so
the band's width does not wander when the length solver breathes the joints.

| `wrist` | bars | loop, clasped | joint pitch | printed footprint |
|---|---|---|---|---|
| 130 (4-year-old) | 11 | 142.0 mm | 11.55 mm | 149.0 × 17.6 mm |
| 140 (child) | 12 | 152.0 mm | 11.41 mm | 159.0 × 17.6 mm |
| 160 | 13 | 172.0 mm | 12.13 mm | 179.0 × 17.6 mm |
| **180 (default, adult)** | **15** | **192.0 mm** | **11.82 mm** | **199.0 × 17.6 mm** |
| 200 | 17 | 212.0 mm | 11.59 mm | 219.0 × 17.6 mm |
| 180, `rows=3` | 15 | 192.0 mm | 11.82 mm | 199.0 × 29.2 mm |

Post travel is 5.5 mm in every row of that table — that is the point of the
short buckle.

The band itself is 4.45 mm thick at every size; the 5.0 mm overall height is
the stud.

Other parameters worth knowing: `pitch_nom` / `body` (what bar spacing wants to
be, and the bar itself — the knuckles need room to swing, so `pitch_min` is
derived from `body` and the knuckle radius),
`pin_d` (2.0 mm — the entire load path of the band), **`bore_fit`** (0.45 mm,
the play in the hinge) and **`axial_fit`** (0.6 mm, along the pin — both above),
`fit` (0.3 mm, the swing and clasp clearances), `knuck_wall` (0.9 mm,
the deliberate thinnest wall), `knuck_slope` (32.7°, derived — the knuckle
underside, asserted at ≤ 40°), and the clasp's `det_gap` / `leaf_w` /
`leaf_free` if the detent wants to be lighter or firmer.

## Printing

```sh
openscad -o projects/bracelet/exports/bracelet-bracelet.stl \
         projects/bracelet/models/bracelet/bracelet.scad
openscad -D charms=3 \
         -o projects/bracelet/exports/bracelet-bracelet-c3.stl \
         projects/bracelet/models/bracelet/bracelet.scad
openscad -o projects/bracelet/exports/flower-charm-flower-charm.stl \
         projects/bracelet/models/flower-charm/flower-charm.scad
```

- **Lay it flat, exactly as modelled.** No rotation, no supports.
- **NO BRIM, and no raft.** This is the one setting that will ruin the print:
  the feet are 0.6 mm apart and a brim bridges straight between them, welding
  every hinge shut. A skirt is fine.
- **Layer height 0.20 mm, or 0.10.** Every interface in the joint sits on a
  0.2 mm boundary or close to it, so at 0.20 mm the clearances come out near
  their designed size.
- **Part cooling on, temperature at the low end of the range.** Every pin is a
  3.2 mm bridge and every bore has a 2.9 mm roof over it — the two places this
  print can go wrong.
- Three perimeters; infill barely matters at this wall thickness.
- PLA is the easy choice. PETG is tougher but strings, and strings between
  knuckles are exactly what you don't want here.
- Off the plate, **work each hinge back and forth before wearing it.** Even
  with the looser bore they come out a little stiff; a few flexes free them.
- To fasten: drop the stud's head through the round entry hole, then slide the
  ends apart until the post snaps past the detent and seats. To release, push
  it back past the detent and lift the head out.

### Charms

- The **flower prints face down, boss up, exactly as modelled** — no supports,
  no brim, one flat 131 mm² island. It is a five-minute print; print several.
- Print charms in the **same material and on the same settings** as the band.
  The snap is 0.25 mm of interference per side, which is inside the range a
  change of filament moves a fit by.
- The one thing to get right is the boss: **three perimeters, cooling on**. The
  jaws between the four slits are about 0.9 mm of wall each, and they are what
  has to spring.
- Charm pins on the band change nothing about how the band prints — same first
  layer, same bridges, same no-brim rule.
- To clip a charm on, hold the bar, press the charm straight down onto the ball
  until it clicks, then check it spins. To take one off, pull it straight off —
  it should need a deliberate tug, not a fingernail.

## License

The models in this project are licensed under
[CC BY-NC 4.0](LICENSE) — attribution, non-commercial.
