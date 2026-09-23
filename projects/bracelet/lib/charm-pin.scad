// charm-pin — the interface every charm in this project shares.
//
// A charm hangs on a BALL PIN standing on a bar's flat top, and clips on with a
// slit socket that snaps over the ball. One joint, two halves, both printed
// with no support and no bridging.
//
// NAMING: everything here is `charm_*`, `ball_*`, `neck_*`, `cav_*`, `mouth_*`
// or `sock_*`. The bracelet's own `pin_d` / `pin_r` / `pin_z` / `pin_flat` are
// the HINGE pin, which is a different pin entirely; nothing in this file is
// allowed to shadow them.
//
// The two shapes, and why they are not the obvious ones:
//
//   * the PIN prints standing up. A sphere on a stalk is not printable as a
//     sphere — everything below its 45-degree latitude faces downwards and
//     gets shallower until the equator hangs level. The cap is removed by
//     HULLING the ball down to a disc the width of the neck, which leaves a
//     `neck_skirt`-degree cone under it and the full equator — the part that
//     does the retaining — untouched.
//
//   * the SOCKET prints mouth UP, so its cavity closes in on itself as the
//     nozzle climbs: the same shape as the roof of any horizontal hole. The
//     mouth may not be too NARROW for that — truncating the cavity at less
//     than r/sqrt(2) leaves a ceiling shallower than 45 degrees, asserted
//     below. The charm is flipped over to wear, so the mouth faces down onto
//     the pin and the face printed on the bed is the one you see.
//
// Retention is `charm_grip`: the mouth is that much narrower, per side, than
// the ball it has to swallow, and the slits are what let it spread. This is a
// deliberate interference — the one joint in the project that is NOT a
// clearance fit — because a charm that slides off is a charm on the pavement.

// ------------------------------------------------------------------ the ball
charm_ball  = 4.0;   // ball diameter — what the socket grips and swivels on
charm_neck  = 2.4;   // the stalk under it
charm_rise  = 3.8;   // mounting face to ball CENTRE. Sets how far the charm
                     //   stands off whatever carries the pin.
charm_foot  = 2.2;   // the taper where the stalk leaves that face
charm_sink  = 1.0;   // how far that taper starts INSIDE it, so the two solids
                     //   genuinely intersect instead of merely touching

// ---------------------------------------------------------------- the socket
charm_fit   = 0.20;  // swivel clearance around the ball, per side — a moving
                     //   fit and a printed ceiling, so it gets the loose end
charm_grip  = 0.25;  // how far each side of the mouth must spread to let the
                     //   ball past. THIS is the "hard to pull off" number.
                     //   Raise it for a stiffer charm, lower it if a test
                     //   print will not clip on. 0.25 needs a firm push.
sock_wall   = 1.4;   // wall around the cavity
sock_slits  = 4;     // slits, so the mouth can open at all
sock_slit_w = 0.9;   // and how wide each one is
sock_lip    = 0.8;   // a straight length of bore above the mouth. Two jobs:
                     //   it is the surface that actually holds the ball in,
                     //   and it keeps the cavity's sphere from meeting the
                     //   boss's top face on the same circle as the bore —
                     //   three surfaces through one edge meshes as a
                     //   zero-thickness sliver, and check_wall_thickness.py
                     //   reads that as a 0.00 mm wall, a hundred times over.

// ------------------------------------------------------------------ derived
cav_d       = charm_ball + 2*charm_fit;              // 4.40 — cavity
mouth_d     = charm_ball - 2*charm_grip;             // 3.50 — the lip
sock_od     = cav_d + 2*sock_wall;                   // 7.20
mouth_z     = sqrt(pow(cav_d/2, 2) - pow(mouth_d/2, 2));  // 1.33 — cavity
                                                     //   centre to mouth plane
assert(mouth_d > cav_d/sqrt(2),
       "socket mouth is so narrow the cavity roof leans past 45 degrees");
assert(mouth_d > charm_neck, "the neck cannot pass the mouth");

sock_h      = 7.2;   // boss height, mouth at the top. Everything below the
                     //   cavity is solid, so this is what sets the floor.
cav_z       = sock_h - sock_lip - mouth_z;           // 5.07 — cavity centre
cav_bottom  = cav_z - cav_d/2;                       // 2.87

// The ball's underside, and the two no-ops that hide in it. Below its
// 45-degree latitude a sphere leans past what FDM holds up, so that cap has to
// go — and the obvious way to take it off does nothing at all:
//
//   1. Intersecting with the TANGENT 45-degree cone removes NOTHING. The
//      tangent cone is the SMALLEST 45-degree cone that CONTAINS the sphere;
//      it touches on one circle and lies outside everywhere else.
//   2. hull()-ing down to a disc that sits INSIDE the ball removes nothing
//      either. The disc has to be below `neck_min`, the depth at which the
//      ball is already as narrow as the neck. Above it, the disc is interior
//      and the hull is the ball again.
//
// Both read like a chamfer in the source and export a plain sphere, and the
// only symptom either time is check_overhangs.py still reporting ~56 degrees
// from vertical under the head. Hence the assert.
neck_min    = sqrt(pow(charm_ball/2, 2) - pow(charm_neck/2, 2));   // 1.60
neck_gap    = 2.2;   // ball centre down to where the skirt meets the neck
assert(neck_gap > neck_min + 0.3,
       "the skirt's disc is inside the ball — hull() would do nothing at all");
neck_skirt  = asin((charm_ball - charm_neck)/2 / neck_gap);   // 21 deg
assert(neck_skirt <= 45,
       "the skirt under the ball leans past 45 degrees — raise neck_gap");
neck_h      = charm_rise - neck_gap + 0.3;           // stalk, up INTO the skirt
assert(neck_h > 0, "charm_rise leaves no stalk under the skirt");

// Head half-width where it passes the outer face of the socket's mouth. What
// is left over is the charm's tilt range; it spins freely regardless.
head_at_lip = charm_neck/2
            + max(0, neck_gap - (mouth_z + sock_lip)) * tan(neck_skirt);
assert(head_at_lip < mouth_d/2, "the skirt cannot pass the socket's mouth");
charm_tilt  = asin((mouth_d/2 - head_at_lip) / (mouth_z + sock_lip));   // 14 deg

// A ball pin, z = 0 on the face it grows out of, ball centre at `charm_rise`.
module charm_pin() {
    translate([0, 0, -charm_sink])
        cylinder(d1 = charm_foot, d2 = charm_neck, h = charm_sink + 0.8);
    cylinder(d = charm_neck, h = neck_h);            // straight stalk
    hull() {                                         // ball, and its skirt
        translate([0, 0, charm_rise]) sphere(d = charm_ball);
        translate([0, 0, charm_rise - neck_gap]) cylinder(d = charm_neck, h = 0.01);
    }
}

