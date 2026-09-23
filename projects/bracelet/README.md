# bracelet

A bracelet made of **printed 3D fabric**: a row of rigid bars joined by
print-in-place **hinges**. It comes off the bed as a band that rolls up around
a wrist, and nothing is assembled, glued, or picked out of supports.

**Sized to the wrist it is printed for — by default a 142 mm loop on a
130 mm wrist (the 4-year-old it was printed for, and fits), 11 bars, printed
flat in a 150.5 × 17.6 × 4.7 mm strip.** `-D wrist=180` is the adult size.
The clasp is the same short buckle at every size; length is band, not plate.

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
180 mm wrist over 15 bars needs 24°; a 130 mm wrist over 11 bars needs a
little more, still far inside the swing.

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

This one locks out of plane. A **4.0 mm post** carries a 6.4 mm head; the
keyhole plate has a 7.0 mm entry hole the head drops through, and a 4.3 mm slot
the post then slides along. Once the post is in the slot the head is **above**
the plate and cannot come back through it. (The post was 3.0 mm and fragile — it
prints standing up, so it snaps along a layer line. Bending strength goes as the
cube of the diameter, so 4.0 mm is 2.4× as strong.)

Two **detent bumps** pinch the slot to 3.7 mm, so the post snaps 0.15 mm past
them a side and will not wander back to the entry hole. Each bump sits on a
**cantilever spring leaf** — a 1.0 mm strip freed by a relief slot that
deliberately runs out into the entry hole. That free end is what makes it a
spring: built in at both ends the post would need something like 50 N to pass,
which is not a clasp but a jam. The leaf is 1.0 × 2.8 mm (the first print's
was 0.8 × 2.5), which makes it **about 1.4× as firm at the same 2.9 % peak
strain** the printed leaf survived.

**It sits tight, not just latched.** The bumps now sit right at the seat and
**cradle** the post: pulled against the seat's far wall it touches them too, so
it cannot rattle along the slot (it used to have ~0.6 mm). And the head's cone
is set so it meets the slot edge 0.15 mm above the plates with the post
centred — under the band's pull it meets the rim right at the plate's top face
and clamps the two plates together. The first clasp let them lift ~0.5 mm.

The head's underside is a cone at 38.7° from vertical, so the stud prints
standing up with no support under the head.

**The buckle is as short as the clasp allows: 17.2 mm between the two end bars
when fastened, down from 20.5.** Every length in it is now a constraint rather
than a round number:

- the entry hole sits 1.0 mm off its bar (it stood 4 mm off);
- post travel, entry to seat, is the least that keeps the entry hole off the
  detent bumps — 4.1 mm, because the bumps now sit at the seat;
- the stud reaches just far enough that, while the head drops through the entry
  hole, the keyhole plate's tip comes down **beside** the stud's end bar rather
  than on it. The first clasp overran that bar by about a millimetre and had to
  be tilted in.

The slot still has a **minimum length**, and it is not cosmetic: on too short a
plate the entry hole reaches the detent bumps and cuts them off the plate
entirely. They then come out of the printer as two loose crumbs and the clasp
has no detent at all — the only symptom is two extra shells. There is an assert
measuring the gap between the entry hole and the bumps.

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

Bed stability: **one separate contact patch per bar** — 11 and 1807 mm² of
first layer at the default size, 15 and 2396 mm² at `wrist=180` — with the two
clasp plates fused onto the end bars. Each patch is a
full-width bar foot, so there is far more of it than the old tile grid had.

## Charms

`charms` bars along the band carry a charm, and there are **two ways they can
carry it** — `charm_mount` in `bracelet.scad` picks one for the whole band:

| | `"ball"` (default) | `"screw"` |
|---|---|---|
| on the bar | a ball pin **fused** to its top face | a threaded hole **through** it |
| the charm | clips over the ball and swivels | winds onto a loose double-ended screw, and sits flat on the bar |
| comes apart | charm only; the pin is there forever | charm, screw and all |
| charms | flower, heart, kitten, puppy, frog | star |
| proven | printed and worn | printed and worn |

