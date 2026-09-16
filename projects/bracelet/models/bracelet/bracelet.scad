// bracelet — a bracelet made of PRINTED 3D FABRIC: a row of rigid bars
// joined by print-in-place HINGES. It comes off the bed as a band that rolls
// up around a wrist, and nothing is assembled or glued.
//
// IT HINGES IN ONE AXIS ONLY, and that is deliberate. The band used to be a
// GRID of tiles, hinged along its length AND across its width. The cross-band
// hinges never worked: with `rows` = 2 the only one of them runs straight down
// the middle of the band, end to end — and both clasp yokes are solid plates
// spanning the full width, so that line is built in at both ends. A hinge
// clamped at both ends is not a hinge, it is a stiff seam. It cost 30-odd
// joints' worth of knuckles, bores and welding risk and bought no movement at
// all. Removed: each column is now ONE BAR spanning the band, and the only
// articulation is the one the wrist actually asks for.
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

// The ball pin every charm clips onto, and the socket that clips onto it.
// Variables and modules only — including it draws nothing. Everything it
// defines is named `charm_*` / `ball_*` / `neck_*` / `cav_*` / `mouth_*` /
// `sock_*`, so nothing in it shadows the HINGE pin's `pin_d` / `pin_z`.
include <../../lib/charm-pin.scad>

// ------------------------------------------------------------------- sizing
wrist   = 180;   // wrist circumference in mm. 180 adult, 140 child.
ease    =  12;   // slack on top of the wrist, so the band hangs rather than
                 //   grips. EXACT, not approximate: the fabric quantises to
                 //   whole columns of `pitch`, and the remainder is spent on
                 //   the keyhole plate's length (see `kh_lock`, below).

rows    =   2;   // how many tile-widths wide the band is. It no longer means
                 //   a row of separate tiles — a column is a single bar — but
                 //   it still sets the width AND the number of hinge knuckle
                 //   clusters spaced along each joint. 2 -> a 17.6 mm band.

// --------------------------------------------------------------------- bars
pitch_nom = 11.6;         // what bar spacing WANTS to be. The spacing actually
                          //   used is solved for in the length budget below,
                          //   within a millimetre of this — see `pitch`.
body      =  6.0;         // the bar slab, along the band. Also the width of
                          //   one hinge knuckle cluster, across it.
h         = body/2;       // 3.0
row_pitch = 11.6;         // spacing of the knuckle clusters ACROSS the band.
                          //   Deliberately NOT `pitch`: the band's width must
                          //   not change when the length solver breathes the
                          //   joints, so this one is fixed.
corner_r  =  1.0;         // plan-view corner radius of a bar

ch_run    = 0.5;          // TOP chamfer only. The bottom stays flat and full
ch_rise   = 0.6;          //   size — articulation here comes from the hinge,
                          //   not from clearing the bars' edges past each
                          //   other, so there is no reason to spend bed
                          //   contact on a bottom chamfer.

// -------------------------------------------------------------------- hinge
fit        = 0.3;               // general clearance: the knuckle against the
                                //   neighbour's body as it swings, and the
                                //   clasp's stack-up. Well clear of the bed.
bore_fit   = 0.45;              // RADIAL clearance of the pin in its bore, and
                                //   the single number that decides how freely
                                //   the band moves. It was 0.3, printed, and
                                //   came off the plate stiff: at 0.3 the bore
                                //   is only half a layer's worth of play over
                                //   the pin, so every joint rubs and 3x lost
                                //   the band's drape. 0.45 leaves the pin
                                //   visibly loose in the bore and the band
                                //   falls limp. It costs `rk`, and through
                                //   that `pitch` — see below.
axial_fit  = 0.6;               // clearance ALONG the pin, between a lug and
                                //   the blade beside it. Deliberately larger
                                //   than `fit`, and it is the one number here
                                //   that decides whether the hinge works: a
                                //   lug and a blade sit side by side and BOTH
                                //   stand on the bed, so their first layers
                                //   are laid 0.5 mm apart. At `fit` = 0.3 two
                                //   0.4 mm beads spread into each other and
                                //   weld the joint solid on layer one, and no
                                //   amount of flexing afterwards frees it.
                                //   Raised from 0.5 with the bore, so the lug
                                //   faces stop rubbing the blade's as well.
pin_d      = 2.0;               // the pin — the entire load path of the band
pin_r      = pin_d/2;
bore_r     = pin_r + bore_fit;  // 1.45
knuck_wall = 0.9;               // material around the bore
rk         = bore_r + knuck_wall;   // 2.35 — the knuckle's outer radius, and
                                    //   the radius everything sweeps through
                                    //   when the hinge turns
