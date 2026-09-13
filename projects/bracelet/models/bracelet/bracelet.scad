// bracelet — a bracelet made of PRINTED 3D FABRIC: a field of small
// rigid tiles joined by print-in-place HINGES. It comes off the bed as a
// textile — it drapes, it shears, it wraps a wrist — and nothing is assembled
// or glued.
//
// THE RULE THIS DESIGN EXISTS TO OBEY: nothing is cantilevered into air.
// Every piece of material here either stands on the bed, or is a bridge
// anchored at BOTH ends to material that stands on the bed.
//
// The joint is a hinge, three knuckles wide:
//
//        tile A                                       tile B
//   +----------+   lug  #####                          +----------+
//   |          |--------#####===== pin =====           |          |
//   |   body   |        #####      (o) blade, bored    |   body   |
//   |  on bed  |--------#####===== pin =====  on bed   |  on bed  |
//   +----------+   lug  #####                          +----------+
//
//   * A's two LUGS are solid and stand on the bed.
//   * The PIN is fused into both of them, so its free span across B's blade
//     is a bridge with two real anchors — not a cantilever.
//   * B's BLADE stands on the bed too, and its BORE is a closed hole, so the
//     roof over the pin is likewise anchored on both sides.
//   * B cannot come off: the bore encircles the pin, and A's two lugs close
//     off the only way out along the pin.
//
// WHAT THIS REPLACED, AND WHY. The joint used to be a stem ending in a round
// head, captured in a pocket in the neighbour. That head was a CANTILEVER: it
// left tile A and its far end was free, floating 0.4 mm over tile B's pocket
// floor. The nozzle had to lay a 1.2 mm bead nearly 5 mm out into air, and it
// would have drooped onto — and welded to — the floor below.
//
// `check_overhangs.py` called all of that BRIDGE and said no support was
// needed. It was wrong, in the exact way this project has been bitten before:
// it measures the span between the features on either side without asking
// whether those features are BONDED to the region. One "anchor" was a loose
// floating head. A BRIDGE verdict is only ever worth what its anchors are
// worth. Hence the rule at the top of this file.
//
// Before that it was a cable chain, tipped 45 degrees, whose arcs ran tangent
// to the bed; the outline leapt sideways further than a bead can carry and
// links tore off the plate. Twice. None of that geometry survives here: every
// curve is either a vertical cylinder wall or a knuckle with a FLAT BOTTOM.
//
// Print it lying exactly as modelled. No supports. NO BRIM — see the README.

$fa = 2;
$fs = 0.3;

// ------------------------------------------------------------------- sizing
wrist   = 180;   // wrist circumference in mm. 180 adult, 140 child.
ease    =  12;   // slack on top of the wrist, so the band hangs rather than
                 //   grips. EXACT, not approximate: the fabric quantises to
                 //   whole columns of `pitch`, and the remainder is spent on
                 //   the keyhole plate's length (see `kh_lock`, below).

rows    =   2;   // tiles across the band. 2 -> a 17.2 mm band. 3 makes a
                 //   28.4 mm cuff and costs nothing but filament.

// -------------------------------------------------------------------- tiles
pitch     = 11.0;         // tile centre to tile centre, both axes
body      =  6.0;         // the tile slab itself
h         = body/2;       // 3.0
corner_r  =  1.0;         // plan-view corner radius of a tile

ch_run    = 0.5;          // TOP chamfer only. The bottom stays flat and full
ch_rise   = 0.6;          //   size — unlike the old design, articulation here
                          //   comes from the hinge, not from clearing the
                          //   tiles' edges past each other, so there is no
                          //   reason to spend bed contact on a bottom chamfer.

// -------------------------------------------------------------------- hinge
fit        = 0.3;               // radial clearance: pin-in-bore, and knuckle
                                //   against the neighbour's body. Both are
                                //   well clear of the bed.
