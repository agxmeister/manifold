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
// A T ON RAILS (the user's design, 2026-10-19).
//
//   top, fastened
//     last bar          socket block (+ bar 0)
//   ────────┐       ┌────────────────────────────┐
//           │       │  ┌──┐╞═rail═╡)  )          │   ) a detent bump, on a
//           │       └──┘  │      │ ┆ ┆  room      │     leaf in the side wall
//      ═════╪═════════════│ T    │    (empty)    │
//           │       ┌──┐  │      │ ┆ ┆            │
//           │       │  └──┘╞═rail═╡)  )          │
//   ────────┘       └────────────────────────────┘
//
//   * The last bar ends in a T: a neck and a CROSSBAR across the band, the
//     band's full thickness, flush on top and underneath.
//   * Bar 0 is lengthened into a SOCKET BLOCK with a T-shaped cut, open top
//     and bottom. At its front the crossbar's HOME, against the block's two
//     SHOULDERS (either side of the neck slot); behind it an empty ROOM.
//   * LIPS overhang the crossbar's edge at the top and at the bottom on three
//     sides: along its front (on the shoulders) and along both its ends (RAILS
//     on the side walls). At home it cannot move up or down. The band's pull
//     holds it against the shoulders.
//   * To close: push the ends together, push the T up into the room from
//     below, then pull the ends apart: the crossbar slides forward along the
//     rails, clicks past two DETENT bumps and sits home. To open: push the
//     ends together (the crossbar clicks back into the room), push it out
//     downwards. Two separate moves, and neither alone opens it.
//   * The detents are mirrored, one in each side wall: a bump on a cantilever
//     leaf cut out of the wall (the old keyhole's proven leaf, standing up).
//     They only keep the crossbar from wandering back into the room when the
//     band is slack. Nothing holds it up or down but the lips.
//
// Why a room and not a spring: the crossbar has to slide its whole length to
// leave the rails, ~4 mm, and no spring that fits here bends that far within
// the strain a printed leaf is proven at.
//
// Nothing is cantilevered into air: the T, the leaves and the lips all stand
// on the bed; the upper lips are an overhang `tb_lip` deep, stepping under a
// bead a layer.
tb_neck    = 4.5;     // neck width
tb_cw      = 11.0;    // crossbar, across the band
tb_ct      = 2.6;     // crossbar, along the band
tb_sh      = 1.6;     // the block's shoulders, front face to the crossbar
tb_lip     = 1.1;     // how far a lip overhangs the crossbar's edge
tb_lip_a   = 60;      // lip faces, from vertical. Steeper than 45 on purpose:
                      //   pushed up or down, a face cams the crossbar sideways
                      //   by tan(90 - a) of the push — 1.0 at 45, 0.58 at 60.
                      //   A layer steps 0.35, under a bead (asserted).
tb_lip_h   = tb_lip / tan(tb_lip_a);         // 0.64 — the lip face's height
tb_land    = 0.4;     // a vertical land at the lip's tip, two layers: without
                      //   it the tip is a 30-degree knife edge
tb_fit     = 0.15;    // vertical walls: shoulders, rails' walls, neck
tb_vfit    = 0.3;     // across the lip faces — they are a printed overhang
                      //   and an elephant's foot, so more than `tb_fit`
tb_room_fit = 0.3;    // the room around the crossbar, as it drops in
tb_far     = 2.4;     // bar 0 behind the room, to its +x face: the detent
                      //   leaves' roots run into it

// The detents: a bump `dt_r` on each leaf, standing `dt_pinch` out of the
// side wall into the crossbar's path, right behind the crossbar at home.
dt_r       = 0.5;
dt_pinch   = 0.5;
lf_t       = 0.8;     // leaf, across the band
lf_slot    = 0.6;     // behind the leaf. Both sides stand on the bed:
                      //   `axial_fit`, or the first layer welds
lf_len     = 4.4;     // free end (at the bump) -> root
lf_flex    = dt_pinch - tb_fit;              // what the crossbar pushes it
lf_strain  = 1.5 * lf_t * lf_flex / (lf_len*lf_len);

// Positions along the band, from the block's front face, fastened, home.
tb_ws      = tb_cw/2 + tb_fit;               // the pocket's side walls, off
                                             //   the band's middle
