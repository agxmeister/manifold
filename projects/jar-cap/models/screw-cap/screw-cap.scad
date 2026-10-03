// screw-cap — the cap that screws onto the collar.
//
// The internal thread runs the full skirt; screwing down pulls the collar up
// under the flange and the ceiling's seal bead down on top of it, clamping the
// flange between the two. There is no hard stop: the squeezed flange is the
// stop, so it tightens the same on any jar.

include <../../lib/common.scad>

/* [Body] */
thread_wall = 2.0;  // skirt wall outside the thread's root

skirt_h  = -flange_bot_z + thread_l;          // covers the whole collar thread
skirt_ro = thread_d / 2 + thread_dep + thread_wall;

module screw_cap() {
    difference() {
        cap_shell(thread_minor / 2, skirt_h, ro = skirt_ro);
        translate([0, 0, -skirt_h - 0.01])
            trapezoidal_threaded_rod(
                d = thread_d, l = skirt_h + 0.01, pitch = thread_p,
                thread_angle = thread_a, thread_depth = thread_dep,
                internal = true, bevel1 = 1, bevel2 = false, lead_in_ang = 45,
                anchor = BOTTOM, $slop = thread_slop, $fn = 160);
    }
    seal_bead();
}

print = true;   // -D print=false to include this file without placing a part
if (print) cap_print_pose() screw_cap();