axial_fit  = 0.5;               // clearance ALONG the pin, between a lug and
                                //   the blade beside it. Deliberately larger
                                //   than `fit`, and it is the one number here
                                //   that decides whether the hinge works: a
                                //   lug and a blade sit side by side and BOTH
                                //   stand on the bed, so their first layers
                                //   are laid 0.5 mm apart. At `fit` = 0.3 two
                                //   0.4 mm beads spread into each other and
                                //   weld the joint solid on layer one, and no
                                //   amount of flexing afterwards frees it.
pin_d      = 2.0;               // the pin — the entire load path of the band
pin_r      = pin_d/2;
bore_r     = pin_r + fit;       // 1.2
knuck_wall = 0.9;               // material around the bore
rk         = bore_r + knuck_wall;   // 2.1 — the knuckle's outer radius, and
                                    //   the radius everything sweeps through
                                    //   when the hinge turns
pin_z      = 2.0;               // pin axis height. NOT free: see the two
                                //   asserts below — it is squeezed between
                                //   needing floor under the bore and needing
                                //   the knuckle to reach the bed.
thick      = pin_z + rk;        // 4.0 — the knuckle's top IS the band's top

pin_flat   = 0.2;   // the pin's underside is cut flat this far above where a
                    //   full cylinder would have been tangent. A cylinder
                    //   tangent to the bed is what tore the old chain off the
                    //   plate: the outline jumps sqrt(2*r*layer) = 0.63 mm in
                    //   the first 0.2 mm layer, past what a 0.4 mm bead can
                    //   carry. Cut flat, the first layer is 1.20 mm wide and
                    //   the worst step after it is 0.20 mm. The bore stays
                    //   round, so the flat only ever adds clearance.

blade_w = 2.0;                                // the middle knuckle (tile B's)
lug_w   = (body - blade_w - 2*axial_fit)/2;   // 1.5 — the two outer (A's)

// How far the cap still reaches past the pin axis where it meets the bed.
// (Not the whole footprint: the arm carries the rest of it.) If this goes to
// zero the knuckle is standing on a knife edge.
knuck_foot  = (rk > pin_z) ? sqrt(rk*rk - pin_z*pin_z) : 0;
knuck_slope = atan((rk - knuck_foot) / pin_z);   // underside, from vertical
pin_flat_w  = 2 * sqrt(pin_r*pin_r - pow(pin_r - pin_flat, 2));

// The knuckle has to reach the bed AND leave a floor under the bore, and
// those pull `pin_z` in opposite directions. Both must hold. Assert on the
// knuckle's actual FOOTPRINT, not on `rk > pin_z`: the disc only just dipping
// below z = 0 technically "reaches" the bed while standing on a knife edge.
assert(knuck_foot >= 0.6,
       str("knuckle stands on a knife edge: cap reaches ", knuck_foot,
           " mm past the pin at the bed"));
assert(pin_z - bore_r >= 0.6,
       str("too little floor under the bore: ", pin_z - bore_r));
// Room to swing: nothing of the neighbour may sit inside the knuckle's radius.
assert(h + rk + fit <= pitch/2,
       str("tiles too close for the knuckles to turn: ", pitch/2 - h - rk - fit));
assert(lug_w >= 1.2, str("lugs too narrow: ", lug_w));
assert(axial_fit >= 0.45,
       str("lug and blade feet will weld on the first layer: ", axial_fit));
assert(pin_flat < pin_r, "pin flattened away to nothing");
// The knuckle's underside is the largest sloped surface in the model and there
// are 92 of them. Keep it well inside the self-supporting cone.
assert(knuck_slope <= 40,
       str("knuckle underside hangs at ", knuck_slope, " deg from vertical"));

// -------------------------------------------------------------------- clasp
// A stud and a keyhole, NOT a toggle. A toggle made of two flat plates in the
// SAME plane does not lock: the bar has to lie across the ring's face,
// perpendicular to the pull, and getting it there needs a 90-degree twist
// that a flat PLA stand will not give. Coplanar, the bar simply slides back
// out through the bore. This clasp locks out of plane instead — the stud's
// head sits above the keyhole plate and cannot pass back through the slot.
cl_t      = 1.6;    // clasp plate thickness. The keyhole plate lies ON TOP of
                    //   the stud plate when fastened, so the post has to
                    //   clear 2 * cl_t.