pin_z      = 2.1;               // pin axis height. NOT free: see the two
                                //   asserts below — it is squeezed between
                                //   needing floor under the bore and needing
                                //   the knuckle to reach the bed.
thick      = pin_z + rk;        // 4.45 — the knuckle's top IS the band's top

pin_flat   = 0.2;   // the pin's underside is cut flat this far above where a
                    //   full cylinder would have been tangent. A cylinder
                    //   tangent to the bed is what tore the old chain off the
                    //   plate: the outline jumps sqrt(2*r*layer) = 0.63 mm in
                    //   the first 0.2 mm layer, past what a 0.4 mm bead can
                    //   carry. Cut flat, the first layer is 1.20 mm wide and
                    //   the worst step after it is 0.20 mm. The bore stays
                    //   round, so the flat only ever adds clearance.

blade_w = 2.0;                                // the middle knuckle (tile B's)
lug_w   = (body - blade_w - 2*axial_fit)/2;   // 1.4 — the two outer (A's)

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
assert(lug_w >= 1.2, str("lugs too narrow: ", lug_w));
assert(bore_fit > fit, "the bore is the joint's play — keep it the loosest fit");
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
det_off   = 1.8;                   // seat -> detent, along the slot
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
// ...but the DETENT itself must stay well OUT of the entry hole. The entry is
// 6 mm across and the seat is only `det_off` + travel from its centre, so on a
// short plate the hole swallows the bumps: they come off the plate as two
// loose 1 mm crumbs and the clasp has no detent at all. The only symptom is
// two extra shells in the export, which is easy to read as "a tile came free".
// This bit the design at travel = 3 and went unnoticed because the default
// size never landed there.
assert(norm([x_entry - x_det, det_gap/2 + det_r]) >= entry_d/2 + det_r + 0.1,
       str("the entry hole is eating the detent bumps: centres ",
           norm([x_entry - x_det, det_gap/2 + det_r]), " apart, need ",
           entry_d/2 + det_r + 0.1));

// ------------------------------------------------------------ length budget
// Clasped, the loop runs: post axis -> keyhole plate -> yoke -> band -> yoke
// -> stud plate -> post axis.
//
// THE BUCKLE IS AS SHORT AS IT WORKS, AND FIXED. It used to be the part that
// absorbed the sizing remainder — the band came in whole bars, so whatever was
// left over lengthened the keyhole plate, and on a small wrist that left a
// 27 mm slab of flat plate hanging off the end of a 149 mm bracelet. Now the
// plate is cut to the shortest slot the clasp can actually use and the BAND
// makes up the difference instead.
//
// Which moves the remainder problem, so: the number of bars is chosen to land
// closest to `pitch_nom`, and then the joints are all stretched or squeezed
// equally — by a fraction of a millimetre each — so the loop still comes out
// exactly on wrist+ease. Nothing about a bar changes; only the gaps do, and
// they have about a millimetre of room between the knuckles binding and the
// band looking gappy.
stud_ext = 8.0;                        // last bar's face -> post axis
kh_entry = yoke_len + entry_d/2 + 1.0; // first bar's face -> entry hole
// Shortest usable slot: the seated post has to sit far enough from the entry
// hole that the hole does not reach the detent bumps (see the assert above).
kh_travel_min = det_off + entry_d/2 + det_r + 0.2;   // 5.5
kh_lock  = kh_entry + kh_travel_min;                 // 12.5, at every size

// What the band has to span, tip face to tip face.
band_run  = wrist + ease - stud_ext - kh_lock;
// The knuckles bind below `pitch_min` — that is the swing clearance, the same
// limit that used to be asserted against a constant. Above `pitch_max` the
// gaps just look wrong; the range is what makes an exact fit reachable.
pitch_min = 2*(h + rk + fit);            // 11.30
pitch_max = pitch_min + 1.4;             // 12.70
joints_lo = ceil((band_run - body) / pitch_max);
joints_hi = floor((band_run - body) / pitch_min);
assert(joints_lo <= joints_hi,
       str("no bar count spans ", band_run, " mm at a legal pitch"));
joints   = min(joints_hi, max(joints_lo,
                              round((band_run - body) / pitch_nom)));
pitch    = (band_run - body) / joints;   // the gaps take up the remainder
cols     = joints + 1;

assert(pitch >= pitch_min,
       str("bars too close for the knuckles to turn: ", pitch/2 - h - rk - fit));
assert(pitch <= pitch_max, str("joints stretched too far: ", pitch));

band_w  = (rows - 1) * row_pitch + body;
band_cy = (rows - 1) * row_pitch / 2;
x_l     = -h;                      // band's -x face
x_r     = (cols-1)*pitch + h;      // band's +x face
x_stud  = x_r + stud_ext;
x_entry = x_l - kh_entry;
x_lock  = x_l - kh_lock;
x_det   = x_lock + det_off;

