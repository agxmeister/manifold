# bracelet

A bracelet made of **printed 3D fabric**: a row of rigid bars joined by
print-in-place **hinges**. It comes off the bed as a band that rolls up around
a wrist, and nothing is assembled, glued, or picked out of supports.

**Sized to the wrist it is printed for — by default a 142 mm loop on a
130 mm wrist (the 4-year-old it was printed for, and fits), 12 bars, printed
flat in a 151.9 × 16.2 × 4.2 mm strip.** `-D wrist=180` is the adult size.
The buckle is a round knob pulled into a lipped niche, where it clicks; flush, the same at every size;
length is band, not buckle.

![the bracelet as it comes off the bed](previews/bracelet-bracelet.png)

It can also carry **charms**: turn on a few charm stations and each gets a
hole for a separately printed **bolt**, pushed in from under the band, and a
small rib on top. A charm sits on the rib at any multiple of 45°, and the
bolt, turned from below with a hex key, clamps it down. See
[Charms](#charms).

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
| vertical through the pin's free span | `floor 0.605 \| air 0.645 \| pin 1.590 \| air 0.455 \| roof 0.905` |
| vertical through a lug | `SOLID 4.199` — bed to top |

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
underside is cut flat so its first layer is **1.13 mm** wide instead of a knife
edge, and the knuckle caps are **not plain discs** — see below.

The hinge swings freely through **±100°** and only binds at 110°. Wrapping a
180 mm wrist over 16 bars needs about 24°; a 130 mm wrist over 12 bars needs a
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
| chord cap | 331.6 mm² | **0.0 mm²** | **31.7°** (30.0° since the 4.2 mm band) |

Per-layer step falls from 0.348 mm to a uniform 0.128 mm.

## The clasp

A **round knob in a niche** — the user's design and sketch, 2026-10-20,
printed 2026-10-21: the way-in was much too big and the clicks too small, so
both were reworked the same day (unprinted again). The knob drops into a
way-in at the back of the socket's hole, then is pulled forward ~2.4 mm into the niche in front, whose
lips hold its front, and it clicks in place. It replaced a dovetail knob whose
springs broke almost at once. Three round versions came before it the same
day: rim springs, a zigzag spring, and a plain slot.

```
 top, fastened
   last bar          socket block (+ bar 0)
 ────────┐       ┌────────────────────────┐
         │       │  ▒▒▒  ┌─---------.      │   ▒ lips over the knob's front,
         │       └─┐▒  / │            \     │     both sides of the neck, out
    ═════╪═════════> ( knob   way in   )    │     to a straight step across
         │       ┌─┘▒  \ │            /     │     the band
         │       │  ▒▒▒  └─---------'      │
 ────────┘       └────────────────────────┘
                 niche step
```

The last bar ends in a 3.5 mm **neck** and a **knob**, 8 mm across and the
band's full 4.2 mm thick, solid, with a small notch in each side. Bar 0 is
lengthened 10.6 mm into a **socket
block** with the hole cut through it, open top and bottom. Its side walls are
solid.

- **The niche.** In front, the knob's own circle. 1.1 mm **lips** overhang the
  knob's edge at the top and the bottom, from the neck out to a straight
  **step** across the band, 85° round the knob from the front either side —
  nearly to its widest point (it was 75°: printed 2026-10-23, the lips were
  too short to hold). The knob cannot move up or down, and the band's pull
  keeps it in the niche.
- **The wedge seat** (2026-10-22, unprinted). The lips' sloped faces and the
  knob's matching insets make a V, top and bottom. At home the faces touch and
  the bumps press the knob into the V, so it has no play up, down or forward.
  The niche's vertical wall stands 0.3 mm off the knob's rim, and the lips'
  tips 0.3 mm off its insets, so only the V holds it. If the overhang prints
  a little droopy or tight, the knob just seats a hair further back, still
  pressed by the bumps. Before this, 0.3 mm of clearance across the faces let
  it rattle up to ~0.2 mm: printed, "the grip is just too loose".
- **The way-in.** Behind the step, just the room the knob sweeps from home
  back to where it drops out, 0.25 mm round it. Its far wall, between the
  hole and bar 0's hinge, is 3.0 mm (2026-10-23; it was 1.44 and bent when
  the buckle was closed).
