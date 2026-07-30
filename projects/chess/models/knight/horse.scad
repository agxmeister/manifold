// horse — the knight's head part: the flat horse-head blade that plugs onto the foot's
// pin. It is the precise image-traced silhouette (see horse_head(), image-traced
// from the reference: thresholded, boundary walked with Moore tracing, simplified
// with Douglas–Peucker, scaled 0.0879 mm/px and centred), extruded into a flat blade
// with a 45 deg BEVEL on each of its two big faces. Below the traced chest it grows a
// short straight NECK COLUMN that seats flat on the foot's top disc; a blind hex
// SOCKET is bored up that column to take the foot's pin.
//
// The horse faces -X (muzzle LEFT, mane down the +X back). Its signature is the mane
// rendered as a comb of separated locks down the curved back of the neck.
//
// The bevel (blade_bevel wide, at 45 deg) is NOT done with offset_sweep on the raw
// outline: that offsets the profile inward by the bevel width, and the mane's ~1 mm
// tooth gaps are far smaller than the bevel, so the teeth collapse into a pinched
// mush. Instead the blade is a STRAIGHT extrusion of
// the crisp silhouette (sharp teeth, sharp gaps) INTERSECTED with a chamfer TOOL: a
// 45 deg offset_sweep of the body outline with the mane comb replaced by a plain
// rectangular block enclosing the teeth (tool_outline()). The tool has no thin
// features, so the chamfer is robust; and because that block reaches past the tips by
// more than the bevel, the chamfer never touches the comb — the intersection bevels
// the whole body while every mane tooth stays full-thickness and crisp.
//
// Printing: lay it FLAT on a face (one X-Z face on the bed) — the whole silhouette
// then prints as a flat slab with NO overhangs and NO support, which is the point of
// splitting the piece. The hex socket bores in from the neck's bottom face; laid flat
// it is a short horizontal hole whose flat-topped hex roof bridges cleanly.

include <connector.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

$fn = 64;

blade_bevel = 2;                     // 2 mm — a 45 deg bevel on each face

trace_min_z = 3.16;              // lowest z in horse_head() (the breast)
shift       = neck_h - trace_min_z;   // lift the trace so the breast sits on the neck

// Default render = the PRINT POSE: the blade tipped onto a face so it prints flat on
// the bed with no overhangs and no support. The horse() module itself is authored
// STANDING (neck-bottom on the bed) so assembly just lifts it onto the foot; only the
// top-level print_pose() tips it over. Set $hide to suppress this auto-render when
// including the file to reposition it (assembly).
if (is_undef($hide)) print_pose();

module print_pose() {
    translate([0, 0, blade_thickness / 2]) rotate([90, 0, 0]) horse();
}

module horse() {
    difference() {
        blade();
        socket();
    }
}

// The blade: a straight extrusion of the crisp silhouette, standing on the bed at
// z = 0 (neck-bottom face down), INTERSECTED with the chamfer tool so both faces get
// a 45 deg bevel while the mane stays crisp (see the header). The 2D outline (x,
// height) sweeps along +Z into the thickness, centred on Y, and stood upright.
module blade() {
    rotate([90, 0, 0])
        translate([0, 0, -blade_thickness / 2])
            intersection() {
                linear_extrude(height = blade_thickness)
                    polygon(horse_outline());
                chamfer_tool();
            }
}

// The chamfer tool: offset_sweep with a 45 deg chamfer applied to tool_outline() —
// the body outline with the mane comb replaced by a solid rectangular BLOCK that
// encloses all the teeth (see tool_outline). That block has no thin features, so the
// chamfer is clean (no self-intersection, no detached slivers — the failure modes the
// fragile 2D-offset "close" produced). Because the block reaches past the tips by
// more than blade_bevel, the chamfer never touches the teeth: intersecting this tool
// with the straight full-silhouette extrude leaves every mane tooth full-thickness
// and crisp, while the rest of the body picks up the 45 deg face bevel.
module chamfer_tool() {
    offset_sweep(tool_outline(), height = blade_thickness,
                 bottom = os_chamfer(width = blade_bevel, height = blade_bevel),
                 top    = os_chamfer(width = blade_bevel, height = blade_bevel),
                 steps = 1, check_valid = true);
}

// The blind hex socket: a vertical bore up the centre of the neck column from the
// seating face (z = 0), sized socket_af (pin + clearance) and socket_depth deep, so
// the pin seats with the neck flush on the foot. Pokes a hair below the face for a
// clean cut. hex_prism() sits flat-face-up so the socket roof bridges flat when laid flat.
module socket() {
    eps = 0.01;
    translate([0, 0, -eps])
        hex_prism(socket_af, socket_depth + eps);
}

// Full CRISP 2D outline [x, height]: the traced head + mane comb (lifted by `shift`)
// closed off at the bottom by the straight neck column that seats on the foot. This
// is the real silhouette — the straight extrude of it carries every sharp mane tooth.
function horse_outline() = concat(
    shifted(concat(head_upper(), mane_comb())),
    neck_column()
);

