// foot — the knight's base part: the EXACT shared Staunton foot the bishop uses
// (foot_pts at canonical height, radius never scaled), capped with a flat top disc,
// carrying a PIN on top that plugs into the horse blade's socket.
//
// Prints upright on its flat base (a full disc of bed contact); the pin points
// straight up and is self-supporting. Its only support-worthy feature is the shared
// foot's tier groove — the same axisymmetric ring every Staunton piece reports.

include <connector.scad>

$fn = 96;

// Set $hide to suppress this auto-render when including the file for assembly.
if (is_undef($hide)) foot();

module foot() {
    union() {
        foot_body();
        pin();
    }
}

// The shared Staunton foot, turned and capped with a flat top disc at foot_top_z so
// the horse's neck can seat flat on it.
module foot_body() {
    rotate_extrude()
        polygon(concat(
            foot_pts(foot_zs, 0),           // shared foot, top-first down to bed
            [[0, 0], [0, foot_top_z]]       // close across the bed and up the axis
        ));
}

// The pin: a HEX prism rising from the centre of the foot's top disc, with a lead-in
// chamfer at the tip so it starts into the socket easily. It roots a hair into the
// disc (eps) so the union merges cleanly. hex_prism() (from connector.scad) orients
// a vertex +Y so it matches the horse's socket.
module pin() {
    eps = 0.01;
    R   = pin_af / sqrt(3);
    translate([0, 0, foot_top_z - eps])
        union() {
            hex_prism(pin_af, pin_h - pin_tip + eps);
            translate([0, 0, pin_h - pin_tip])          // chamfered hex tip
                cylinder(h = pin_tip, r1 = R, r2 = R - 0.9, $fn = 6);
        }
}