post_d    = 3.0;
head_d    = 5.4;
post_top  = 2*cl_t + fit;          // 3.5 — top of the parallel post
head_h    = 1.5;                   // cone up to head_d. The underside of the
                                   //   head is therefore at atan(1.2/1.5) =
                                   //   38.7 deg from vertical: self-supporting,
                                   //   no support under the head.
slot_w    = post_d + 0.3;          // 3.3 — the post slides freely along this
entry_d   = head_d + 0.6;          // 6.0 — the hole the head drops through
det_gap   = 2.7;                   // the detent pinches to here, so the post
det_r     = 0.5;                   //   (3.0) must snap 0.15 mm past it a side
leaf_w    = 0.8;                   // Each detent bump sits on a SPRING LEAF —
rel_w     = 0.8;                   //   a strip of plate freed by a relief slot
leaf_free = 2.5;                   //   beside the main slot. Without it the
                                   //   bump is rigid: a 1.6 mm plate will not
                                   //   yield 0.13 mm, so the post either
                                   //   refuses to pass or splits the plate.
                                   //
                                   //   The relief runs OUT INTO THE ENTRY
                                   //   HOLE on purpose, so each leaf is a
                                   //   CANTILEVER rooted `leaf_free` before
                                   //   the bump, not a beam built in at both
                                   //   ends. That matters: fixed-fixed at this
                                   //   length it would take ~50 N to push the
                                   //   post past, which is not a clasp, it is
                                   //   a jam. As a cantilever it takes ~6 N —
                                   //   a click you can feel and undo.
                                   //   leaf_w is a FLEXURE, and is meant to be
                                   //   under the 1.2 mm wall threshold.
kh_w      = 9.0;                   // keyhole plate width
tip_wall  = 1.8;                   // plate left beyond the seat — this is what
                                   //   the post pulls against, so it carries
                                   //   the entire clasp load
kh_tip    = slot_w/2 + tip_wall;
stud_pw   = 8.0;
stud_tip  = 3.5;
yoke_len  = 3.0;                   // how far a yoke stands off the end column
yoke_bite = 1.4;                   // how far it reaches INTO it, so it unions

assert(head_d > slot_w + 1.5, "head can pull back through the slot");
assert(det_gap < post_d, "detent does not actually pinch the post");
assert(entry_d > head_d, "head will not pass through the entry hole");
assert(post_top >= 2*cl_t + fit, "post too short to reach through both plates");
assert(slot_w > post_d, "post cannot slide along the slot at all");
assert(kh_w/2 - (slot_w/2 + leaf_w + rel_w) >= 1.0,
       str("relief slot leaves too little plate outboard: ",
           kh_w/2 - (slot_w/2 + leaf_w + rel_w)));
