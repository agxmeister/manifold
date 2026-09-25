# bracelet

A bracelet made of **printed 3D fabric**: a row of rigid bars joined by
print-in-place **hinges**. It comes off the bed as a band that rolls up around
a wrist, and nothing is assembled, glued, or picked out of supports.

**Sized to the wrist it is printed for — by default a 142 mm loop on a
130 mm wrist (the 4-year-old it was printed for, and fits), 11 bars, printed
flat in a 150.5 × 17.6 × 4.7 mm strip.** `-D wrist=180` is the adult size.
The clasp is the same short buckle at every size; length is band, not plate.

![the bracelet as it comes off the bed](previews/bracelet-bracelet.png)

It can also carry **charms**: turn on a few charm stations and the band gets
small pockets that a separately-printed H-shaped pin snaps into, and a charm
snaps onto the pin — firmly enough that it does not fall off, by hand when you
want it to. See [Charms](#charms).

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

`charms` bars along the band carry a charm, hung on an **H-pin** snapped in at
both ends. Three charms are built for it: a 3D **butterfly**, a two-colour
**ladybug** and a puffy **heart** that can be turned to any angle.

Two earlier mounts came before this one — a ball pin fused to the bar with
clip-on charms, and a loose double-ended screw — and both printed and worked.
This one proved the best, and on 2026-09-24 the other two were removed along
with their charms (a flower, heart, kitten, puppy, frog and star). They are in
the project's git history.

The first version of the H-pin was **printed and confirmed on 2026-09-23** ("It printed
well"), on the same print as the reworked clasp. It sat very well in the bar
but a bit loose in the charm, so the pin's spring was **retuned the same
day** (see *Why the charm was loose*). That version is **not printed yet**.
The pin, the butterfly and the band's pockets all changed, slightly.

![a butterfly on its H-pin, and a pin over an empty pocket](previews/bracelet-bracelet-c3.png)

The pin is a flat **H**: two upright legs joined by a crossbar, a small hook on
the end of every leg. A bar gets a **pocket** sunk into its top. The lower half of the H pushes down into the pocket until the
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
face — so the pin is 11.6 × 6.9 × 2.8 mm. Tell them apart by the hooks: the
half whose hooks point **out** goes into the bracelet.

`charms` in `bracelet.scad` cuts the pockets; `models/pin`
is the pin and `models/butterfly-charm` is the charm built for it.

### The H prints lying flat, so its hooks are free

The whole pin is a 2D outline extruded 2.8 mm straight up. Its hooks are just
corners of that outline, so nothing on it overhangs, and the one part that
flexes flexes **in the plane of the bed**, along its perimeters.

### The crossbar is the spring, for both halves

Both halves are far too short to bend — a 3.45 mm leg flexed 0.4 mm would
strain ~6–15 %. So the legs do not bend, they **turn**, and the crossbar bends
in an arc between them: **2.85 % strain** at worst, under the 2.9 % the clasp's
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

### Why it was still loose: the hooks were too small

That pin printed, and a heart still came off with a light pull. The retune had
made the spring stiffer, so the spring was not what gave way. The catches
were. Each hook only reached **0.4 mm** past its wall. That is about one printed
line, and the printer rounds off most of it, so the hook rolled over a rounded
edge instead of catching behind a steep face.

So the hooks are bigger now. The upper ones reach **0.60 mm** past the wall
(0.75 hook) and the lower ones **0.55** (0.70 hook), and the charm's catch
is **60°**, up from 55°. The rest follows from the rules above:

- **The bar's hooks had to grow too.** Bigger charm hooks need a bigger turn
  to let go. That same turn frees the bar's hooks, so with only the charm's
  hooks enlarged, the pin would come out of the bracelet with the charm. The
  bar's hooks still hold 0.11 mm when the charm lets go.
- **The crossbar is thinner and a little longer** (0.76 mm, the legs 0.1 mm
  further out). Bigger bar hooks mean the legs turn further going in, and this
  keeps the bend under the 2.9 % limit.
- **The upper legs taper on the outside above the hook**, down to 0.54 mm at
  the tip. A turning leg's end swings outward, and the taper keeps it inside
  the room the old holes already had. The charms' holes did not grow, and
  every charm keeps its shape.

**The bands, pins and charms printed before 2026-09-25 do not mix with the new
ones.** The bigger bar hooks don't fit an old pocket, and the charm holes
changed inside. Reprint all three.

### The two catches are different angles, and that is on purpose

- **In the bar, 45°.** The bar prints upright, so the shoulder a lower hook
  catches under faces down — a ceiling — and this project prints no flat
  ceilings. 45° is only a detent, but it never has to be more: the lower hooks
  can only let go by turning the legs, and while a charm is on, the charm
  holds the upper legs still. **The pin cannot leave the bar with a charm on
  it.**
- **In the charm, 60°.** The charm prints bottom down, so the shoulder its
  hooks catch on is a *floor* and can be any angle. A steeper catch is what
  makes the charm **hold**: it takes a firm tug to pull it off. `hp_catch_up`
  is the number to tune: 45 makes the charm easy to pull off, and past 60
  friction locks it on for good (an assert rejects that). If the charm is now
  too firm, lower this to 55. The bigger hooks are what make the real
  difference, so leave those alone.

### What it costs the band

Nothing it prints with. The pocket is 3.1 mm along the band and 11.9 mm across
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
  tall, it stands 7.0 off the band's top at the antennae.
- The wings' **undersides rise at 43.6°** beyond |x| = 5 mm, so every layer
  lands on the one below. That also keeps them
  clear of the neighbouring hinges, whose arms tilt up above the band as a
  joint turns: with a butterfly seated, the neighbours swing clear to **±40°**
  at both 130 and 180 and bind at 60 (a wrist needs about 24°).
- 15.8 mm wingspan along the band; 18.6 mm across it with the head and
  antennae. It cannot swivel — two legs hold it square.

### The ladybug — a two-colour charm

![the ladybug charm](previews/ladybug-charm-ladybug-charm-accent.png)

A round red **shell** with six heart-shaped spots and a seam down the middle,
a black **head** with two antennae, and three stubby **legs** a side. It
takes the same two holes as the butterfly and goes on the same H-pin.

- **Two colours, one object.** The shell is filament 1. The hearts, seam,
  head, legs and antennae are filament 2. The eyes and the antennae's tips go
  back to filament 1, so they show on the black head. The spots are inlaid
  0.8 mm deep, flush with the shell, not painted on the surface.
- It prints **bottom down** like the butterfly. The shell is a dome and every
  face closes inward as it rises. Beyond |x| = 5 mm its underside is relieved
  at 43.6°. The **legs lie flat on the bed**, each a strip with a rounded
  top, so nothing overhangs.
- The shell is 7.8 mm tall, not 7.0 like the butterfly. It must roof both
  holes' 45° gables with a 1.2 mm wall right to their ends, and a rounded
  shell comes down faster there than the butterfly's ridge does.
- 20.6 mm along the band, 18.3 mm across it, head included. The middle legs
  are longer than the others, because the shell is widest there and hides
  more of them. All six show 4 mm of leg. **The legs lie
  on the neighbouring bars.** As the band curls round a wrist, those bars
  swing away from them: clear to 60° at both 130 and 180. **Bent backwards,
  the two joints beside it do not move at all.** The legs rest flat on the
  neighbours and stop them from the first half-degree. Forcing it levers
  on the charm. The butterfly keeps its underside off the hinges, so it
  bends back to 40°.
- `-D accent=false` (the default) writes it in one colour. The two-colour
  file is `exports/ladybug-charm-ladybug-charm-accent.3mf`; see
  [Printing](#the-ladybug-in-two-colours).

### The heart — a puffy charm you can turn

![the heart charm](previews/heart-charm-heart-charm.png)

**Printed and confirmed on 2026-09-25.**

A **pillow heart**, 23 mm wide and 19 tall: one smooth surface with no seams
or corners. Its outline is a smooth heart curve, with two wide lobes, a soft
1.5 mm notch, full round sides and a point rounded off just enough not to be
sharp. The heart is that outline **inflated**. It rises from the bed on one
pillow profile to an 8 mm crown, and the notch carries up the surface as a
gentle valley between the lobes. A cartoon **shine**, an arc and a dot, is
sunk 0.6 mm into the upper-left lobe.

- **`-D angle=` turns it** in plan about the pin, in degrees, anticlockwise
  seen from above. The holes stay where they are, because the pin always runs
  across the band. At 0 the heart stands upright across the band, lobes to
  one edge and point to the other. At 90 or 270 it lies along the band,
  pointing one way or the other. The heart is symmetric, so -a (or 360 − a) is
  the mirror image of a, apart from the shine.
- **It is sized to work at every angle at once.** Wherever it is turned, the
  pin's two holes and their 1.2 mm walls must stay buried inside it. A test
  grows the holes by the wall and subtracts the heart at every 10° from −150°
  to 180°, and it comes back empty at every angle. It keeps 0.6–1.0 mm to
  spare: moved 1.0 mm off centre, the heart leaks.
- It prints **bottom down** like the others. Every ring of the surface lies
  inside the one below it, so it only ever faces up. The shine is a groove
  whose walls flare outward, so it is all floor. No supports, no brim, 307 mm²
  on the bed.
- **Its bottom is flat to the edge, like the ladybug's legs.** The heart reaches
  up to 13 mm along the band from the pin. The butterfly's 43.6° relief would
  cut its edges away from underneath, so the heart rests on the neighbouring
  bars instead. As the band curls round a wrist they swing away from it: clear
  to 60° at both 130 and 180, at 0°, 45° and 90°. **Bent backwards, the two
  joints beside it do not move**, the same trade as the ladybug.
- Two hearts side by side at `charms = 3` clear each other by 0.75 mm at 0°,
  when their 23 mm width lies along the band. That is closer than any other
  pair of charms.
- Exports, in `exports/`: `heart-charm-heart-charm.stl` (0°) and `-a45`,
  `-a90`, `-a270`, `-a315`. Any other angle is one
  `openscad -D angle=... ` away.

## Two colours

`-D accent=true` prints **the middle of the band in a second colour**: a
stripe from 1.8 to 3.2 mm up, with the bottom and the top in the first colour.
It shows as a band of colour round every bar's sides and ends, and the clasp
plates (1.6 mm thick) stay entirely in the first colour.

![the bracelet with an accent stripe](previews/bracelet-bracelet-accent.png)

The geometry does not change at all. The bracelet is cut at those two heights
into **two parts**, the stripe and the rest, which together are exactly the
plain band. It exports as a **3MF** holding **one object made of those two
parts**, with the rest on filament 1 and the stripe on filament 2, for a
multi-material printer (AMS, MMU). Because the stripe is horizontal, it costs
only **two filament swaps per print**, one at 1.8 mm and one back at 3.2.

`accent_lo` / `accent_hi` move the stripe; keep them on 0.2 mm layer
boundaries. `base_color` / `accent_color` only tint the preview; the slicer
picks the actual filaments.

## Models and parts

```
projects/bracelet/
├── lib/charm-pin.scad                    # the H-pin mount: the pin, the pocket in
│                                         #   the bar and the holes in the charm
└── models/
    ├── bracelet/bracelet.scad            # the whole bracelet — one printed object
    ├── pin/pin.scad                      # the loose H-shaped pin
    ├── butterfly-charm/butterfly-charm.scad  # a charm that snaps onto it
    ├── ladybug-charm/ladybug-charm.scad      # another, in two colours
    └── heart-charm/heart-charm.scad          # a heart, turnable with `angle`
```

The bracelet exports as **one separate shell per bar** — 11 at the default
size, 15 at `wrist=180` — with the clasp plates fused onto the two end bars.
They are not supposed to touch. The pin and each charm export as one
piece.

| Model | Part | Size (print pose) | Sits on |
|---|---|---|---|
| `bracelet` | `bracelet` | 150.5 × 17.6 × 4.7 mm | all 11 bars' own flat feet |
| `pin` | `pin` | 11.6 × 6.9 × 2.8 mm | its own face, 24 mm² |
| `butterfly-charm` | `butterfly-charm` | 16.1 × 18.6 × 7.0 mm | its own bottom, 146 mm² in one piece |
| `ladybug-charm` | `ladybug-charm` | 20.6 × 18.3 × 7.8 mm | its own bottom and legs, 197 mm² in one piece |
| `heart-charm` | `heart-charm` | 23.0 × 19.0 × 8.0 mm at 0° | its own flat bottom, 307 mm² in one piece |

`charm_reach` in `bracelet.scad` spaces the stations for a **16 mm** charm,
the butterfly. Charms may be bigger than that (the ladybug is 20.6 mm along
the band, and the heart up to 23). At `charms = 3` the closest stations are
23.75 mm apart, so neighbours still clear each other. A charm on an H-pin
cannot swivel, so only its length along the band counts.

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
openscad -D copies=6 \
         -o projects/bracelet/exports/pin-pin.stl \
         projects/bracelet/models/pin/pin.scad
openscad -o projects/bracelet/exports/butterfly-charm-butterfly-charm.stl \
         projects/bracelet/models/butterfly-charm/butterfly-charm.scad
openscad -o projects/bracelet/exports/ladybug-charm-ladybug-charm.stl \
         projects/bracelet/models/ladybug-charm/ladybug-charm.scad

# two colours, in two steps. OpenSCAD writes each colour as a SEPARATE
# object (--enable=lazy-union keeps them apart), and a slicer would load
# those as separate models in one filament. tools/multicolor-3mf.py turns
# them into one object with one part and one filament per colour.
openscad --enable=lazy-union -D accent=true \
         -o /tmp/accent.3mf projects/bracelet/models/bracelet/bracelet.scad
python3 tools/multicolor-3mf.py /tmp/accent.3mf \
         projects/bracelet/exports/bracelet-bracelet-accent.3mf
openscad --enable=lazy-union -D accent=true -D charms=3 \
         -o /tmp/accent-c3.3mf projects/bracelet/models/bracelet/bracelet.scad
python3 tools/multicolor-3mf.py /tmp/accent-c3.3mf \
         projects/bracelet/exports/bracelet-bracelet-c3-accent.3mf
openscad --enable=lazy-union -D accent=true \
         -o /tmp/ladybug.3mf projects/bracelet/models/ladybug-charm/ladybug-charm.scad
python3 tools/multicolor-3mf.py /tmp/ladybug.3mf \
         projects/bracelet/exports/ladybug-charm-ladybug-charm-accent.3mf
```

### Printing it in two colours

- Open the `-accent.3mf`. It loads as **one object with two parts**, already
  on filaments 1 and 2. Set those two filament slots to the colours you want.
  The stripe is filament 2.
- Everything else under *Printing* still applies. **No brim, still.** The
  prime/wipe tower is the slicer's and sits apart from the band, so it is fine.
- Watch for ooze at the two colour changes. A blob or string left in a
  hinge's 0.6 mm gap welds that hinge just as a brim would. Keep the prime
  tower (or "wipe into object" off), and work every hinge after the print, as
  always.

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

### The H-pin and the charms

- The pockets change nothing about how the band prints — same first layer,
  same bridges, same no-brim rule.

- **Print the pin lying flat, exactly as modelled** — no rotation, no supports,
  no brim. It is 2.8 mm tall on 24 mm² of its own face; `-D copies=6` lays out
  a batch, which exports as that many separate shells.
- **Print the butterfly bottom down, exactly as modelled** — no rotation, no
  supports, no brim. It stands on the face that sits on the bracelet, 146 mm²
  of it.
- **Same material and settings as the band**, and **three perimeters**: the
  pin's crossbar is 0.76 mm and its legs 1.0 mm, about two lines each. The
  crossbar is the spring and is meant to be thin; one fat perimeter would print
  it as a single weak line.
- **Print the ladybug the same way**, bottom down, no supports, no brim, 197
  mm² on the bed. Its holes are the butterfly's exactly, so it fits the pin
  the same way.
- **Print the heart the same way**, bottom down, no supports, no brim, 307
  mm² on the bed. Pick the angle before you slice: it is in the file, not a
  rotation in the slicer (turning it in the slicer would turn its holes too).
- The fits are proven ones: 0.15 mm around the pin in every slot, and 0.15 mm
  of play over each hook.
- To assemble: push the pin's **outward-hooked** half (the one with its hooks
  at the very ends of the legs) straight down into the
  pocket until the crossbar bottoms out — the upper legs splay as the hooks go
  in and spring back when they snap. Then press the charm straight down
  over the upper legs until its underside is flat on the bar.
- To take the charm off, pull it straight up, firmly. The pin stays in the
  bar; pull it separately if you want the bar bare.

### The ladybug in two colours

- Open `ladybug-charm-ladybug-charm-accent.3mf`. It loads as **one object with
  two parts**: the shell on filament 1 and the spots, head and legs on
  filament 2. Set them to red and black, or whatever you like.
- **Unlike the band's stripe, this costs a filament change on every layer.**
  Both colours share every layer from the bed to the top, about 39 layers at
  0.2 mm, so expect a prime tower several times the charm's own volume. It
  is still a small print. Several ladybugs on one plate share the same tower.
- Keep the prime tower on. Stringing from the black nozzle onto red shell is
  the main thing that can mark it.

## License

The models in this project are licensed under
[CC BY-NC 4.0](LICENSE) — attribution, non-commercial.