// The socket boss, standing on z = 0 with its mouth at z = sock_h. `floor_z` is
// where the slits may start — pass the thickness of whatever the boss is
// unioned onto, so the slits never cut into the charm's own face.
module charm_socket(floor_z) {
    assert(cav_bottom > floor_z, "the charm's face is thicker than the socket floor");
    difference() {
        cylinder(d = sock_od, h = sock_h);
        translate([0, 0, cav_z]) sphere(d = cav_d);
        translate([0, 0, cav_z]) cylinder(d = mouth_d, h = mouth_z + sock_lip + 1);
        for (i = [0 : sock_slits - 1])
            rotate([0, 0, i * 360/sock_slits])
                translate([0, -sock_slit_w/2, floor_z])
                    cube([sock_od, sock_slit_w, sock_h - floor_z + 1]);
    }
}

// --------------------------------------------------------------- engraving
// Decoration on a charm is CUT, never raised. The decorated face lies on the
// bed (that is forced: the socket's mouth has to point up, and the mouth is on
// the charm's back), so anything embossed would lift the plate off the plate.
//
// Both cutters below are 45-degree wedges with their WIDE end at the face, so
// the void they leave closes in on itself as the nozzle climbs — the same
// reason the socket prints mouth up. Neither is run to a true apex or a true
// knife edge: `charm_cut_tip` leaves a real flat at the bottom, because a cone
// or wedge run to nothing meshes into slivers there and the wall check reads
// those as 0.00 mm.
//
// What limits a cut is how much material is left ABOVE it. Two different
// thicknesses are available depending on where the cut lands, and
// `charm_cut_max` takes the smaller so one number governs everywhere:
//
//   * out on the open plate, `plate` mm of it;
//   * under the socket, `cav_bottom` mm — the cavity floor, which is thicker
//     than the plate, so a cut is actually freer there, not tighter.
//
// The constraint that is NOT expressed here, because it depends on the
// silhouette: a cut must stay a printable wall clear of the charm's outline,
// and clear of the next cut. Two cuts 0.1 mm apart leave a 0.1 mm rib, and
// two cuts that merge are fine — it is the near miss that fails. And no cut
// may close a LOOP: a ring-shaped groove cuts the first layer into islands
// (see models/flower-charm for the 12-island version of that mistake).
charm_cut_tip = 0.8;   // default flat at the bottom of a cut

function charm_cut_max(plate)        = min(plate, cav_bottom) - 1.2;
function charm_cut_depth(d, tip = charm_cut_tip) = (d - tip)/2;

// A countersunk round dimple, `d` across at the face. Eyes, noses, nostrils.
module charm_dimple(d, tip = charm_cut_tip) {
    h = charm_cut_depth(d, tip);
    translate([0, 0, -0.01]) cylinder(d1 = d, d2 = tip, h = h + 0.01);
}

// A tapered slot from `a` to `b`, `w` wide at the face, with rounded ends —
// a V-groove for a mouth, a whisker, a highlight. hull() of two congruent
// cones keeps every flank at the same 45 degrees the dimple has.
module charm_groove(a, b, w, tip = charm_cut_tip) {
    h = charm_cut_depth(w, tip);
    hull() {
        translate([a[0], a[1], -0.01]) cylinder(d1 = w, d2 = tip, h = h + 0.01);
        translate([b[0], b[1], -0.01]) cylinder(d1 = w, d2 = tip, h = h + 0.01);
    }
}

// A polyline of grooves — a smile, a pair of whiskers meeting. Same rules.
module charm_grooves(pts, w, tip = charm_cut_tip) {
    for (i = [0 : len(pts) - 2]) charm_groove(pts[i], pts[i+1], w, tip);
}

// ======================================================================
// THE SCREW MOUNT — a second, detachable way to hang a charm.
// ======================================================================
//
// The ball pin above is FUSED to its bar: the charm comes off, the pin never
// does. This mount replaces the pin with a loose double-ended SCREW. A bar
// gets a threaded hole straight through it, the screw winds down into that
// hole until its collar seats on the bar's top face, and the charm winds onto
// the other end. Nothing is permanent and nothing springs.
//
// Everything here is named `scr_*`. The file already has `charm_*` (the ball),
// and bracelet.scad has `pin_*` (the HINGE pin) — a third thing called a pin
// in the same namespace is how a silent shadowing bug gets written.
//
// WHAT SETS THE SIZE, and it is not the screw. The hole has to go through a
// bar, and a bar is `body` = 6.0 mm along the band — but only 5.0 mm of that
// used to survive the top chamfer, and the hole had to fit inside the 5.0.
// That is what held the thread to M3 and left 0.85 mm of wall at the
// chamfered rim against 1.35 mm below it.
//
// THE CHAMFER IS NOW FILLED BACK IN at a charm station. `charm_screw_seat` in
// bracelet.scad unions a lens of material into the chamfer wedge around the
// hole, so the bar is square-shouldered and its full 6.0 mm wide everywhere
// the hole passes through it. That costs nothing to print — the added
// material's sides are flush with the slab below it, so it adds no overhang,
// no layer step and no bed contact — and it buys the whole millimetre the
// chamfer was eating:
//
//     major 4.0 + 2 x fit = 4.3 hole -> (6.0 - 4.3)/2 = 0.85 mm of wall,
//                                       top to bottom, no thinner rim at all.
//
// So the wall is the same 0.85 mm the printed version was proven at, and the
// thread inside it went from M3 to M4 — 78% more cross-section in the shaft,
// and the same again in the thread that carries it. 0.85 mm is two perimeters
// at a 0.4 mm nozzle and is deliberately the floor here — `knuck_wall` = 0.9
// elsewhere in the band. There is now no chamfer left to spend: fattening the
// thread past M4 means widening the bar.
//
// BOTH FLANKS HAVE TO PRINT, and that is a change. A female thread cut into a
// part prints with its axis VERTICAL, so one flank of every groove is a
// CEILING and the other is a floor, and WHICH ONE depends on which way up the
// part goes on the bed. There are two females in this joint and THEY PRINT THE
// OTHER WAY UP FROM EACH OTHER:
//
//   * the BAR's hole is bored down from a face that prints up, so its ceiling
//     is the flank at the MOUTH end — `scr_up_f`, the slack one;
//   * the CHARM's socket is entered from the face it STANDS ON (models/
//     star-charm prints seat-down, see that file), so its ceiling is the other
//     flank — `scr_dn` grown by the fit.
//
// So the tooth is still asymmetric, but no longer as lopsided as it was: the
// mouth flank keeps the proven 0.65 that prints at 31 degrees, and `scr_dn`
// went 0.2 -> 0.30 so the other one comes out at 41. Both are asserted, on the
// FEMALE and on the finished surface. The pitch pays for it, 2.2 -> 2.30.
//
// THIS RETIRES A TRAP. It used to matter enormously which way round the
// asymmetry went — mirror the tooth and every thread still exported, still
// mated, and printed its groove roofs at 57 degrees. With both flanks inside
// 45 that failure mode is gone, and the charm was free to be turned over.
//
// The ceiling angle is measured AFTER clearance, not before: the female is the
// male grown by `scr_fit` in both r and z, and growing radially steepens the
// flank. `scr_up_f` is therefore its own number, not `scr_up`, and the asserts
// below are written on the female.
//
// THE MALE PRINTS LYING DOWN, which is the whole reason it is a separate part.
// Standing up it would be a 9 mm tower on a 3 mm circle, every thread crest a
// tangent ledge; lying down it is a horizontal cylinder, and a horizontal
// cylinder's problem is its underside, which `scr_flat` cuts off exactly as
// `pin_flat` does for the hinge pin. Flat at `scr_flat` from the axis, both
// the crest cylinder and the collar leave the bed inside 45 degrees and the
// flat is a real 2.1 mm of first layer instead of a tangent line. The thread
// is missing over the ~90 degrees of arc the flat eats; the other 270 hold.

