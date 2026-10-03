// collar — the jar's missing thread.
//
// A ring that slides up the jar from its narrow bottom and stops under the
// flange, gripping the straight top of the wall lightly so it stays there.
// Its top face carries the flange from below and its outside is the external
// thread the screw-cap runs on; a ribbed band below the thread is where you
// hold it while screwing the cap on.

include <../../lib/common.scad>

/* [Fit] */
bore_fit = -0.2;    // bore minus jar wall diameter: negative grips the wall

/* [Body] */
grip_h  = 6;        // ribbed band below the thread
grip_ribs = 48;

bore_d   = neck_d + bore_fit;
collar_h = thread_l + grip_h;

assert(bore_d < flange_d - 2, "bore would let the flange through");

// In the use frame the collar's top face is against the flange's bottom.
module collar() {
    translate([0, 0, flange_bot_z - collar_h])
    difference() {
        union() {
            translate([0, 0, grip_h])
                trapezoidal_threaded_rod(
                    d = thread_d, l = thread_l, pitch = thread_p,
                    thread_angle = thread_a, thread_depth = thread_dep,
                    bevel1 = false, bevel2 = 1, lead_in_ang = 45,
                    anchor = BOTTOM, $fn = 160);
            cylinder(d = thread_d, h = grip_h + 0.01);
            for (i = [0:grip_ribs-1]) rotate(i * 360 / grip_ribs)
                translate([thread_d / 2, 0, 0])
                    cylinder(r = 1, h = grip_h, $fn = 16);
        }
        translate([0, 0, -1]) cylinder(d = bore_d, h = collar_h + 2);
        // eases the collar over the jar as it slides up
        translate([0, 0, collar_h - 0.6]) cylinder(d1 = bore_d, d2 = bore_d + 1.2, h = 0.61);
    }
}

// Print pose: on its bottom face, thread vertical.
print = true;   // -D print=false to include this file without placing a part
if (print) translate([0, 0, -(flange_bot_z - collar_h)]) collar();
