// pin — the coarse-setting lock: a shear pin through the slider and the bar.
//
// Everything the clamp squeezes is reacted by this pin in double shear,
// through both collar walls. That is why the coarse setting is a pin through a
// hole rather than a friction collar: printed plastic on plastic will slip
// long before an 8 mm pin in shear will.
//
// It prints standing on its head plate — a flat 22 x 12 footprint, with the
// shaft rising as a plain vertical cylinder.

include <common.scad>

pin_len = collar_y + 3;   // through both collar walls, with a little to spare

// Print orientation: as used, standing on the head.
clamp_pin();

module clamp_pin() {
    head();
    shaft();
}

// A flat stadium plate: enough to pull the pin out by, and the part's whole
// bed contact.
module head() {
    linear_extrude(pin_head_t)
        hull() for (s = [-1, 1])
            translate([s * (pin_head_l - pin_head_w) / 2, 0])
                circle(d = pin_head_w);
}

module shaft() {
    translate([0, 0, pin_head_t - 0.01]) {
        // 45-degree fillet spreading the shear load into the head
        cylinder(d1 = pin_d + 3, d2 = pin_d, h = 1.5);
        cylinder(d = pin_d, h = pin_len - 1);
        // a lead-in chamfer so the pin finds the far collar wall
        translate([0, 0, pin_len - 1])
            cylinder(d1 = pin_d, d2 = pin_d - 1.5, h = 1);
    }
}
