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

// The H-pin every charm snaps onto, and the pocket it snaps into. Variables and
// modules only — including it draws nothing. Everything it defines is named
// `hp_*`, so nothing in it shadows the HINGE pin's `pin_d` / `pin_z`.
include <../../lib/charm-pin.scad>

// ------------------------------------------------------------------- sizing
wrist   = 130;   // wrist circumference in mm. 130 is the 4-year-old this was
                 //   printed for and fits (2026-09-14); 180 adult, 140 child.
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
post_d    = 4.0;    // the post — the clasp's whole load path, and the one part
                    //   of it that can snap off. It was 3.0 and was fragile:
                    //   it prints standing up, so it breaks along a layer
                    //   line, and bending strength goes as d^3 — 4.0 is 2.4x.
slot_fit  = 0.15;                  // radial play of the post in the slot, the
                                   //   printed value: the post has to SLIDE here
slot_w    = post_d + 2*slot_fit;   // 4.3
head_lip  = 1.05;                  // how far the head overhangs the slot each
                                   //   side — what holds it. The printed value.
head_d    = slot_w + 2*head_lip;   // 6.4
head_h    = 1.5;                   // cone up to head_d. The underside of the
                                   //   head is therefore at atan(1.2/1.5) =
                                   //   38.7 deg from vertical: self-supporting,
                                   //   no support under the head.
head_slope = (head_d - post_d)/2 / head_h;   // radial growth per mm of rise
// HOW TIGHT THE CLASP SITS, UP AND DOWN. The head's underside is a cone, so
// what the keyhole plate lifts into is not the post's top but the height where
// that cone grows out to the SLOT EDGE. The printed clasp put the cylinder
// top a full `fit` over the plates, and the cone then reached the slot edge
// 0.49 mm above them — that much rattle. Now the gap is set AT THE SLOT EDGE,
// with the post centred: 0.15, a hair under the 0.2 a sagging ceiling would
// want, which is fine because this ceiling is a 38.7-degree cone, not a flat
// bridge. Pull the post against the slot's side — which the band's tension
// does, against the seat's far wall — and the cone meets the edge right at the
// plate's top face: under load the head clamps the two plates together.
head_gap  = 0.15;
post_top  = 2*cl_t + head_gap - slot_fit/head_slope;   // 3.16 — top of the
                                   //   parallel post. It ends just BELOW the
                                   //   top of the stacked plates, on purpose.
entry_d   = head_d + 0.6;          // 7.0 — the hole the head drops through
det_pinch = 0.15;                  // how far each bump stands into the post's
det_gap   = post_d - 2*det_pinch;  //   path: 3.7. The printed value.
det_r     = 0.5;
leaf_w    = 1.0;                   // Each detent bump sits on a SPRING LEAF —
rel_w     = 0.8;                   //   a strip of plate freed by a relief slot
leaf_free = 2.8;                   //   beside the main slot. Without it the
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
                                   //   a jam.
                                   //
                                   //   FIRMER THAN THE PRINTED ONE, AT THE SAME
                                   //   STRAIN. The leaf's root strain is
                                   //   3*(w/2)*pinch/L^2 and its force goes as
                                   //   w^3*pinch/L^3. The printed leaf (0.8 x
                                   //   2.5) ran at 2.88% and survived; this one
                                   //   (1.0 x 2.8) runs at 2.87% and pushes
                                   //   back 1.39x as hard. A deeper pinch was
                                   //   the other way to firm it up, and it
                                   //   would have taken the leaf past the
                                   //   strain it is proven at.
                                   //   leaf_w is a FLEXURE, and is meant to be
                                   //   under the 1.2 mm wall threshold.
leaf_strain = 3*(leaf_w/2)*det_pinch / (leaf_free*leaf_free);
det_y     = det_gap/2 + det_r;     // a bump's centre, off the slot's axis
// seat -> detent, along the slot. NOT a free choice any more: the bumps CRADLE
// the seated post. With the post pulled against the seat's far wall, they
// just touch its back — so the post cannot rattle along the slot at all. The
// printed clasp set them 1.8 mm out and the seated post had ~0.6 mm to wander.
det_off   = sqrt(pow(post_d/2 + det_r, 2) - det_y*det_y) - slot_fit;   // 0.70
rail_w    = 1.25;                  // plate outboard of each relief — the two
                                   //   rails carry the whole clasp load to the
                                   //   yoke. The printed value.