scr_maj     = 4.0;    // male major diameter — see the wall arithmetic above
scr_depth   = 0.4;    // radial depth of the thread
scr_pitch   = 2.30;   // lead per turn. Coarse: a fine thread on a 0.4 mm
                      //   nozzle smears into a plain cylinder. It was 2.2 —
                      //   the extra 0.1 is what pays for a printable `scr_dn`
                      //   while leaving `scr_crest_f` at its proven 0.45.
scr_crest   = 0.45;   // axial width of the crest flat. Never run a thread to
                      //   a knife edge — it meshes into slivers.
scr_up      = 0.5;    // the flank that becomes the female's CEILING
scr_dn      = 0.30;   // the other flank. It was 0.2, back when it was only
                      //   ever a floor; it is the CHARM's ceiling now, so it
                      //   has to print too. 0.30 + `scr_fit` = 0.45 on the
                      //   female, which comes out at 41 degrees.
scr_fit     = 0.15;   // clearance, radial AND axial, male to female
scr_up_f    = 0.65;   // the female's ceiling flank (see above — not `scr_up`)

scr_flat    = 1.40;   // axis to the flat the male lies on. TWO bounds, and on
                      //   an M4 they are 0.2 mm apart: it must be at most
                      //   (scr_maj/2)*cos(45) = 1.414 or the shaft leaves the
                      //   bed past 45 degrees, and below `scr_minor/2` = 1.6
                      //   so the groove roots touch the bed too and the
                      //   contact patch is continuous along the shaft. Both
                      //   asserted below. It was 1.05 on the M3.
// THE COLLAR IS COUNTERSUNK, and that is not styling. A straight hex in a
// straight pocket leaves a ledge where the pocket steps in to the thread —
// (`scr_pocket_d` - `scr_hole_maj`)/2 = 0.77 mm of annulus with nothing under
// it. On a charm printed seat-down that ledge is a CEILING, it is the first
// thing the slicer shows, and it hangs. It was shipped once and it hung.
//
// So the collar tapers and the pocket tapers with it, at the same angle, which
// turns the ledge into a countersink: the void closes in on itself as the
// nozzle climbs, exactly like the roof of a horizontal hole. The clearance
// stays `scr_pocket_fit` the whole way up because both cones have the same
// drop over the same rise.
//
// It costs nothing. The pocket now ends at the collar's top rather than
// `scr_seat_gap` above it, so the female thread starts 0.2 mm LOWER than it
// did and the joint gained a fraction of a turn.
scr_collar_af = 4.8;  // the collar: stop, seat and finger grip in one. A HEX,
scr_collar_h  = 1.4;  //   because a 4.8 mm cylinder 1.4 mm tall is nothing to
                      //   turn with; across CORNERS it is 5.54 mm, which lands
                      //   inside the bar's now-unchamfered 6.0 mm top with
                      //   0.23 mm to spare and overhangs the 4.3 mm hole by
                      //   0.62 mm a side — that overhang IS the seat. Its
                      //   flats also leave the bed at a flat 30 degrees, which
                      //   a cylinder of the same size does not.

scr_bar     = 4.45;   // thread length on the BAR end == the band's `thick`.
                      //   bracelet.scad asserts they agree.
scr_sink    = 0.25;   // how far the tip stops SHORT of the bar's underside, so
                      //   nothing ever protrudes against the wrist
scr_charm   = 3.9;    // thread length on the CHARM end
scr_lead    = 0.5;    // dead depth at the bottom of a blind bore, so the joint
                      //   comes up tight on the collar and never on the floor
scr_tip     = 0.60;   // lead-in taper at the end of a male thread. Trimmed
                      //   from 0.8 to buy back the engagement the coarser
                      //   pitch cost — see `scr_turns_bar`.

// THE BAR'S MOUTH HAS NO COUNTERBORE, and that is the second thing the wall
// check caught. The obvious way to give the collar a flat face to sit on is a
// short plain bore at the mouth, at the thread's own major diameter — and that
// puts the plain bore's wall and the thread's crest cylinder on the SAME
// CIRCLE, which meshes as a zero-thickness sliver: 290 sampled points reading
// 0.00 mm, all of them on that one plane. It is the same failure `sock_lip`
// exists to keep out of the ball socket, arriving by a different door. And the
// bar has no rim wall to spend on widening it out of trouble. So on the bar
// the thread simply runs OUT through the mouth, the collar lands on the
// 0.85 mm annulus left around the hole with the runout spiralling across it,
// and the joint gains a quarter turn of engagement rather than losing one.
//
// THE CHARM'S MOUTH IS DIFFERENT: it has a POCKET, and the pocket is the whole
// point of the current shape. The collar used to sit BETWEEN the charm and the
// bar — the charm stood off on top of it, and what you saw was a three-step
// stack of bar, hex and pad. The pocket swallows the collar instead, so the
// charm's pad comes all the way down onto the bar's top face and the screw
// disappears inside the joint.
//
// The pocket is NOT the trap above, and the difference is the only thing that
// makes it legal: it is `scr_pocket_d` = 6.04 mm across against a 4.3 mm
// crest, nowhere near the same circle, so the thread runs out onto the flat
// pocket floor exactly as it runs out onto the bar's top annulus. What it
// costs is the charm's SEAT diameter — the seat has to wall a 6.04 mm pocket
// instead of a 4.3 mm bore — and the seat is what now overhangs the bar into
// the hinge gap. See `scr_seat_d`.
//
// It costs NO height. The collar is swallowed, but the bore's mouth moves the
// same `scr_collar_h` deeper to meet it, so the cut reaches `scr_socket_h` in
// from the face that lands on the bar, wherever that face happens to be.

scr_wall    = 1.4;    // pad wall around a female thread in a charm
scr_roof    = 1.2;    // the LEAST material a charm may leave over the blind
                      //   end of its bore. It used to be a floor 2.2 thick,
                      //   because the charm was a flat plate printed face-down
                      //   and that face got engraved. Seat-down it is a roof
                      //   instead — and a bridged one, see `charm_screw_socket`
                      //   — so what it has to be is structural, not a budget.

scr_pocket_fit  = 0.25;  // radial clearance around the collar in that pocket.
                         //   The charm turns over a stationary hex, so this is
                         //   a running fit on a 12-sided sweep, not a mating
                         //   one — it only has to clear the corners.
