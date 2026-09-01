// wheel — one road wheel. Four per platform.
//
// It prints lying on its outer face with the snap peg pointing straight up,
// which is the whole reason the peg lives on the wheel rather than on the
// chassis: every surface of the joint is then either a vertical wall or an
// upward-facing taper, and the one downward face (the retaining shoulder) is a
// 37 deg cone. Nothing here needs support.
//
// Push it into the platform's flank until it clicks. It turns on the peg shaft
// inside the platform's 12 mm journal.
//
// Every dimension lives in ../../lib/common.scad.

include <../../lib/common.scad>

// Peg stations, measured up from the outer face (the print bed).
boss_top   = wheel_w + wheel_boss_h;
// The shaft has to span what is left of the side clearance plus the full wall.
shaft_top  = boss_top + (wheel_gap - wheel_boss_h) + axle_neck_l;
retain_top = shaft_top + axle_retain_h;
peg_top    = retain_top + axle_lead_h;

// ---------------------------------------------------------------------------

// The road wheel itself: a barrel with both rim edges broken. The lower break
// is a 45 deg ramp growing straight off the plate.
module disc() {
    hull() {
        cylinder(h = 0.01, d = wheel_dia - 2*wheel_cham);
        translate([0, 0, wheel_cham])
            cylinder(h = wheel_w - 2*wheel_cham, d = wheel_dia);
        translate([0, 0, wheel_w - 0.01])
            cylinder(h = 0.01, d = wheel_dia - 2*wheel_cham);
    }
}

// The snap peg. Read bottom to top: a boss that carries the rubbing face, the
// shaft the wheel turns on, the retaining cone that catches behind the wall,
// and a long shallow ramp that is what makes it easy to push in.
module peg() {
    // rubbing boss — the wheel rides on a 16 mm ring rather than its whole
    // 34 mm face, and the ring has to land OUTSIDE the socket's flared mouth
    cylinder(h = boss_top, d = wheel_boss_d);
    cylinder(h = shaft_top, d = axle_d);
    translate([0, 0, shaft_top])
        cylinder(h = axle_retain_h, d1 = axle_d, d2 = axle_barb_d);
    translate([0, 0, retain_top])
        cylinder(h = axle_lead_h, d1 = axle_barb_d, d2 = axle_tip_d);
}

// The slit that lets the barb through a hole smaller than itself.
//
// Two things about it are load-bearing, both learned from a broken print:
//
//   * Its FLOOR is rounded, not square. A square-cornered slit bottom is a
//     stress riser sitting exactly where the finger is most highly stressed,
//     in a direction (across the print layers) where PLA is brittle. This is
//     where the first version failed.
//   * It runs from well down inside the disc, because the fingers' length is
//     what keeps the strain low — and it must be longer than the BOSS is wide,
//     or a hair-thin web of boss bridges the two fingers and stiffens the snap.
module slit() {
    len = wheel_boss_d + 2;
    hull() {
        translate([0, 0, axle_slot_z + axle_slot_r])
            rotate([0, 90, 0])
                cylinder(h = len, r = axle_slot_r, center = true);
        translate([0, 0, peg_top + 1])
            cube([len, axle_slot_w, 0.01], center = true);
    }
}

module wheel() {
    difference() {
        union() {
            disc();
            peg();
        }
        slit();
    }
}

wheel();
