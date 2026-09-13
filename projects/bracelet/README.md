# bracelet

A bracelet made of **printed 3D fabric**: a field of small rigid tiles joined
by print-in-place **hinges**. It comes off the bed as a textile — it drapes, it
shears, it wraps a wrist — and nothing is assembled, glued, or picked out of
supports.

**Sized to the wrist it is printed for — a 192 mm loop on a 180 mm wrist, a
16 × 2 field of tiles, printed flat in a 199 × 17 × 5 mm strip.**

![the bracelet as it comes off the bed](previews/bracelet-bracelet.png)

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
        tile A                                       tile B
   +----------+   lug  #####                          +----------+
   |          |--------#####===== pin =====           |          |
   |   body   |        #####      (o) blade, bored    |   body   |
   |  on bed  |--------#####===== pin =====  on bed   |  on bed  |
   +----------+   lug  #####                          +----------+
```

A three-knuckle hinge. Tile A carries **two lugs** with a **pin** fused into
both of them; tile B carries a single **blade** with a closed **bore** around
that pin.

- The pin's free span is **3.0 mm**, anchored at each end inside a lug that is
  solid from the plate up. A bridge, not a cantilever.
- The blade's bore is a *closed* hole, so the roof over the pin is anchored on
  both sides too. (A hook opening toward the neighbour would simply pull off.)
- B cannot escape: the bore encircles the pin, and A's two lugs block the only
  way out along it.

Measured on the exported mesh:

| probe | reading |
|---|---|
| along the pin, at the bed (z = 0.10) | `lug 1.500 \| air 0.500 \| blade 2.000 \| air 0.500 \| lug 1.500` |
| along the pin, at its axis | one unbroken `SOLID 6.000` — fused lug to lug |
| vertical through the pin's free span | `floor 0.700 \| air 0.500 \| pin 1.792 \| air 0.308 \| roof 0.896` |
| vertical through a lug | `SOLID 4.196` — bed to top |

The first two lines are the point: the pin's anchors are feet on the plate, and
the pin is continuous between them.

**The 0.5 mm along the pin is the number the whole thing lives on.** A lug and
the blade beside it sit side by side and *both* stand on the bed, so their
first layers are laid 0.5 mm apart. At the 0.3 mm used elsewhere, two 0.4 mm
beads spread into each other and weld the joint solid on layer one, and no
amount of flexing afterwards frees it.

Nothing is tangent to the bed either, and nothing overhangs off it. The pin's
underside is cut flat so its first layer is **1.20 mm** wide instead of a knife
edge, and the knuckle caps are **not plain discs** — see below.

The hinge swings freely through **±100°** and only binds at 110°. Wrapping a
180 mm wrist over 16 columns needs 22.5°.

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
| chord cap | 269.9 mm² | **0.0 mm²** | **32.7°** |

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

## What is printed over air

| layer | reaches past a bead | what it is |
|---|---|---|
| z ≈ 1.2 | 102.6 mm² | each pin's first layer — a 3.0 mm bridge between two lugs |
| z ≈ 3.2 | 9.2 mm² | each bore's roof — anchored on both sides of the blade |

Nothing else in the print reaches more than one 0.4 mm bead past the layer
below it, at either 0.20 or 0.15 mm layers. The overhang checker reports 92
regions, all `BRIDGE`, none needing support — and this time the anchors are
real, which the probes above are there to prove.

Note what those 92 regions are **not**: they are the pins and the bore roofs,
and the count was identical before and after the knuckle cap was fixed. Neither
automated check ever saw the drooping knuckle (see
`CLAUDE.md` — it took looking at the model in a slicer).

Bed stability: **30 separate contact patches**, 2188 mm² of first layer, 28
tile feet plus the two clasp ends. Adhesion and tipping both score **0.3**.

## Models and parts

```
projects/bracelet/
└── models/
    └── bracelet/bracelet.scad   # the whole bracelet — one printed object
```

One model, one part, one print. It exports as **30 separate shells**: 32 tiles,
less the four end tiles that the two clasp yokes fuse into two pieces. They are
not supposed to touch.

| Model | Part | Size (print pose) | Sits on |
|---|---|---|---|
| `bracelet` | `bracelet` | 199.0 × 17.0 × 5.0 mm | all 30 pieces' own flat feet |

## Sizing

`wrist` is the only number you normally touch. `ease` (12 mm) is exact, not
approximate — the fabric quantises to whole 11 mm columns and the remainder
lengthens the keyhole plate, which is why the loop lands on `wrist + 12` at
every size. `rows` widens the band and costs nothing but filament.

| `wrist` | tiles | loop, clasped | post travel | printed footprint |
|---|---|---|---|---|
| 140 (child) | 12 × 2 | 152.0 mm | 10.0 mm | 159.0 × 17.0 mm |
| 160 | 14 × 2 | 172.0 mm | 8.0 mm | 179.0 × 17.0 mm |
| **180 (default, adult)** | **16 × 2** | **192.0 mm** | **6.0 mm** | **199.0 × 17.0 mm** |
| 200 | 18 × 2 | 212.0 mm | 4.0 mm | 219.0 × 17.0 mm |
| 180, `rows=3` | 16 × 3 | 192.0 mm | 6.0 mm | 199.0 × 28.0 mm |

The band itself is 4.2 mm thick at every size; the 5.0 mm overall height is the
stud.

Other parameters worth knowing: `pitch` / `body` (tile spacing and size — the
knuckles need room to swing, so these are tied together by an assert),
`pin_d` (2.0 mm — the entire load path of the band), `fit` (0.3 mm, radial)
and **`axial_fit`** (0.5 mm, along the pin — see above), `knuck_wall` (0.9 mm,
the deliberate thinnest wall), `knuck_slope` (32.7°, derived — the knuckle
underside, asserted at ≤ 40°), and the clasp's `det_gap` / `leaf_w` /
`leaf_free` if the detent wants to be lighter or firmer.

## Printing

```sh
openscad -o projects/bracelet/exports/bracelet-bracelet.stl \
         projects/bracelet/models/bracelet/bracelet.scad
```

- **Lay it flat, exactly as modelled.** No rotation, no supports.
- **NO BRIM, and no raft.** This is the one setting that will ruin the print:
  the feet are 0.5 mm apart and a brim bridges straight between them, welding
  every hinge shut. A skirt is fine.
- **Layer height 0.20 mm, or 0.10.** Every interface in the joint sits on a
  0.2 mm boundary — bore floor at 0.7 is the one exception — so at 0.20 mm the
  clearances come out at their designed size.
- **Part cooling on, temperature at the low end of the range.** Every pin is a
  3 mm bridge and every bore has a roof over it.
- Three perimeters; infill barely matters at this wall thickness.
- PLA is the easy choice. PETG is tougher but strings, and strings between
  knuckles are exactly what you don't want here.
- Off the plate, **work each hinge back and forth before wearing it.** They
  come out stiff; a little movement frees them.
- To fasten: drop the stud's head through the round entry hole, then slide the
  ends apart until the post snaps past the detent and seats. To release, push
  it back past the detent and lift the head out.

## License

The models in this project are licensed under
[CC BY-NC 4.0](LICENSE) — attribution, non-commercial.
