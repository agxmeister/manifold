// cell — one square cell of the puzzle chess board, styled as a smooth
// battlefield tile. It is one of the three parts of the `board` model (the
// others are pin.scad and platform.scad).
//
// The top is a gently rolling terrain with a round central SOCKET that holds
// a separately printed platform (platform.scad); the platform's top finishes
// flush with the surrounding flat plateau, giving a chess piece a firm, level
// stage. The ground swells and dips toward the edges, most strongly at the
// rounded corners. The surface is a heightfield (one height per point), so
// however it undulates it never creates a downward overhang — the terrain
// prints support-free.
//
// `design` (0..7) selects one of eight deterministic terrains, so a board
// assembled from many cells reads as continuously varied ground. Cells join
// edge-to-edge with pin.scad connectors that drop in from underneath, holding
// a small gap between neighbours so height mismatches read as natural seams.

include <connector.scad>

// ---- Terrain parameters ----
design       = 0;    // 0..7: which of the eight battlefield layouts to build
grid_n       = 32;   // terrain resolution (grid cells per side)
ground_level = 15;   // nominal ground height, and the flat plateau height (mm).
                     //   Raised to keep a solid roof of material between the taller
                     //   pin pocket below and the platform socket floor above.
flat_radius  = 22;   // radius of the flat round central plateau (44 mm across)
blend        = 4;    // width over which terrain eases up out of the plateau
amp          = 5;    // greatest terrain swing from ground (peaks/dips at corners)
eject_radius = 4;    // radius of the eject hole punched up through the socket floor
                     //   (8 mm across) so a rod poked in from under the board pushes
                     //   the platform back out of its socket

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
                // Crisp, guaranteed-flat round plateau for the platform to seat in.
                cylinder(r = flat_radius, h = ground_level);
            }
            rounded_prism();   // rounds the vertical corners & sets the footprint
        }
        // Round central socket for the platform, recessed from the plateau top.
        socket();
        // Eject hole up through the socket floor, open at the board bottom.
        eject_hole();
        // One dumbbell groove per side, open at the bottom for the pins.
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

// Round recess in the plateau centre. Its floor sits socket_depth below the
// plateau top so the platform's top finishes flush with the terrain plateau.
module socket() {
    eps = 0.2;  // break the plateau surface cleanly
    translate([0, 0, ground_level - socket_depth])
        cylinder(r = socket_radius, h = socket_depth + eps);
}

// Small hole punched straight up from the board bottom (z = 0) through the
// socket floor and into the socket cavity. With the platform seated, its
// underside spans this hole, so a rod poked in from underneath the board bears
// on the disc and pushes it back out — no way to lever it from the top.
module eject_hole() {
    eps = 0.2;
    translate([0, 0, -eps])
        cylinder(r = eject_radius, h = (ground_level - socket_depth) + 2 * eps);
}

// A dumbbell-half pocket cut into the +Y edge and OPEN AT THE BOTTOM
// (z = 0). It is a round bulb chamber set groove_depth in from the edge,
// joined to the edge by a narrow neck slot. The pin's bulb drops up into
// the chamber from below; the bulb is wider than the neck slot, so the
// joined cells cannot pull apart. The cell body above the pocket forms the
// roof the pin bottoms out against.
module groove() {
    eps = 0.2;
    bulb_cy   = half - groove_depth;                 // chamber centre
    slot_len  = (half + eps) - bulb_cy;              // neck reaches through the edge
    translate([0, 0, -eps])
        linear_extrude(groove_height + eps)
            union() {
                // Nominal cavity — the pin (pin.scad) carries the clearance by
                // being shrunk connector_gap on every face. Enlarging it here
                // too would double the gap and the joint would fall apart.
                translate([0, bulb_cy])
                    circle(r = bulb_radius);
                translate([0, bulb_cy + slot_len / 2])
                    square([neck_width, slot_len], center = true);
            }
}
