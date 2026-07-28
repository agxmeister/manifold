// rook — the classic Staunton ROOK, turned as a solid of revolution.
//
// Built from the SAME shared parts as the rest of the set (see
// ../../lib/staunton.scad), with ONE exception: a rook has NO collar. So it is
// three parts, not four — head (crenellated tower) + body + foot — stacked
// bottom-up into one [r, z] profile and revolved with rotate_extrude(). The foot
// is the shared turned part; the body is a smooth curve through a few control
// points (`body_pts`) — a concave trumpet that absorbs what used to be a
// separate thick neck, tapering up to seat the tower directly (no collar, no
// cylinder neck). The crenellated tower head is the rook's own.
//
// The head was traced from the reference photo; the rook reaches ~59 mm — taller
// than the pawn (~49 mm), shorter than the bishop (~72 mm), standing by rank.
//
// The crown carries the rook's mark: the CRENELLATIONS — a hollow central well
// and a ring of notches cut into the rim, leaving a wreath of merlons (teeth)
// around an open parapet walk.
//
// Single-part model: prints upright on its base, which is cut dead flat (z = 0)
// for a full disc of bed contact.
//
// Printability: like the pawn, the flaring foot and shared base tiers descend
// outward and bridge without support. The crown flares wider toward the top, so
// its underside is a shallow turned overhang (~15 deg from vertical) that bridges
// cleanly; the astragal bead is a short turned overhang, a few mm, bridging
// acceptably. The crenels are cut down from the top and open upward, so the
// merlons cast no overhang.

include <../../lib/staunton.scad>

$fn = 96;

// ---- Crenellations (the rook's mark) ----
tower_top    = 58.70;  // z of the top of the merlons (also the crown rim)
crenel_floor = 54.00;  // z the gaps are cut down to — the parapet walk
well_r       = 8.00;   // radius of the hollow central well
well_floor   = 50.00;  // z of the well floor (below the walk, so gaps open in)
merlons      = 8;      // number of teeth around the parapet
crenel_w     = 3.80;   // tangential width of each gap — leaves ~4 mm merlons

// Shared-part placement (bottom-up). The rook uses the shared foot at canonical
// height; it has no collar, so the body seats the tower head directly.
foot_zs    = 1.0;                   // foot at canonical height
foot_top   = foot_h * foot_zs;      // 14.22 — body seats on the foot here
head_base  = 38.00;                 // top of the body, where the tower seats
body_z0    = foot_top;              // body's bottom, where it meets the foot
body_h     = head_base - body_z0;   // 23.78 — body height (head base - foot top)

rook();

module rook() {
    difference() {
        // Revolve the assembled half-section. The profile runs from the top
        // centre out across the flat rim and down the silhouette to the base
        // edge; closing back along the flat base (append [0, 0]) and up the axis
        // makes a solid tower with a flat top and a flat foot. No collar_pts()
        // between head and body — the rook's exception.
        rotate_extrude()
            polygon(concat(
                rook_head(),                             // crenellated tower
                body_pts(rook_body(), body_h, body_z0),  // concave trumpet
                foot_pts(foot_zs, 0),                    // shared foot
                [[0, 0]]                                 // close along the axis
            ));
        well();
        crenels();
    }
}

// Hollow out the parapet: a central cylinder cut down from above the rim to the
// well floor, leaving the ~4 mm ring wall that the merlons stand on. Open
// upward, so it needs no support.
module well() {
    translate([0, 0, well_floor])
        cylinder(r = well_r, h = tower_top - well_floor + 1);
}

// Cut the gaps between the merlons: one radial slot per gap, straddling the ring
// wall (from the well out past the rim) and open at the top, reaching down to
// the parapet walk. Each slot is open upward, so it casts no overhang; the
// merlons left behind are solid blocks.
module crenels() {
    eps    = 0.2;
    h      = tower_top - crenel_floor + eps;
    zc     = crenel_floor + h / 2;
    rim    = 12.0;                        // crown outer radius at the rim
    depth  = (rim - well_r) + 4;          // through the wall, with margin
    rmid   = well_r + (rim - well_r) / 2; // slot centred on the wall
    for (a = [0 : 360 / merlons : 359])
        rotate([0, 0, a])
            translate([rmid, 0, zc])
                cube([depth, crenel_w, h], center = true);
}

// Crenellated tower head [r, z], from the top centre (on the axis) out across
// the flat rim and down the crown and astragal bead to the top of the body
// (where the concave trumpet begins, r = 6.00). Traced from the photo.
function rook_head() = [
    [  0.00,  58.70],  // top centre (flat rim face, on the axis)
    [ 12.00,  58.70],  // crown rim — top of the merlons
    [ 12.00,  54.00],  // rim wall drops straight to the parapet walk
    [ 11.40,  52.00],  // crown flares in as it descends
    [ 10.60,  49.00],
    [  9.80,  46.00],
    [  9.30,  44.30],  // crown wall base
    [  9.30,  43.60],
    [ 10.30,  42.40],  // astragal bead under the crown (widest of the bead)
    [  9.60,  41.40],
    [  7.60,  40.40],  // shoulder stepping in to the body
    [  6.20,  39.50],
    [  6.00,  38.00],  // top of the body (the tower seats here)
];

// Body control points [t, r]: t = 1 at the head (top), t = 0 at the foot.
// A concave TRUMPET: slim at the top where it seats the tower (no collar, no
// cylinder neck — the old thick neck is absorbed into the curve, which starts
// nearly straight), flaring smoothly outward as it descends and tucking in to
// meet the foot. The top r matches the head's base (6.00).
function rook_body() = [
    [ 1.00,  6.00 ],  // top, seats the tower (no collar)
    [ 0.82,  6.05 ],  // slim upper body — absorbs the old straight neck
    [ 0.64,  6.35 ],  // concave trumpet begins to flare
    [ 0.48,  7.05 ],
    [ 0.35,  8.00 ],
    [ 0.24,  9.10 ],
    [ 0.15, 10.10 ],
    [ 0.07, 10.95 ],
    [ 0.00, 11.30 ],  // bottom, meets the foot
];
