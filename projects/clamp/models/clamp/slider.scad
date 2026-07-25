// slider — the sliding jaw: a collar that rides the bar, an arm, and a boss
// carrying the screw thread.
//
// It prints exactly as it is used, standing on its flat underside. That puts
// both bores on the build axis: the square bar bore and the internal thread
// are vertical, which is the only orientation in which a printed thread comes
// out clean. The one sideways hole — the pin bore through the collar — is a
// teardrop so its crown does not sag.

include <common.scad>

// Print orientation: as used, flat on the bed.
clamp_slider();

module clamp_slider() {
    difference() {
        union() {
            collar();
            arm();
        }
        bar_bore();
        pin_bore();
        screw_thread();
    }
}

// The sleeve around the bar.
module collar() {
    translate([bar_x / 2, 0, collar_h / 2])
        cuboid([collar_x, collar_y, collar_h], rounding = 3, edges = "Z");
}

// A tapering slab from the collar's front face out to the boss. Hulled from a
// thin plate to the boss cylinder so the arm and boss are one continuous solid
// with no seam at the joint.
module arm() {
    hull() {
        translate([bar_x / 2 + collar_x / 2 - 2, 0, collar_h / 2])
            cuboid([4, arm_w, collar_h], rounding = 1.5, edges = "Z");
        translate([x_screw, 0, 0])
            cylinder(d = boss_d, h = collar_h);
    }
}

// The bar bore, with a lead-in flare at each end so the slider starts onto the
// bar easily. This is a deliberately loose sliding fit, so the flare costs
// nothing.
module bar_bore() {
    lead = 1.5;
    translate([0, 0, -1]) linear_extrude(collar_h + 2) bar_section(slide_gap);
    for (m = [0, 1])
        translate([0, 0, m == 0 ? 0 : collar_h]) mirror([0, 0, m])
            hull() {
                translate([0, 0, -0.01]) linear_extrude(0.01) bar_section(slide_gap + lead);
                translate([0, 0, lead])  linear_extrude(0.01) bar_section(slide_gap);
            }
}

// The pin bore through both collar walls. The pin bears on the full circle;
// the 45-degree apex above it only removes the part of the hole that would
// otherwise print as an unsupported crown.
//
// Both mouths are countersunk to take the 45-degree fillet at the root of the
// pin's shaft. Without it the fillet lands on the collar's face and holds the
// pin head 1.25 mm proud — it still works, but the countersink also gives the
// pin a lead-in, so it costs nothing.
module pin_bore() {
    r = pin_d / 2 + pin_gap;
    translate([bar_x / 2, collar_y / 2 + 1, collar_h / 2]) rotate([90, 0, 0]) {
        linear_extrude(collar_y + 2) teardrop2d(r);
        for (m = [0, 1])
            translate([0, 0, m == 0 ? 1 : collar_y + 1]) mirror([0, 0, m])
                cylinder(r1 = r + 1.5, r2 = r, h = 1.5);
    }
}

// The internal thread, cut with BOSL2's rod used as a mask.
module screw_thread() {
    translate([x_screw, 0, -1])
        trapezoidal_threaded_rod(
            d = thread_d, l = boss_h + 2, pitch = thread_p,
            thread_angle = thread_a, thread_depth = thread_dep,
            internal = true, bevel = true,
            anchor = BOTTOM, $slop = thread_slop, $fn = 48);
}
