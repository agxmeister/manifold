// flower-charm — a six-petalled flower that snaps onto a bracelet charm pin.
//
// The first charm, and the pattern every other one should follow: a flat
// decorative plate, printed FACE DOWN on the bed, with the socket boss rising
// from its back. That orientation is not a preference, it is the whole design:
//
//   * the socket cavity has to close in on itself as the nozzle climbs, so the
//     mouth must point UP while printing (see lib/charm-pin.scad). The mouth is
//     on the back of the charm, so the back points up and the face lies on the
//     plate.
//   * which is where you want the face anyway. Detail on the bed face comes
//     out crisp and flat; the same detail on top would be a stack of tiny
//     overhangs. So the flower is ENGRAVED, not embossed.
//
// Flip it over to wear it: the boss drops onto the pin, the flower faces out.
// Nothing here needs support and nothing bridges.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-pin.scad>

// ------------------------------------------------------------------- flower
petals      = 6;
flower_d    = 16;    // tip to tip. The bracelet spaces charm stations by this
                     //   number — keep `charm_reach` in bracelet.scad in step.
plate       = 2.2;   // plate thickness
tip_d       = 3.0;   // width at a petal's tip — a rounded tip, not a point, so
                     //   there is never less than this much wall anywhere
root_d      = 5.4;   // and at its root
tip_r       = flower_d/2 - tip_d/2;                 // 6.5 — tip circle centre
root_r      = 2.6;                                  //       root circle centre

hub_d       = sock_od + 1.0;                        // 8.2 — the plate under the
                                                    //   boss, a little proud of
                                                    //   it so the boss has a
                                                    //   shoulder to stand on

// The flower's eye: a countersunk dimple in the FACE, cut at 45 degrees so it
// has no flat roof to bridge — the same trick as the ball's underside, upside
// down. It has to stay inside the hub and clear of the socket's floor, which
// is what the two asserts are.
//
// Everything else on this face is left plain, and that is deliberate. A groove
// that opens onto the bed SPLITS THE FIRST LAYER into separate islands, and a
// groove anywhere under the boss eats into the socket's floor — the first
// version of this file did both, turned one 131 mm² island into twelve (four
// of them 0.0 mm²), and left a 0.05 mm sliver of wall beside the boss.
// Decoration on a charm belongs outside r = sock_od/2, and there is no room
// for any on a flower this size.
eye_d       = 2.8;   // the dimple's mouth
eye_tip     = 1.0;   // and its floor — a truncated cone, not a point. A cone
                     //   run to a true apex meshes into slivers there.
eye_z       = (eye_d - eye_tip)/2;                  // 0.90 — 45 deg walls
assert(cav_bottom - eye_z >= 1.2, "the eye cuts too far into the socket floor");
assert(eye_d < hub_d - 2, "the eye reaches past the hub");
assert(tip_d >= 1.2, "petal tips are thinner than a printable wall");

echo(str("flower ", flower_d, " mm across, ", plate, " mm plate, ",
         sock_h, " mm tall printed"));
echo(str("socket: cavity d", cav_d, " mouth d", mouth_d, " over a d", charm_ball,
         " ball — ", charm_grip, " mm of grip per side, ", sock_slits, " slits"));
echo(str("swivel ", charm_tilt, " deg off axis, free spin"));

// ----------------------------------------------------------------- geometry

// One petal, in plan: a teardrop from `root_d` at the hub to `tip_d` at the rim.
module petal_2d() {
    hull() {
        translate([root_r, 0]) circle(d = root_d);
        translate([tip_r,  0]) circle(d = tip_d);
    }
}

module flower_2d() {
    union() {
        circle(d = hub_d);
        for (i = [0 : petals - 1]) rotate([0, 0, i * 360/petals]) petal_2d();
    }
}

module eye() {
    translate([0, 0, -0.01])
        cylinder(d1 = eye_d, d2 = eye_tip, h = eye_z + 0.01);
}

module flower_charm() {
    difference() {
        union() {
            linear_extrude(plate) flower_2d();
            charm_socket(plate);               // boss: z = 0 .. sock_h
        }
        eye();
    }
}

flower_charm();