scr_pocket_lip  = 0.3;   // straight depth at the pocket's mouth before the
                         //   countersink starts, and the matching straight
                         //   band at the bottom of the collar. It keeps the
                         //   opening crisp and the seat face square; all it
                         //   costs is countersink angle.
scr_cs_slack    = 0.2;   // how much WIDER than the thread's crest the
                         //   countersink stops. Zero would put the cone's
                         //   small end on the crest circle, which is the
                         //   coincident-surface sliver again; going NARROWER
                         //   than the crest would foul the male's thread,
                         //   because the male is at full major diameter from
                         //   the collar's top up. So it stops just outside,
                         //   and what is left is a 0.1 mm lip instead of a
                         //   0.77 mm ledge.
scr_pocket_wall = 0.9;   // wall around the POCKET, which is shallow and carries
                         //   nothing. The 1.4 mm `scr_wall` is for the threaded
                         //   bore below it; spending 1.4 here as well would
                         //   push the pad out past the star's valleys.
// There is no `scr_seat_gap` any more and none is needed. It used to hold the
// collar's flat top off a flat pocket floor so the two seats could not fight;
// with both faces conical and `scr_pocket_fit` between them at every height,
// the collar cannot bottom out at all. The joint closes on the charm's face
// against the bar, and on nothing else.
// ------------------------------------------------------------------ derived
scr_minor    = scr_maj - 2*scr_depth;          // 3.20 — the core
scr_hole_maj = scr_maj + 2*scr_fit;            // 4.30
scr_hole_min = scr_minor + 2*scr_fit;          // 3.50
scr_bore     = scr_charm + scr_lead;           // 4.40 — blind bore in a charm
scr_len      = scr_bar - scr_sink + scr_collar_h + scr_charm;   // 9.50
scr_r_out    = scr_collar_af / cos(30) / 2;    // 2.77 — across corners

// The pocket in the charm that swallows the collar, and the SEAT that has to
// wall it. The seat is sized by the POCKET, not by the bore — the bore alone
// would only ask for 7.10 — and that is the price of seating the charm on the
// bar rather than on the collar.
scr_pocket_d = 2*scr_r_out + 2*scr_pocket_fit;                  // 6.04
scr_pocket_h = scr_collar_h;                                    // 1.40 — the
                                       //   pocket ends where the collar does
scr_socket_h = scr_collar_h + scr_bore;                         // 5.80 — how
                                       //   far the whole cut reaches in from
                                       //   the seat face

// The countersink. One drop, one rise, one angle — and the collar is given the
// SAME drop over the SAME rise, which is what keeps the clearance at exactly
// `scr_pocket_fit` from the mouth to the thread instead of pinching somewhere
// in the middle.
scr_cs_rise   = scr_pocket_h - scr_pocket_lip;                          // 1.10
scr_cs_drop   = (scr_pocket_d - (scr_hole_maj + scr_cs_slack)) / 2;     // 0.77
scr_cs_ang    = atan(scr_cs_drop / scr_cs_rise);                        // 35.0
scr_collar_r2 = scr_r_out - scr_cs_drop;                                // 2.00
assert(scr_pocket_lip < scr_collar_h,
       "the pocket's straight lip is deeper than the collar is tall");
assert(scr_cs_ang <= 40,
       str("the countersink's roof closes at ", scr_cs_ang,
           " deg from vertical — lower scr_pocket_lip"));
assert(scr_collar_r2 >= scr_maj/2,
       str("the collar tapers to ", 2*scr_collar_r2,
           " across corners, narrower than the ", scr_maj,
           " thread it carries — the head would neck in"));

// The SEAT LAND — the ring of material a socket needs around it, wherever the
// socket is cut. It is not a part by itself; it is a minimum that two other
// things have to meet:
//
//   * on the BAR, `charm_screw_seat` in bracelet.scad lays a lens this wide
//     into the top chamfer, so the hole passes through full-thickness material;
//   * on the CHARM, whatever the charm's own shape is, it has to provide at
//     least this much around the socket — the pocket plus a wall.
//
// It may not be much bigger than 8.2 either: on a charm it must stay inside
// the outline at the height it is needed, and on the star the narrowest the
// outline ever gets is the valley circle at 4.28.
scr_seat_d   = 8.2;
assert(scr_seat_d >= scr_pocket_d + 2*scr_pocket_wall,
       str("the seat land is ", scr_seat_d, " and the pocket needs ",
           scr_pocket_d + 2*scr_pocket_wall));

// The BOSS a charm needs above the pocket. The pocket is only `scr_pocket_h`
// deep, so on any charm with a plate thicker than that the pocket is buried in
// the plate and the boss only has to wall the BORE. That is 1.1 mm narrower
// than the seat land, and on a 16 mm star it is the difference between a
// raised middle with the points standing clear of it and a disc with five
// spikes stuck on.
scr_boss_d   = scr_hole_maj + 2*scr_wall;                       // 7.10

// A FLAT-BOTTOMED CHARM SITS ON A PLANE, and it is worth writing down why that
// is safe, because it is the one clearance in this mount that is not a fit.
// The band's top is genuinely flat: `thick` IS `pin_z + rk`, so a knuckle cap's
// apex reaches exactly the height of a bar's top face and NOTHING on the band
// goes above it. A charm resting on that plane touches its own bar's top face
// and grazes the crest of any knuckle it happens to reach over.
//
// That does not bind the hinge. The cap is a cylinder about the PIN AXIS, so
// its envelope is the same at every angle of the joint — the crest slides
// under the charm rather than lifting it. And the neighbouring BAR, which does
// move, never gets there: its near face is `pitch - body` = 5.8 mm from this
// bar's, so it is out of reach of a 16 mm charm entirely.
//
// bracelet.scad asserts the flatness rather than assuming it.

// The female's ceilings — the only overhangs in the whole joint, and the
// numbers that decide whether a threaded hole prints clean. THERE ARE TWO of
// them now, one per flank, because the bar's hole and the charm's socket print
// the other way up from each other and so read opposite flanks as the ceiling.
//
// IT IS NOT THE FLANK ANGLE YOU DRAW. A thread flank is a helicoid, not a
// cone: it also winds, by the lead angle `atan(pitch / 2 pi r)`, and the
// steepest descent on the finished surface combines the two. Drawn at 31.6
// degrees in the axial section, this ceiling measures 31 on the exported mesh
// — close here only because the lead tilts the surface the other way about.
// Assert on the combined figure, not on `atan(scr_depth/scr_up_f)`, and check
// it against the mesh: the surface is what gets sliced.
function scr_ceil_at(r) = atan(r / sqrt(pow(scr_pitch/(2*PI), 2)
                                      + pow(scr_up_f/scr_depth, 2) * r * r));
function scr_ceil_gen(r, f) = atan(r / sqrt(pow(scr_pitch/(2*PI), 2)
                                          + pow(f/scr_depth, 2) * r * r));
scr_ceiling    = scr_ceil_gen(scr_hole_maj/2, scr_up_f);           // 31.5 deg
scr_ceiling_dn = scr_ceil_gen(scr_hole_maj/2, scr_dn + scr_fit);   // 41.3 deg
assert(scr_ceiling <= 45,
       str("the BAR's groove roof hangs at ", scr_ceiling,
           " deg from vertical — raise scr_up_f"));
