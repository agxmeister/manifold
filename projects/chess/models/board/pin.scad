// pin — the connector that joins two neighbouring cells. It is one of the
// three parts of the `board` model (the others are cell.scad and
// platform.scad).
//
// A flat dumbbell tab: one bulb seats in each cell's bottom-opening bulb
// chamber and the narrow waist spans the seam. Because each bulb is wider
// than the neck slot it passes through, the two cells cannot pull apart.
// Pins drop in (and out) from UNDER the board, so a tile in the middle of an
// assembled field can be added or removed without disturbing its neighbours.
//
// Prints flat on the bed, no supports. The pin is modelled with its decorative
// bevel on the TOP edge (matching the platform's top rim); rotate it upside
// down before slicing so that beveled edge lands on the bed.

include <connector.scad>

pin();

// The dumbbell is built as three CONVEX pieces (two bulbs + the waist), each
// chamfered on its own and then unioned. Chamfering the whole dumbbell at
// once would need a convex hull, which fills in the waist and makes the tab
// too wide to clear the cell's neck slot — so keep the pieces separate.
module pin() {
    br = bulb_radius - pin_gap;   // bulb, a hair under the chamber
    nw = neck_width  - 2 * pin_gap;  // waist, a hair under the neck slot
    union() {
        chamfered(pin_thickness) translate([0,  bulb_offset]) circle(r = br);
        chamfered(pin_thickness) translate([0, -bulb_offset]) circle(r = br);
        chamfered(pin_thickness) square([nw, 2 * bulb_offset], center = true);
    }
}

// Extrude a CONVEX 2D child to height h with a bevel on each end:
// pin_top_chamfer on the top and pin_bottom_chamfer on the bottom. Each bevel
// eases the perimeter inward. Convexity matters: a bevel is a hull of the full
// profile and an inset copy, which is only exact for convex shapes — which is
// why the dumbbell is built as three separate convex pieces, each chamfered on
// its own and then unioned.
module chamfered(h) {
    union() {
        // Straight full-profile middle between the two bevels.
        translate([0, 0, pin_bottom_chamfer])
            linear_extrude(h - pin_top_chamfer - pin_bottom_chamfer) children();
        // Bottom bevel.
        if (pin_bottom_chamfer > 0)
            hull() {
                linear_extrude(0.01) offset(delta = -pin_bottom_chamfer) children();
                translate([0, 0, pin_bottom_chamfer])
                    linear_extrude(0.01) children();
            }
        // Top bevel.
        if (pin_top_chamfer > 0)
            translate([0, 0, h - pin_top_chamfer])
                hull() {
                    linear_extrude(0.01) children();
                    translate([0, 0, pin_top_chamfer])
                        linear_extrude(0.01) offset(delta = -pin_top_chamfer) children();
                }
    }
}
