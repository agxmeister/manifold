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
// bar, and a bar is `body` = 6.0 mm along the band and only 5.0 mm across its
// flat top once the chamfer has taken its 0.5 mm a side. So the hole's major
// diameter is bounded by the WALL it leaves at that chamfered rim, which is
// the thinnest vertical wall the screw mount adds:
//
//     major 3.0 + 2 x fit = 3.3 hole -> (5.0 - 3.3)/2 = 0.85 mm at the rim,
//                                       (6.0 - 3.3)/2 = 1.35 mm below it.
//
// 0.85 mm is two perimeters at a 0.4 mm nozzle and is deliberately the floor
// here — `knuck_wall` = 0.9 elsewhere in the band. Do not fatten the thread
// without shrinking the chamfer or widening the bar; the rim is what pays.
//
// THE THREAD PROFILE IS ASYMMETRIC ON PURPOSE. A female thread cut into a bar
// prints with its axis VERTICAL, so one flank of every groove is a CEILING and
// the other is a floor. Only the ceiling is an overhang, so only the ceiling
// has to stay inside 45 degrees — and buying that on both flanks would cost
// roughly twice the pitch. The male's up-facing flank (`scr_up`) is the one
// that becomes that ceiling, and it is the flank that is slackened.
//
// The ceiling angle is measured AFTER clearance, not before: the female is the
// male grown by `scr_fit` in both r and z, and growing radially steepens the
// flank. `scr_up_f` is therefore its own number, not `scr_up`, and the assert
// below is written on the female.
//
// THE MALE PRINTS LYING DOWN, which is the whole reason it is a separate part.
// Standing up it would be a 9 mm tower on a 3 mm circle, every thread crest a
// tangent ledge; lying down it is a horizontal cylinder, and a horizontal
// cylinder's problem is its underside, which `scr_flat` cuts off exactly as
// `pin_flat` does for the hinge pin. Flat at `scr_flat` from the axis, both
// the crest cylinder and the collar leave the bed inside 45 degrees and the
// flat is a real 2.1 mm of first layer instead of a tangent line. The thread
// is missing over the ~90 degrees of arc the flat eats; the other 270 hold.

scr_maj     = 3.0;    // male major diameter — see the wall arithmetic above
scr_depth   = 0.4;    // radial depth of the thread
scr_pitch   = 2.2;    // lead per turn. Coarse: a fine thread on a 0.4 mm
                      //   nozzle smears into a plain cylinder.
scr_crest   = 0.45;   // axial width of the crest flat. Never run a thread to
                      //   a knife edge — it meshes into slivers.
scr_up      = 0.5;    // the flank that becomes the female's CEILING
scr_dn      = 0.2;    // the flank that becomes the female's floor — faces up
                      //   in the print, so it may be as steep as it likes
scr_fit     = 0.15;   // clearance, radial AND axial, male to female
scr_up_f    = 0.65;   // the female's ceiling flank (see above — not `scr_up`)

scr_flat    = 1.05;   // axis to the flat the male lies on. Below `scr_minor/2`
                      //   by a hair, so the groove roots touch the bed too and
                      //   the contact patch is continuous along the shaft.
scr_collar_af = 4.2;  // the collar: stop, seat and finger grip in one. A HEX,
scr_collar_h  = 1.4;  //   because a 4 mm cylinder 1.4 mm tall is nothing to
                      //   turn with; across CORNERS it is 4.85 mm, which still
                      //   lands inside the bar's 5.0 mm flat top. Its flats
                      //   also leave the bed at a flat 30 degrees, which a
                      //   cylinder of the same size does not.

scr_bar     = 4.45;   // thread length on the BAR end == the band's `thick`.
                      //   bracelet.scad asserts they agree.
scr_sink    = 0.25;   // how far the tip stops SHORT of the bar's underside, so
                      //   nothing ever protrudes against the wrist
scr_charm   = 3.9;    // thread length on the CHARM end
scr_lead    = 0.5;    // dead depth at the bottom of a blind bore, so the joint
                      //   comes up tight on the collar and never on the floor
scr_tip     = 0.8;    // lead-in taper at the end of a male thread

// THERE IS NO COUNTERBORE AT EITHER MOUTH, and that is the second thing the
// wall check caught. The obvious way to give the collar a flat face to sit on
// is a short plain bore at the mouth, at the thread's own major diameter — and
// that puts the plain bore's wall and the thread's crest cylinder on the SAME
// CIRCLE, which meshes as a zero-thickness sliver: 290 sampled points reading
// 0.00 mm, all of them on that one plane. It is the same failure `sock_lip`
// exists to keep out of the ball socket, arriving by a different door.
//
// Widening the counterbore past the crest fixes the sliver and spends the bar's
// rim wall, which is the one dimension here with nothing to spare. So the
// thread simply runs OUT through the mouth instead. The collar lands on the
// annulus left around the hole — 0.85 mm of it on a bar, 1.4 on a charm's pad
// — with the thread's runout spiralling across it, and the joint gains a
// quarter turn of engagement rather than losing one.

