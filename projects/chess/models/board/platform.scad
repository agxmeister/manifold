// platform — the round stage a chess piece stands on. It is one of the three
// parts of the `board` model (the others are cell.scad and pin.scad).
//
// A disc that friction-fits into the cell's central socket; its top finishes
// flush with the surrounding terrain plateau. Printed separately so it can be
// a different colour from the terrain — print black platforms for the dark
// squares and white ones for the light squares.
//
// Prints flat on the bed, no supports. Print it top-face-down for the smoothest
// visible surface; that puts the top chamfer on the bed, where it flares out at
// 45° (self-supporting) and doubles as elephant-foot relief on the visible rim.
//
// The vertical wall between the chamfers is the full fit radius and does all the
// gripping. platform_chamfer eases the bottom (insertion) edge; platform_top_chamfer
// eases the top (visible) edge. Either may be 0 for a square edge.

include <connector.scad>

platform();

module platform() {
    // Straight gripping wall spans between the two chamfers. Uses the fit radius
    // (nominal minus the friction gap) so it grips the socket without falling out.
    wall_bottom = platform_chamfer;
    wall_top    = platform_height - platform_top_chamfer;
    union() {
        translate([0, 0, wall_bottom])
            cylinder(r = platform_fit_radius, h = wall_top - wall_bottom);
        // Chamfered bottom edge: lead-in as the disc drops into the socket.
        if (platform_chamfer > 0)
            hull() {
                cylinder(r = platform_fit_radius - platform_chamfer, h = 0.01);
                translate([0, 0, platform_chamfer])
                    cylinder(r = platform_fit_radius, h = 0.01);
            }
        // Chamfered top edge: eased visible rim, flush with the terrain plateau.
        if (platform_top_chamfer > 0)
            translate([0, 0, wall_top])
                hull() {
                    cylinder(r = platform_fit_radius, h = 0.01);
                    translate([0, 0, platform_top_chamfer])
                        cylinder(r = platform_fit_radius - platform_top_chamfer, h = 0.01);
                }
    }
}