kh_w      = 2*(slot_w/2 + leaf_w + rel_w + rail_w);   // 10.4
tip_strip = 2.0;                   // full-width plate left beyond the reliefs'
                                   //   ends. The seat's far wall hangs off this
                                   //   strip and the post pulls against it, so
                                   //   it carries the entire clasp load.
kh_tip    = leaf_free - det_off + rel_w/2 + tip_strip;   // seat -> plate tip
kh_wall   = 1.0;                   // plate between the entry hole and the bar
stud_pw   = 8.0;
stud_tip  = post_d/2 + 2.0;
yoke_len  = 3.0;                   // how far a yoke stands off the end column
yoke_bite = 1.4;                   // how far it reaches INTO it, so it unions

assert(head_d > slot_w + 1.5, "head can pull back through the slot");
assert(det_gap < post_d, "detent does not actually pinch the post");
assert(entry_d > head_d, "head will not pass through the entry hole");
// The post itself has to pass through the slot with the plates stacked: at the
// keyhole plate's top face the cone must still be inside the slot.
assert(post_d/2 + (2*cl_t - post_top)*head_slope < slot_w/2,
       "the head's cone starts inside the slot and jams the post");
assert(post_top + (slot_fit/head_slope) > 2*cl_t,
       "the head bears on the plate below its top face — the clasp cannot close");
assert(slot_w > post_d, "post cannot slide along the slot at all");
assert(kh_w/2 - (slot_w/2 + leaf_w + rel_w) >= 1.0,
       str("relief slot leaves too little plate outboard: ",
           kh_w/2 - (slot_w/2 + leaf_w + rel_w)));
assert(det_r > (post_d - det_gap)/2, "detent bump too small to pinch");
assert(leaf_strain <= 0.029,
       str("detent leaf strained to ", 100*leaf_strain,
           "% — past the 2.88% the printed leaf was proven at"));
// The seat's far wall, directly behind the post, must stay at least as thick
// as the printed clasp's (1.8).
assert(kh_tip - slot_w/2 >= 1.8,
       str("only ", kh_tip - slot_w/2, " mm of wall behind the seat"));
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
assert(norm([x_entry - x_det, det_y]) >= entry_d/2 + det_r + 0.1,
       str("the entry hole is eating the detent bumps: centres ",
           norm([x_entry - x_det, det_y]), " apart, need ",
           entry_d/2 + det_r + 0.1));
// Fastening, the head drops through the entry hole while the band's ends are
// `kh_travel` closer together than they are once clasped, and the keyhole
// plate's tip is then that much nearer the stud's end bar. It has to come
// down BESIDE that bar, not onto it. The printed clasp overran it by 0.95 mm
// and had to be tilted in; `stud_ext` is now derived so it never does.
assert(stud_ext - (kh_lock - kh_entry) - kh_tip >= -1e-9,
       str("the keyhole plate's tip lands on the stud's end bar while fastening, by ",
           (kh_lock - kh_entry) + kh_tip - stud_ext, " mm"));

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
//
// AND THE BUCKLE ITSELF IS NOW CUT TO THE BONE. Clasped, it is a rigid flat
// run from one end bar to the other, `stud_ext + kh_lock` long, and every term
// in it is now a constraint rather than a round number:
//
//   kh_entry  the entry hole, `kh_wall` off the bar. It used to stand a whole
//             `yoke_len` + 1 mm off it — 3 mm of plate doing nothing.
//   travel    entry -> seat: the least that keeps the entry hole off the
//             detent bumps. Short, because the bumps now cradle the seated
//             post instead of standing 1.8 mm out from it.
//   stud_ext  post -> stud's end bar: the least that lets the keyhole plate's
//             tip come down beside that bar while the head drops through the
//             entry hole (see the assert above). It used to be a flat 8.0 —
//             more than needed, and still 0.95 mm short of that.
//
// Travel appears twice — once in each plate — which is why shortening it is
// what shortens the buckle.
kh_entry = kh_wall + entry_d/2;        // first bar's face -> entry hole, 4.5
// Shortest usable slot: the seated post has to sit far enough from the entry
// hole that the hole does not reach the detent bumps (see the assert above).
kh_travel_min = det_off + sqrt(pow(entry_d/2 + det_r + 0.15, 2) - det_y*det_y);
kh_lock  = kh_entry + kh_travel_min;   // 8.6, at every size
stud_ext = kh_travel_min + kh_tip;     // last bar's face -> post axis, 8.6

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
// OPTIONAL. `charms` bars along the band get a POCKET sunk into their top face.
// A loose H-shaped pin (models/pin) snaps down into it with the hooks
// on its lower legs, its crossbar sinks just under the bar's top, and the
// charm (models/butterfly-charm) snaps onto the upper legs. See the lib. Leave
// it at 0 and the bracelet is exactly the plain band.
charms      = 0;     // how many charm stations. 0 = none.
charm_reach = 16;    // the widest charm this spacing has to keep apart —
                     //   models/butterfly-charm spans 15.8 mm along the band.

