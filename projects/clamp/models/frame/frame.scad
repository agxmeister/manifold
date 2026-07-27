// frame — the bar and the fixed jaw, printed as one piece.
//
// This is the part that carries the whole clamping moment, so it is one solid
// F-outline rather than a bar with a jaw bolted on: no joint at the highest
// stressed point. Its outline is a single 2D profile extruded bar_y thick,
// which prints lying flat on that profile — every fibre of the bar and jaw
// runs along a layer, and the pin holes come out as clean vertical bores.

include <../../lib/common.scad>

// Print orientation: profile flat on the bed, bar_y tall.
translate([0, 0, bar_y / 2]) rotate([-90, 0, 0]) clamp_frame();

module clamp_frame() {
    difference() {
        translate([0, bar_y / 2, 0]) rotate([90, 0, 0])
            linear_extrude(bar_y) frame_profile();
        pin_holes();
    }
}

// The F outline in the XZ plane: bar up from the origin, jaw arm out at the
// top. Corners are rounded — the inside corner at the jaw root generously,
// since that is where the bending moment peaks.
module frame_profile() {
    pts = [
        [0,                        0         ],
        [bar_x,                    0         ],
        [bar_x,                    jaw_face_z],  // jaw root, inside corner
        [x_screw + jaw_overhang,   jaw_face_z],  // clamping face, then the tip
        [x_screw + jaw_overhang,   jaw_face_z + jaw_tip_t],
        [bar_x,                    bar_len   ],  // taper back to the bar
        [0,                        bar_len   ],
    ];
    radii = [2, 2, 10, 3, 3, 4, 2];
    polygon(round_corners(pts, radius = radii, closed = true));
}

// The coarse-adjustment holes, bored across the bar's thin direction. They sit
// on the bar's centreline, where the bending stress is lowest.
module pin_holes() {
    for (i = [0 : notch_count - 1])
        translate([bar_x / 2, bar_y / 2 + 1, hole_z(i)])
            rotate([90, 0, 0])
                cylinder(d = pin_d + 2 * pin_gap, h = bar_y + 2);
}