tb_uc      = tb_sh + tb_fit;                 // crossbar front
tb_ur      = tb_uc + tb_ct;                  // crossbar back: the rails end
dt_y       = tb_ws + dt_r - dt_pinch;        // bump centre, off the middle
// the bumps CRADLE the crossbar at home: its back corners just touch them
dt_u       = tb_ur + sqrt(dt_r*dt_r - pow(dt_y - tb_cw/2, 2));
tb_urm     = dt_u + dt_r + tb_room_fit;      // the room: the crossbar's front
tb_ufar    = tb_urm + tb_ct + tb_room_fit;   // the far wall
tb_slide   = tb_urm - tb_uc;                 // home -> room
face_gap   = tb_slide + 0.1;                 // the seam when fastened, ~4
lf_u0      = dt_u;                           // the leaf's free end
tb_tipd    = tb_fit + tb_lip - tb_vfit;      // a lip's reach past its wall
tb_tipu    = tb_sh + tb_tipd;                // the front lips' tip
tb_zlip    = tb_land + tb_tipd * tan(90 - tb_lip_a);   // where a lip face
                                             //   meets its wall
tb_rail_u  = dt_u - dt_r - lf_slot;          // the rails end: a slot's width
                                             //   short of the bump
tb_rail    = tb_rail_u - tb_uc;              // rail along a crossbar end

assert(band_w/2 - (tb_ws + lf_t + lf_slot) >= 1.0,
       str("only ", band_w/2 - (tb_ws + lf_t + lf_slot), " mm of side wall outside the leaf"));
assert(tb_cw/2 - tb_neck/2 >= 2.5, "the crossbar hardly reaches past its neck");
assert(0.2 * tan(tb_lip_a) <= 0.4, "the lips step more than a bead a layer");
assert(tb_zlip > tb_land && tb_zlip < tb_land + tb_lip_h,
       "the lip's face misses its wall");
assert(2*tb_zlip < thick - 1.5, "the lips leave too little wall face");
assert(tb_ct - tb_lip >= 1.2, "the crossbar is too thin under the lips");
assert(tb_rail >= 0.7*tb_ct, str("the rails hold only ", tb_rail, " of the crossbar's ends"));
assert(dt_pinch > tb_fit + 0.25, "the detent hardly stands in the crossbar's way");
assert(lf_strain <= 0.029, str("detent leaf strained to ", 100*lf_strain, "%"));
assert(lf_slot >= 0.45, "the leaf slot will weld on the first layer");

// ------------------------------------------------------------ length budget
// Clasped, the loop runs: bar 0's +x face -> band -> last bar's +x face ->
// `face_gap` -> socket block -> bar 0. The block is fixed at every size; the
// BAND makes up the difference, as it did for the old buckle.
//
// The block is as short as the pocket allows: its far wall stops `tb_far`
// short of bar 0's +x face, so the pocket runs on into bar 0 itself, and the
// block reaches `blk_ext` past bar 0's -x face.
x_f       = (h - tb_far) - tb_ufar;              // the block's front face
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
         "  T ", tb_cw, " x ", tb_ct, " neck ", tb_neck, " lips ", tb_lip,
         " at ", tb_lip_a, "deg  seam ", face_gap,
         "  slide ", tb_slide, "  rails ", tb_rail, " of ", tb_ct,
         "  detent leaf strain=", 100*lf_strain, "%",
         "  footprint=", (tb_x0 + tb_uc + tb_ct) - x_f,
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

// The T, in the print frame: `tb_x0` is where the block's front face lands
// when it is fastened (u = 0).
tb_x0 = x_r + face_gap;

// A lip-shaped edge in section, (a, z) with a measured INTO the part from
// `a0`: inset by the lip at the bottom and the top, full in between. The
// crossbar's front (along x) and its ends (along y).
module tb_edge_2d(a0, len)
    polygon([[a0 + tb_lip, 0], [a0 + tb_lip, tb_land],
             [a0, tb_land + tb_lip_h], [a0, thick - tb_land - tb_lip_h],
             [a0 + tb_lip, thick - tb_land], [a0 + tb_lip, thick],
             [a0 + len, thick], [a0 + len, 0]]);

// The lips a wall carries, in section, (a, z) with a measured from the wall
// (at a = 0) into the cut: what is left standing of the wall's material.
module tb_lips_2d()
    polygon([[-1, -2], [-1, thick + 2], [tb_tipd, thick + 2],
             [tb_tipd, thick - tb_land], [0, thick - tb_zlip], [0, tb_zlip],
             [tb_tipd, tb_land], [tb_tipd, -2]]);