assert(scr_ceiling_dn <= 45,
       str("the CHARM's groove roof hangs at ", scr_ceiling_dn,
           " deg from vertical — raise scr_dn (and scr_pitch with it)"));

// What is left of the female thread between two of its own grooves. This is
// the number the clearance eats: every millimetre of fit is taken out of it
// twice, and at zero the female thread has no crest at all.
scr_crest_f = scr_pitch - ((scr_crest + 2*scr_fit) + scr_up_f + (scr_dn + scr_fit));
assert(scr_crest_f >= 0.4,
       str("the female thread's crest is ", scr_crest_f,
           " mm wide — raise scr_pitch"));

// Engagement, in turns. Under ~1.5 a thread is a bayonet with extra steps.
scr_turns_bar   = (scr_bar - scr_sink - scr_tip) / scr_pitch;    // 1.57
scr_turns_charm = (scr_charm - scr_tip) / scr_pitch;             // 1.43
                       //   Nothing comes off the top any more: the countersink
                       //   stops level with the collar, so the female's thread
                       //   starts exactly where the male's does.
assert(scr_turns_bar >= 1.5,
       str("only ", scr_turns_bar, " turns of thread in the bar"));
assert(scr_turns_charm >= 1.25,
       str("only ", scr_turns_charm, " turns of thread in the charm"));

// The flat, and the two surfaces it has to bring down to the bed: the crest
// cylinder (the smaller radius, so the harder case) and the collar.
scr_flat_w   = 2 * sqrt(pow(scr_maj/2, 2) - pow(scr_flat, 2));       // 2.14
scr_crest_ov = 90 - acos(scr_flat / (scr_maj/2));                    // 44.4 deg
assert(scr_flat < scr_maj/2, "the flat has eaten the whole thread");
assert(scr_flat < scr_collar_af/2,
       "the flat misses the collar, so the shaft would carry the whole part");
assert(2*scr_r_out <= 6.0,
       str("the collar is ", 2*scr_r_out,
           " across corners and will not sit inside a bar's 6.0 mm top"));
assert(scr_flat <= (scr_maj/2)*cos(45) + 1e-9,
       str("the flat is only ", scr_flat,
           " from the axis — the shaft leaves the bed past 45 degrees"));
assert(scr_pocket_d > scr_hole_maj + 1.0,
       str("the pocket is ", scr_pocket_d, " across and the crest is ",
           scr_hole_maj, " — too close to the same circle"));
assert(scr_crest_ov <= 45,
       str("the shaft leaves the bed at ", scr_crest_ov,
           " deg from vertical — raise scr_flat"));

// --------------------------------------------------------------- the thread
// One period of the MALE tooth, drawn in (radius, axial) and swept along a
// helix. The inner edge is pushed well inside the core so the rib genuinely
// merges with the core cylinder instead of meeting it on a coincident face.
//
// WHICH WAY ROUND THE ASYMMETRY GOES USED TO DECIDE EVERYTHING, and getting it
// backwards cost nothing at export and everything on the plate. `scr_up`, the
// slacker flank, sits on the side of the tooth FACING THE COLLAR — on both
// ends of the screw, which is why both ends can be the same module (one is the
// other rotated 180 degrees about x, and that swaps its flanks over as well).
//
// Follow it through: the collar side of the bar-end thread points UP in the
// assembly, and up is where the bar's hole opens; the collar side of the
// charm-end thread points DOWN, and down is where the charm's socket opens.
// So in both holes the slacker flank is the one at the MOUTH end — and whether
// that is the ceiling or the floor depends on which way up the part prints.
// The bar's hole prints mouth up, so its ceiling is that flank, at 31 degrees.
// The charm prints SEAT DOWN, so its ceiling is the other one — which is why
// `scr_dn` is no longer allowed to be steep.
//
// Mirroring this tooth is therefore no longer fatal, and that is new: it used
// to export, still mate, and print its groove roofs at 57 degrees. Both flanks
// are inside 45 now (`scr_ceiling` and `scr_ceiling_dn`). Do NOT read that as
// permission to narrow `scr_dn` again to save pitch — the charm's roof is the
// only thing holding it.
// NOTE THE SIX POINTS. The obvious four-point version runs each flank
// straight on to the inner edge, and that quietly RE-CUTS THE FLANK ANGLE:
// the flank is then measured over the whole extension instead of over
// `scr_depth`, so a 38-degree flank exports as a 51-degree one and the number
// in the assert stops describing the mesh. The extension is a pair of
// HORIZONTAL tongues, at the root's own z, and it exists only so the rib
// merges with the core instead of meeting it on a coincident face.
scr_tooth = [
    [scr_minor/2 - 0.3, -(scr_crest/2 + scr_up)],
    [scr_minor/2,       -(scr_crest/2 + scr_up)],
    [scr_maj/2,         -scr_crest/2],
    [scr_maj/2,          scr_crest/2],
    [scr_minor/2,        scr_crest/2 + scr_dn],
    [scr_minor/2 - 0.3,  scr_crest/2 + scr_dn],
];

// The FEMALE tooth: the male grown by `scr_fit` in both directions, with the
// ceiling flank slackened to `scr_up_f` so the growth does not steepen it.
// Mirrored relative to the male — see above: a hole is entered from its mouth,
// so the flank at the mouth is the far side of the tooth from the male's.
scr_tooth_f = [
    [scr_minor/2 - 0.3, -(scr_crest/2 + scr_fit + scr_dn + scr_fit)],
    [scr_hole_min/2,    -(scr_crest/2 + scr_fit + scr_dn + scr_fit)],
    [scr_hole_maj/2,    -(scr_crest/2 + scr_fit)],
    [scr_hole_maj/2,     (scr_crest/2 + scr_fit)],
    [scr_hole_min/2,     (scr_crest/2 + scr_fit + scr_up_f)],
    [scr_minor/2 - 0.3,  scr_crest/2 + scr_fit + scr_up_f],
];

// A thin radial plate carrying the tooth, at step `i` of the helix.
module scr_rib(i, prof, steps)
    rotate([0, 0, i * 360/steps])
        translate([0, 0, i * scr_pitch/steps])
            rotate([90, 0, 0])
                linear_extrude(0.02, center = true) polygon(prof);

// Sweep it: hull consecutive plates, phase 0 at z = 0, overrunning both ends
// so the caller can trim it square. `steps` per turn — at 30 the chord sits
// 0.01 mm inside the true helix, under a tenth of `scr_fit`.
module scr_helix(len, prof, steps = 30) {
    n = ceil((len + 2*scr_pitch) / scr_pitch * steps);
    translate([0, 0, -scr_pitch])
        for (i = [0 : n - 1]) hull() {
            scr_rib(i, prof, steps);
            scr_rib(i + 1, prof, steps);
        }
}