// The CHAMFER-TOOL outline: identical to horse_outline() but with the mane comb
// swapped for a rectangular BLOCK enclosing the teeth (out to mane_tip_x + margin, a
// margin > blade_bevel so the chamfer never reaches the real tips). No thin features,
// so the chamfer is robust; and since the block covers every tooth full-thickness,
// intersecting leaves the comb crisp and unbevelled.
function tool_outline() = concat(
    shifted(concat(head_upper(), mane_block())),
    neck_column()
);

// mane extent (pre-shift), used to size the enclosing block.
mane_tip_x  = 20.21;                 // furthest a tooth reaches out (+X)
mane_top_z  = 44.6;                  // just above the first comb point
mane_base_z = 5.0;                   // just below the last comb point
block_x     = mane_tip_x + blade_bevel + 1.0;   // past the tips by > the bevel

function mane_block() = [ [ block_x, mane_top_z ], [ block_x, mane_base_z ] ];

// Lift a list of [x, z] points by the seating `shift`.
function shifted(pts) = [ for (p = pts) [p[0], p[1] + shift] ];

// The straight neck column that closes the outline onto the foot's top disc.
function neck_column() = [
    [  neck_hw, neck_h ],   // back:  flare in from the mane base to the column
    [  neck_hw, 0      ],   // back bottom of the neck column
    [ -neck_hw, 0      ],   // front bottom (flat seating face across the bottom)
    [ -neck_hw, neck_h ]    // front: column top, flares out to the breast
];

// The traced head [x, height], one loop from the breast (front, lowest) up the throat
// and dished face to the muzzle, over the forelock/ears, to the crest of the neck.
// Image-traced from the reference picture; kept crisp.
function head_upper() = [
    [  -16.78,    3.16 ],
    [  -16.17,    7.56 ],
    [  -14.32,   11.69 ],
    [  -12.39,   14.24 ],
    [   -4.13,   22.32 ],   // up the breast toward the throat
    [   -2.99,   24.17 ],
    [   -2.37,   26.71 ],
    [   -2.64,   26.89 ],
    [   -5.89,   25.83 ],
    [  -10.98,   25.92 ],   // under the jaw
    [  -12.92,   25.13 ],
    [  -15.38,   23.37 ],
    [  -16.52,   23.20 ],
    [  -18.01,   23.73 ],
    [  -18.98,   24.52 ],
    [  -19.07,   26.10 ],
    [  -20.47,   26.36 ],   // muzzle / mouth (leftmost)
    [  -20.83,   26.71 ],
    [  -20.91,   30.05 ],
    [  -20.56,   31.20 ],
    [  -19.42,   33.04 ],
    [  -16.26,   35.41 ],   // up the dished face
    [  -13.53,   38.05 ],
    [  -10.72,   42.00 ],
    [   -8.26,   43.41 ],
    [   -4.31,   44.90 ],
    [   -5.27,   49.91 ],   // forelock tip
    [   -5.18,   50.00 ],
    [   -4.39,   50.00 ],
    [   -2.81,   49.21 ],
    [   -0.62,   47.63 ],
    [    1.14,   45.69 ],
    [    2.46,   43.59 ]    // crest of the neck
];

// The mane comb [x, height]: the separated locks down the maned back (+X), from the
// crest to the mane base. Kept crisp — the straight extrude carries these sharp.
function mane_comb() = [
    [    3.78,   44.55 ],
    [    6.77,   43.23 ],
    [    6.94,   42.62 ],
    [    6.68,   41.56 ],
    [    6.94,   41.21 ],
    [    8.35,   42.09 ],
    [    9.40,   41.56 ],
    [   11.16,   39.98 ],
    [   10.46,   38.05 ],
    [   10.81,   37.87 ],
    [   12.39,   38.58 ],
    [   14.32,   36.20 ],
    [   14.50,   35.50 ],
    [   13.36,   34.27 ],
    [   13.36,   33.92 ],
    [   14.85,   34.18 ],
    [   15.64,   34.01 ],
    [   16.87,   30.93 ],
    [   15.38,   29.44 ],
    [   17.49,   29.44 ],
    [   18.54,   26.45 ],
    [   18.37,   25.83 ],
    [   16.70,   24.69 ],
    [   18.89,   24.43 ],
    [   19.33,   22.93 ],
    [   19.42,   20.83 ],
    [   17.75,   20.21 ],
    [   17.57,   19.86 ],
    [   19.77,   19.33 ],
    [   20.04,   15.82 ],
    [   17.84,   14.94 ],
    [   20.04,   14.24 ],
    [   20.21,   10.90 ],
    [   17.84,    9.84 ],
    [   20.12,    8.96 ],
    [   19.86,    5.54 ]    // mane base, down to the neck column
];