// --------------------------------------------------------------- the charms
// OPTIONAL. `charms` bars along the band grow a ball pin out of their top
// face, and a charm (models/flower-charm) snaps onto it. Leave it at 0 and the
// bracelet is exactly the bracelet it was.
//
// A bar's top is the best mounting face in the whole project: flat, horizontal,
// 5.0 x 16.6 mm inside the chamfer, and solid all the way to the plate. The pin
// is therefore a plain vertical stalk — it adds nothing to the footprint, no
// overhang, and no layer step, and the rule at the top of this file is not even
// tested by it. It sits at the bar's centre, on the band's centreline.
//
// The pin is FUSED to its bar, permanently. Everything in this print is
// print-in-place; the joint that comes apart is the one at the TOP of the pin,
// where it can be made as stiff as it likes without anything having to flex to
// get it there.
charms      = 0;     // how many charm stations. 0 = none.
charm_reach = 16;    // the widest charm this spacing has to keep apart —
                     //   models/flower-charm is 16 mm across.

function charm_col(i) = round((i + 1) * (cols - 1) / (charms + 1));
charm_ix    = [for (i = [0 : charms - 1]) charm_col(i)];

// Spacing is checked on the SMALLEST gap between consecutive stations, not on
// the average. Rounding station indices to whole bars makes the gaps uneven,
// and the average happily passes a pair that lands one bar apart.
charm_sep   = charms < 2 ? cols
            : min([for (i = [0 : charms - 2]) charm_ix[i+1] - charm_ix[i]]);
assert(charms == 0 || charm_sep * pitch >= charm_reach,
       "two charms would land closer together than a charm is wide — lower `charms`");
assert(charms == 0 || (charm_ix[0] >= 1 && charm_ix[charms-1] <= cols - 2),
       "a charm landed on an end bar, where the clasp yoke is");

// The pin outgrows the stud, so it sets the print height once there is one.
top_z       = charms > 0 ? max(post_top + head_h, thick + charm_rise + charm_ball/2)
                         : post_top + head_h;

echo(str("cols=", cols, " rows=", rows,
         "  loop=", band_run + stud_ext + kh_lock,
         "  pitch=", pitch, " (gap ", pitch - body, ")",
         "  keyhole travel=", kh_lock - kh_entry,
         "  footprint=", (x_stud + stud_tip) - (x_lock - kh_tip),
                    " x ", band_w, " x ", top_z,
         "  band thick=", thick,
         "  knuckle cap at bed=", knuck_foot,
         "  knuckle underside=", knuck_slope, "deg",
         "  pin first layer=", pin_flat_w));
if (charms > 0)
    echo(str(charms, " charm pin(s) on bar(s) ", charm_ix, " of ", cols,
             " — ball d", charm_ball, " standing ", charm_rise + charm_ball/2,
             " mm off the band", charms < 2 ? ""
                 : str(", closest pair ", charm_sep * pitch, " mm apart")));

// ------------------------------------------------------------------ modules
module rrect(s) offset(r = corner_r)
    square([s[0] - 2*corner_r, s[1] - 2*corner_r], center = true);

// One bar: `body` along the band, the WHOLE band width across it. Flat on the
// bed, chamfered only at the top. This slab is what replaced a row of separate
// tiles once the cross-band hinges came out — there is nothing to articulate
// across the width, so the width is solid.
module bar_body() {
    hull() {
        linear_extrude(thick - ch_rise) rrect([body, band_w]);
        translate([0, 0, thick - 0.01])
            linear_extrude(0.01) rrect([body - 2*ch_run, band_w - 2*ch_run]);
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

// A column of the band: the bar, plus its share of the two joints beside it.
// The joint is spread into `rows` knuckle clusters along the bar — one at each
// old tile centre — so a wide band is held by several knuckles rather than
// one, and the bar cannot twist about a single pin.
module bar(col) {
    translate([col*pitch, band_cy, 0]) bar_body();
    for (row = [0 : rows - 1])
        translate([col*pitch, row*row_pitch, 0]) {
            if (col > 0)        blade();
            if (col < cols - 1) fork();
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

// A charm station: the ball pin, standing on the flat top of bar `col`, on the
// band's centreline. Sunk `charm_sink` into the bar so the two solids genuinely
// merge rather than meeting on a coincident face.
module charm_station(col) {
    translate([col*pitch, band_cy, thick]) charm_pin();
}

module bracelet() {
    for (c = [0:cols-1]) bar(c);
    for (c = charm_ix) charm_station(c);
    clasp_stud();
    clasp_keyhole();
}

bracelet();