// A male thread standing on z = 0, `len` long, tapered at the top so it finds
// its hole. Trimmed to exactly [0, len]; z = 0 is the collar face, and the
// helix's phase is referenced to it.
module charm_screw_male(len) {
    intersection() {
        union() {
            cylinder(d = scr_minor, h = len);
            scr_helix(len, scr_tooth);
        }
        union() {
            cylinder(d = scr_maj + 1, h = len - scr_tip);
            translate([0, 0, len - scr_tip])
                cylinder(d1 = scr_maj + 1, d2 = scr_minor - 0.4, h = scr_tip);
        }
    }
}

// The cutter for a female thread whose MOUTH is at z = 0 and which runs DOWN
// `depth`. It overruns the mouth by a full turn: the thread runs out THROUGH
// the face rather than into a counterbore (see above), and a cutter that
// stopped level with the face would leave its own truncation there.
//
// PHASE IS REFERENCED TO THE MOUTH, which is what makes the joint able to
// close at all. Reference it to the bottom of the bore instead — the obvious
// way to write it — and the two threads meet at whatever phase the bore's
// depth happens to leave, which is not the phase the collar seats at: the
// charm then jams a fraction of a turn short of its seat, and the only symptom
// is an `intersection()` that is never empty at ANY rotation.
module charm_screw_hole(depth) {
    over = scr_pitch;                       // run out through the mouth
    intersection() {
        union() {
            translate([0, 0, -depth]) cylinder(d = scr_hole_min, h = depth + over);
            translate([0, 0, -depth]) rotate([0, 0, -360*depth/scr_pitch])
                scr_helix(depth + over, scr_tooth_f);
        }
        translate([0, 0, -depth]) cylinder(d = scr_hole_maj + 1, h = depth + over);
    }
}

// The whole screw, as an ASSEMBLY: z = 0 is the collar's underside, which is
// the face that lands on the bar. THE CHARM'S PAD FACE LANDS THERE TOO, on
// the same z = 0 plane, with the whole collar up inside its pocket — that is
// what the pocket is for. The bar end runs down, the charm end up.
// The flat is at y = +scr_flat; the model file rolls it onto the bed.
module charm_screw() {
    difference() {
        union() {
            rotate([180, 0, 0]) charm_screw_male(scr_bar - scr_sink);
            cylinder(r = scr_r_out, h = scr_pocket_lip, $fn = 6);
            translate([0, 0, scr_pocket_lip])              // the countersink
                cylinder(r1 = scr_r_out, r2 = scr_collar_r2,
                         h = scr_cs_rise, $fn = 6);
            translate([0, 0, scr_collar_h]) charm_screw_male(scr_charm);
        }
        translate([-scr_r_out - 1, scr_flat, -scr_len])
            cube([2*scr_r_out + 2, scr_r_out + 1, 2*scr_len]);
    }
}

// THE SOCKET A CHARM IS BUILT AROUND — a CUTTER, not a solid. The charm is
// whatever shape it likes; this is the hole through the middle of it, entered
// from the face at z = 0 and running UP into the body. That face is the one
// that lands on the bar, and it is also the one that lands on the bed, because
// a screw-mounted charm prints seat-down.
//
// Two cuts, in the order they are met coming in from that face:
//
//   1. the POCKET — a short straight lip, then a COUNTERSINK — that swallows
//      the screw's collar. It is round and `scr_pocket_fit` clear of the hex
//      across corners at every height, so the charm turns freely over a collar
//      that is already seated in its bar.
//   2. the THREAD, whose mouth is `scr_collar_h` in from the seat face, which
//      is also exactly where the countersink stops. The male's phase is
//      referenced to the top of its collar, so the female's has to be
//      referenced to where the top of the collar lands, and when the seat face
//      is on the bar that is `scr_collar_h` in. Reference it anywhere else —
//      to the visible mouth, say — and the two threads meet out of phase and
//      the charm jams short of its seat on some screws and not on others.
//
// The runout the cutter overruns its mouth by falls inside the pocket and is
// removed with it, so the thread runs out onto the countersink's cone rather
// than ending on a face of its own.
//
// THE POCKET IS A COUNTERSINK, not a counterbore, and that is the whole point
// of `scr_cs_*`. A straight pocket steps in to the thread across 0.77 mm of
// annulus, and on a part printed seat-down that annulus is a downward-facing
// ring hanging over the bore. It was built that way once, the slicer drew it
// straight away, and it hung. The cone closes the void in on itself instead,
// at `scr_cs_ang` = 35 degrees from vertical.
//
// What is left of it is `scr_cs_slack`/2 = 0.1 mm of lip where the cone stops
// just outside the thread's crest — a quarter of a bead, and it cannot be
// closed any further without either putting the cone's small end ON the crest
// circle (a coincident-surface sliver) or inside it (which fouls the male,
// since the male is at full major diameter from the collar's top up).
//
// ONE CEILING IS LEFT and a charm that uses this module owns it: the blind end
// of the bore, a flat `scr_hole_maj` disc. That one is a 4.3 mm bridge
// anchored all the way round, it is buried in the middle of the part, and the
// band's own bore roofs are 2.9 mm of the same thing. It cannot be coned away
// — a 45-degree point over a 4.3 mm hole is 2.15 mm tall and the roof is 1.5.
module charm_screw_socket() {
    translate([0, 0, scr_collar_h]) rotate([180, 0, 0]) charm_screw_hole(scr_bore);
    translate([0, 0, -1]) cylinder(d = scr_pocket_d, h = scr_pocket_lip + 1);
    translate([0, 0, scr_pocket_lip])
        cylinder(d1 = scr_pocket_d, d2 = scr_hole_maj + scr_cs_slack,
                 h = scr_cs_rise);
}