// The two ends of a solid, mirrored about the band's middle: `children()` is
// drawn for the +y end, in a frame where y is measured from the middle.
module tb_both_ends() for (s = [-1, 1])
    translate([0, band_cy, 0]) mirror([0, s < 0 ? 1 : 0, 0]) children();

module clasp_tab() {
    // neck, from inside the last bar into the crossbar — past the lip's
    // inset, so it meets the crossbar's chamfered top and bottom too
    translate([x_r - 1.0, band_cy - tb_neck/2, 0])
        cube([tb_x0 + tb_uc + tb_lip + 0.5 - (x_r - 1.0), tb_neck, thick]);
    // the crossbar, its front and both ends shaped to the lips. The two ends
    // are two separate children: a `for` inside intersection() is ONE child,
    // the union of both, and would shape neither.
    intersection() {
        translate([tb_x0 + tb_uc, band_cy - tb_cw/2, 0]) cube([tb_ct, tb_cw, thick]);
        xz_extrude(band_cy - tb_cw, 2*tb_cw) tb_edge_2d(tb_x0 + tb_uc, 20);
        tb_end_shape(+1);
        tb_end_shape(-1);
    }
}

// The crossbar's +y (s = 1) or -y end, shaped to the rail: everything of the
// band's width short of that end, inset by the lip at the top and the bottom.
module tb_end_shape(s)
    translate([0, band_cy, 0]) mirror([0, s < 0 ? 1 : 0, 0])
        translate([tb_x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(tb_ufar)
            translate([tb_cw/2, 0]) mirror([1, 0]) tb_edge_2d(0, tb_cw);

// Bar 0 lengthened to the block's front face: the same slab as a bar, so the
// two read as one.
module clasp_block()
    translate([(x_f + h)/2, band_cy, 0]) slab(h - x_f);

// What the cut leaves standing in the block's +y side wall, in a frame with
// y measured from the band's middle: the rail, and the detent's bump.
module tb_side_keep() {
    // the rail: the lips along the crossbar's end, from the shoulder to the
    // slot that frees the leaf
    translate([x_f + tb_sh - 0.01, tb_ws, 0]) rotate([90, 0, 90])
        linear_extrude(tb_rail_u - tb_sh + 0.01)
            mirror([1, 0]) tb_lips_2d();
    // the bump, on the leaf's free end
    translate([x_f + dt_u, dt_y, -1]) cylinder(r = dt_r, h = thick + 2);
}

// ... and what it cuts from that wall: the slot behind the leaf, and across
// in front of its free end, so the leaf is a cantilever rooted at the back.
// The bump's front half stands over that cross slot, which is therefore a
// slot's width wider than the bump: nothing comes within `lf_slot` of it.
// It cuts only the wall (y >= `tb_ws`), never the bump in front of it.
module tb_side_cut() {
    translate([x_f + tb_rail_u, tb_ws, -1])
        cube([lf_u0 - tb_rail_u, lf_t + lf_slot, thick + 2]);
    hull() {
        translate([x_f + lf_u0 - lf_slot/2, tb_ws + lf_t + lf_slot/2, -1])
            cylinder(d = lf_slot, h = thick + 2);
        translate([x_f + lf_u0 + lf_len, tb_ws + lf_t + lf_slot/2, -1])
            cylinder(d = lf_slot, h = thick + 2);
    }
}

// The cut: the neck slot, the crossbar's home and room, open top and bottom,
// with the front lips on the shoulders, the rails and the bumps left standing.
module clasp_pocket() {
    // the neck slot
    translate([x_f - 1, band_cy - tb_neck/2 - tb_fit, -1])
        cube([tb_sh + 2, tb_neck + 2*tb_fit, thick + 2]);
    difference() {
        // home and room, the front lips left standing on the shoulders
        xz_extrude(band_cy - tb_ws, 2*tb_ws)
            polygon([[x_f + tb_tipu, -1], [x_f + tb_tipu, tb_land],
                     [x_f + tb_sh, tb_zlip], [x_f + tb_sh, thick - tb_zlip],
                     [x_f + tb_tipu, thick - tb_land], [x_f + tb_tipu, thick + 1],
                     [x_f + tb_ufar, thick + 1], [x_f + tb_ufar, -1]]);
        tb_both_ends() tb_side_keep();
    }
    tb_both_ends() tb_side_cut();
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