- **Springs in the walls** (2026-10-23, unprinted). Each side wall of the
  way-in is a straight 0.8 mm **leaf**, 5.0 mm long, freed by a slot behind
  it and a thin slit past the hole's back corner, with a rounded **bump** on its inner face. The knob's sides, behind
  the step, have a shallow **recess** (where the bump stands while the knob
  drops in), a **lead-in** rising at ~23° to a **crest** on the knob's back
  half (it has to be: the knob drops out 2.4 mm back, and the bump must then
  stand behind its lipped front), and a 60° **catch** falling into a **notch**. At home the
  bump sits in the notch, 0.35 mm into the catch, pressing the knob forward
  into the V so it does not rattle.
  - **Closing**, the bump rides up the gentle lead-in and the leaf bends out
    0.7 mm, then it snaps into the notch. (It was 0.4, with the bump only
    0.15 into the catch: printed, the bumps did not touch the knob at all.)
  - **Opening**, it has to climb the 60° catch: roughly 4–5× the push.
  - Why not springs on the knob, as before: a leaf on a round knob's rim
    bends in *and forward*, whichever end it is rooted at, and forward is
    the way the tooth pushes it when the knob is pulled out. The printed
    leaves (rooted at the back) were hard to close and easy to open. A
    straight leaf in the wall bends straight out, so only the face angles
    decide.
- **The cost:** ~4.6 % bend at the leaf's root by a straight-beam estimate
  (the long teeth ran ~7 % and printed fine). Past ~70° the
  catch would lock for good; `cl_catch` is asserted ≤ 65.
- **To close:** push the ends together, drop the knob into the way-in, pull
  it forward into the niche until the bumps snap into the notches.