// ======================================================================
// THE H-PIN MOUNT — a third way to hang a charm, snapped rather than screwed.
// ======================================================================
//
// A flat H. Two upright LEGS joined by a CROSSBAR, a small HOOK on every leg
// end. The lower half pushes down into a pocket in a bar and its hooks snap
// under shoulders at the foot of the pocket; the charm pushes down over the
// upper half and the upper hooks snap into it. The crossbar is sunk just below
// the bar's top face, so the charm lands flat on the bar.
//
// Everything here is named `hp_*`. The hinge already owns `pin_*`.
//
//      u ->  (across the band, assembled)          v = 0 is the bar's top face
//
//        |<   >|        upper hooks point IN, into the charm's two holes
//   -----|=====|-----   v = 0: bar top / charm seat; crossbar `hp_recess` below
//        |>   <|        lower hooks point OUT, under the pocket's shoulders
//
// THE TWO HALVES ARE THE SAME LENGTH: the upper legs reach exactly as far
// above the seat as the lower ones reach below it. The crossbar is off-centre
// (it has to sit in the bar), so the H is not symmetric, but its extents are.
//
// THE H PRINTS LYING FLAT, on its face, `hp_t` thick. Its hooks are corners of
// a 2D outline, so the pin has no overhang anywhere and its springs flex in
// the bed plane, along the perimeters.
//
// NEITHER HALF'S LEGS ARE THE SPRING — BOTH ARE TOO SHORT. A 3.45 mm leg bent
// 0.4 mm strains ~6-15 %. So the legs TURN about the crossbar's middle, and the
// CROSSBAR bends in an arc between them (`hp_strain_cb`). It is the long thin
// member of the part and carries none of the pull, which goes down the legs.
//
// WHY THE UPPER HOOKS POINT INWARD. Turning a leg moves its two ends opposite
// ways. Going into the bar the lower hooks are pushed IN, the upper ends swing
// OUT, and they are free — no charm yet. Going into the charm the upper hooks
// have to move one way and the lower ends then move the other, while the
// lower hooks are already under their shoulders. With every hook pointing out,
// that second move would drive the lower hooks deeper, straight into the
// shoulders above them: it jams. Pointing the upper hooks IN, fitting the
// charm swings the upper ends OUT and the lower ends IN — the lower hooks back
// off their shoulders a little and spring home once the charm has snapped.
//
// THE TWO CATCHES ARE DIFFERENT ANGLES, and each is forced by how its part
// prints:
//
//   * the BAR prints upright, so the lower hooks' shoulder faces DOWN — a
//     ceiling. It descends away from the slot at 45 degrees, the material
//     closing in over the chamber like a hole's roof. 45 is a detent, but it
//     never has to be more: the lower hooks can only let go by turning the
//     legs, and while a charm is on, the charm holds the upper ends.
//   * the CHARM prints SEAT DOWN, so the upper hooks' shoulder is a FLOOR and
//     may be any angle. `hp_catch_up` is steeper than 45 on purpose: that is
//     what makes the charm hold. It is the one tuning number of this mount.
//     What goes the other way is the far end of each hole, now a ceiling:
//     it is roofed with a 45-degree gable.

hp_t      = 2.8;    // the H's thickness: its print height, and its extent
                    //   ALONG the band once assembled
hp_leg_w  = 1.0;    // a leg, across
hp_s      = 4.5;    // a leg's centre off the H's axis
hp_cb_h   = 0.8;    // the crossbar, top to bottom — THE spring. Meant to be
                    //   under the 1.2 mm wall threshold, like the clasp's leaf.
hp_recess = 0.3;    // how far the crossbar's top sits below the bar's top face
hp_fillet = 0.3;    // inside corners where the crossbar meets a leg — the
                    //   spring's roots. recess >= fillet keeps the fillets
                    //   below the charm's seat face (asserted).

hp_hook   = 0.55;   // how far a hook stands out from its leg
hp_lead   = 35;     // lead-in, degrees from vertical: steeper = easier in
hp_tip    = 0.3;    // straight flat at the hook's edge, never a point
hp_catch_up = 55;   // the UPPER catch, degrees from vertical. 45 = a light
                    //   detent (the charm pulls off easily); 55 needs a firm
                    //   tug, ~25-55 N depending on friction; past ~60 the
                    //   friction locks it and the charm is on for good.
hp_fit    = 0.15;   // clearance: a hook's tip to its chamber, a leg to its
                    //   slot, and the H's faces to the slots along the band
hp_vfit   = 0.15;   // vertical play between a seated hook and its shoulder
hp_gap    = 0.2;    // a leg's end to the far end of its hole

hp_bar    = 4.45;   // the bar's thickness == the band's `thick`, asserted there
hp_floor  = 0.8;    // bar left under the pocket — it never reaches the first
                    //   layer
hp_wall   = 1.2;    // charm wall around its two holes

// ------------------------------------------------------------------ derived
hp_uo     = hp_s + hp_leg_w/2;                  // 5.00 — leg's outer face
hp_ui     = hp_s - hp_leg_w/2;                  // 4.00 — leg's inner face
hp_lr     = hp_hook / tan(hp_lead);             // 0.79 — lead-in rise
hp_cr     = hp_hook / tan(hp_catch_up);         // 0.39 — upper catch rise
hp_defl   = hp_hook - hp_fit;                   // 0.40 — how far a hook has to
                                                //   move to pass its slot's wall

hp_cb_top = -hp_recess;                         // -0.30
hp_cb_bot = hp_cb_top - hp_cb_h;                // -1.10
hp_v_fl   = hp_floor - hp_bar;                  // -3.65 — the pocket's floor
hp_v_end  = hp_v_fl + hp_gap;                   // -3.45 — lower leg's end
hp_v_lt   = hp_v_end + hp_lr + hp_tip;          // -2.36 — lower hook's tip top
hp_v_lc   = hp_v_lt + hp_hook;                  // -1.81 — lower catch meets leg
hp_v_top  = -hp_v_end;                          //  3.45 — AS SHORT AS THE BOTTOM
hp_v_ut   = hp_v_top - hp_lr - hp_tip;          //  2.36 — upper hook's tip bottom
hp_v_uc   = hp_v_ut - hp_cr;                    //  1.98 — upper catch meets leg

// The spring. The legs turn about the crossbar's middle and the crossbar bends
// in a pure arc, strain = angle * depth / length. Going into the bar the lever
// is the short one (pivot -> lower hook), so that insertion sets the strain;
// going into the charm the lever is longer and the turn smaller.
hp_pivot  = (hp_cb_top + hp_cb_bot)/2;
hp_arm_lo = hp_pivot - (hp_v_end + hp_lr + hp_tip/2);
hp_arm_up = (hp_v_ut + hp_tip/2) - hp_pivot;
hp_turn_lo = hp_defl / hp_arm_lo;
hp_turn_up = hp_defl / hp_arm_up;
hp_cb_len = 2*hp_ui;
hp_strain_cb = max(hp_turn_lo, hp_turn_up) * hp_cb_h / hp_cb_len;
// A turning leg's END swings further than its hook, so each hole leaves room
// on the side the end swings to: INSIDE the lower legs (bar), OUTSIDE the
// upper legs (charm).
hp_room_lo = hp_turn_lo * (hp_pivot - hp_v_end) + 0.1;   // 0.72
hp_room_up = hp_turn_up * (hp_v_top - hp_pivot) + 0.1;   // 0.62

hp_slot_x = hp_t + 2*hp_fit;                    // 3.10 — every slot, along the band
hp_out    = hp_uo + hp_hook + hp_fit;           // 5.70 — a bar chamber's outer wall
hp_c_out  = hp_uo + hp_room_up;                 // a charm hole's outer wall
hp_c_in   = hp_ui - hp_hook - hp_fit;           // 3.30 — a charm chamber's inner wall
hp_roof   = hp_v_top + hp_gap;                  // 3.65 — a charm hole's eaves
hp_apex   = hp_roof + hp_slot_x/2;              // 5.20 — and the gable's ridge
hp_boss_x = hp_slot_x + 2*hp_wall;              // 5.50
hp_boss_u = 2*hp_c_out + 2*hp_wall;

assert(hp_lead < 45, "the hook's lead-in is flatter than its catch — it would hold going IN");
assert(hp_catch_up >= 45 && hp_catch_up <= 60,
       str("hp_catch_up = ", hp_catch_up, ": under 45 the charm falls off, past 60 friction locks it on"));
