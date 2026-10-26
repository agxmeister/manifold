// bracelet — a bracelet made of PRINTED 3D FABRIC: a row of rigid bars
// joined by print-in-place HINGES. It comes off the bed as a band that rolls
// up around a wrist, and nothing is assembled or glued.
//
// IT HINGES IN ONE AXIS ONLY, and that is deliberate. The band used to be a
// GRID of tiles, hinged along its length AND across its width. The cross-band
// hinges never worked: with `rows` = 2 the only one of them runs straight down
// the middle of the band, end to end — and both clasp yokes were solid plates
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

// The CONE PIN every charm hangs on, the hole, countersink and rib it needs
// in a bar. Variables and modules only — including it draws nothing.
// Everything in it is named `cn_*`, so nothing shadows the HINGE pin's
// `pin_d` / `pin_z`.
include <../../lib/charm-cone.scad>
// The buckle's lock screw (`buckle = "screw"`): the screw's thread and size,
// which the socket's threaded hole must match. Named `sk_*`.
include <../../lib/lock-screw.scad>

// ------------------------------------------------------------------- sizing
wrist   = 130;   // wrist circumference in mm. 130 is the 4-year-old this was
                 //   printed for and fits (2026-09-14); 180 adult, 140 child.
ease    =  12;   // slack on top of the wrist, so the band hangs rather than
                 //   grips. EXACT, not approximate: the fabric quantises to
                 //   whole columns of `pitch`, and the remainder is spread
                 //   over the joints (see `pitch`, below).

rows    =   2;   // how many tile-widths wide the band is. It no longer means
                 //   a row of separate tiles — a column is a single bar — but
                 //   it still sets the width AND the number of hinge knuckle
                 //   clusters spaced along each joint. 2 -> a 16.2 mm band.

// --------------------------------------------------------------------- bars
pitch_nom = 11.6;         // what bar spacing WANTS to be. The spacing actually
                          //   used is solved for in the length budget below,
                          //   within a millimetre of this — see `pitch`.
body      =  6.0;         // the bar slab, along the band. Also the width of
                          //   one hinge knuckle cluster, across it.
h         = body/2;       // 3.0
row_pitch = 10.2;         // spacing of the knuckle clusters ACROSS the band.
                          //   Deliberately NOT `pitch`: the band's width must
                          //   not change when the length solver breathes the
                          //   joints, so this one is fixed. It was 11.6 (a
                          //   17.6 band); 10.2 (2026-09-26) was the narrowest
                          //   the old H-pin pocket allowed.
corner_r  =  1.0;         // plan-view corner radius of a bar

ch_run    = 0.5;          // TOP chamfer only. The bottom stays flat and full
ch_rise   = 0.6;          //   size — articulation here comes from the hinge,
                          //   not from clearing the bars' edges past each
                          //   other, so there is no reason to spend bed
                          //   contact on a bottom chamfer.

// -------------------------------------------------------------------- hinge
fit        = 0.3;               // general clearance: the knuckle against the
                                //   neighbour's body as it swings, and the
                                //   clasp's face gap. Well clear of the bed.
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
pin_d      = 1.8;               // the pin — the entire load path of the band.
                                //   It was 2.0, printed and confirmed; 1.8
                                //   (2026-09-25) is what brings `thick` down
                                //   to 4.2 so the accent stripe can split the
                                //   band into three equal 1.4 mm bands.
                                //   Bending strength goes as d^3: 0.73x.
pin_r      = pin_d/2;
bore_r     = pin_r + bore_fit;  // 1.35
knuck_wall = 0.9;               // material around the bore
rk         = bore_r + knuck_wall;   // 2.25 — the knuckle's outer radius, and
                                    //   the radius everything sweeps through
                                    //   when the hinge turns
pin_z      = 1.95;              // pin axis height. NOT free: see the two
                                //   asserts below — it is squeezed between
                                //   needing floor under the bore and needing
                                //   the knuckle to reach the bed. 1.95 leaves
                                //   exactly the 0.6 mm floor the assert asks.
