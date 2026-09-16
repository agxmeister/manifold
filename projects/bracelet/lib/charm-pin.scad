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