The ball mount came first; the screw mount came later and was printed and
confirmed on 2026-09-19 — screws, star and a threaded band. It was then opened
back up to fatten the thread to M4, to seat the charm flat on the bar and to
turn the charm over, and **that revision is confirmed too**, on 2026-09-20. It
is described [below](#the-screw-mount).

With `charm_mount = "ball"`, `charms` bars grow a **ball pin** out of their top
face and a charm snaps onto it. There are five: a **flower**, a **heart**, a
**kitten**, a **puppy** and a **frog**. They all use the same ball-and-socket,
so any charm fits any station, and each one is its own five-minute print.

**A bar's top is the best mounting face in the project**: flat, horizontal,
5.0 × 16.6 mm inside the chamfer, and solid all the way down to the plate. So
the pin is a plain vertical stalk. It adds nothing to the footprint, no
overhang, no layer step — measured, not assumed (at the 180 size): with three
charms the export is still 15 shells and genus 43, still 2338 mm² of first
layer across 15 islands, still 0.00 mm² of downward surface past 45° below z = 0.7, and the
layer-step raster is **identical** to the plain bracelet's. The rule at the top
of this README is not even tested by it.

The pin is **fused to its bar, permanently**. Everything here is printed in
place; the joint that comes apart is the one at the *top* of the pin, where it
can be made as stiff as you like because nothing has to flex to get it there.

Set `charms` and the stations spread themselves evenly, clear of the two bars
carrying the clasp yokes. **`charms = 0` is the default, and the export is then
byte-for-byte the plain bracelet.**

| `charms` | stations land on bars (of 15) | closest pair |
|---|---|---|
| **0 (default)** | — | — |
| 1 | 7 | — |
| 3 | 4, 7, 11 | 36.2 mm |
| 6 (the most that fits) | 2, 4, 6, 8, 10, 12 | 24.1 mm |

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

A mounted charm clears the five bars around it on a flat band, and the hinge
still swings free to ±100° and binds at 110° with a pin on the bar — the same
readings as without one.

All five charms were walked off the pin the same way and gave the same four
numbers, which is the point of having one library: the joint is identical, so
a charm that clips on is a charm that clips on.

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

### The five charms

Every charm is the same idea: a flat plate printed **face down** on the bed,
its decoration **engraved** into that face, and the socket boss rising from the
back. Flip it over to wear it.

| charm | size, print pose | first layer | the printed face |
|---|---|---|---|
| `flower-charm` | 16.0 × 14.3 × 7.2 mm | 131 mm² | six petals, a countersunk eye |
| `heart-charm` | 15.7 × 13.9 × 7.2 mm | 138 mm² | two gloss streaks on one lobe |
| `kitten-charm` | 12.0 × 15.6 × 7.2 mm | 126 mm² | eyes, nose, an upturned mouth |
| `puppy-charm` | 15.0 × 13.9 × 7.2 mm | 138 mm² | eyes, a big nose, a split mouth |
| `frog-charm` | 15.8 × 13.6 × 7.2 mm | 155 mm² | pupils, nostrils, a wide smile |

Each is **one island on the plate** and one piece in the export, the thinnest
wall on any of them is 1.30 mm, and none of them needs support.

**The silhouette carries the shape; the cuts only carry the detail.** On a
16 mm charm that is not a style choice, it is what fits. Ears, a muzzle, a
frog's bulging eyes are part of the **outline**, where they get to be
millimetres of real material; eyes, nose and mouth are engraved, where they
cost nothing to print.

What you cannot have at this size is fine detail, and the kitten is the proof.
**Whiskers were drawn and taken out twice.** Any whisker that keeps a printable
wall clear of the head's rim, of the nose and of the next whisker comes out
about 1.2 mm long — an invisible scratch — and the ones that looked right on
screen finished 0.2 mm from the rim. The inner-ear crease went the same way.
Four bold features beat eight faint ones.

Four shapes took a second pass, all for the same reason: the first version was
geometrically fine and *read* as the wrong thing.

- The **kitten's ears** started as wide lobes on a head hulled from two
  circles, and rendered as elephant legs — their bases were as far apart as the
  gap between them, so there was no notch to see, and the skull ran flat across
  the top. A narrower base brought in towards the middle, a longer taper and a
  head made from **one** circle fixed it; 3.7 mm of ear now stands clear of the
  skull.
- The **kitten's mouth** was a plain V from under the nose out to the cheeks,
  which is a frown: the arms only ever go down. It needs a third point a side
  so it can flick back up.
- The **frog's mouth** was a chevron and read as an arrowhead. Swept along an
  arc whose centre sits above the face, it is a smile.
- The **heart** was a spade. The lobes' sides run straight to the tip, so a tip
  drawn far down gives two long flanks and a point; pulled up until the lobes
  dominate, the outline goes round again.
- And the **puppy** was a cloud. Gentle ear bulges on a big round head have no
  outline to read, so the skull shrank, the ears grew into lobes that hang past
  it and down to the chin, and a **muzzle** — a third circle — pokes out below.
  The muzzle also pays for itself: on a plain round head the rim curved up under
  the mouth and left 0.9 mm of wall beside it.

Each of those is now a named number in the source with an assert on it —
`ear_notch`, `flank`, `ear_out`, `muzzle_out` — rather than something to
re-judge by eye next time.

### What an engraved face is allowed to do

`lib/charm-pin.scad` provides the two cutters every charm uses, a countersunk
`charm_dimple` and a tapered `charm_groove`. Both are 45° wedges with the wide
end at the face, so the void they leave **closes in on itself** as the nozzle
climbs — the same reason the socket prints mouth up. Neither runs to a true
apex: a cone or wedge drawn to nothing meshes into slivers, and the wall check
reads those as 0.00 mm.

What limits a cut is the material left **above** it, and `charm_cut_max` is
that number: **1.0 mm** on a 2.2 mm plate. It is the smaller of two
thicknesses, because a cut under the socket is actually freer than one out on
the open plate — the cavity floor is 2.87 mm thick, not 2.2.

Two more rules are not in the library, because they depend on the shape:

- **No cut may close a loop.** A ring-shaped groove cuts the first layer into
  islands. The flower's first version had an outline groove and turned one
  131 mm² island into twelve, four of them 0.0 mm², which the bed-stability
  check called unprintable.
- **Two cuts must either merge or stand a printable wall apart.** The near miss
  is the failure: two grooves 0.1 mm apart leave a 0.1 mm rib. Merging is free,
  and the animal charms use it on purpose — the mouth starts *inside* the nose
  dimple, which is also what a muzzle looks like.

The one overhang any charm reports is the puppy's nose. A 3 mm dimple at 45°
would be 1.5 mm deep, well past what the plate can spare, so it is truncated on
a 1.2 mm flat — a 1.2 mm horizontal ceiling at the top of a self-supporting
cone, which the slicer bridges without noticing. Running the cone to a point
instead would cut straight through the plate.

To make yet another charm: `include <../../lib/charm-pin.scad>`, union
`charm_socket(<your plate thickness>)` onto the back of a flat shape, cut the
face with `charm_dimple` / `charm_groove`, and print it face down. The socket
brings its own asserts.

## The screw mount

The ball pin is fused to its bar, so a bar that once carried a charm carries a
4 mm ball for the rest of its life. The screw mount takes the other road:
**nothing is fused and nothing springs.** A bar gets a threaded hole straight
through it, a loose **double-ended screw** winds into that hole until its hex
collar seats on the bar's top face, and the charm winds onto the other end. Take
everything off and the bar is a plain bar with a hole in it.

```
    ___________      star-charm, a solid — the screw lives inside it
   /  ║     ║  \     a blind threaded bore...
   \  ║╱   ╲║  /     ...over a COUNTERSINK that swallows the collar whole,
    \_╨═╧═╨_/         so the charm's own underside lands on the bar
   ────╨───╨────     the bar's top face — square-shouldered here, no chamfer
   bar ║ ⦀ ║         M4 x 2.3 through the whole 4.45 mm
   ────╨───╨────     the tip stops 0.25 mm shy of the underside
```

**The bar is what sets the size, not the screw.** The hole has to pass through
6.0 mm of bar — and the top chamfer used to take a millimetre of that before the
hole ever got there, which held the thread to an M3 in a rim only 0.85 mm thick.
So at a charm station **the chamfer is filled back in**: a lens of material
around the hole brings the bar back to its full 6.0 mm, square-shouldered, for
as far as the hole reaches. It costs nothing to print — the added material's
sides are flush with the slab below, so there is no overhang, no layer step and
no extra bed contact — and it buys the whole millimetre the chamfer was eating.

The hole is now **4.3 mm across with 0.85 mm of wall beside it, top to bottom**,
and the thread inside it is **M4 × 2.2** — major 4.0 mm, 0.4 mm deep, a coarse
pitch because a fine one on a 0.4 mm nozzle smears into a plain cylinder. That
is the same wall the printed version was proven at, around a shaft with 78% more
cross-section. There is no chamfer left to spend: fatter than M4 means a wider
bar.

**The charm sits down on the bracelet.** The collar used to stand between the
two — bar, then hex, then pad, a visible three-step stack with the screw on show
in the middle of it. The charm's pad now opens into a 6.04 mm **pocket** deep
enough to swallow the collar whole, so the pad's face comes all the way down
onto the bar's top and the screw disappears inside the joint. It costs no
height: the collar is swallowed, but the threaded bore starts the same 1.4 mm
deeper to meet it, so the star's face ends up exactly where it was.

What it does cost is **seat** diameter — the seat has to wall a 6.04 mm pocket
rather than a 4.3 mm bore, so it is **8.2 mm** and its rim overhangs the bar by
1.1 mm a side, out over the hinge gap. Nothing is in the way there: the knuckle
below it is a cylinder about the pin axis, so its envelope does not move when
the joint turns, and it clears the rim by 0.58 mm even at the tightest pitch the
band's solver can land on. The model asserts that against `pitch_min`, not
against the size that happens to be on the bench, and the band still swings free
past 40° with a charm seated on it.

**The charm prints seat down** — the face that lands on the bracelet is the face
that lands on the bed — so the screw ends up inside the charm rather than under
it. That is what turned the star from a plate into a solid; see below.

Both female threads now have to print, which was not true before. A thread cut
into a part has one flank as a groove ceiling and the other as a floor, and
*which* one depends on which way up the part goes on the bed — and these two go
opposite ways. The bar's hole reads the mouth-side flank as its ceiling and gets
the proven **31°**; the charm's socket reads the other one, so that flank was
fattened (`scr_dn` 0.2 → 0.30, paid for with pitch 2.2 → **2.3**) and comes out
at **41°**. Both are asserted on the finished surface, not on the drawn angle.
It also retires a trap: it used to matter enormously which way round the tooth's
asymmetry went, and now neither way is wrong.

**The screw prints lying down**, which is the whole reason it is a separate
part. Standing up it would be a 9.5 mm tower on a 3 mm circle with every thread
crest leaving the layer below at the tangent. Lying down it is a horizontal
cylinder, and a horizontal cylinder's only real problem is its underside — cut
off by a flat, exactly as the hinge pin's underside is. The flat lands 1.40 mm
from the axis, which on an M4 is squeezed between two bounds only 0.2 mm apart:
any further out and the shaft leaves the bed past 45°, any further in and it
stops short of the groove roots. There the thread *and* the roots both reach the
bed and the first layer is an unbroken 2.86 mm strip rather than a tangent
line. The thread is missing over the ~90° of arc the flat eats; the
other 270° hold, and a charm is not a load.

**The threaded holes print with no overhang at all.** A female thread's groove
roof is the only surface in the joint that hangs, and it is shaped so that it
does not: the tooth is asymmetric, slack on the flank that becomes the ceiling
and steep on the one that becomes the floor, which buys a printable roof for
about half the pitch a symmetric thread would cost. Measured on the export,
every ceiling is **31° from vertical**, and the band with three threaded holes
in it reports exactly the same 56 overhang regions as the plain band.

### What it costs

A screw stops where the thread stops. The charm ends up at whatever angle it
seats at — give or take the 45° of phase slack the clearance leaves — and is
held there by friction. **The ball let a charm spin and swing; this one does
not.** A star has five-fold symmetry and no obvious up, which is why it is the
charm that got built for this mount; a charm with a face on it would want the
seat re-thought first.

Both threads are right-handed, so tightening the charm also tightens the screw
into its bar. Unscrewing the charm tends to bring the screw out with it, which
is no loss — they then unscrew from each other.

### The star

`star-charm` is the charm built for this mount: a five-pointed star, 16 mm tip
to tip and 7.3 mm tall, printed **flat side down** with the whole screw buried
inside it.

```
        ___                   a 45° bevel on the boss
       /   \                  the BOSS: 7.1 mm wide, tall enough to swallow
      |     |                   the socket. A top feature — no support needed
    __|     |__
   |___________|              the plate: the full 16 mm star, 3.4 mm thick
   ^^^^^^^^^^^^^              flat on the bar, flat on the bed
```

**This is the second shape.** The first was a solid — a 45° skirt rising from an
8.2 mm seat out to the points, because a 16 mm plate held on an 8.2 mm seat
would be cantilevered into air. It printed beautifully and then **came off the
plate**: the only face touching the bed was the seat, the seat is an *annulus*
(the collar's pocket is a hole through the middle of it), and 24 mm² under a
7.3 mm part was not enough. It detached mid-print.

So the plate came back and the socket went the other way — hidden under a raised
middle on the **top** face instead of behind a skirt on the bottom. The first
layer is now **61 mm²**, and everything in the part is either a vertical wall or
a surface that closes inward as it rises. No supports, no brim.

**The five points are relieved, and the number is measured, not chosen.** A flat
face at the band's top rests on a plane — `thick` is `pin_z + rk`, so a knuckle
crest reaches exactly a bar's top face and nothing on the band is higher. But
that is only true while the joint is *still*. Turn it and the knuckle's ARM, a
full-height rectangle behind the cap, tilts its top edge up above that plane.
Swept against the real band, a flat underside is clear out to **r = 5.8** at 40°
of swing. Past that the points are lifted at 45°, which is the shallowest rise
that prints, so they end up 1.2 mm thick at the tips against 3.4 mm at the
middle. The band swings free to 30° with a charm seated on it and binds at 40°;
a wrist needs 24°.

What grows there is a **disc**, intersected with the star — so new material on
each layer is always within a layer height of the one below and the outline
never leaps sideways. Offsetting or scaling the star instead makes a point
emerge tangentially from the body, which is the same sideways leap that tore the
old cable-chain design off the plate.

There is **no engraving**. The bed-side face is against the bracelet where
nothing would be seen, and a cut into the top would be an overhanging void. The
raised middle is the decoration.

**The pocket is a countersink, and that came from a real print.** The first
version had a straight pocket, which steps in to the thread across 0.77 mm of
annulus — a downward-facing ring with nothing under it. It was written off as "a
bridge anchored all the way round"; on the plate it hung, and it is the first
thing the slicer draws on this part. The collar is now tapered and the pocket
tapered to match, at the same 35° and with the same `scr_pocket_fit` clearance
the whole way up, so the void closes in on itself as the nozzle climbs. What is
left of the ledge is 0.1 mm — a quarter of a bead — and it cannot be closed
further without either putting the cone's small end on the thread's crest circle
(which meshes as a sliver) or inside it (which fouls the screw). It cost nothing
and it gained a tenth of a turn of thread, because the pocket now ends level
with the collar instead of 0.2 mm above it.

One ceiling is left, buried 5.8 mm inside the part: the blind end of the bore, a
4.3 mm disc. That one is an ordinary bridge with support all the way round, the
band's own bore roofs are 2.9 mm of the same thing, and it cannot be coned away
— a 45° point over a 4.3 mm hole is 2.15 mm tall and the roof is 1.5.

The M3 version of the joint printed first time on 2026-09-19 — the screws in a
batch of six, the star, and a band with three threaded stations — so the 0.15 mm
thread clearance is a proven fit rather than a calculated one, and it has not
moved.

The M4, the 2.3 pitch and the seat went on the plate on 2026-09-20 and were
fine. The star took three attempts the same day: the first hung its pocket's
eave, the second detached outright, and the third — the countersunk pocket and
the flat bottom with the raised middle described above — **printed well and is
confirmed**. So the 35° countersink, the r = 5.8 flat bottom and the 41° groove
roof of a mouth-down thread are all proven on a real plate now, and so is
everything else on this page.

## The H-pin mount

A third way to hang a charm, and the only one **snapped on at both ends**.
The first version was **printed and confirmed on 2026-09-23** ("It printed
well"), on the same print as the reworked clasp. It sat very well in the bar
but a bit loose in the charm, so the pin's spring was **retuned the same
day** (see *Why the charm was loose*). That version is **not printed yet**.
The pin, the butterfly and the band's pockets all changed, slightly.

![a butterfly on its H-pin, and a pin over an empty pocket](previews/bracelet-bracelet-c3-h.png)

The pin is a flat **H**: two upright legs joined by a crossbar, a small hook on
the end of every leg. A bar gets a **pocket** sunk into its top instead of a
pin or a hole. The lower half of the H pushes down into the pocket until the
crossbar bottoms out, and the lower hooks snap under shoulders at its foot. The
charm then pushes down over the upper half and the upper hooks snap into it.
The crossbar ends up **sunk 0.3 mm into the bar**, so the charm comes down flat
onto the bar and the pin is not on show anywhere.

```
  charm  |<   >|    upper hooks point IN, into the charm's two holes
  -------|=====|--- bar top: the crossbar sits just below it
  bar    |>   <|    lower hooks point OUT, under 45° shoulders in the pocket
```

**The two halves are the same length** — 3.45 mm each side of the bar's top
face — so the pin is 11.1 × 6.9 × 2.8 mm. Tell them apart by the hooks: the
half whose hooks point **out** goes into the bracelet.

`charm_mount = "h"` in `bracelet.scad` cuts the pockets; `models/charm-h-pin`
is the pin and `models/butterfly-charm` is the charm built for it.

### The H prints lying flat, so its hooks are free

The whole pin is a 2D outline extruded 2.8 mm straight up. Its hooks are just
corners of that outline, so nothing on it overhangs, and the one part that
flexes flexes **in the plane of the bed**, along its perimeters.

### The crossbar is the spring, for both halves

Both halves are far too short to bend — a 3.45 mm leg flexed 0.4 mm would
strain ~6–15 %. So the legs do not bend, they **turn**, and the crossbar bends
in an arc between them: **2.55 % strain** at worst, under the 2.9 % the clasp's
printed leaf runs at. The crossbar carries none of the pull, which goes
straight down the legs.

That is why the upper hooks point the other way. Turning a leg moves its two
ends in opposite directions. Pushing the pin into the bar squeezes the lower
hooks in and the upper legs splay out — freely, there is no charm yet. Pushing
the charm on then splays the upper legs out again, which swings the lower ends
**in**: with the lower hooks pointing out, that eases them off their shoulders
a little, and they spring home as the charm snaps. Had all four hooks pointed
out, fitting the charm would have driven the lower hooks up into their
shoulders and jammed.

So: **pin into the bracelet first, then the charm onto the pin.**

### Why the charm was loose

The crossbar sits in the bar, so the legs turn about a point just below the
bar's top face. The bar's hooks are close to that point and the charm's are
far from it. A hook's grip goes as **1 / lever²**: the first pin had its charm
hooks at the very top of their legs, on a 3.2 mm lever against the bar's
1.8 mm, so the charm was held with about **a third** of the bar's force.

The legs are still the same length each side, but the charm's hooks now sit
**as low on them as the charm allows** (1 mm of charm under each catch), with a
long, gentle 19° ramp from the hook up to the leg's end. That cuts their lever
to 2.4 mm. The crossbar is also a little thicker, 0.9 mm instead of 0.8.
Against the printed pin, the charm now holds about **2.5×** as firmly and the
pin pushes into the bar about **1.5×** as firmly.

The charm's lever is still deliberately the longer one. Pulling the charm off
turns the legs the same way that frees the bar's hooks. With the longer lever,
the charm's hooks clear first, while the bar's still overlap their shoulders
by 0.11 mm, so the pin stays in the bar.

### The two catches are different angles, and that is on purpose

- **In the bar, 45°.** The bar prints upright, so the shoulder a lower hook
  catches under faces down — a ceiling — and this project prints no flat
  ceilings. 45° is only a detent, but it never has to be more: the lower hooks
  can only let go by turning the legs, and while a charm is on, the charm
  holds the upper legs still. **The pin cannot leave the bar with a charm on
  it.**
- **In the charm, 55°.** The charm prints bottom down, so the shoulder its
  hooks catch on is a *floor* and can be any angle. A steeper catch is what
  makes the charm **hold**: it takes a firm tug to pull it off. `hp_catch_up`
  is the number to tune: 45 makes the charm easy to pull off, and past 60
  friction locks it on for good (an assert rejects that). If the charm is now
  too firm, lower this. If the pin is too hard to push into the bar, set
  `hp_cb_h` back to 0.8, which returns the bar side to exactly how it printed.

### What it costs the band

Nothing it prints with. The pocket is 3.1 mm along the band and 11.4 mm across
it, 3.65 deep, leaving 1.45 mm of wall either side (0.99 at the chamfered rim)
and **0.8 mm of floor**. So the first layer is identical to the plain band
(1807 mm² over 11 bars at the default size), the genus is unchanged and it is
still one shell per bar. The only new overhangs are the pockets' 45° shoulders.

### The butterfly — a 3D charm

It prints **bottom down**: the face that lands on the bracelet is the face that
lands on the bed. That is what lets it be a solid thing rather than a flat
plate. A raised, rounded **body** runs across the band with a head and two
antennae at the front, and the **wings lift away from it in a shallow V**, with
a spot sunk into each one.

- The body is where the pin goes: its two holes open on the bed, and their far
  ends have **pointed 45° roofs**, since a flat one would be a ceiling. 6.5 mm
  tall, it stands 7.0 off the band's top at the antennae — against 8.8 for the
  ball charms.
- The wings' **undersides rise at 43.6°** beyond |x| = 5 mm, so every layer
  lands on the one below (the star's trick, in a V). That also keeps them
  clear of the neighbouring hinges, whose arms tilt up above the band as a
  joint turns: with a butterfly seated, the neighbours swing clear to **±40°**
  at both 130 and 180 and bind at 60 (a wrist needs about 24°).
- 15.8 mm wingspan along the band; 18.6 mm across it with the head and
  antennae. It cannot swivel — two legs hold it square.

## Models and parts

```
projects/bracelet/
├── lib/charm-pin.scad                    # all three mounts — the ball-and-socket,
│                                         #   the screw and its threads, the H-pin —
│                                         #   and the cutters charms engrave with
└── models/
    ├── bracelet/bracelet.scad            # the whole bracelet — one printed object
    ├── charm-screw/charm-screw.scad      # the loose double-ended screw
    ├── charm-h-pin/charm-h-pin.scad      # the loose H-shaped pin
    ├── flower-charm/flower-charm.scad    # and seven charms, each printed separately
    ├── heart-charm/heart-charm.scad
    ├── kitten-charm/kitten-charm.scad
    ├── puppy-charm/puppy-charm.scad
    ├── frog-charm/frog-charm.scad
    ├── star-charm/star-charm.scad        # the one that screws on
    └── butterfly-charm/butterfly-charm.scad  # the one that snaps onto an H-pin
```

The bracelet exports as **one separate shell per bar** — 11 at the default
size, 15 at `wrist=180` — with the clasp plates fused onto the two end bars. They are not supposed to touch. Every charm
exports as one piece.

| Model | Part | Size (print pose) | Sits on |
|---|---|---|---|
| `bracelet` | `bracelet` | 150.5 × 17.6 × 4.7 mm (10.25 with charm pins) | all 11 bars' own flat feet |
| `flower-charm` | `flower-charm` | 16.0 × 14.3 × 7.2 mm | its own face, 131 mm² in one piece |
| `heart-charm` | `heart-charm` | 15.7 × 13.9 × 7.2 mm | its own face, 138 mm² in one piece |
| `kitten-charm` | `kitten-charm` | 12.0 × 15.6 × 7.2 mm | its own face, 126 mm² in one piece |
| `puppy-charm` | `puppy-charm` | 15.0 × 13.9 × 7.2 mm | its own face, 138 mm² in one piece |
| `frog-charm` | `frog-charm` | 15.8 × 13.6 × 7.2 mm | its own face, 155 mm² in one piece |
| `star-charm` | `star-charm` | 14.7 × 15.3 × 7.3 mm | its flat side, 61 mm² in one piece |
| `charm-screw` | `charm-screw` | 5.5 × 9.5 × 3.8 mm | the flat along its shaft, 22 mm² |
| `butterfly-charm` | `butterfly-charm` | 16.1 × 18.6 × 7.0 mm | its own bottom, 146 mm² in one piece |
| `charm-h-pin` | `charm-h-pin` | 11.1 × 6.9 × 2.8 mm | its own face, 22 mm² |

The last two are the H-pin mount, the two above them the screw mount, and the
five above those the ball mount. No charm may exceed **16 mm** along the band
— that is `charm_reach` in `bracelet.scad`, the number the station spacing is
checked against, and each charm asserts its own size against it. The ball and
screw charms can turn, so for them that means 16 mm in every direction; the
butterfly cannot, so only its wingspan counts.

## Sizing

`wrist` is the only number you normally touch, and `ease` (12 mm) is exact,
not approximate — the loop lands on `wrist + 12` at every size.

**How it lands there is worth knowing, because it changed.** The keyhole plate
used to soak up whatever the band could not cover, since the band only came in
whole bars. On a small wrist that left a 27 mm slab of flat plate hanging off
the end of a 149 mm bracelet. Now the buckle is cut to the shortest slot the
clasp can actually use — **17.2 mm fastened, 4.1 mm of post travel, the same
at every size** —
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
| **130 (default, 4-year-old)** | **11** | **142.0 mm** | **11.88 mm** | **150.5 × 17.6 mm** |
| 140 (child) | 12 | 152.0 mm | 11.71 mm | 160.5 × 17.6 mm |
| 160 | 14 | 172.0 mm | 11.44 mm | 180.5 × 17.6 mm |
| 180 (adult) | 15 | 192.0 mm | 12.05 mm | 200.5 × 17.6 mm |
| 200 | 17 | 212.0 mm | 11.80 mm | 220.5 × 17.6 mm |
| 180, `rows=3` | 15 | 192.0 mm | 12.05 mm | 200.5 × 29.2 mm |

The buckle is 17.2 mm fastened in every row of that table — that is the point
of the short buckle. (The flat print got 1.5 mm *longer* even so: the plates
overlap when fastened, and the 3.3 mm the buckle gave up went to the band.)

The band itself is 4.45 mm thick at every size; the 4.66 mm overall height is
the stud.

Other parameters worth knowing: `pitch_nom` / `body` (what bar spacing wants to
be, and the bar itself — the knuckles need room to swing, so `pitch_min` is
derived from `body` and the knuckle radius),
`pin_d` (2.0 mm — the entire load path of the band), **`bore_fit`** (0.45 mm,
the play in the hinge) and **`axial_fit`** (0.6 mm, along the pin — both above),
`fit` (0.3 mm, the swing and clasp clearances), `knuck_wall` (0.9 mm,
the deliberate thinnest wall), `knuck_slope` (32.7°, derived — the knuckle
underside, asserted at ≤ 40°), and the clasp's `det_pinch` / `leaf_w` /
`leaf_free` if the detent wants to be lighter or firmer (`leaf_strain` is
asserted at the printed leaf's 2.9 %), `head_gap` for how tight it sits, and
`post_d` for the post.

## Printing

```sh
openscad -o projects/bracelet/exports/bracelet-bracelet.stl \
         projects/bracelet/models/bracelet/bracelet.scad
openscad -D wrist=180 \
         -o projects/bracelet/exports/bracelet-bracelet-w180.stl \
         projects/bracelet/models/bracelet/bracelet.scad
openscad -D charms=3 \
         -o projects/bracelet/exports/bracelet-bracelet-c3.stl \
         projects/bracelet/models/bracelet/bracelet.scad
for c in flower heart kitten puppy frog star; do
  openscad -o "projects/bracelet/exports/$c-charm-$c-charm.stl" \
           "projects/bracelet/models/$c-charm/$c-charm.scad"
done

# the screw mount: a band with threaded holes, and a batch of screws
openscad -D charm_mount='"screw"' -D charms=3 \
         -o projects/bracelet/exports/bracelet-bracelet-c3-screw.stl \
         projects/bracelet/models/bracelet/bracelet.scad
openscad -D copies=6 \
         -o projects/bracelet/exports/charm-screw-charm-screw.stl \
         projects/bracelet/models/charm-screw/charm-screw.scad

# the H-pin mount: a band with pockets, a batch of pins, and the butterfly
openscad -D charm_mount='"h"' -D charms=3 \
         -o projects/bracelet/exports/bracelet-bracelet-c3-h.stl \
         projects/bracelet/models/bracelet/bracelet.scad
openscad -D copies=6 \
         -o projects/bracelet/exports/charm-h-pin-charm-h-pin.stl \
         projects/bracelet/models/charm-h-pin/charm-h-pin.scad
openscad -o projects/bracelet/exports/butterfly-charm-butterfly-charm.stl \
         projects/bracelet/models/butterfly-charm/butterfly-charm.scad
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
  ends apart until the post snaps past the detent and seats. Hold the keyhole
  plate pushed slightly away from the stud's end bar as you drop it on — its
  tip comes down right beside that bar. To release, push
  it back past the detent and lift the head out.

### Charms

- **Every charm prints face down, boss up, exactly as modelled** — no supports,
  no brim, one flat island of 126–155 mm². Each is a five-minute print; print
  several, and any charm fits any station.
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

### The screw and the star

- **Print the screw lying down, exactly as modelled** — no rotation, no
  supports, no brim. It is a 9.5 mm part on a 22 mm² flat, so print a batch:
  `-D copies=6` lays them out 8 mm apart, and the export is then that many
  separate shells, which is correct rather than a fault.
- **Print the star flat side down, exactly as modelled** — no rotation, no
  supports, no brim. An earlier version of it stood on a 24 mm² annulus and
  came off the plate mid-print; this one lies on 61 mm² of its own face.
- **Same material and settings as the band.** The thread clearance is 0.15 mm
  per side, which is well inside the range a change of filament moves a fit by.
- Three perimeters. The thread crests are 0.45 mm wide at their tips, so they
  want a nozzle laying a clean single line, not a fat one.
- To assemble: wind the **long** end of the screw down into the bar until the
  collar is tight on the bar's top face, then wind the star onto the short end
  until the star's own underside is tight **on the bar** — the collar ends up
  inside the star, not under it, and once it is on you cannot see the screw at
  all. Finger-tight is the whole range; there is nothing to torque against.
- The star lands at whatever angle it seats at. If it matters, back it off a
  fraction rather than forcing it round.

### The H-pin and the butterfly

- **Print the pin lying flat, exactly as modelled** — no rotation, no supports,
  no brim. It is 2.8 mm tall on 22 mm² of its own face; `-D copies=6` lays out
  a batch, which exports as that many separate shells.
- **Print the butterfly bottom down, exactly as modelled** — no rotation, no
  supports, no brim. Unlike every other charm it is *not* face down: it stands
  on the face that sits on the bracelet, 146 mm² of it.
- **Same material and settings as the band**, and **three perimeters**: the
  pin's crossbar is 0.9 mm and its legs 1.0 mm, about two lines each. The
  crossbar is the spring and is meant to be thin; one fat perimeter would print
  it as a single weak line.
- The fits are the proven ones from the other mounts: 0.15 mm around the pin
  in every slot, and 0.15 mm of play over each hook.
- To assemble: push the pin's **outward-hooked** half straight down into the
  pocket until the crossbar bottoms out — the upper legs splay as the hooks go
  in and spring back when they snap. Then press the butterfly straight down
  over the upper legs until its underside is flat on the bar.
- To take the charm off, pull it straight up, firmly. The pin stays in the
  bar; pull it separately if you want the bar bare.

## License

The models in this project are licensed under
[CC BY-NC 4.0](LICENSE) — attribution, non-commercial.