thick      = pin_z + rk;        // 4.2 — the knuckle's top IS the band's top

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
assert(pin_z - bore_r >= 0.6 - 1e-9,
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
// A ROUND KNOB in a NICHE (the user's design and sketch, 2026-10-20): the
// knob drops into a roomy round WAY-IN at the back of the socket's hole and
// is pulled forward ~2 mm into the NICHE in front, whose lips hold its front.
// Two CLICKS on the knob's sides stop it sliding back.
//
//   top, fastened
//     last bar          socket block (+ bar 0)
//   ────────┐       ┌────────────────────────┐
//           │       │  ▒▒▒  ┌─---------.      │   ▒ lips over the knob's front,
//           │       └─┐▒  / │            \     │     both sides of the neck, out
//      ═════╪═════════> ( knob   way in   )    │     to a straight STEP across
//           │       ┌─┘▒  \ │            /     │     the band at `tb_lip_end`
//           │       │  ▒▒▒  └─---------'      │
//   ────────┘       └────────────────────────┘
//                   niche step
//
//   * The last bar ends in a NECK and a round KNOB `tb_r`, the band's full
//     thickness, flush on top and underneath.
//   * Bar 0 is lengthened into a SOCKET BLOCK with the hole cut through it,
//     open top and bottom. In front, the NICHE: the knob's circle, its LIPS
//     overhanging the knob's edge at the top and the bottom from the neck back
//     to the STEP. At home the lips' faces and the knob's insets touch as
//     a V (the WEDGE SEAT): pressed in by the bumps, it has no play. Behind
//     the step, the WAY-IN: the knob swept
//     from home to where it drops in, `tb_drop_fit` round them. The block's
//     side walls are solid.
//   * CLICKS (the user's request, 2026-10-20): since 2026-10-23 the knob is
//     solid and the SPRINGS are in the block: a straight LEAF in each side
//     wall of the way-in, with a BUMP on it. Pulled home, the bump rides up a
//     gentle LEAD-IN on the knob's side and drops behind its crest into a
//     NOTCH, against a steep CATCH face. Easy to close, hard to open.
//   * To close: push the ends together, drop the knob into the way-in, pull it
//     forward into the niche — it clicks. The band's pull keeps it there.
//   * To open: push the ends together firmly (past the click; `tb_slide`, ~2.4,
//     the seam's width), push the knob out downwards.
//
// A push spring was ruled out: it would bend `tb_slide` + preload, ~2.3, and
// on an 8 mm knob its leaves are ~4 mm long (15–20 %; the dovetail's broke
// at 8.5 %). A click only bends `cl_h`.
//
// Nothing is cantilevered into air: the knob and the lips stand on the bed;
// the upper lips are an overhang `tb_lip` deep, stepping under a bead a layer.
tb_neck    = 3.5;     // neck width (thin, as in the user's sketch: a 4.5 neck on an
                      //   8 mm knob left the lips beside it too short)
tb_side    = 1.4;     // the block's side walls, at their thinnest
tb_sh      = 1.6;     // the block's front wall, beside the neck
tb_r       = 4.0;     // the knob's radius (8 across, the user's choice)
tb_lip_end = 80;      // the STEP: where the lips end, as an angle on the
                      //   knob's edge from the band's axis. The step itself is
                      //   a straight line across the band. Was 75: printed
                      //   (2026-10-23), the lips were too short to hold; 85
                      //   needed the hooks to reach 1.76 to the knob's back
tb_lip     = 1.1;     // how far a lip overhangs the knob's edge
tb_lip_a   = 60;      // lip faces, from vertical. Steeper than 45 on purpose:
                      //   pushed up or down, a face cams the knob sideways
                      //   by tan(90 - a) of the push — 1.0 at 45, 0.58 at 60.
                      //   A layer steps 0.35, under a bead (asserted).
tb_lip_h   = tb_lip / tan(tb_lip_a);         // 0.64 — the lip face's height
tb_land    = 0.4;     // a vertical land at the lip's tip, two layers: without
                      //   it the tip is a 30-degree knife edge
tb_fit     = 0.15;    // vertical walls round the neck
// The WEDGE SEAT (2026-10-22): at home the knob's shaped edge sits in the
// lips' V, top and bottom faces touching, and the bumps press it in. The V
// takes up the play and any printed droop: it just seats a hair further back.
tb_vfit    = 0.0;     // across the lip faces at home: they touch
tb_wfit    = 0.3;     // the niche's wall round the knob's rim: more than
                      //   `tb_vfit`, so the V seats before the wall stops it
tb_tfit    = 0.3;     // a lip's tip <-> the knob's inset under it (the old
                      //   face fit, printed): the tips must never seat first
tb_clear   = 0.2;     // knob pulled back -> the lips' tips; the knob's
                      //   shaped edge past the step
tb_drop_fit = 0.25;   // the way-in, round the knob as it drops
                      //   in and slides home. It was a circle 1.4 wider than
                      //   the knob all round: printed (2026-10-21), the hole
                      //   was much too big — the knob sat in a ~3.3 crescent

// The clicks (`cl_*`), in the knob's own frame: x' back from its centre, y
// out to the +y side; mirrored. The knob is a circle with, on each side
// behind the step, a RECESS (where the bump stands while the knob drops in),
// a LEAD-IN rising at `cl_psi` to a CREST C behind the widest point, and the
// CATCH falling at `cl_catch` into a NOTCH, where the bump sits at home,
// pressing the catch so the knob is held forward in its V.
//   Why the springs left the knob (2026-10-23): a leaf on a round knob's rim
// bends in and FORWARD whichever end it is rooted at, which is the way a
// tooth pushes it when the knob is pulled out, so opening came easy. A
// straight leaf in the wall bends straight out, and the faces alone set the
// effort: ~tan(angle + friction), so ~0.8 to close (25°) and ~4 to open
// (60°) times the leaf's force. The catch locks for good from ~70°.
cl_h       = 0.65;    // how far the bump pushes its leaf out passing the crest.
                      //   Was 0.4 with `cl_pre` 0.15: printed (2026-10-23),
                      //   the bumps did not touch the knob at all; 0.7 with
                      //   0.35 printed (2026-10-24): they pressed it so hard
                      //   closed that the buckle bent
cl_xc      = 1.9;     // the crest, behind the knob's centre: on its back half,
                      //   since the knob drops out ~2.1 back and the bump
                      //   must then stand behind the lipped front
cl_catch   = 60;      // the catch face, from the band's axis
cl_rb      = 0.4;     // the bump's rounded tip
cl_pre     = -0.1;    // the bump into the catch at home. Negative: a GAP, so
                      //   the knob seats freely. 0.35 and 0.2 printed
                      //   (2026-10-24): the bumps pressed the knob forward
                      //   and bent the buckle. The band's pull holds it home;
                      //   the bumps only stop it sliding back
cl_dc      = 0.15;    // the bump clear of the knob where the knob drops in
cl_t       = 0.8;     // the wall leaf
cl_slot    = 0.85;    // behind it: room to bend `cl_h`, and >= 0.2 more
cl_gap     = 0.6;     // the slot's mouth into the way-in, at the leaf's tip
cl_wr      = 0.8;     // the way-in's back corners
cl_ext     = 1.3;     // the leaf runs on past the way-in's back corner, freed
                      //   by a slit `cl_slit` inside it: the click's on the
                      //   knob's back half, so the leaf needs the length
cl_slit    = 0.6;
tb_far     = 3.0;     // bar 0 behind the slot's far end, to its +x face:
                      //   the slot must stop short of bar 0's lug arms. Was
                      //   1.44: printed (2026-10-23), that wall bent closing

tb_band_w  = (rows - 1) * row_pitch + body;  // = band_w, which comes later
tb_overlap = tb_lip - tb_vfit - tb_tfit;     // a lip's tip over the knob's edge
// The step, ahead of the knob's centre, and the lips' last tip on it.
tb_step    = tb_r * cos(tb_lip_end);
tb_tip_y   = sqrt(pow(tb_r - tb_overlap, 2) - tb_step*tb_step);
// The pull: that tip, the worst point, ends up `tb_clear` outside the knob
// moved back by it.
tb_slide   = sqrt(pow(tb_r + tb_clear, 2) - tb_tip_y*tb_tip_y) - tb_step;
face_gap   = tb_slide + 0.1;                 // the seam when fastened

// Positions along the band, from the block's front face, fastened, home.
tb_ua      = tb_sh + tb_wfit;                // knob front
tb_uc      = tb_ua + tb_r;                   // knob centre: the lips end here
tb_ustep   = tb_uc - tb_step;                // the step
tb_ue      = tb_uc + tb_slide;               // the way-in's centre
tb_uend    = tb_ue + tb_r + tb_drop_fit;     // the hole's far end
// The clicks. The crest, the bump's centre at home (`cl_s` down the catch
// from C, `cl_rb - cl_pre` out of it) and where the knob drops in.
cl_wy      = tb_r + tb_drop_fit;              // the way-in's side walls
cl_c       = [cl_xc, sqrt(tb_r*tb_r - cl_xc*cl_xc)];
cl_yb      = cl_c[1] - cl_h + cl_rb;
cl_s       = (cl_h - cl_rb + (cl_rb - cl_pre) * cos(cl_catch)) / sin(cl_catch);
cl_xb      = cl_xc + cl_s * cos(cl_catch) + (cl_rb - cl_pre) * sin(cl_catch);
cl_bd      = [cl_xb - tb_slide, cl_yb];       // the bump where the knob drops in
// The lead-in's slope, solved: there the bump stands `cl_rb + cl_dc` off it.
cl_A       = cl_xc - cl_bd[0];
cl_C       = cl_yb - cl_c[1];
cl_psi     = asin((cl_rb + cl_dc) / norm([cl_A, cl_C])) - atan2(cl_C, cl_A);
function cl_yl(x) = cl_c[1] - (cl_xc - x) * tan(cl_psi);
cl_x0      = -tb_step + tb_clear;             // the recess starts: the knob's
                                              //   lip shaping ends here
cl_yn      = cl_yb - cl_rb - 0.15;            // the notch's floor
cl_f       = [cl_xc + (cl_c[1] - cl_yn) / tan(cl_catch), cl_yn];  // catch's foot
// The leaf: free tip just in front of the bump, root where the way-in's
// back corner begins. Straight-beam strain at the bump.
cl_tip     = cl_xb - 0.7;
cl_back    = tb_slide + tb_r + tb_drop_fit - cl_wr;  // the way-in's back corners
cl_root    = cl_back + cl_ext;
cl_uslot   = tb_uc + cl_root + cl_slot/2;     // the slots' far end
cl_strain  = 1.5 * cl_t * cl_h / pow(cl_root - cl_xb, 2) * 100;
function tb_pol(a, r) = [tb_uc - r*cos(a), r*sin(a)];
tb_tipd    = tb_wfit + tb_overlap;           // a lip's reach past its wall
// The lip's face is the knob's face moved out `tb_vfit`; its tip stops
// `tb_tfit` short of the knob's inset, so the tip's land is that much taller.
tb_tip_z   = tb_land + tb_tfit * tan(90 - tb_lip_a);
tb_zlip    = tb_tip_z + tb_tipd * tan(90 - tb_lip_a);  // where a lip face
                                             //   meets its wall

assert(0.2 * tan(tb_lip_a) <= 0.4, "the lips step more than a bead a layer");
assert(tb_vfit >= 0 && tb_wfit >= tb_vfit + 0.2,
       "the knob's rim meets the niche's wall before the V seats");
assert(tb_tfit >= 0.2, "the lips' tips seat on the knob's insets before the faces");
assert(2*tb_zlip < thick - 1.5, "the lips leave too little wall face");
assert(tb_band_w/2 - (tb_r + tb_drop_fit) >= tb_side,
       "the block's side walls are too thin");
assert(tb_tip_y - (tb_neck/2 + tb_fit) >= 0.7,
       "the lips beside the neck are too short to hold");
assert(tb_step > 0, "the step must be ahead of the knob's centre");
assert(cl_psi > 10 && cl_psi < 35, str("the lead-in's slope ", cl_psi, " is off"));
assert(cl_catch <= 65, "the catch is near self-locking: the knob would never come out");
assert(cl_s > 0.05 && cl_c[1] - cl_s * sin(cl_catch) > cl_yn + 0.1,
       "the bump meets the catch off its face");
assert(cl_yl(cl_x0) >= cl_yn - 0.8, "the recess cuts deep into the knob");
// Where the knob drops in, the bump is clear of the knob's front corner too.
// (The whole front: the full circle ahead of `cl_x0`, not just its corner.)
cl_drop_c  = (cl_bd[0] <= cl_x0 ? norm(cl_bd) - tb_r
              : norm(cl_bd - [cl_x0, min(cl_bd[1], sqrt(tb_r*tb_r - cl_x0*cl_x0))])) - cl_rb;
assert(cl_drop_c >= 0.1, str("the bump meets the knob's front where it drops out: ", cl_drop_c));
// At home, the notch's floor clears the bump: the floor is cut straight back
// past the knob's end, so nothing behind it stands higher.
assert(cl_yb - cl_rb - cl_yn >= 0.1, "the bump rests on the knob behind the notch");
assert(cl_tip - cl_gap >= 0, "the leaf's mouth runs off the way-in's straight wall");
assert(cl_slot >= cl_h + 0.2 - 1e-9, "the leaf bottoms out in its slot");
assert(tb_band_w/2 - (cl_wy + cl_t + cl_slot) >= tb_side,
       "the wall outside the leaf is too thin");
// ~4.3 % (the long teeth printed fine at ~7 %).
assert(cl_strain <= 7, str("the leaves strain ", cl_strain, " %"));
assert(h - tb_far <= 1.6,
       str("the slot reaches x ", h - tb_far, " of bar 0, into its lug arms"));

// ------------------------------------- the ROOFED niche (`buckle = "screw"`)
// The lock-screw buckle's niche (the user's alternative, 2026-10-25; the
// lipped niche above stays the default). Knob, neck, way-in and block are the
// lipped buckle's, less the clicks (the screw locks it, below); the niche:
//
//   section through the knob's front, fastened
//                 roof
//     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓──────┐  step
//     ▓▓▓  ┌────────────────────────┐   │
//     ▓▓▓  │     knob, front half    │   │  back half: full height,
//     ▓▓▓▓  \                      /    │
//     ▓▓▓▓▓▓ \____________________/     │
//     ▓▓▓▓▓▓▓|                    |     │
//    ─────────────────────────────────────── bed
//      lower lip (DOVETAIL)
//
//   * A ROOF over the block's front end, from its front face to the step:
//     it covers the knob's front half, and the neck's way in, as a tunnel.
//     The knob's front half and the neck are `dv_h` tall to pass under it;
//     the back half stays the band's full height, flush with it in the
//     way-in.
//   * A DOVETAIL instead of the V: the knob's front edge WIDENS TO THE TOP,
//     at `dv_a` from vertical, over the niche's lower lip, which reaches in
//     `tb_lip` under it, as before. No upper lip: the roof is the stop.
//     The band's pull wedges the knob out along that face, so up into the
//     roof: it seats between lip and roof without play.
//   * To close: push the ends together, push the knob UP into the way-in
//     from BELOW (the roof is over its front), pull it forward, screw the
//     lock out. To open: screw it in, push together, push the knob out
//     downwards.
//
// The lip's reach is the V's (`tb_lip`, `tb_tfit`, `tb_vfit`, `tb_wfit`),
// so the pull is unchanged.
// (A `buckle = "roof"` WITH the clicks and no screw existed for a day; the
// user kept only the two buckles, 2026-10-26.)
// Printed lying, no support: the knob's flaring face is a `dv_a` overhang,
// the lip's face looks up, and the roof bridges the niche across the band,
// anchored on its walls both sides.
buckle  = "lips";     // "lips": the V-lipped niche, held by clicks;
                      //   "screw": the roofed dovetail locked by a screw (below)
dv_roof = 1.2;        // the roof
dv_rfit = 0.25;       // the knob's top under the roof, while nothing pulls it
dv_a    = 40;         // the dovetail face, from vertical. On the knob it is an
                      //   overhang, so keep it inside 45.
dv_back = 0.2;        // the knob's full-height back half starts this much
                      //   further behind the roof's edge than `tb_clear`:
                      //   wedged up into the roof, the knob moves forward
dv_h    = thick - dv_roof - dv_rfit;          // 2.75 — the knob's front half
dv_ub   = tb_ustep + tb_clear + dv_back;      // where the back half starts
dv_lip_h = tb_lip / tan(dv_a);                // 1.31 — the face's height
// The socket's face is the knob's moved out `tb_vfit`; the lip's tip stops
// `tb_tfit` short of the knob's foot (as in the V, see `tb_tip_z`).
dv_tip_z = tb_land + tb_tfit / tan(dv_a);     // the lip tip's land
dv_zlip  = dv_tip_z + tb_tipd / tan(dv_a);    // where the face meets the wall

assert(buckle == "lips" || buckle == "screw", str("unknown buckle ", buckle));
assert(dv_a <= 40, "the knob's dovetail face is past 40 deg — it would droop");
assert(dv_roof >= 1.0, "the roof is too thin to hold the knob's wedge");
assert(dv_h - (tb_land + dv_lip_h) >= 0.6,
       "too little knob rim above the dovetail face");
assert(dv_zlip <= dv_h + dv_rfit - 0.4,
       "the niche's wall has no vertical rim left under the roof");
// Pulled, the knob climbs the face into the roof: `dv_rfit` up moves it
// out by rfit·tan(a). Its foot and rim must not meet the lip's tip or the
// wall first, or it seats on them instead of the face.
assert(dv_rfit * tan(dv_a) <= min(tb_tfit, tb_wfit - tb_vfit) - 0.05,
       "climbing into the roof, the knob meets the lip's tip or the wall");
assert(tb_clear + dv_back - dv_rfit * tan(dv_a) >= 0.15,
       "wedged into the roof, the knob's back half meets the roof's edge");

// -------------------------------------------- the LOCK SCREW (`buckle = "screw"`)
// The roofed niche above, without clicks (a plain round knob, solid way-in
// walls), locked by a separately printed SCREW along the band's middle, in the far
// wall (the user's sketch, 2026-10-25). Its thread, head and travel are in
// lib/lock-screw.scad; see there. Here, what the band does for it:
//   * the far wall is `sk_far` thick instead of `tb_far`: the thread runs in it;
//   * joint 0's two knuckle clusters are narrowed (`sk_lug`, `sk_blade`) and
//     pushed out to the band's edges, to open the gap between them for the
//     ribbed head (`sk_head_d`), which turns there.
// The cross bolt that came before it (same day) printed and failed: "parts
// are too small". Its nub, bridges and detent leaf were 0.5–0.6 thick.
sk_lug    = 1.2;      // joint 0's lugs (`lug_w` elsewhere, 1.4; asserted >= 1.2)
sk_blade  = 1.6;      // ... and its blade (`blade_w`, 2.0)
sk_head_fit = 0.4;    // the head <-> joint 0's knuckles, either side
sk_cw     = 2*sk_lug + sk_blade + 2*axial_fit;      // 5.2 — a narrowed cluster
sk_shift  = (body - sk_cw) / 2;                     // pushed out this far
sk_gap    = (row_pitch - body) + 2*(body - sk_cw);  // 5.8 — the gap for the head
// Locked, how far the knob can still go back before it meets the tip.
sk_play   = tb_slide + tb_drop_fit - sk_ext;

if (buckle == "screw") {
    assert(rows == 2, "the lock screw's head sits between joint 0's two clusters: rows must be 2");
    assert(sk_lug >= 1.2, "joint 0's lugs too narrow");
    assert(sk_gap >= sk_head_d + 2*sk_head_fit - 1e-9,
           str("the head (", sk_head_d, ") does not fit between joint 0's clusters (", sk_gap, ")"));
    assert(sk_play >= 0.3 && sk_play <= tb_slide - 1.2,
           str("locked, the knob's play ", sk_play, " must clear the tip and stop it well short of dropping out"));
    assert(sk_hole_maj <= thick - 2*0.5, "the screw's hole leaves too thin a skin over it");
}

// ------------------------------------------------------------ length budget
// Clasped, the loop runs: bar 0's +x face -> band -> last bar's +x face ->
// `face_gap` -> socket block -> bar 0. The block is fixed at every size; the
// BAND makes up the difference, as it did for the old buckle.
//
// The block is as short as the pocket allows: the pocket's far end stops
// `tb_far` short of bar 0's +x face, so it runs on into bar 0 itself, and the
// block reaches `blk_ext` past bar 0's -x face.
x_f       = buckle == "screw" ? (h - sk_far) - tb_uend      // the block's front face
                              : (h - tb_far) - max(tb_uend, cl_uslot);
blk_ext   = -h - x_f;

// Which leaves a remainder problem, so: the number of bars is chosen to land
// closest to `pitch_nom`, and then the joints are all stretched or squeezed
// equally — by a fraction of a millimetre each — so the loop still comes out
// exactly on wrist+ease. Nothing about a bar changes; only the gaps do, and
// they have about a millimetre of room between the knuckles binding and the
// band looking gappy.
band_run  = wrist + ease - face_gap - blk_ext;
// The knuckles bind below `pitch_min` — that is the swing clearance, the same
// limit that used to be asserted against a constant. Above `pitch_max` the
// gaps just look wrong; the range is what makes an exact fit reachable.
pitch_min = 2*(h + rk + fit);            // 11.10
pitch_max = pitch_min + 1.4;             // 12.50
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

// --------------------------------------------------------------- the charms
// OPTIONAL. `charms` bars along the band become STATIONS for the cone pin
// (models/cone-pin, lib/charm-cone.scad): a plain hole through the bar with a
// countersink under it, the +x gap beside the bar filled, and a half-round
// RIB across the bar's top that keys a charm's grooves. Leave it at 0 and the
// bracelet is exactly the plain band.
charms      = 0;     // how many charm stations, odd. 0 = none.
charm_reach = 16;    // the widest charm this spacing has to keep apart —
                     //   models/butterfly-charm spans 15.8 mm along the band.

charm_step  = 3;     // bars from one station to the next.

// One station on the MIDDLE bar, the rest paired off either side of it,
// `charm_step` bars apart — so `charms` is odd. Stations used to be spread
// evenly over the whole band, which on 11 bars put three charms on every
// second bar, [3, 5, 7]; now they are [2, 5, 8]. An even bar count has no
// middle bar, and the pattern then sits half a pitch towards the first end.
charm_mid   = floor((cols - 1) / 2);
charm_ix    = [for (i = [0 : charms - 1])
                   charm_mid + (i - (charms - 1) / 2) * charm_step];
assert(charms % 2 == 1 || charms == 0,
       "`charms` must be odd: one on the middle bar and pairs either side of it");

// Spacing is checked on the SMALLEST gap between consecutive stations. With a
// fixed step every gap is `charm_step`, but the check still guards the step.
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
accent_lo    = 1.4;       // both on a 0.2 layer boundary, and off every
accent_hi    = 2.8;       //   feature plane of the band (see CLAUDE.md §3):
                          //   three equal 1.4 mm bands of the 4.2 band
base_color   = "white";   // only a hint for the slicer's preview — the
accent_color = "hotpink"; //   filament is chosen per object when slicing

assert(accent_lo > 0 && accent_hi > accent_lo && accent_hi < thick,
       "the stripe must lie inside the band");
assert(charms == 0 || (charm_ix[0] >= 1 && charm_ix[charms-1] <= cols - 2),
       str("a charm landed on or past an end bar, where the clasp is — ",
           charms, " charms every ", charm_step, " bars need more than ",
           cols, " bars; lower `charms`"));

// A station is a plain hole through the bar with a
// countersink under it, `cn_off` towards +x of the bar's centre, and the
// +x gap between the bar's two fork lugs FILLED: a block across the gap with
// exactly the lugs' own knuckle profile (`charm_seat`), so it fuses into them
// and swings inside their envelope — it can reach nothing they do not. The
// -x gap is flanked by the NEIGHBOUR's lugs, which swing, so it stays open.
// The countersink is the widest thing and it is round:
//   * towards -x it is bounded by the bar's face;
//   * towards +x, past the bar's face, by the lugs' far faces (the
//     neighbour's blade is 0.6 beyond them), and by the knuckle's axis.
cn_gap_y    = (row_pitch - body)/2;                     // 2.10 — half the gap
cn_wall_bar = h - (cn_cs_r - cn_off);                   // 0.75 — the -x side
cn_chord    = sqrt(pow(cn_cs_r, 2) - pow(h - cn_off, 2));   // 2.76 at the +x face
assert(cn_bar == thick,
       str("the cone pin is drawn for a ", cn_bar, " mm bar but a bar is ",
           thick, " thick"));
assert(cn_wall_bar >= 0.7,
       str("only ", cn_wall_bar, " mm of bar beside the countersink, -x side"));
assert(cn_chord <= cn_gap_y + lug_w - 0.7,
       str("past the +x face the countersink is ", 2*cn_chord,
           " across — it cuts too far into the fork lugs"));
assert(cn_boss_y >= cn_gap_y + 0.3 && cn_boss_y <= cn_gap_y + lug_w - 0.4,
       "the fill must reach into the fork lugs, and stop inside them");
assert(cn_off + cn_cs_r + cn_wall <= pitch_min/2,
       "the countersink reaches past the knuckle's axis");
assert(-h + ch_run - (cn_off - cn_hole/2) <= -0.8,
       "the hole comes within 0.8 of the -x bevel's foot");
// The rib stands on the bar's flat top: inside the bevels' feet both ways.
assert(cn_off + cn_rib_r <= h - ch_run,
       "the rib runs onto the bar's +x bevel");
assert(cn_rib_out <= band_w/2 - ch_run - 0.3,
       "the rib's ends run onto the bar's bevels at the band's edges");

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

// The tallest thing: the band, or a station's rib.
top_z       = max(thick, charms > 0 ? thick + cn_rib_r : 0);

echo(str("cols=", cols, " rows=", rows,
         "  loop=", band_run + face_gap + blk_ext,
         "  pitch=", pitch, " (gap ", pitch - body, ")",
         "  buckle clasped=", body + face_gap + blk_ext + body,
         " (block ", blk_ext, " past bar 0)",
         "  knob r ", tb_r, ", step at ", tb_lip_end, "deg, way-in fit ", tb_drop_fit, ", neck ", tb_neck,
         "  wall leaves ", cl_t, " x ", cl_root - cl_tip, ", click ", cl_h,
                    ", lead-in ", cl_psi, "deg, catch ", cl_catch, "deg, strain ",
                    cl_strain, "%",
         buckle != "lips"
             ? str(" LOCK SCREW ", sk_maj, " x ", sk_pitch, ", head ", sk_head_d,
                   ", travel ", sk_travel, " (", sk_turns, " turns), knob play locked ",
                   sk_play, ", far wall ", sk_far, ", joint 0 gap ", sk_gap, ";",
                   " ROOF ", dv_roof, " over the front half, knob front ", dv_h,
                   " tall, dovetail ", tb_lip, " at ", dv_a, "deg")
             : str(" lips ", tb_lip, " at ", tb_lip_a, "deg"),
         "  seam ", face_gap, "  push to open ", tb_slide,
         "  footprint=", (tb_x0 + tb_uc + tb_r) - x_f,
                    " x ", band_w, " x ", top_z,
         "  band thick=", thick,
         "  knuckle cap at bed=", knuck_foot,
         "  knuckle underside=", knuck_slope, "deg",
         "  pin first layer=", pin_flat_w));
if (charms > 0)
    echo(str(charms, " cone station(s) in bar(s) ", charm_ix, " of ", cols,
             " — hole ", cn_hole, ", countersink ", 2*cn_cs_r, " at ", cn_cs_a,
             " deg, ", cn_off, " towards +x (wall ", cn_wall_bar, " at -x, ",
             2*cn_chord, " across at the +x face); +x gap filled, ",
             2*cn_boss_y, " wide, to the knuckles' ends; rib ", 2*cn_rib_r,
             " x ", cn_rib_r, " from ", cn_rib_in, " to ", cn_rib_out,
             charms < 2 ? ""
                 : str(", closest pair ", charm_sep * pitch, " mm apart")));
// ------------------------------------------------------------------ modules
module rrect(s) offset(r = corner_r)
    square([s[0] - 2*corner_r, s[1] - 2*corner_r], center = true);

// One bar: `body` along the band, the WHOLE band width across it. Flat on the
// bed, chamfered only at the top. This slab is what replaced a row of separate
// tiles once the cross-band hinges came out — there is nothing to articulate
// across the width, so the width is solid.
module bar_body() slab(body);

// A bar's slab at any length along the band — the socket block is one too.
module slab(len) {
    hull() {
        linear_extrude(thick - ch_rise) rrect([len, band_w]);
        translate([0, 0, thick - 0.01])
            linear_extrude(0.01) rrect([len - 2*ch_run, band_w - 2*ch_run]);
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
module pin(pl = blade_w + 2*axial_fit + 2*lug_w) {   // == body
    intersection() {
        translate([pitch/2, -pl/2, pin_z]) rotate([-90, 0, 0])
            cylinder(h = pl, r = pin_r);
        translate([pitch/2 - pin_r, -pl/2, pin_z - pin_r + pin_flat])
            cube([2*pin_r, pl, thick]);
    }
}

// The +x half of a joint: two lugs straddling the neighbour's blade, plus the
// pin they both carry. (`lw`, `bw`: narrower at joint 0 for the lock screw.)
module fork(lw = lug_w, bw = blade_w) {
    for (s = [-1, 1])
        xz_extrude(s > 0 ? bw/2 + axial_fit
                         : -(bw/2 + axial_fit + lw), lw)
            knuckle_2d(pitch/2, +1, h - 1.0);
    pin(bw + 2*axial_fit + 2*lw);
}

// The -x half: one central blade with a closed bore. Closed, not hooked — a
// hook opening toward the neighbour would simply pull off the pin.
module blade(bw = blade_w) {
    difference() {
        xz_extrude(-bw/2, bw) knuckle_2d(-pitch/2, -1, -(h - 1.0));
        translate([-pitch/2, -bw, pin_z]) rotate([-90, 0, 0])
            cylinder(h = 2*bw, r = bore_r);
    }
}

// A column of the band: the bar, plus its share of the two joints beside it.
// The joint is spread into `rows` knuckle clusters along the bar — one at each
// old tile centre — so a wide band is held by several knuckles rather than
// one, and the bar cannot twist about a single pin.
// With the lock screw, joint 0 (bar 0's fork, bar 1's blade) has narrowed
// clusters pushed out to the band's edges: the screw's head turns between them.
module bar(col) {
    translate([col*pitch, band_cy, 0]) bar_body();
    for (row = [0 : rows - 1]) {
        j0 = buckle == "screw";
        dy = row == 0 ? -sk_shift : sk_shift;
        translate([col*pitch, row*row_pitch, 0]) {
            if (col > 0)
                if (j0 && col == 1) translate([0, dy, 0]) blade(sk_blade); else blade();
            if (col < cols - 1)
                if (j0 && col == 0) translate([0, dy, 0]) fork(sk_lug, sk_blade); else fork();
        }
    }
}

// The clasp, in the print frame: `tb_x0` is where the block's front face lands
// when it is fastened (u = 0). Clasp modules work in a local frame: x = u
// along the band from the block's front face, y off the band's middle.
tb_x0 = x_r + face_gap;

// The lips a wall carries, in section, (a, z) with a measured from the wall
// (at a = 0) into the cut: what is left standing of the wall's material.
module tb_lips_2d()
    polygon([[-1, -2], [-1, thick + 2], [tb_tipd, thick + 2],
             [tb_tipd, thick - tb_tip_z], [0, thick - tb_zlip], [0, tb_zlip],
             [tb_tipd, tb_tip_z], [tb_tipd, -2]]);

// What a lip-shaped edge loses, in section, (a, z) with a measured INTO the
// part from its edge: the insets at the bottom and the top.
module tb_edge_cut_2d() {
    polygon([[-1, -1], [tb_lip, -1], [tb_lip, tb_land],
             [0, tb_land + tb_lip_h], [-1, tb_land + tb_lip_h]]);
    polygon([[-1, thick + 1], [tb_lip, thick + 1], [tb_lip, thick - tb_land],
             [0, thick - tb_land - tb_lip_h], [-1, thick - tb_land - tb_lip_h]]);
}

// Sweep a radial section — x is the radius from the knob's centre — round the
// knob's front arc, `ang` either side of the band's axis.
module tb_sector(ang)
    translate([tb_uc, 0, 0]) rotate([0, 0, 180 - ang])
        rotate_extrude(angle = 2*ang) children();

// The roofed buckle's sections. The knob's foot: what its front edge loses,
// (a, z) with a measured INTO the knob — the dovetail, narrow at the bed.
module dv_edge_cut_2d()
    polygon([[-1, -1], [tb_lip, -1], [tb_lip, tb_land],
             [0, tb_land + dv_lip_h], [-1, tb_land + dv_lip_h]]);

// The lower lip the niche's wall keeps, (a, z) with a measured from the wall
// into the cut. Above it the wall is plain, up to the roof.
module dv_lips_2d()
    polygon([[-1, -2], [-1, thick + 2], [0, thick + 2], [0, dv_zlip],
             [tb_tipd, dv_tip_z], [tb_tipd, -2]]);

module clasp_tab() if (buckle != "lips") clasp_tab_roofed(); else {
    // neck, from inside the last bar into the knob — past the lip's inset,
    // so it meets the knob's chamfered top and bottom too
    translate([x_r - 1.0, band_cy - tb_neck/2, 0])
        cube([tb_x0 + tb_ua + tb_lip + 0.5 - (x_r - 1.0), tb_neck, thick]);
    // the knob, its front shaped to the lips — `tb_clear` past the step, so
    // the lips' end faces clear the knob's full edge
    translate([tb_x0, band_cy, 0]) difference() {
        linear_extrude(thick) tb_knob_2d();
        intersection() {
            tb_sector(100) translate([tb_r, 0]) mirror([1, 0]) tb_edge_cut_2d();
            translate([-50, -50, -5]) cube([50 + tb_ustep + tb_clear, 100, thick + 10]);
        }
    }
}

// The roofed knob: the front half (to the step, `tb_clear` past it) and the
// neck `dv_h` tall with the dovetail foot; the back half full height. The
// neck is low all the way: pushed to open it travels `tb_slide` under the
// roof, and the seam is only that wide.
module clasp_tab_roofed() {
    translate([x_r - 1.0, band_cy - tb_neck/2, 0])
        cube([tb_x0 + tb_ua + tb_lip + 0.5 - (x_r - 1.0), tb_neck, dv_h]);
    translate([tb_x0, band_cy, 0]) difference() {
        intersection() {
            linear_extrude(thick) tb_knob_2d();
            union() {
                // overlapping the back half: merely touching it, the two
                // kept a seam (a non-manifold edge on the bed)
                translate([-50, -50, 0]) cube([50 + dv_ub + 1, 100, dv_h]);
                translate([dv_ub, -50, 0]) cube([50, 100, thick]);
            }
        }
        intersection() {
            tb_sector(100) translate([tb_r, 0]) mirror([1, 0]) dv_edge_cut_2d();
            translate([-50, -50, -5]) cube([50 + tb_ustep + tb_clear, 100, thick + 10]);
        }
    }
}

// The knob's plan: the circle, each side behind the step cut down to the
// recess, the lead-in, the crest, the catch and the notch.
module tb_knob_2d()
    translate([tb_uc, 0]) difference() {
        circle(r = tb_r);
        if (buckle == "lips") for (m = [0, 1]) mirror([0, m])
            polygon([[cl_x0, tb_r + 1], [cl_x0, cl_yl(cl_x0)], cl_c, cl_f,
                      [tb_r + 1, cl_yn], [tb_r + 1, tb_r + 1]]);
    }

// Bar 0 lengthened to the block's front face: the same slab as a bar, so the
// two read as one.
module clasp_block()
    translate([(x_f + h)/2, band_cy, 0]) slab(h - x_f);

// The lips the block keeps, in the local frame: round the niche's front arc
// from the neck slot to the step. Their section is the child.
module tb_lips()
    difference() {
        tb_sector(100) translate([tb_r + tb_wfit, 0]) mirror([1, 0]) children();
        translate([-50, -(tb_neck/2 + tb_fit), -6]) cube([100, tb_neck + 2*tb_fit, thick + 12]);
        translate([tb_ustep, -50, -6]) cube([100, 100, thick + 12]);
    }

// The way-in: the knob, `tb_drop_fit` round it, swept from home back to
// where it drops out. No bigger than the knob needs.
// Its back is square (round corners `cl_wr`), so the leaves' inner faces
// run straight to their roots.
module tb_way_in_2d()
    hull() {
        translate([tb_uc, 0]) circle(r = cl_wy);
        for (m = [-1, 1]) translate([tb_uc + cl_back, m * (cl_wy - cl_wr)]) circle(r = cl_wr);
    }

// The cut: the neck slot, the niche (the knob's circle at home, its lips left
// standing) and, behind the step, the way-in less its two bumps, plus the slots that free the leaves. Open top and
// bottom.
// Roofed (`buckle = "screw"`), the neck slot and the niche stop under the
// roof: `ct` is how high they cut.
module clasp_pocket() translate([x_f, band_cy, 0]) {
    roof = buckle != "lips";
    ct   = roof ? 1 + thick - dv_roof : thick + 2;
    translate([-1, -(tb_neck/2 + tb_fit), -1]) cube([tb_ua + 2, tb_neck + 2*tb_fit, ct]);
    difference() {
        // in front of the step only: behind it the way-in covers the knob,
        // and the bumps reach inside its circle
        translate([0, 0, -1]) linear_extrude(ct) intersection() {
            translate([tb_uc, 0]) circle(r = tb_r + tb_wfit);
            translate([-50, -50]) square([50 + tb_ustep + 0.01, 100]);
        }
        if (roof) tb_lips() dv_lips_2d(); else tb_lips() tb_lips_2d();
    }
    translate([0, 0, -1]) linear_extrude(thick + 2) difference() {
        intersection() {
            tb_way_in_2d();
            translate([tb_ustep, -50]) square([100, 100]);
        }
        // the bumps, on the leaves' inner faces
        if (buckle == "lips") for (m = [0, 1]) mirror([0, m]) hull() {
            translate([tb_uc + cl_xb, cl_yb]) circle(r = cl_rb);
            translate([tb_uc + cl_xb - 0.6, cl_wy - 0.01]) square([1.2, 0.2]);
        }
    }
    // the slots that free the leaves: behind each, and its mouth in front
    // of its tip, into the way-in; the root end rounded
    // the lock screw's threaded hole: from bar 0's +x face, through the far
    // wall, out into the way-in
    if (buckle == "screw")
        translate([h - x_f, 0, thick/2]) rotate([0, -90, 0]) sk_female(sk_far);
    if (buckle == "lips") translate([0, 0, -1]) linear_extrude(thick + 2) for (m = [0, 1]) mirror([0, m]) {
        translate([tb_uc + cl_tip - cl_gap, cl_wy + cl_t])
            square([cl_root - (cl_tip - cl_gap), cl_slot]);
        translate([tb_uc + cl_tip - cl_gap, cl_wy - 0.5])
            square([cl_gap, cl_t + cl_slot + 0.5]);
        translate([tb_uc + cl_root, cl_wy + cl_t + cl_slot/2]) circle(d = cl_slot);
        // the slit inside the leaf, from the way-in's back corner on
        hull() {
            translate([tb_uc + cl_back, cl_wy - cl_slit]) square([0.01, cl_slit]);
            translate([tb_uc + cl_root, cl_wy - cl_slit/2]) circle(d = cl_slit);
        }
    }
}

// A station: the hole and the countersink, cut from bar `col` on the pin's
// axis, `cn_off` towards +x of the bar's centre.
module charm_station_cut(col) {
    translate([col*pitch + cn_off, band_cy, thick]) cn_bar_cut();
}

// ... and what stands on it once it is cut: the rib, across the band.
module charm_station_add(col) {
    translate([col*pitch + cn_off, band_cy, thick]) cn_bar_rib();
}

// What goes in before the cut: the +x gap's fill, one wide lug with the
// lugs' own knuckle profile. A station keeps its bevels, like every other
// bar: its hole stays ~1 mm clear of the chamfer's foot.
module charm_seat(col) {
    translate([col*pitch, 0, 0])
        xz_extrude(band_cy - cn_boss_y, 2*cn_boss_y) knuckle_2d(pitch/2, +1, h - 1.0);
}

// The pocket is cut from bar 0 and its block together: it runs on into the
// bar.
module bracelet() {
    difference() {
        union() {
            for (c = [0:cols-1]) bar(c);
            for (c = charm_ix) charm_seat(c);
            clasp_block();
            clasp_tab();
        }
        clasp_pocket();
        for (c = charm_ix) charm_station_cut(c);
    }
    for (c = charm_ix) charm_station_add(c);
}

// Where the accent colour goes: a slab far wider than any bracelet. The clasp
// is the band's own thickness now, so it takes the stripe like any bar.
module accent_region()
    translate([-1000, -1000, accent_lo]) cube([2000, 2000, accent_hi - accent_lo]);

if (accent) {
    color(base_color)   difference()   { bracelet(); accent_region(); }
    color(accent_color) intersection() { bracelet(); accent_region(); }
} else
    bracelet();
