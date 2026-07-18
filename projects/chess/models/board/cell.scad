// cell — one square cell of the puzzle chess board, styled as a smooth
// battlefield tile. It is one of the two parts of the `board` model (the
// other is pin.scad).
//
// The top is a gently rolling terrain with a big, flat, ROUND central
// plateau where a chess piece (round base) stands firm. The ground swells
// and dips toward the edges, most strongly at the rounded corners. The
// surface is a heightfield (one height per point), so however it undulates
// it never creates a downward overhang — the terrain prints support-free.
//
// `design` (0..7) selects one of eight deterministic terrains, so a board
// assembled from many cells reads as continuously varied ground. Cells join
// edge-to-edge with pin.scad connectors, which hold a small gap between
// neighbours so height mismatches read as natural seams.

include <connector.scad>

// ---- Terrain parameters ----
design       = 0;    // 0..7: which of the eight battlefield layouts to build
grid_n       = 24;   // terrain resolution (grid cells per side)
ground_level = 10;   // nominal ground height, and the flat plateau height (mm)
flat_radius  = 9;    // radius of the flat round central plateau (18 mm across)
blend        = 3;    // width over which terrain eases up out of the plateau
amp          = 4;    // greatest terrain swing from ground (peaks/dips at corners)

half    = cell_size / 2;
spacing = cell_size / grid_n;

function vx(i) = -half + i * spacing;
function vy(j) = -half + j * spacing;

// Eight smooth terrains: three blended sine ripples with per-design random
// frequencies and phases. rands() with a fixed seed is deterministic.
prm = rands(0, 1, 12, 1000 + design * 101);
function ripple(x, y, k) =
    sin((8 + prm[k * 4 + 0] * 14) * x + prm[k * 4 + 2] * 360) *
    sin((8 + prm[k * 4 + 1] * 14) * y + prm[k * 4 + 3] * 360);
function undulation(x, y) = (ripple(x, y, 0) + ripple(x, y, 1) + ripple(x, y, 2)) / 3;

function smoothstep(e0, e1, v) = let (t = max(0, min(1, (v - e0) / (e1 - e0)))) t * t * (3 - 2 * t);
function corner01(x, y) = (abs(x) / half) * (abs(y) / half);  // 0 on axes -> 1 at corners

// Terrain height at grid vertex (i, j): flat at ground_level over the round
// plateau, then easing smoothly into the undulating ground, with the swing
// weighted toward the corners so the mid-edges (the grooves) stay calm.
function height(i, j) =
    let (
        x = vx(i), y = vy(j),
        r = sqrt(x * x + y * y),
        b = smoothstep(flat_radius, flat_radius + blend, r),
        a = amp * (0.4 + 0.6 * corner01(x, y))
    )
    max(1, ground_level + b * a * undulation(x, y));

// Render the selected design when this file is opened directly. Another
// file can set `cell_library_only = true` before including this one to
// pull in the module without auto-rendering a cell.
if (is_undef(cell_library_only) || !cell_library_only)
    cell();

module cell() {
    difference() {
        intersection() {
            union() {
                terrain();
                // Crisp, guaranteed-flat round plateau for the piece to stand on.
                cylinder(r = flat_radius, h = ground_level);
            }
            rounded_prism();   // rounds the vertical corners & sets the footprint
        }
        // One groove per side for the connecting pins.
        for (a = [0, 90, 180, 270])
            rotate([0, 0, a])
                groove();
    }
}

// Heightfield solid: for each grid cell, hull four corner posts running
// from the bed (z = 0) up to that corner's terrain height. Shared corner
// heights make neighbouring cells meet seamlessly, so the union is a single
// watertight body with a flat base and a smooth terrain top.
module terrain() {
    for (i = [0 : grid_n - 1])
        for (j = [0 : grid_n - 1])
            hull() {
                post(i,     j);
                post(i + 1, j);
                post(i,     j + 1);
                post(i + 1, j + 1);
            }
}

module post(i, j) {
    e = 0.001;  // negligible footprint; the hull spans the true corner points
    translate([vx(i), vy(j), 0])
        cube([e, e, height(i, j)]);
}

// Tall rounded-corner square prism used to round the tile and trim it to
// its footprint. Extends well above the tallest terrain.
module rounded_prism() {
    linear_extrude(height = ground_level + amp + 10)
        offset(r = corner_radius)
            square(cell_size - 2 * corner_radius, center = true);
}

// A groove cut into the +Y edge, centred along it, at groove_center_z.
module groove() {
    eps = 0.2;  // poke through the surface so the mouth cuts cleanly
    translate([0, half - groove_depth / 2 + eps / 2, groove_center_z])
        cube([groove_width, groove_depth + eps, groove_height], center = true);
}