function charm_col(i) = round((i + 1) * (cols - 1) / (charms + 1));
charm_ix    = [for (i = [0 : charms - 1]) charm_col(i)];

// Spacing is checked on the SMALLEST gap between consecutive stations, not on
// the average. Rounding station indices to whole bars makes the gaps uneven,
// and the average happily passes a pair that lands one bar apart.
charm_sep   = charms < 2 ? cols
            : min([for (i = [0 : charms - 2]) charm_ix[i+1] - charm_ix[i]]);
assert(charms == 0 || charm_sep * pitch >= charm_reach,
       "two charms would land closer together than a charm is wide — lower `charms`");

// ------------------------------------------------------ the two-colour stripe
// OPTIONAL. `accent = true` cuts the whole bracelet at two heights into TWO
// objects — the slab between `accent_lo` and `accent_hi`, and everything above
// and below it — so a multi-material printer can print the middle of the band
// in a second colour. The geometry is untouched: the two objects together are
// exactly the plain bracelet. Export it as 3MF WITH LAZY UNION, or OpenSCAD
// fuses them back into one:
//   openscad --enable=lazy-union -D accent=true -o ....3mf bracelet.scad
// A horizontal slab costs the printer exactly TWO filament swaps per print.
accent       = false;
accent_lo    = 1.8;       // both on a 0.2 layer boundary, and off every
accent_hi    = 3.2;       //   feature plane of the band (see CLAUDE.md §3)
base_color   = "white";   // only a hint for the slicer's preview — the
accent_color = "hotpink"; //   filament is chosen per object when slicing

// The clasp plates (0 .. cl_t) stay one colour: a slab starting inside them
// would leave a skin of accent a layer thick on their top faces.
assert(accent_lo >= cl_t + 0.2 && accent_hi > accent_lo && accent_hi < thick,
       "the stripe must start above the clasp plates and end inside the band");
assert(charms == 0 || (charm_ix[0] >= 1 && charm_ix[charms-1] <= cols - 2),
       "a charm landed on an end bar, where the clasp yoke is");

// The H-pin's pocket runs ACROSS the bar: `hp_slot_x` of the 6.0 mm along the
// band, the rest left as wall either side; the full chamber width across it,
// well inside the band's width; and `hp_floor` of bar under it, so the first
// layer never sees it. It stays inside |x| < h - 1.0 too, where the knuckle
// arms begin, so it cuts nothing but plain bar.
hp_wall_bar = (body - hp_slot_x) / 2;                   // 1.45
assert(hp_bar == thick,
       str("the H-pin's pocket is drawn for a ", hp_bar, " mm bar but a bar is ",
           thick, " thick"));
assert(hp_wall_bar - ch_run >= 0.85,
       str("only ", hp_wall_bar - ch_run, " mm of bar beside the pocket at the rim"));
assert(hp_slot_x/2 < h - 1.0,
       "the H-pin's pocket reaches the knuckle arms");
assert(band_w/2 - hp_out >= 2.0,
       str("only ", band_w/2 - hp_out, " mm of bar beyond the pocket's end"));