scr_wall    = 1.4;    // pad wall around a female thread in a charm
scr_floor   = 2.2;    // material left under a blind bore in a charm. Equal to
                      //   the plate, so `charm_cut_max` is the same 1.0 mm
                      //   under the pad as it is out on the open face.

// ------------------------------------------------------------------ derived
scr_minor    = scr_maj - 2*scr_depth;          // 2.2 — the core
scr_hole_maj = scr_maj + 2*scr_fit;            // 3.30
scr_hole_min = scr_minor + 2*scr_fit;          // 2.50
scr_pad_d    = scr_hole_maj + 2*scr_wall;      // 6.10
scr_bore     = scr_charm + scr_lead;           // 3.80 — blind bore in a charm
scr_len      = scr_bar - scr_sink + scr_collar_h + scr_charm;   // 9.90
scr_r_out    = scr_collar_af / cos(30) / 2;    // 2.42 — across corners
function scr_pad_h(plate) = scr_bore + scr_floor - plate;

// The engraving budget on a screw-mounted charm, the counterpart of
// `charm_cut_max` above. `scr_floor` is deliberately set equal to the plate,
// so this comes out at the same 1.0 mm everywhere on the face — under the pad
// and out on the open plate alike — and one number governs a charm again.
function charm_screw_cut_max(plate) = min(plate, scr_floor) - 1.2;

// The female's ceiling — the one overhang in the whole joint, and the number
// that decides whether a threaded hole prints clean.
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
scr_ceiling = scr_ceil_at(scr_hole_maj/2);                     // 31.4 deg
assert(scr_ceiling <= 45,
       str("the female thread's ceiling hangs at ", scr_ceiling,
           " deg from vertical — raise scr_up_f"));

// What is left of the female thread between two of its own grooves. This is
// the number the clearance eats: every millimetre of fit is taken out of it
// twice, and at zero the female thread has no crest at all.
scr_crest_f = scr_pitch - ((scr_crest + 2*scr_fit) + scr_up_f + (scr_dn + scr_fit));
assert(scr_crest_f >= 0.4,
       str("the female thread's crest is ", scr_crest_f,
           " mm wide — raise scr_pitch"));

// Engagement, in turns. Under ~1.5 a thread is a bayonet with extra steps.
scr_turns_bar   = (scr_bar - scr_sink - scr_tip) / scr_pitch;    // 1.55
scr_turns_charm = (scr_charm - scr_tip) / scr_pitch;             // 1.41
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
assert(2*scr_r_out <= 5.0,
       str("the collar is ", 2*scr_r_out,
           " across corners and will not sit inside a bar's 5.0 mm top"));
assert(scr_crest_ov <= 45,
       str("the shaft leaves the bed at ", scr_crest_ov,
           " deg from vertical — raise scr_flat"));

// --------------------------------------------------------------- the thread
// One period of the MALE tooth, drawn in (radius, axial) and swept along a
// helix. The inner edge is pushed well inside the core so the rib genuinely
// merges with the core cylinder instead of meeting it on a coincident face.
//
// WHICH WAY ROUND THE ASYMMETRY GOES IS NOT FREE, and getting it backwards
// costs nothing at export and everything on the plate. `scr_up`, the slack
// flank, sits on the side of the tooth FACING THE COLLAR — on both ends of the
// screw, which is why both ends can be the same module (one is the other
// rotated 180 degrees about x, and that swaps its flanks over as well).
//
// Follow it through: the collar side of the bar-end thread points UP in the
// assembly, and up is where the bar's hole opens; the collar side of the
// charm-end thread points DOWN, and down is where the charm's bore opens
// once the charm is flipped over to wear. So in both holes the slack flank is
// the one at the MOUTH end — and the mouth end is up in the print, because
// both holes are bored downwards from a face that prints upwards. The slack
// flank is therefore the ceiling of every groove, in both parts, which is the
// only surface in the joint that overhangs at all.
//
// Mirror this tooth and every thread in the project still exports, still
// mates, and prints its groove roofs at 57 degrees.
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
// the face that lands on the bar. The bar end runs down, the charm end up.
// The flat is at y = +scr_flat; the model file rolls it onto the bed.
module charm_screw() {
    difference() {
        union() {
            rotate([180, 0, 0]) charm_screw_male(scr_bar - scr_sink);
            cylinder(r = scr_r_out, h = scr_collar_h, $fn = 6);
            translate([0, 0, scr_collar_h]) charm_screw_male(scr_charm);
        }
        translate([-scr_r_out - 1, scr_flat, -scr_len])
            cube([2*scr_r_out + 2, scr_r_out + 1, 2*scr_len]);
    }
}

// The pad on the back of a charm: a boss with a blind threaded bore, standing
// on z = 0 with its seat face — the one that meets the collar — on top.
module charm_screw_pad(plate) {
    h = scr_pad_h(plate);
    assert(h > 0, str("the charm's plate is thicker than the whole pad: ", h));
    difference() {
        cylinder(d = scr_pad_d, h = h);
        translate([0, 0, h]) charm_screw_hole(scr_bore);
    }
}
