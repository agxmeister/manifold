// screw — the threaded spindle with its tommy lever moulded on.
//
// The lever is part of the screw rather than a press-fit handle: the spindle
// threads in from below and the lever never has to pass through the boss, so
// there is no reason to split it — and keeping it integral removes the one
// joint that would have to carry the tightening torque.
//
// That also settles the print orientation. Standing on the lever, the whole
// part has an 84 mm flat footprint, the thread's 40-degree flanks self-support
// all the way up, and the ball on top is the only overhang.

include <common.scad>

// Print orientation: as used, standing on the lever.
clamp_screw();

shank_z0 = lever_t + (lever_w - 4 - thread_d) / 2;   // 45-degree cone between
shank_z1 = shank_z0 + screw_shank;

module clamp_screw() {
    lever();
    // 45-degree cone from the lever up to the shank — no overhang, and it
    // doubles as the stop that limits how far the screw can be run in.
    translate([0, 0, lever_t - 0.01])
        cylinder(d1 = lever_w - 4, d2 = thread_d, h = shank_z0 - lever_t + 0.01);
    shank();
    ball_tip();
}

// A stadium-shaped bar, extruded flat, with grip grooves scooped out of the
// top face. Its half-length stays clear of the bar at full throat.
//
// The grooves start outboard of the cone's 22 mm base — a groove passing under
// the cone would leave the cone's flat underside bridging over the void, the
// one avoidable overhang on this part. They also land where fingers actually
// go.
module lever() {
    difference() {
        linear_extrude(lever_t) lever_outline();
        for (s = [-1, 1], i = [0 : 2])
            translate([s * (14 + i * 6), 0, lever_t + 2.2])
                rotate([90, 0, 0])
                    cylinder(d = 6, h = lever_w + 2, center = true);
    }
}

module lever_outline() {
    hull() for (s = [-1, 1])
        translate([s * (lever_l - lever_w) / 2, 0]) circle(d = lever_w);
}

module shank() {
    translate([0, 0, shank_z0])
        trapezoidal_threaded_rod(
            d = thread_d, l = screw_shank, pitch = thread_p,
            thread_angle = thread_a, thread_depth = thread_dep,
            anchor = BOTTOM, bevel2 = true,
            $fn = 48);
}

// Waist plus ball for the swivel pad. The sphere breaks out of the neck at
// about 46 degrees from vertical and only gets shallower going up, so it
// bridges without support.
module ball_tip() {
    translate([0, 0, shank_z1 - 0.5]) cylinder(d = neck_d, h = neck_h + 0.5);
    translate([0, 0, shank_z1 + ball_up]) sphere(d = ball_d);
}