// A charm has a FLAT BOTTOM and it is wider than its bar, so it
// rests on whatever the band's top surface is out to its own radius. That is
// only safe because the band's top surface is a PLANE: `thick` is defined as
// `pin_z + rk`, so a knuckle cap's apex reaches exactly the height of a bar's
// top face and nothing on the band goes above it.
//
// Assert that rather than assume it. If `thick` and the cap's reach are ever
// decoupled — by raising `pin_z`, or by capping the knuckle differently — a
// charm would land on the crests and stand proud of its own bar, and the only
// symptom would be a charm that will not pull down tight.
knuck_top  = pin_z + rk;                                // == thick, by design
assert(knuck_top <= thick + 1e-9,
       str("a knuckle reaches ", knuck_top, " but a bar's top is ", thick,
           " — a flat-bottomed charm would sit on the hinge, not on its bar"));

// The charm still may not reach the neighbouring BAR, which is the part that
// actually moves. `charm_reach` is the charm's width, so half of it is how far
// it hangs over, and the gap to the next bar's face is `pitch - body`.
assert(charms == 0 || charm_reach/2 <= (pitch_min - body) + body/2,
       str("a ", charm_reach, " mm charm overhangs past the neighbouring bar's",
           " face at pitch_min — it would jam the joint"));

// A pocket adds no height at all — it is a hole — so the stud sets it.
top_z       = post_top + head_h;

echo(str("cols=", cols, " rows=", rows,
         "  loop=", band_run + stud_ext + kh_lock,
         "  pitch=", pitch, " (gap ", pitch - body, ")",
         "  keyhole travel=", kh_lock - kh_entry,
         "  buckle clasped=", stud_ext + kh_lock,
         "  post d", post_d, " head d", head_d,
         "  leaf strain=", 100*leaf_strain, "%",
         "  footprint=", (x_stud + stud_tip) - (x_lock - kh_tip),
                    " x ", band_w, " x ", top_z,
         "  band thick=", thick,
         "  knuckle cap at bed=", knuck_foot,
         "  knuckle underside=", knuck_slope, "deg",
         "  pin first layer=", pin_flat_w));
if (charms > 0)
    echo(str(charms, " H-pin pocket(s) in bar(s) ", charm_ix, " of ", cols,
             " — ", hp_slot_x, " x ", 2*hp_out, " x ", hp_bar - hp_floor,
             " deep, wall ", hp_wall_bar, " along the band, floor ", hp_floor,
             charms < 2 ? ""
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
    //
    // Each relief then TURNS IN, radially, to the entry hole's centre. At the
    // 4 mm post it runs `slot_w/2 + leaf_w + rel_w/2` = 3.55 off the axis and
    // the hole is only 3.5 in radius, so a straight relief merely grazes the
    // hole and leaves a 0.02 mm cusp of rail between the two. Turned radially,
    // it crosses the hole's edge square.
    for (s = [-1, 1]) {
        p_end = [x_entry + 1.0, band_cy + s*(slot_w/2 + leaf_w + rel_w/2)];
        hull() {
            translate([x_det - leaf_free, p_end[1]]) circle(d = rel_w);
            translate(p_end) circle(d = rel_w);
        }
        hull() {
            translate(p_end) circle(d = rel_w);
            translate([x_entry, band_cy]) circle(d = rel_w);
        }
    }
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

// An H-pin station: the pocket, cut down from bar `col`'s top face, running
// across the band.
module charm_h_station(col) {
    translate([col*pitch, band_cy, thick]) charm_h_pocket();
}

// With no charms the band is written out in full, NOT wrapped in the
// difference() the pockets need: at `charms = 0` its export has to stay
// byte-for-byte the file the printed bracelet was cut from.
module bracelet() {
    if (charms > 0)
        difference() {
            union() {
                for (c = [0:cols-1]) bar(c);
                clasp_stud();
                clasp_keyhole();
            }
            for (c = charm_ix) charm_h_station(c);
        }
    else {
        for (c = [0:cols-1]) bar(c);
        clasp_stud();
        clasp_keyhole();
    }
}

// The slab the accent colour fills, far wider than any bracelet.
module accent_slab()
    translate([-1000, -1000, accent_lo]) cube([2000, 2000, accent_hi - accent_lo]);

// `accent` off writes `bracelet()` alone, so the plain export stays
// byte-for-byte what it was.
if (accent) {
    color(base_color)   difference()   { bracelet(); accent_slab(); }
    color(accent_color) intersection() { bracelet(); accent_slab(); }
} else
    bracelet();