- **To open:** push the ends together firmly, past the click (2.4 mm, the
  seam's width), and push the knob out downwards.
- **Flush.** Both ends are the full band thickness. Fastened, it is 25.1 mm of
  rigid band including both end bars, with a 2.0 mm seam.

**The click is not a push spring.** It stops the knob sliding back until it is
pushed firmly. Past the bumps the knob is free. A spring that pushes the knob
home would have to bend the whole 2.4 mm pull plus a preload. On an 8 mm knob
its leaves are only ~4 mm long, so they would bend 15–20 %, and the dovetail's
springs broke at 8.5 %. The wall leaves bend only 0.7 mm. To tune the
click: `cl_h` sets how far they bend (how hard it is either way), `cl_catch`
how much harder opening is than closing.

**The pull.** A lip lets go once the knob, moved back, has cleared its tip by
0.2 mm. The worst tip is the last one, on the step. With the step at 85° that
takes 2.39 mm (1.88 at the old 75°); at the widest point it would be 2.72. `tb_lip_end` moves the step.

**The neck is 3.5 mm** (it was 4.5), as in the sketch. On an 8 mm knob a 4.5 mm
neck takes the middle of the front arc and leaves the lips beside it too short.

The lip faces are 60° from vertical, not 45°: pushed up or down, a sloped lip
cams the knob sideways, out from under itself, and at 60° that cam is about half
as strong. If it lets go, make the lips deeper (`tb_lip`) or steeper
(`tb_lip_a`), or move the step back (`tb_lip_end`).

Everything prints without support: the knob, the leaves, their bumps
and the block all stand on the bed. The slots behind the leaves are 1.2 mm.
The upper lips are a 60° overhang 1.1 deep, stepping 0.35 mm a layer, under a
bead; each lip's tip has a 0.4 mm vertical land.

Fits: 0.15 mm round the neck; at home the lip faces touch (the wedge), with
0.3 at the niche's wall and 0.3 between the lips' tips and the knob's insets.
Checked by intersecting the fastened halves (the front: lips, V and wall; the
back: the bumps):

| test | reads |
|---|---|
| home | front: a contact sheet on the lip faces only (0.0008 mm³); back: the bumps in the notches (the grip) |
| up / down 0.02, forward 0.02 | front: the lip faces — no play left |
| pushed 0.1, up / down 0.05 | front: the lip faces (0.06) — the play opens only as the knob moves back |
| pulled apart 0.25 | the niche's wall |
| pulled forward 0.15 | the bumps still in the notches |
| pushed 0.1 … 1.3 | the bumps on the knob only, deepest near 0.6 |
| pushed 1.5 | empty: past the click |
| pushed 1.0, down 1 (control) | the lips |
| pushed 2.39, moved down by any amount | empty: the knob drops right out |
| pushed 2.1 | the faces of the seam |

## What is printed over air

| layer | reaches past a bead | what it is |
|---|---|---|
| z ≈ 1.3 | 87.4 mm² | each pin's first layer — a 3.2 mm bridge between two lugs |
| z ≈ 3.3 | 28.0 mm² | each bore's roof — anchored on both sides of the blade |

(Measured on the 4.45 mm band at `wrist=180`. The buckle adds two short
ones: the socket's upper lips and rails, 1.1 deep at 60°. The 4.2 mm band has the same
two layers and nothing else, a little lower: the pin's flat is narrower, and
the bore roof now closes as one ~1.4 mm bridge instead of stepping in.)

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

Bed stability: **one separate contact patch per bar** — 12 and 1630 mm² of
first layer at the default size, 16 and 2200 mm² at `wrist=180` —
with the socket block and the T part of the two end bars. Each patch is a
full-width bar foot, so there is far more of it than the old tile grid had.

## Charms

`charms` bars along the band — the middle one and every third bar either side
of it — carry a charm, held by a **bolt** (the cone pin) through the bar.
Five charms are built for it: a 3D **butterfly**, a two-colour **ladybug**, a
puffy **heart**, a **rose** with thin, ruffled petals, and an articulated
**dolphin** whose tail bends every way. Any of them sits on the bracelet at
any multiple of **45°**.

The bolt is the only mount since 2026-10-18. The H-pin and the dovetail
H-pin before it are gone, and so are their two-hole charms: every charm now
has the bolt's threaded socket and eight grooves underneath. **The grooves
and the rib are not printed yet.** The bolt itself printed well (lying down,
2026-10-05); the standing bolt with the hex socket is not printed yet.

![the band with three stations](previews/bracelet-bracelet-c3.png)

### The bolt

```
              charm, sitting on the rib
          ___/  ___  \___
         |     |   |     |   <- threaded socket, M5
   rib  (_)    |   |    (_)  rib          bar top
  ======|======|   |=====|=======
        |   bar \   /   |              <- countersink, 13 deg
  ======|========\_/=====|=======  bar underside
                  ^ the bolt's foot, a hex socket in it
```

- **It goes in from underneath.** Its foot is a round **cone** that seats in
  a countersink in the bar's underside, 0.4 mm inside the skin side. Its
  shaft runs up through a plain hole and carries an **M5 thread**, 5 mm of
  it (about 2 turns), above the bar.
- **The rib** is a half-round ridge, 2.0 mm wide and 1.0 mm tall, on the bar's
  top. It runs across the band through the bolt's axis, in two short halves
  either side of the hole, 4.3–7.0 mm out.
- **Every charm has eight grooves** underneath, every 45°, radiating from its
  socket. Two opposite ones take the rib. They leave the charm 0.15 mm of
  clearance round it, which is about ±1.7° of play. A charm set down between
  two grooves stands on the rib and cannot be clamped.
- **So the bolt turns, not the charm.** The rib stops the charm from
  turning, and the round cone lets the bolt spin in its countersink. A charm
  screwed down instead would have to spin through the rib.
- **The bar has no thread.** It has a hole and a countersink, 1.1 mm off the
  bar's centre, towards the side whose gap is **filled**. A bar is only 6 mm
  along the band. On one side, the knuckles beside the gap between the
  knuckle clusters are that bar's own fork lugs, so that gap is filled
  completely: one wide lug with the lugs' own shape, out to their ends. It
  swings exactly as they do, so the band bends exactly as before. The gap on
  the other side is flanked by the neighbour's knuckles and stays open.
- **The cone is long.** It tapers all the way from the foot to where the
  thread starts, about 13° from the axis, so it bears on the bar over 3 mm. A
  steep wedge pushes the bar's walls apart hard, so tighten a charm firmly,
  not with force.
- **The bolt prints standing up**, round all the way, with a **hex socket**
  in its foot for a **3 mm hex key** (3.1 mm across flats, 2.5 mm deep). It
  is cut tight, 0.05 mm a side; if a key won't go in, raise `cn_key_fit` in
  `lib/charm-cone.scad`.

**The screwdriver.** `models/screwdriver` is a hex key for the bolt's foot,
sized for a child's hand: a 2.9 mm hex bit (0.1 mm a side in the socket),
4 mm long, on a round shaft and a flat 32 mm paddle that is pinched and
twisted like a door key. The paddle has a hole for a string, so the key can
stay with the bracelet. The bit reaches the end of the socket with the shaft
still 1.5 mm clear of the band. It is not printed yet. If it is loose in the
socket, lower `key_fit`; if it won't go in, raise it.

### Putting a charm on, and taking it off

1. **Set the charm on the station**, facing the way you want, with the rib in
   two of its grooves. It drops flat onto the bar when it is in.
2. **Push the bolt up into the bar from underneath** and turn it with the
   screwdriver (or any 3 mm hex key), **clockwise as you look at the
   underside**, until the charm is pulled down tight.
3. **To turn or take off the charm**, unscrew the bolt the same way, from
   underneath. Lift the charm, turn it, set it down and tighten again.

### What it costs the band

- Same 12 shells and the same hinge bridges as the plain band (genus +1 per
  station, the hole), and less first layer: 1578 mm² against 1630. The countersink is a 13° ceiling, so it adds no overhang.
  The rib sits on the bar's top: nothing overhangs.
- The band stands 5.2 mm tall at a station, at the rib, instead of 4.2.

### What came before

A ball pin fused to the bar and a loose double-ended screw both printed and
worked. They were removed on 2026-09-24 in favour of the **H-pin**, a flat H
whose hooked lower legs snapped into a pocket in the bar. It held well in the
charm but kept pulling out of the bar. A U-pin, a twist-key (printed,
failed) and a slider were tried after it and rolled back on 2026-09-29. A
**dovetail H-pin** (the H's top on a dovetail that clicked into the bar)
followed and printed well. The **cone pin** ran beside it from 2026-10-04,
printed well, and became the only mount on 2026-10-18, taking with it the heart's `angle` parameter: the angle is now
chosen on the wrist. All of them are in git history.

### The butterfly — a 3D charm

It prints **bottom down**: the face that lands on the bracelet is the face that
lands on the bed. That is what lets it be a solid thing rather than a flat
plate. A raised, rounded **body** runs across the band with a head and two
antennae at the front, and the **wings lift away from it in a shallow V**, with
a spot sunk into each one.

- The body is where the bolt goes. Since 2026-10-18 its middle is a round
  **thorax**, 7.7 mm across, domed up to 9.3 mm over the socket (the body was
  6.85 tall on the H-pin). The head is raised to match and the wing spots
  moved out. The notch between fore- and hindwing is shallower: a groove ran
  out through it and left knife edges.
- The wings' **undersides rise at 43.6°** beyond |x| = 5 mm, so every layer
  lands on the one below. That also keeps them
  clear of the neighbouring hinges, whose arms tilt up above the band as a
  joint turns: with a butterfly seated, the neighbours swing clear to **±40°**
  at both 130 and 180 and bind at 60 (a wrist needs about 24°).
- 16.1 mm wingspan, 19.8 mm head to tail with the antennae. Turned 90° on the
  rib, the wings lie across the band instead and the flat bottom rests on the
  neighbouring bars: still clear to 40° as the band curls, every 45°.

### The ladybug — a two-colour charm

![the ladybug charm](previews/ladybug-charm-ladybug-charm-accent.png)

A round red **shell** with six heart-shaped spots and a seam down the middle,
a black **head** with two antennae, and three stubby **legs** a side.

**Reshaped for the bolt on 2026-10-18, not printed yet.** The shell is 8.8 mm
tall (was 8.0) and rounder, 15.2 mm wide (was 12.6), so it roofs the socket
and every groove. A leg lying on the bed is only 1.6 mm tall, lower than a
groove, so a groove would cut it off. The legs now sit between the grooves:
they leave the shell at about +23°, −23° and −56° each side instead of an
even fan, and still show about 2.8 mm each.

- **Two colours, one object.** The shell is filament 1. The hearts, seam,
  head, legs and antennae are filament 2. The eyes and the antennae's tips go
  back to filament 1, so they show on the black head. The spots are inlaid
  0.8 mm deep, flush with the shell, not painted on the surface.
- It prints **bottom down** like the butterfly. The shell is a dome and every
  face closes inward as it rises. Beyond |x| = 5 mm its underside is relieved
  at 43.6°. The **legs lie flat on the bed**, each a strip with a rounded
  top, so nothing overhangs.
- 20.6 × 21.6 mm with the legs and head. **The legs lie
  on the neighbouring bars.** As the band curls round a wrist, those bars
  swing away from them: clear to 60° at both 130 and 180. **Bent backwards,
  the two joints beside it do not move at all.** The legs rest flat on the
  neighbours and stop them from the first half-degree. Forcing it levers
  on the charm. This holds at every 45° step.
- `-D accent=false` (the default) writes it in one colour. The two-colour
  file is `exports/ladybug-charm-ladybug-charm-accent.3mf`; see
  [Printing](#the-ladybug-in-two-colours).

### The heart — a puffy charm

![the heart charm](previews/heart-charm-heart-charm.png)

**The shape printed and was confirmed on 2026-09-25**, 8 mm tall on the
H-pin. It is 9.2 mm tall for the bolt's socket, and printed well that way
too (2026-10-05). The grooves are new and not printed yet.

A **pillow heart**, 23 mm wide and 19.4 tall: one smooth surface with no
seams or corners. Its outline is a smooth heart curve, with two wide lobes, a
soft 1.5 mm notch, full round sides and a point rounded off just enough not
to be sharp. The heart is that outline **inflated**. It rises from the bed on
one pillow profile to a 9.2 mm crown, and the notch carries up the surface as
a gentle valley between the lobes. A cartoon **shine**, an arc and a dot, is
sunk 0.6 mm into the upper-left lobe.

- **It turns on the wrist, every 45°**, on the rib (it used to take an
  `angle` parameter and one export per angle). The socket is at the middle of
  the heart, with at least 1 mm of heart over its coned end and 5.8 mm over
  the far end of every groove.
- It prints **bottom down** like the others. Every ring of the surface lies
  inside the one below it, so it only ever faces up. The shine is a groove
  whose walls flare outward, so it is all floor. No supports, no brim, 252 mm²
  on the bed.
- **Its bottom is flat to the edge, like the ladybug's legs.** The heart reaches
  up to 13 mm along the band from the bolt, so it rests on the neighbouring
  bars. As the band curls round a wrist they swing away from it: clear at 24°
  and 40° at 130, turned 0°, 45° or 90° — every charm reads the same. **Bent backwards, the two joints beside it do
  not move**, the same trade as the ladybug.
- Two hearts side by side at `charms = 3` clear each other by about 12 mm
  when their 23 mm width lies along the band.

### The rose — thin, ruffled petals

![the rose charm](previews/rose-charm-rose-charm.png)

**Added, printed and confirmed on 2026-09-26** ("Printed good").

A rose **22.7 mm across and 10.5 mm tall**, made of 19 thin petals. Three
petals wrap the open middle of the bud. Around it stand three rings of 5, 5
and 6 petals, each ring turned against the next. Every petal is a **0.9 mm
shell**: a rounded top that dips between petals, a wavy lip, pleats that
deepen toward the lip, and a flare that opens outward as it rises. The flare
grows ring by ring, so the rose opens out from the middle.

- The **core** under the petals is solid and holds the bolt's socket and the
  grooves. Its dome rose from 7.95 to 8.75 mm for the socket on 2026-10-18,
  so the open middle of the bud is 0.8 mm shallower; the petals did not
  change. The
  outer petals are fused to it up to 6.6 mm, so from the side you see petals
  all the way down. Above that they stand free.
- **No two petals graze.** Two thin walls crossing at a shallow angle leave
  a slit too narrow to print, and slivers too thin to lay down. Inside a
  ring, neighbours overlap and are fused solid. Between rings there is always
  at least 0.4 mm of air. Both are asserted in the source.
- It prints **bottom down**, like the others. Every petal leans out at most
  about 30° from vertical, so every layer lands on the one below. No
  supports, no brim, 201 mm² on the bed (the socket and grooves take the
  rest).
- **The petals are two lines thick.** On a 0.4 mm nozzle they print as two
  perimeters. Keep the slicer's thin-wall handling on (Arachne, the default
  in Creality Print). `petal_t` sets the thickness if you want sturdier
  petals.
- **Its bottom is flat to the edge**, like the heart's, and reaches 9.5 mm
  from the pin. It rests on the neighbouring bars. As the band curls round a
  wrist they swing away from it freely. **Bent backwards, the two joints
  beside it do not move**, the same trade as the heart and the ladybug.
- Two roses side by side at `charms = 3` clear each other by about 13 mm.

### The dolphin — an articulated tail

![the dolphin charm](previews/dolphin-charm-dolphin-charm.png)

**Added 2026-09-27, not printed yet.** Reworked the same day: the fluke now
tilts up, and the tail hangs on chain-link rings that bend in every
direction. Later that day the fluke's lobes were swept back into a smaller V, and the
dorsal fin and the beak were reshaped like a real dolphin's. Then the body
was reshaped so that it is fullest in the middle of the torso, under the
fin, with a smaller head tapering to the beak. Later still, **the links
between the tail segments were hidden**, the way a flexi toy's are: each
segment's skin runs on over the next one's rounded nose, so every joint looks
like a groove between two rings.

A chubby cartoon dolphin **52.5 mm long, 29.8 mm across the flippers and
13.9 mm tall**. For the bolt (2026-10-18) the torso grew about 0.35 mm, to
8.86 mm over the socket, the fin rose with it, and the first two tail joints
moved back 0.1 mm to clear the grooves. Two grooves come out through the
body's sides as small arches at bed level, just behind the flippers. It is fullest under the fin. The head is smaller, and its forehead slopes down to a slim beak,
dimpled eyes and a blowhole, and a dorsal fin with a long sloping front
edge, a tip that curls back and a curved-in back edge. The flippers and the fluke
are each one smooth inflated surface over a rounded outline, with no creases
anywhere. **The fluke is tilted up 50°** at the end of the tail, and its two lobes
are swept back so that from above they are about 120° apart. It lies **across the band**,
the same way the heart does. The head, body, fin and flippers are one solid,
and that solid holds the bolt's socket. Behind it, the **tail is three
loose segments**, the last one the fluke. Each joint bends **about 23°
sideways** and **about 12° up or down**, and anything in between. It also
twists about 15°, and there is 0.5 mm of play on top of that. Over three
joints the tail curls about 70° sideways and about 35° up or down.

![the tail curled up and sideways](previews/dolphin-charm-dolphin-charm-bend.png)

- **It prints in one go, tail and all.** Every joint prints in place, like
  two links of a chain. Each segment stands on the bed by itself, 0.5 mm
  from its neighbour:
  - The front segment ends in a **wall** with a slot through it, and a
    **crossbar** bridges the slot halfway up.
  - The next segment reaches forward through the slot in a closed **loop**
    that hooks round the crossbar. The loop is a rail on the bed, an upright
    in a pocket in the front segment, and a rail over the top.
  - The loop cannot come off the crossbar. There is 0.5 mm of clearance all
    round it.
- **The links are hidden.** The front segment roofs over its pocket and
  slot, and its skin carries on 1.8 mm past the joint as a **hood** over the
  next segment's rounded **nose**. From outside, a joint is a groove with the
  nose at the bottom, and the link is out of sight. The nose is round about
  the joint's upright axis, so it turns sideways inside the hood without the
  gap changing. Its top is flat under the hood's flat roof, which is what
  limits the up-and-down bend to about 12°. At a full sideways bend, looking
  straight into the open side of the groove, you can just see the link
  deep inside the hood.
- **The fluke prints without support.** Its flat underside rises from the
  bed at 50°, so every layer lands on the one below.
- **Nothing hangs in the air.** The only flat undersides are the three
  crossbars and the three loop top rails, each a bridge of about 3 mm, and
  the three hood roofs, a bridge of 5–7 mm. Each spans between two parts
  that stand on the bed. The hood's ceiling slopes down to its walls at 40°
  from vertical. No supports. **No brim**: a brim
  would weld the segments together, just as it welds the band's hinges.
- **Work the tail after printing.** Bend each joint every way a few times,
  until it moves freely.
- **The tail hangs past the band's edge.** Only the head, body and first
  tail joint are over the band. The other two joints and the fluke stick out
  about 28 mm on one side, and the beak about 9 mm on the other. It is a big
  charm.
- **Its bottom is flat to the edge**, like the heart and rose. As the band
  curls round a wrist, the neighbouring bars swing away from it freely.
  **Bent backwards, the two joints beside it do not move**, the same trade as
  the others. The flippers reach 14.9 mm along the band each way, so two
  dolphins at `charms = 3` clear each other by only about 5 mm (3.5 at the
  tightest joint spacing) — the closest pair of any charms.

## Two colours

`-D accent=true` prints **the middle of the band in a second colour**: a
stripe from 1.4 to 2.8 mm up, with the bottom and the top in the first colour
— three equal bands of 1.4 mm. To make them equal the whole band was thinned
from 4.45 to 4.2 mm (2026-09-25): the hinge pin went from 2.0 to 1.8 mm, and
the H-pin pocket's floor from 0.8 to 0.6 mm, so the pins and charms did not
change. **The 4.2 mm band was printed and confirmed on 2026-09-25** in one colour, with
a heart charm on the H-pin ("Printed well, the pin sits fine"). The
two-colour 3MF has not been printed yet.
It shows as a band of colour round every bar's sides and ends, the socket
block's included.

![the bracelet with an accent stripe](previews/bracelet-bracelet-accent.png)

The geometry does not change at all. The bracelet is cut at those two heights
into **two parts**, the stripe and the rest, which together are exactly the
plain band. It exports as a **3MF** holding **one object made of those two
parts**, with the rest on filament 1 and the stripe on filament 2, for a
multi-material printer (AMS, MMU). Because the stripe is horizontal, it costs
only **two filament swaps per print**, one at 1.4 mm and one back at 2.8.

`accent_lo` / `accent_hi` move the stripe; keep them on 0.2 mm layer
boundaries. `base_color` / `accent_color` only tint the preview; the slicer
picks the actual filaments.

## Models and parts

```
projects/bracelet/
├── lib/charm-cone.scad                   # the bolt: its thread, the bar's hole,
│                                         #   countersink and rib, a charm's socket
│                                         #   and grooves
└── models/
    ├── bracelet/bracelet.scad            # the whole bracelet — one printed object
    ├── cone-pin/cone-pin.scad            # the bolt every charm is held by
    ├── screwdriver/screwdriver.scad      # a kid's hex key for the bolt
    ├── butterfly-charm/butterfly-charm.scad  # a 3D butterfly
    ├── ladybug-charm/ladybug-charm.scad      # a ladybug, in two colours
    ├── heart-charm/heart-charm.scad          # a puffy heart
    ├── rose-charm/rose-charm.scad            # a rose with thin petals
    └── dolphin-charm/dolphin-charm.scad      # a dolphin with a bendy tail
```

The bracelet exports as **one separate shell per bar** — 12 at the default
size, 16 at `wrist=180` — with the socket block and the T part of the two
end bars.
They are not supposed to touch. The bolt and each charm export as one
piece, except the dolphin, which is four: the body and three tail segments,
printed in place.

| Model | Part | Size (print pose) | Sits on |
|---|---|---|---|
| `bracelet` | `bracelet` | 151.9 × 16.2 × 4.2 mm | all 12 bars' own flat feet |
| `cone-pin` | `cone-pin` | 6.3 × 6.3 × 8.8 mm, standing | its foot, a ring round the hex socket, 20 mm² |
| `screwdriver` | `screwdriver` | 65.0 × 32.0 × 8.0 mm, lying flat | its paddle and shaft, 1033 mm² in one piece |
| `butterfly-charm` | `butterfly-charm` | 16.1 × 19.8 × 9.3 mm | its own bottom, 104 mm² in one piece |
| `ladybug-charm` | `ladybug-charm` | 20.6 × 21.6 × 8.8 mm | its own bottom and legs, 177 mm² in one piece |
| `heart-charm` | `heart-charm` | 23.0 × 19.4 × 9.2 mm | its own flat bottom, 252 mm² in one piece |
| `rose-charm` | `rose-charm` | 22.1 × 22.4 × 10.5 mm | its own flat bottom, 201 mm² in one piece |
| `dolphin-charm` | `dolphin-charm` | 29.8 × 52.5 × 13.9 mm | its own flat bottom, 420 mm² in 4 pieces |

The stations sit on the **middle bar**, then on **every third bar** either
side of it (`charm_step` in `bracelet.scad`), so `charms` is odd. On the
default 12 bars, `charms = 3` puts them on bars 2, 5 and 8 (counting from 0),
35 mm apart; 5 charms need at least 15 bars (a 170–180 wrist). Until
2026-09-27 they were spread evenly over the band, which put three charms on
every second bar, only 23.4 mm apart. `charm_reach` is the narrowest spacing
the model accepts: **16 mm**, the butterfly. The bigger charms (ladybug
20.6 mm along the band, heart up to 23, dolphin 29.8) all clear each other at
three bars apart. Turned on the rib, a charm puts a different side along
the band. Only the dolphin is too long for that: turned 90°, its tail
reaches 35.7 mm along the band, onto the next station's charm. Keep it
across the band, or leave its neighbouring stations empty.

## Sizing

`wrist` is the only number you normally touch, and `ease` (12 mm) is exact,
not approximate — the loop lands on `wrist + 12` at every size.

**How it lands there is worth knowing, because it changed.** The old keyhole
plate used to soak up whatever the band could not cover, since the band only
came in whole bars. On a small wrist that left a 27 mm slab of flat plate
hanging off the end of a 149 mm bracelet. Now the buckle is fixed — **the
socket block reaches 7.5 mm past bar 0, the same at every size** — and the
band makes up the difference: the solver picks the bar count that lands
nearest the nominal 11.6 mm spacing, then stretches or squeezes **every joint
equally**, by a fraction of a millimetre, to hit the length exactly. Bars never
change; only the gaps do, and they have about a millimetre of room between the
knuckles binding (11.1 mm) and the band looking gappy (12.5 mm).

`charms` is independent of all of it — it does not touch the length budget, and
the stations are placed on whatever bar count the solver lands on.

`rows` widens the band, adds a knuckle cluster to every joint, and costs
nothing but filament. It spaces those clusters on its own fixed `row_pitch`, so
the band's width does not wander when the length solver breathes the joints.

The band is 16.2 mm wide (`row_pitch` 10.2; it was 17.6 until 2026-09-26).
That was as narrow as the old H-pin's pocket allowed. The bolt's rib must
stay on a bar's flat top (asserted), which a narrower band would cut short.

| `wrist` | bars | loop, clasped | joint pitch | printed footprint |
|---|---|---|---|---|
| **130 (default, 4-year-old)** | **12** | **142.0 mm** | **11.17 mm** | **151.9 × 16.2 mm** |
| 140 (child) | 12 | 152.0 mm | 12.08 mm | 161.9 × 16.2 mm |
| 160 | 14 | 172.0 mm | 11.76 mm | 181.9 × 16.2 mm |
| 180 (adult) | 16 | 192.0 mm | 11.52 mm | 201.9 × 16.2 mm |
| 200 | 18 | 212.0 mm | 11.34 mm | 221.9 × 16.2 mm |
| 180, `rows=3` | 16 | 192.0 mm | 11.52 mm | 201.9 × 26.4 mm |

The buckle is 25.1 mm of rigid band at every size and width, the end bars and
the 2.0 mm seam included.

The band is 4.2 mm thick at every size, and so is the whole print: nothing
stands above it any more (a charm station's rib reaches 5.2).

Other parameters worth knowing: `pitch_nom` / `body` (what bar spacing wants to
be, and the bar itself — the knuckles need room to swing, so `pitch_min` is
derived from `body` and the knuckle radius),
`pin_d` (1.8 mm — the entire load path of the band; it was 2.0 until the band
was thinned to 4.2 mm for three equal colour bands), **`bore_fit`** (0.45 mm,
the play in the hinge) and **`axial_fit`** (0.6 mm, along the pin — both above),
`fit` (0.3 mm, the swing clearance and the buckle's face gap), `knuck_wall` (0.9 mm,
the deliberate thinnest wall), `knuck_slope` (30.0°, derived — the knuckle
underside, asserted at ≤ 40°), and the buckle's `tb_lip` / `tb_lip_a` (how
far and how steeply the lips hold the knob), `tb_lip_end` (how far round
its front they run, to the straight step), `tb_drop_fit` (the play round the knob in the way-in), `cl_h` and `cl_catch` (the click, above), `tb_r` (the knob), and `tb_vfit` / `tb_wfit` / `tb_tfit` for how it seats (the wedge, above).

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
         -o projects/bracelet/exports/cone-pin-cone-pin.stl \
         projects/bracelet/models/cone-pin/cone-pin.scad
openscad -o projects/bracelet/exports/heart-charm-heart-charm.stl \
         projects/bracelet/models/heart-charm/heart-charm.scad
openscad -o projects/bracelet/exports/rose-charm-rose-charm.stl \
         projects/bracelet/models/rose-charm/rose-charm.scad
openscad -o projects/bracelet/exports/screwdriver-screwdriver.stl \
         projects/bracelet/models/screwdriver/screwdriver.scad
openscad -o projects/bracelet/exports/butterfly-charm-butterfly-charm.stl \
         projects/bracelet/models/butterfly-charm/butterfly-charm.scad
openscad -o projects/bracelet/exports/ladybug-charm-ladybug-charm.stl \
         projects/bracelet/models/ladybug-charm/ladybug-charm.scad
openscad -o projects/bracelet/exports/dolphin-charm-dolphin-charm.stl \
         projects/bracelet/models/dolphin-charm/dolphin-charm.scad

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
- To fasten: push the two ends together, push the T up into the block's
  room from below, then pull the ends apart until it clicks home. To open:
  push the ends together (it clicks back) and push the T out downwards.

### The bolt and the charms

- The stations change nothing about how the band prints: same first layer,
  same bridges, same no-brim rule. The countersinks open on the bed side and
  close in at 13° from vertical; the ribs sit on the bars' tops.
- **Print the bolt standing up, exactly as modelled, in ABS.** It stands on
  its foot with the thread on top. No supports, no brim. The hex socket opens
  on the bed and its end is a pointed hex cone. The thread's underside flanks
  are the only overhang, 0.4 mm deep, like any printed bolt. `-D copies=6`
  lays out a batch, which exports as that many separate shells.
- **Print every charm bottom down, exactly as modelled** — no rotation, no
  supports, no brim. The socket and the eight grooves open on the bed; the
  socket's end is a 45° cone and each groove's roof a 45° gable.
- The rose's petals are 0.9 mm, two perimeters. Leave thin-wall handling on
  and do not print it with a single fat perimeter.
- The thread is the M4 screw's printed tooth and fit (0.15 mm), at M5:
  printed and confirmed with the heart on 2026-10-05.

### The screwdriver

- **Print it lying flat**, on the paddle's underside, as modelled. The bit
  lies on one of its flats, so its layers run along it and twisting it does
  not split them apart. No supports, no brim. PLA or ABS.
- **Not printed yet.** The fit was checked against the bolt's socket in
  OpenSCAD only.

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