assert(hp_v_lc < hp_cb_bot - 0.3,
       str("the lower hook runs into the crossbar: catch top ", hp_v_lc,
           ", crossbar bottom ", hp_cb_bot));
assert(hp_v_uc - hp_vfit >= 1.0,
       str("only ", hp_v_uc - hp_vfit, " mm of charm under the upper hooks' shoulders"));
assert(hp_recess >= hp_fillet,
       "the crossbar's fillets stand above the bar's top face and into the charm");
assert(hp_strain_cb <= 0.029,
       str("the crossbar bends to ", 100*hp_strain_cb,
           "% — past the 2.9% this project's flexures run at"));
assert(hp_room_lo < hp_ui - hp_fillet - 0.8,
       "the legs' inward room eats the bar between the two leg slots");
assert(hp_c_in > hp_cb_len/2 - hp_ui + 2.0, "the charm's two chambers meet in the middle");
assert(hp_defl > 0.3, "the hooks barely overlap their shoulders");

// ----------------------------------------------------------------- the pin
// One leg, the one at +u, in (u, v): lower hook OUT, upper hook IN. The left
// leg is its mirror.
function hp_leg_pts() = [
    [hp_ui,           hp_v_end],
    [hp_uo,           hp_v_end],
    [hp_uo + hp_hook, hp_v_end + hp_lr],             // lower lead-in
    [hp_uo + hp_hook, hp_v_lt],                      // tip flat
    [hp_uo,           hp_v_lc],                      // 45-degree catch
    [hp_uo,           hp_v_top],
    [hp_ui,           hp_v_top],
    [hp_ui - hp_hook, hp_v_top - hp_lr],             // upper lead-in
    [hp_ui - hp_hook, hp_v_ut],                      // tip flat
    [hp_ui,           hp_v_uc],                      // `hp_catch_up` catch
];

module hp_pin_raw_2d() union() {
    polygon(hp_leg_pts());
    mirror([1, 0]) polygon(hp_leg_pts());
    translate([-hp_ui - 0.3, hp_cb_bot]) square([2*hp_ui + 0.6, hp_cb_h]);
}

// The H's outline, in (u, v). The four inside corners where the crossbar
// meets the legs are filleted — they are the spring's roots — and ONLY those:
// a closing pass over the whole outline would also fill the root of every
// catch by a few hundredths and eat the hooks' clearance there.
module hp_pin_2d() union() {
    hp_pin_raw_2d();
    intersection() {
        offset(r = -hp_fillet) offset(r = hp_fillet) hp_pin_raw_2d();
        translate([-hp_ui, hp_cb_bot - 2*hp_fillet])
            square([2*hp_ui, hp_cb_h + 4*hp_fillet]);
    }
}

// An (u, v) outline stood up in 3D: x = along the band (the extrusion,
// centred), y = u, z = v.
module hp_stand(w) rotate([90, 0, 90]) linear_extrude(w, center = true) children();

// The pin, ASSEMBLED: z = 0 is the bar's top face. models/charm-h-pin lays
// it flat for printing.
module charm_h_pin() hp_stand(hp_t) hp_pin_2d();

// ------------------------------------------------------------- the cutters
// The bar's pocket, one side, in (u, v). The shoulder over the chamber
// descends OUTWARD at 45 degrees — `hp_vfit` above the hook's catch — so as the
// bar prints upward the material closes in over the chamber and there is no
// ceiling. The mouth is chamfered `hp_fit` outward so the hooks find it.
function hp_bar_pocket_pts() = [
    [hp_ui - hp_room_lo, hp_v_fl],
    [hp_out,             hp_v_fl],
    [hp_out,             hp_v_lt + hp_vfit - hp_fit],
    [hp_uo + hp_fit,     hp_v_lc + hp_vfit - hp_fit],
    [hp_uo + hp_fit,     -0.4],
    [hp_uo + 2*hp_fit,   0],
    [hp_uo + 2*hp_fit,   1],
    [hp_ui - hp_room_lo, 1],
];

// The pocket, cut DOWN from z = 0 (a bar's top face): two leg slots with a
// chamber at the foot of each, joined across the top by the crossbar's slot.
// The crossbar's slot floor is the stop the H is pushed down onto.
module charm_h_pocket() hp_stand(hp_slot_x) union() {
    polygon(hp_bar_pocket_pts());
    mirror([1, 0]) polygon(hp_bar_pocket_pts());
    translate([-hp_uo, hp_cb_bot]) square([2*hp_uo, 1 - hp_cb_bot]);
}

// A charm's hole, one side, in the charm's ASSEMBLED frame — which is also
// its PRINT frame, since it prints seat down: v = 0 is the seat, the hole runs
// up. The chamber is on the INSIDE (the upper hooks point in): its floor is the
// shoulder, `hp_vfit` under the catch and at the catch's own angle; its roof
// follows the hook's lead-in down and inward, the material growing out from
// the chamber's inner wall at `hp_lead` from vertical. Over the leg the hole
// stops at flat eaves, and `charm_h_holes` puts a 45-degree gable on them.
function hp_c_sh(u) = hp_v_uc + (hp_ui - u) * hp_cr / hp_hook - hp_vfit;
function hp_c_rf(u) = hp_roof - (hp_ui - u) / tan(hp_lead);
function hp_charm_hole_pts() = [
    [hp_ui - hp_fit, -1],
    [hp_c_out,       -1],
    [hp_c_out,       hp_roof],
    [hp_ui - hp_fit, hp_roof],
    [hp_ui - hp_fit, hp_c_rf(hp_ui - hp_fit)],
    [hp_c_in,        hp_c_rf(hp_c_in)],
    [hp_c_in,        hp_c_sh(hp_c_in)],
    [hp_ui - hp_fit, hp_c_sh(hp_ui - hp_fit)],
];
assert(hp_c_rf(hp_c_in) - hp_c_sh(hp_c_in) >= 0.2,
       "the charm's chamber pinches shut at its inner wall");

// The two holes, cut UP from z = 0 (the charm's seat face).
module charm_h_holes() {
    hp_stand(hp_slot_x) {
        polygon(hp_charm_hole_pts());
        mirror([1, 0]) polygon(hp_charm_hole_pts());
    }
    // the gables: 45-degree roofs over each leg's end, running along u
    for (s = [-1, 1])
        translate([0, s*(hp_ui - hp_fit + hp_c_out)/2, 0])
            rotate([90, 0, 0])
                linear_extrude(hp_c_out - (hp_ui - hp_fit), center = true)
                    // walls carried a millimetre down into the hole, so the
                    // gable meets them square instead of leaving a ledge
                    polygon([[-hp_slot_x/2, hp_roof - 1], [hp_slot_x/2, hp_roof - 1],
                             [ hp_slot_x/2, hp_roof], [0, hp_apex],
                             [-hp_slot_x/2, hp_roof]]);
}

// The least a charm must be around those holes, in plan: x along the band,
// y = u. `hp_apex + hp_wall` is the least it must be tall over them.
module charm_h_boss_2d()
    offset(r = hp_wall) square([hp_slot_x, 2*hp_c_out], center = true);