assert(det_r > (post_d - det_gap)/2, "detent bump too small to pinch");
// The leaf must stay a cantilever: its free end has to reach the entry hole.
assert(x_entry + 1.0 - (x_det - leaf_free) > leaf_free,
       "relief slot does not reach the entry hole - the leaf is built in at
        both ends and the detent becomes a jam");

// ------------------------------------------------------------ length budget
// Clasped, the loop runs: post axis -> keyhole plate -> yoke -> fabric ->
// yoke -> stud plate -> post axis. The fabric only comes in whole columns, so
// `cols` is the most that fit and the remainder lengthens the keyhole plate.
// That is why the loop lands exactly on wrist+ease at every size.
stud_ext = 8.0;                        // last tile's face -> post axis
kh_entry = yoke_len + entry_d/2 + 1.0; // first tile's face -> entry hole
span     = function (n) (n - 1) * pitch + body;

cols     = floor((wrist + ease - body - stud_ext - (kh_entry + 3)) / pitch) + 1;
chain    = span(cols);
kh_lock  = wrist + ease - chain - stud_ext;   // face -> the seated post

assert(kh_lock >= kh_entry + 3,
       str("keyhole plate too short to hold the post: ", kh_lock));
assert(kh_lock < kh_entry + 3 + pitch,
       str("a whole column was missed: ", kh_lock));

band_w  = (rows - 1) * pitch + body;
band_cy = (rows - 1) * pitch / 2;
x_l     = -h;                      // fabric's -x face
x_r     = (cols-1)*pitch + h;      // fabric's +x face
x_stud  = x_r + stud_ext;
x_entry = x_l - kh_entry;
x_lock  = x_l - kh_lock;
x_det   = x_lock + 1.8;

echo(str("cols=", cols, " rows=", rows,
         "  loop=", chain + stud_ext + kh_lock,
         "  keyhole travel=", kh_lock - kh_entry,
         "  footprint=", (x_stud + stud_tip) - (x_lock - kh_tip),
                    " x ", band_w, " x ", post_top + head_h,
         "  band thick=", thick,
         "  knuckle cap at bed=", knuck_foot,
         "  knuckle underside=", knuck_slope, "deg",
         "  pin first layer=", pin_flat_w));

// ------------------------------------------------------------------ modules
module rrect(s) offset(r = corner_r) square(s - 2*corner_r, center = true);

// A tile slab: flat on the bed, chamfered only at the top.
module tile_body() {
    hull() {
        linear_extrude(thick - ch_rise) rrect(body);
        translate([0, 0, thick - 0.01]) linear_extrude(0.01) rrect(body - 2*ch_run);
    }
}

// The knuckle's silhouette in the XZ plane: an arm running out from inside
// the tile to the pin axis, capped beyond it by a knuckle centred on the pin.
//
// The cap is NOT a plain disc. A disc cut flat at z = 0 leaves the bed at 65
// degrees from vertical and its outline steps 0.348 mm in the first 0.2 mm
// layer -- 87% of a 0.4 mm bead unsupported. It squeaks past a step check and
// then droops on the plate, which is exactly what it did.
//
// What the circle is actually FOR is the swing envelope: when the hinge turns,
// nothing of the knuckle may reach further than `rk` from the pin, because
// that is how close the neighbour's body comes. Only the envelope has to be
// circular -- the material inside it does not.
//
// So below the pin axis the arc is replaced by a straight CHORD from the foot
// to the widest point. Both of its endpoints lie exactly `rk` from the pin, so
// the swing envelope is untouched, and a chord of a circle lies inside the arc
// it replaces, so clearance only improves. The underside becomes a uniform
// 32.7 degrees from vertical, stepping 0.128 mm a layer.
//
// Above the pin axis the arc stays: there the surface closes inward as it
// rises, which is a top surface, not an overhang.
module knuckle_2d(xp, dir, xin) {
    union() {
        translate([min(xin, xp), 0]) square([abs(xp - xin), thick]);
        // upper half: the arc, trimmed to z >= pin_z and to the far side of xp
        intersection() {
            translate([xp, pin_z]) circle(r = rk);
            translate([dir > 0 ? xp : xp - rk - 1, pin_z])
                square([rk + 1, rk + 1]);
        }
        // lower half: the self-supporting chord
        polygon(dir > 0
            ? [[xp, 0], [xp + knuck_foot, 0], [xp + rk, pin_z], [xp, pin_z]]
            : [[xp, 0], [xp - knuck_foot, 0], [xp - rk, pin_z], [xp, pin_z]]);
    }
}

// Extrude an XZ profile along y, from y0 to y0 + w.
module xz_extrude(y0, w) {
    translate([0, y0 + w, 0]) rotate([90, 0, 0]) linear_extrude(w) children();
}

// The pin: one cylinder spanning the whole joint, flattened underneath, fused
// into both lugs. Its free span is blade_w + 2*axial_fit = 3.0 mm, anchored
// at each end in a lug that stands on the bed.
module pin() {
    pl = blade_w + 2*axial_fit + 2*lug_w;   // == body
    intersection() {
        translate([pitch/2, -pl/2, pin_z]) rotate([-90, 0, 0])
            cylinder(h = pl, r = pin_r);
        translate([pitch/2 - pin_r, -pl/2, pin_z - pin_r + pin_flat])
            cube([2*pin_r, pl, thick]);
    }
}

// The +x half of a joint: two lugs straddling the neighbour's blade, plus the
// pin they both carry.
module fork() {
    for (s = [-1, 1])
        xz_extrude(s > 0 ? blade_w/2 + axial_fit
                         : -(blade_w/2 + axial_fit + lug_w), lug_w)
            knuckle_2d(pitch/2, +1, h - 1.0);
    pin();
}

// The -x half: one central blade with a closed bore. Closed, not hooked — a
// hook opening toward the neighbour would simply pull off the pin.
module blade() {
    difference() {
        xz_extrude(-blade_w/2, blade_w) knuckle_2d(-pitch/2, -1, -(h - 1.0));
        translate([-pitch/2, -blade_w, pin_z]) rotate([-90, 0, 0])
            cylinder(h = 2*blade_w, r = bore_r);
    }
}

// The -y blade and +y fork are the -x/+x ones REFLECTED IN y = x, not
// rotated: a rotation would send them to the wrong edge.
module tile(col, row) {
    translate([col*pitch, row*pitch, 0]) {
        tile_body();
        if (col > 0)        blade();
        if (row > 0)        mirror([1, -1, 0]) blade();
        if (col < cols - 1) fork();
        if (row < rows - 1) mirror([1, -1, 0]) fork();
    }
}

// Fillet the inside corners of a flat clasp plate — a yoke/plate junction is
// where a 1.6 mm plate tears.
module filleted(r = 1.2) offset(r = -r) offset(r = r) children();

module clasp_stud() {
    linear_extrude(cl_t) filleted() union() {
        translate([x_r - yoke_bite, -h]) square([yoke_len + yoke_bite, band_w]);
        translate([x_r, band_cy - stud_pw/2])
            square([x_stud + stud_tip - x_r, stud_pw]);
    }
    translate([x_stud, band_cy, 0]) {
        cylinder(h = post_top, d = post_d);
        translate([0, 0, post_top]) cylinder(h = head_h, d1 = post_d, d2 = head_d);
    }
}

// The keyhole: drop the head through the round entry, then slide the band so
// the post travels to the seat. Two detent bumps pinch the slot to `det_gap`
// on the way, so the post has to snap past them and will not wander back.
module keyhole_cut() {
    // the keyhole proper: entry hole, slot, seat, minus the two detent bumps
    difference() {
        union() {
            translate([x_entry, band_cy]) circle(d = entry_d);
            translate([x_lock,  band_cy]) circle(d = slot_w);
            translate([x_lock,  band_cy - slot_w/2])
                square([x_entry - x_lock, slot_w]);
        }
        for (s = [-1, 1])
            translate([x_det, band_cy + s*(det_gap/2 + det_r)]) circle(r = det_r);
    }
    // the relief slots that turn each bump into a cantilever spring leaf.
    // They deliberately run into the entry hole — that free end is what makes
    // the leaf a spring instead of a rigid rib.
    for (s = [-1, 1])
        hull() for (e = [x_det - leaf_free, x_entry + 1.0])
            translate([e, band_cy + s*(slot_w/2 + leaf_w + rel_w/2)])
                circle(d = rel_w);
}

module clasp_keyhole() {
    linear_extrude(cl_t) difference() {
        filleted() union() {
            translate([x_l - yoke_len, -h]) square([yoke_len + yoke_bite, band_w]);
            translate([x_lock - kh_tip, band_cy - kh_w/2])
                square([x_l - (x_lock - kh_tip), kh_w]);
        }
        keyhole_cut();
    }
}

module bracelet() {
    for (c = [0:cols-1], r = [0:rows-1]) tile(c, r);
    clasp_stud();
    clasp_keyhole();
}

bracelet();
