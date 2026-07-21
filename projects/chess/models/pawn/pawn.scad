// pawn — the classic Staunton PAWN, turned as a solid of revolution.
//
// The humblest piece of the set and the reference shape for the shared parts
// (see ../../lib/staunton.scad). A pawn is four parts stacked bottom-up into one
// [r, z] profile and revolved with rotate_extrude():
//
//     head (ball) + collar + body + foot
//
// The collar and foot are the shared turned parts; the body is a smooth curve
// through a few control points (`body_pts`), tapering into the collar with no
// separate neck. The ball head is the pawn's own. The whole piece lands on the
// shared 16 mm foot (a 32 mm footprint, the set's shared base).
//
// Single-part model: prints upright on its base, which is cut dead flat (z = 0)
// for a full disc of bed contact.
//
// Printability: everything below the widest ring of each feature flares outward
// as it descends, so the skirt and base bridge without support. The downward-
// facing undersides are the classic turned overhangs — the underside of the ball
// where it necks in, and the underside of the collar brim. Their spans are small
// (a few mm), so they bridge acceptably on most printers; add light support only
// if you want the crispest finish on the ball and collar.

include <../../lib/staunton.scad>

$fn = 96;

// Where the shared parts sit on the axis (bottom-up).
body_z0   = 14.93;             // body's bottom, where it meets the foot
body_h    = 10.67;             // body height (collar bottom - body bottom)
collar_z0 = body_z0 + body_h;  // 25.60 — collar seats on the body top

pawn();

module pawn() {
    // Revolve the assembled half-section. The profile is closed back to the axis
    // along the flat base (append [0, 0]); the ball apex already sits on the axis.
    rotate_extrude()
        polygon(concat(
            pawn_head(),                          // ball, on the axis
            collar_pts(1, 1, collar_z0),          // shared collar
            body_pts(pawn_body(), body_h, body_z0),  // tapering skirt
            foot_pts(1, 0),                       // shared foot
            [[0, 0]]                              // close along the axis
        ));
}

// Ball head [r, z], apex on the axis down to the last point above the collar's
// neck pinch. Traced from the photo.
function pawn_head() = [
    [  0.00,  48.76],  // ball apex
    [  3.02,  48.36],
    [  4.03,  47.64],
    [  4.98,  46.93],
    [  5.57,  46.22],
    [  5.93,  45.51],
    [  6.28,  44.80],
    [  6.52,  44.09],
    [  6.76,  43.38],  // ball widest
    [  6.76,  42.67],
    [  6.76,  41.96],
    [  6.76,  41.24],
    [  6.52,  40.53],
    [  6.28,  39.82],
    [  5.93,  39.11],
    [  5.57,  38.40],
    [  4.98,  37.69],
    [  4.03,  36.98],  // necks in toward the collar pinch
];

// Body control points [t, r]: t = 1 at the collar (top), t = 0 at the foot.
// A plain flaring skirt — narrow at the collar, tapering smoothly to the top
// (no cylinder neck) and widening to its widest at the very bottom (no belly).
function pawn_body() = [
    [ 1.00,  4.27 ],  // top, meets the collar
    [ 0.73,  4.50 ],
    [ 0.53,  4.95 ],
    [ 0.33,  5.75 ],
    [ 0.20,  6.76 ],
    [ 0.13,  7.47 ],
    [ 0.07,  8.53 ],
    [ 0.00, 10.07 ],  // bottom, meets the foot
];
